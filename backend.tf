terraform {
  backend "s3" {
    key            = "valxay3t.tfstate"
    bucket         = "clarinda-valaxybucket"
    region         = "eu-west-2"
    profile        = "Clarinda"
    dynamodb_table = "valaxy3t-dynamoDB"
  }
}