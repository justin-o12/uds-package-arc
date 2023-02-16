terraform {
  backend "s3" {
    bucket         = "tfstate-dd-kb"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "tfstate-dd-kb-table"
  }
}