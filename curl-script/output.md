# Example FOLIO session using `curl`

The goal here is to demonstrate the lack of magic involved in invoking Okapi services. Here, the user wants to find instance records containing the word "change", but first runs into authentication problems. All the examples use the open FOLIO service at https://folio-snapshot-okapi.dev.folio.org

## Try to find instances

Here, we just jump straight in an run the search, using the query `keyword=change` against the endpoint `/search/instances`:
```shell
$ curl -w '\n' -D - -H 'X-Okapi-Tenant: diku' 'https://folio-snapshot-okapi.dev.folio.org/search/instances?query=keyword=change'
HTTP/2 403 
date: Fri, 04 Mar 2022 15:26:30 GMT
content-type: text/plain

Token missing, access requires permission: search.instances.collection.get
```
This fails because we did not specify an authentication token in the `X-Okapi-Token` header.

## Try to log in

We post to the `/authn/login` endpoint:
```shell
$ curl -w '\n' -X POST -D - -H 'Content-type: application/json' -H 'X-Okapi-Tenant: foobar' -d '{ "username": "diku_admin", "password": "swordfish" }' https://folio-snapshot-okapi.dev.folio.org/authn/login
HTTP/2 400 
date: Fri, 04 Mar 2022 15:26:30 GMT
content-type: text/plain
content-length: 21

No such Tenant foobar
```
This fails because the FOLIO instance we are connecting to knows nothing of a tenant called `foobar`.

## Log in to the right tenant

This time we specify the tenant `diku`, which does exist:
```shell
$ curl -w '\n' -X POST -D - -H 'Content-type: application/json' -H 'X-Okapi-Tenant: diku' -d '{ "username": "someguy", "password": "swordfish" }' https://folio-snapshot-okapi.dev.folio.org/authn/login
HTTP/2 422 
date: Fri, 04 Mar 2022 15:26:31 GMT
content-type: application/json

{
  "errors" : [ {
    "message" : "Error verifying user existence: No user found by username someguy",
    "type" : "error",
    "code" : "username.incorrect",
    "parameters" : [ {
      "key" : "username",
      "value" : "someguy"
    } ]
  } ]
}
```
But the username we specified is not valid.

## Log in to a working account

This time we use the account `diku_admin`:
```shell
$ curl -w '\n' -X POST -D - -H 'Content-type: application/json' -H 'X-Okapi-Tenant: diku' -d '{ "username": "diku_admin", "password": "swordfish" }' https://folio-snapshot-okapi.dev.folio.org/authn/login
HTTP/2 422 
date: Fri, 04 Mar 2022 15:26:31 GMT
content-type: application/json

{
  "errors" : [ {
    "message" : "Password does not match",
    "type" : "error",
    "code" : "password.incorrect",
    "parameters" : [ {
      "key" : "username",
      "value" : "diku_admin"
    } ]
  } ]
}
```
But the password was wrong.

## Log in using the correct password

(`swordfish2` is not the real password, but lets pretend it it.)
```shell
$ curl -w '\n' -X POST -D - -H 'Content-type: application/json' -H 'X-Okapi-Tenant: diku' -d '{ "username": "diku_admin", "password": "swordfish2" }' https://folio-snapshot-okapi.dev.folio.org/authn/login
HTTP/2 201 
date: Fri, 04 Mar 2022 15:26:32 GMT
content-type: application/json
x-okapi-token: eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkaWt1X2FkbWluIiwidHlwZSI6ImFjY2VzcyIsInVzZXJfaWQiOiJkMGQxNDJlZS0zODVkLTU4MDYtYjJhYi0wY2M0Nzg0MWQxM2QiLCJpYXQiOjE2NDY0MDc1OTIsInRlbmFudCI6ImRpa3UifQ.lJcByhUJjVz15ahAYNFOx25ZRKJHlax5J8I3HO_iqEI
refreshtoken: eyJlbmMiOiJBMjU2R0NNIiwiYWxnIjoiZGlyIn0..dNIL2RM3jB4dlAaF.db7S9Ma2EDjPASm1EP8byFtiYJrKhOXAVWK8mRA-_N3XMM5XnWznziljL57yZiiZWEblUJXldC3SIFAVa_-Qaw_7sh8qdmVyym9tSQwVd_0T9HBPV7o04jxdOyZssixuccP0ffbKToSl0yvC5Mf0jetnNY98F6Q77DlJSKp1W4glaPb3yTkjgVphMO-iXvE6oDUuBCJEeSAn78mcHY1Fngs9SlDNltd8eI7Nu6KQ3jQ-M8kYw82hms10MkrKeJdwYDHsCGCoapyVfs97YjuY6aZ0Ivmw8zyhVvFicKo.HX_CY8EgEuS176V8TyIx_w

{
  "okapiToken" : "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkaWt1X2FkbWluIiwidHlwZSI6ImFjY2VzcyIsInVzZXJfaWQiOiJkMGQxNDJlZS0zODVkLTU4MDYtYjJhYi0wY2M0Nzg0MWQxM2QiLCJpYXQiOjE2NDY0MDc1OTIsInRlbmFudCI6ImRpa3UifQ.lJcByhUJjVz15ahAYNFOx25ZRKJHlax5J8I3HO_iqEI",
  "refreshToken" : "eyJlbmMiOiJBMjU2R0NNIiwiYWxnIjoiZGlyIn0..dNIL2RM3jB4dlAaF.db7S9Ma2EDjPASm1EP8byFtiYJrKhOXAVWK8mRA-_N3XMM5XnWznziljL57yZiiZWEblUJXldC3SIFAVa_-Qaw_7sh8qdmVyym9tSQwVd_0T9HBPV7o04jxdOyZssixuccP0ffbKToSl0yvC5Mf0jetnNY98F6Q77DlJSKp1W4glaPb3yTkjgVphMO-iXvE6oDUuBCJEeSAn78mcHY1Fngs9SlDNltd8eI7Nu6KQ3jQ-M8kYw82hms10MkrKeJdwYDHsCGCoapyVfs97YjuY6aZ0Ivmw8zyhVvFicKo.HX_CY8EgEuS176V8TyIx_w"
}
```
Now the login has succeeded, and we have been given a valid token that we can use for the session. It is redundantly returned both in the `X-Okapi-Token` header and in the JSON response body.

# Actually find instances

Now we pass the token back as the `X-Okapi-Token` header of our request, and get a response:
```shell
$ curl -w '\n' -D - -H 'X-Okapi-Tenant: diku' -H 'X-Okapi-Token: eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkaWt1X2FkbWluIiwidHlwZSI6ImFjY2VzcyIsInVzZXJfaWQiOiJkMGQxNDJlZS0zODVkLTU4MDYtYjJhYi0wY2M0Nzg0MWQxM2QiLCJpYXQiOjE2NDY0MDc1OTIsInRlbmFudCI6ImRpa3UifQ.lJcByhUJjVz15ahAYNFOx25ZRKJHlax5J8I3HO_iqEI' 'https://folio-snapshot-okapi.dev.folio.org/search/instances?query=keyword=change&limit=1'
HTTP/2 200 
date: Fri, 04 Mar 2022 15:26:32 GMT
content-type: application/json

{"totalRecords":5,"instances":[{"id":"549fad9e-7f8e-4d8e-9a71-00d251817866","title":"Agile Organisation, Risiko- und Change Management Harald Augustin (Hrsg.)","contributors":[{"name":"Augustin, Harald","contributorNameTypeId":"2b94c631-fca9-4892-a730-03ee529ffe2a"},{"name":"Shaker Verlag GmbH","contributorNameTypeId":"2e48e713-17f3-4c13-a9f8-23845bb210aa"}],"publication":[{"publisher":"Shaker Verlag","dateOfPublication":"2017"}],"staffSuppress":false,"discoverySuppress":false,"isBoundWith":false}]}
```

