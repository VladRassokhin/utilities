#!/bin/bash
export VAULT_ADDR='http://127.0.0.1:8200'

if [ -z "$AWS_ACCESS_KEY" -o -z "$AWS_SECRET_KEY" ]; then
echo "AWS credentials should be set in AWS_ACCESS_KEY and AWS_SECRET_KEY env variables"
exit 1
fi

echo "Adding ReadSecrets, ReadAWS policy"
tee vault-simple-policy.hcl <<EOF
path "secret/*" {
  capabilities = ["read", "list"]
}
EOF
vault write sys/policy/read-secrets rules=@vault-simple-policy.hcl
rm vault-simple-policy.hcl
tee vault-simple-policy.hcl <<EOF
path "aws/roles/*" {
  capabilities = ["read", "list"]
}
path "aws/creds/*" {
  capabilities = ["read", "list"]
}
EOF
vault write sys/policy/read-aws rules=@vault-simple-policy.hcl
rm vault-simple-policy.hcl

echo "Adding AppRole"
vault auth-enable approle
vault write auth/approle/role/testrole secret_id_ttl=24h token_num_uses=10 token_ttl=10s token_max_ttl=5m \
	secret_id_num_uses=40 policies=read-secrets,read-aws
vault write auth/approle/role/test-role/role-id role_id=test-role-id
vault read auth/approle/role/testrole/role-id

echo
echo "AppRole SecretID:"
vault write -f auth/approle/role/testrole/secret-id


echo "Adding secrets"
# Add testing secrets
vault write /secret/test data=TestSecret
vault write /secret/test-complex first=SecretPartA second=SecretPartB

echo "Adding AWS"
vault mount aws
vault write aws/config/root \
    "access_key=$AWS_ACCESS_KEY" \
    "secret_key=$AWS_SECRET_KEY" \
    region=us-east-1

tee vault-aws-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "iam:*",
      "Resource": "*"
    }
  ]
}
EOF

vault write aws/roles/iam policy=@vault-aws-policy.json
rm vault-aws-policy.json
vault write aws/roles/readonly arn=arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess
vault write aws/roles/ec2-full arn=arn:aws:iam::aws:policy/AmazonEC2FullAccess

# Usage:
#vault read aws/creds/iam
#vault read aws/creds/readonly
#vault read aws/creds/ec2-full

