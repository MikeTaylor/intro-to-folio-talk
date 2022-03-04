folioLogin() {
  curl -w '\n' -X POST -D - \
    -H "Content-type: application/json" \
    -H "X-Okapi-Tenant: $1" \
    -d '{ "username": "'"$2"'", "password": "'"$3"'" }' \
    https://folio-snapshot-okapi.dev.folio.org/authn/login
}
