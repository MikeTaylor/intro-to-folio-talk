# Missing token
curl -w '\n' -D - \
  -H "X-Okapi-Tenant: diku" \
  https://folio-snapshot-okapi.dev.folio.org/search/instances?query=change

login() {
  curl -w '\n' -X POST -D - \
    -H "Content-type: application/json" \
    -H "X-Okapi-Tenant: $1" \
    -d '{ "username": "'"$2"'", "password": "'"$3"'" }' \
    https://folio-snapshot-okapi.dev.folio.org/authn/login
}

## Unrecognised tenant
login foobar diku_admin swordfish

# Unrecognised user
login diku someguy swordfish

# Bad password
login diku diku_admin swordfish

# Success
login diku diku_admin admin

# Find instances matching "change"
curl -w '\n' -D - \
  -H "X-Okapi-Tenant: diku" \
  -H "X-Okapi-Token: eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkaWt1X2FkbWluIiwidHlwZSI6ImFjY2VzcyIsInVzZXJfaWQiOiJkMGQxNDJlZS0zODVkLTU4MDYtYjJhYi0wY2M0Nzg0MWQxM2QiLCJpYXQiOjE2NDYzOTU5ODksInRlbmFudCI6ImRpa3UifQ.3oAnAULxCfVQooUwr8AD2_SwPJKLD_4pzLA1xcjj8AA" \
  https://folio-snapshot-okapi.dev.folio.org/search/instances?query=keyword=change\&limit=1
