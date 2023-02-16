locals {
  # s3Bucket     = "somebucket_name"
  prodLockName = "inhv2-tf-state-locks-736826601929-prod-us-east-1"
}

resource "aws_dynamodb_table" "action_locktable" {
  name           = local.prodLockName
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  stream_enabled = false

  tags = tomap({
    TEAM = "dashdays-kibbles-and-bits",
    Name = "inh-prod-lock-table",
    Role = "INH prod runner terraform locktable",
  })

  attribute {
    name = "LockID"
    type = "S"
  }

}
