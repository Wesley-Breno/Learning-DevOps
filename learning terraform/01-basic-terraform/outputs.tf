# Mostra se o versionamento do bucket 'werlindo' esta ativo quando for aplicado o projeto terraform
output "my_s3_bucket_versioning" {
  value = aws_s3_bucket.my_s3_bucket.versioning[0].enabled
}

# Mostra os dados do usuario IAM
output "my_iam_user_complete_details" {
  value = aws_iam_user.my_iam_user
}