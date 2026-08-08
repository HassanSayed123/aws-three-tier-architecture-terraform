terraform {
  backend "s3" {
    bucket         = "hassan-terraform-state-2026"
    key            = "backend/Hassan_Cloud.tfstate"
    region         = "us-east-1"
    dynamodb_table = "remote-backend"
  }
}
