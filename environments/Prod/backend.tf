terraform {
  backend "s3" {
    bucket         = "company-prod-tf-state"
    key            = "webapp/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
