#!/bin/bash

[ -z "$VAULT_ADDR" ] && export VAULT_ADDR='http://127.0.0.1:8200'

echo "Adding ReadSecrets, ReadAWS policy"
tee vault-simple-policy.hcl <<EOF
path "secret/*" {
  capabilities = ["read", "list"]
}
EOF
vault write sys/policy/read-aws rules=@vault-simple-policy.hcl
rm vault-simple-policy.hcl

vault auth enable approle

echo "First approle"
vault write auth/approle/role/testrole secret_id_ttl=10m token_num_uses=10 token_ttl=30s token_max_ttl=30m secret_id_num_uses=40 policies=read-aws
vault read auth/approle/role/testrole/role-id
vault write -f auth/approle/role/testrole/secret-id

echo "Second approle"
vault write auth/approle/role/secondrole secret_id_ttl=10m token_num_uses=10 token_ttl=30s token_max_ttl=30m secret_id_num_uses=40 policies=read-aws
vault read auth/approle/role/secondrole/role-id
vault write -f auth/approle/role/secondrole/secret-id


vault kv put /secret/test data=simple
vault kv put /secret/test-complex first=a second=2



