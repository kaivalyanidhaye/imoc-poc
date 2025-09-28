terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "imoc-tfstate-dev-obs"
    key            = "envs/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "imoc-tflock-dev"
    encrypt        = true
  }
}
