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
path "aws/roles/*" {
  capabilities = ["read", "list"]
}
path "aws/creds/*" {
  capabilities = ["read", "list"]
}
EOF
vault write sys/policy/read-aws policy=@vault-simple-policy.hcl
rm vault-simple-policy.hcl

echo
echo "Adding AppRole"
vault auth enable approle
vault write auth/approle/role/testrole secret_id_ttl=24h token_num_uses=50 token_ttl=5m token_max_ttl=1h \
	secret_id_num_uses=40 policies=read-aws

echo
echo "AppRole ID:"
vault read auth/approle/role/testrole/role-id

echo
echo "AppRole SecretID:"
vault write -f auth/approle/role/testrole/secret-id


echo
echo "Adding secrets"
# Add testing secrets
vault kv put /secret/test data=TestSecret
vault kv put /secret/test-complex first=SecretPartA second=SecretPartB

echo
echo "Adding AWS"
vault secrets enable aws
vault write aws/config/root \
    "access_key=$AWS_ACCESS_KEY" \
    "secret_key=$AWS_SECRET_KEY" \
    region=us-east-1

vault write aws/config/lease lease=5m lease_max=1h

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

vault write aws/roles/iam credential_type=iam_user policy_document=@vault-aws-policy.json
rm vault-aws-policy.json
vault write aws/roles/readonly credential_type=iam_user policy_arns=arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess
vault write aws/roles/ec2-full credential_type=iam_user policy_arns=arn:aws:iam::aws:policy/AmazonEC2FullAccess
tee vault-aws-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
vault write aws/roles/ec2-s3 credential_type=iam_user policy_document=@vault-aws-policy.json
rm vault-aws-policy.json

tee vault-aws-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::mybucket"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "arn:aws:s3:::mybucket/path/to/my/key"
    }
  ]
}
EOF
vault write aws/roles/ec2-s3 credential_type=iam_user policy_document=@vault-aws-policy.json
rm vault-aws-policy.json



cat <<EOF
 Usage:
vault read aws/creds/iam
vault read aws/creds/readonly
vault read aws/creds/ec2-full
vault read aws/creds/ec2-s3
EOF

