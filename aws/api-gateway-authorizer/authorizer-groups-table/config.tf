resource "aws_dynamodb_table" "groups" {
  attribute {
    name = "GroupId"
    type = "S"
  }
  hash_key        = "GroupId"
  name            = "${var.name_prefix}-authorizer-groups"
  read_capacity   = "${var.read_capacity}"
  write_capacity  = "${var.write_capacity}"
}