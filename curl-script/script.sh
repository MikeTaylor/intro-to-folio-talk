# Missing token
curl -w '\n' -D - \
  -H "X-Okapi-Tenant: diku" \
  https://folio-snapshot-okapi.dev.folio.org/search/instances?query=change

folioLogin() {
  curl -w '\n' -X POST -D - \
    -H "Content-type: application/json" \
    -H "X-Okapi-Tenant: $1" \
    -d '{ "username": "'"$2"'", "password": "'"$3"'" }' \
    https://folio-snapshot-okapi.dev.folio.org/authn/login
}

## Unrecognised tenant
folioLogin foobar diku_admin swordfish

# Unrecognised user
folioLogin diku someguy swordfish

# Bad password
folioLogin diku diku_admin swordfish

# Success
folioLogin diku diku_admin swordfish2

# Find instances matching "change"
curl -w '\n' -D - \
  -H "X-Okapi-Tenant: diku" \
  -H "X-Okapi-Token: 12345" \
  https://folio-snapshot-okapi.dev.folio.org/search/instances?query=keyword=change\&limit=1
