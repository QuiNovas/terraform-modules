resource "aws_dynamodb_table" "apikeys" {
  attribute {
    name = "Apikey"
    type = "S"
  }
  hash_key        = "Apikey"
  name            = "${var.name_prefix}-api-keys"
  read_capacity   = "${var.read_capacity}"
  write_capacity  = "${var.write_capacity}"
}
