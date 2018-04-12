resource "aws_dynamodb_table" "table" {
  attribute               = [
    "${var.attributes}"
  ]
  global_secondary_index  = [
    "${var.global_secondary_indexes}"
  ]
  hash_key                = "${var.hash_key}"
  lifecycle {
    ignore_changes  = [
      "global_secondary_index.read_capacity",
      "global_secondary_index.write_capacity",
      "read_capacity",
      "ttl",
      "write_capacity"
    ]
    prevent_destroy = true
  }
  local_secondary_index   = [
    "${var.local_secondary_indexes}"
  ]
  name                    = "${var.name}"
  range_key               = "${var.range_key}"
  read_capacity           = "${var.read_capacity["min"]}"
  server_side_encryption {
    enabled = true
  }
  stream_enabled          = "${length(var.stream_view_type) > 0 ? true : false}"
  stream_view_type        = "${var.stream_view_type}"
  tags                    = "${local.tags}"
  ttl {
    attribute_name  = "${var.ttl_attribute_name}"
    enabled         = "${length(var.ttl_attribute_name) > 0 ? true : false}"
  }
  write_capacity          = "${var.write_capacity["min"]}"
}

resource "aws_appautoscaling_target" "table_read" {
  max_capacity        = "${var.read_capacity["max"]}"
  min_capacity        = "${var.read_capacity["min"]}"
  resource_id         = "table/${aws_dynamodb_table.table.name}"
  role_arn            = "${var.autoscaling_service_role_arn}"
  scalable_dimension  = "dynamodb:table:ReadCapacityUnits"
  service_namespace   = "dynamodb"
}

resource "aws_appautoscaling_policy" "table_read" {
  name                = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.table_read.resource_id}"
  policy_type         = "TargetTrackingScaling"
  resource_id         = "${aws_appautoscaling_target.table_read.resource_id}"
  scalable_dimension  = "${aws_appautoscaling_target.table_read.scalable_dimension}"
  service_namespace   = "${aws_appautoscaling_target.table_read.service_namespace}"
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value = 70
  }
}

resource "aws_appautoscaling_target" "table_write" {
  max_capacity        = "${var.write_capacity["max"]}"
  min_capacity        = "${var.write_capacity["min"]}"
  resource_id         = "table/${aws_dynamodb_table.table.name}"
  role_arn            = "${var.autoscaling_service_role_arn}"
  scalable_dimension  = "dynamodb:table:WriteCapacityUnits"
  service_namespace   = "dynamodb"
}

resource "aws_appautoscaling_policy" "table_write" {
  name                = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.table_write.resource_id}"
  policy_type         = "TargetTrackingScaling"
  resource_id         = "${aws_appautoscaling_target.table_write.resource_id}"
  scalable_dimension  = "${aws_appautoscaling_target.table_write.scalable_dimension}"
  service_namespace   = "${aws_appautoscaling_target.table_write.service_namespace}"
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value = 70
  }
}

resource "aws_appautoscaling_target" "global_secondary_index_read" {
  count               = "${local.global_secondary_indexes_count}"
  max_capacity        = "${var.read_capacity["max"]}"
  min_capacity        = "${var.read_capacity["min"]}"
  resource_id         = "table/${aws_dynamodb_table.table.name}/index/${lookup(var.global_secondary_indexes[count.index], "name")}"
  role_arn            = "${var.autoscaling_service_role_arn}"
  scalable_dimension  = "dynamodb:index:ReadCapacityUnits"
  service_namespace   = "dynamodb"
}

resource "aws_appautoscaling_policy" "global_secondary_index_read" {
  count               = "${local.global_secondary_indexes_count}"
  name                = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.global_secondary_index_read.*.resource_id[count.index]}"
  policy_type         = "TargetTrackingScaling"
  resource_id         = "${aws_appautoscaling_target.global_secondary_index_read.*.resource_id[count.index]}"
  scalable_dimension  = "${aws_appautoscaling_target.global_secondary_index_read.*.scalable_dimension[count.index]}"
  service_namespace   = "${aws_appautoscaling_target.global_secondary_index_read.*.service_namespace[count.index]}"
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value = 70
  }
}

resource "aws_appautoscaling_target" "global_secondary_index_write" {
  count               = "${local.global_secondary_indexes_count}"
  max_capacity        = "${var.write_capacity["max"]}"
  min_capacity        = "${var.write_capacity["min"]}"
  resource_id         = "table/${aws_dynamodb_table.table.name}/index/${lookup(var.global_secondary_indexes[count.index], "name")}"
  role_arn            = "${var.autoscaling_service_role_arn}"
  scalable_dimension  = "dynamodb:index:WriteCapacityUnits"
  service_namespace   = "dynamodb"
}

resource "aws_appautoscaling_policy" "global_secondary_index_write" {
  count               = "${local.global_secondary_indexes_count}"
  name                = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.global_secondary_index_write.*.resource_id[count.index]}"
  policy_type         = "TargetTrackingScaling"
  resource_id         = "${aws_appautoscaling_target.global_secondary_index_write.*.resource_id[count.index]}"
  scalable_dimension  = "${aws_appautoscaling_target.global_secondary_index_write.*.scalable_dimension[count.index]}"
  service_namespace   = "${aws_appautoscaling_target.global_secondary_index_write.*.service_namespace[count.index]}"
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value = 70
  }
}
