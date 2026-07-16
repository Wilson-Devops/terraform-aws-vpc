terraform {
  backend "s3" {
    bucket         = "wmanda-terraform-state-845517756351"
    key            = "project-2/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}