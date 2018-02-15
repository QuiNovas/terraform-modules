resource "aws_dynamodb_table" "users" {
  attribute {
    name = "Username"
    type = "S"
  }
  hash_key        = "Username"
  name            = "${var.name_prefix}-basic-authentication-users"
  read_capacity   = "${var.read_capacity}"
  write_capacity  = "${var.write_capacity}"
}
