#!/bin/bash
export VAULT_ADDR='http://127.0.0.1:8200'

vault auth-enable approle
vault write auth/approle/role/testrole secret_id_ttl=10m token_num_uses=10 token_ttl=30s token_max_ttl=30m secret_id_num_uses=40
vault read auth/approle/role/testrole/role-id
vault write -f auth/approle/role/testrole/secret-id

vault write /secret/test data=simple
vault write /secret/test-complex first=a second=2



