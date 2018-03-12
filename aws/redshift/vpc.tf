resource "aws_vpc" "main" {
  cidr_block = "${var.cidr_block}"
  tags {
    Name = "${var.name}"
  }
}

resource "aws_internet_gateway" "main" {
  tags {
    Name = "${var.name}"
  }
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_default_route_table" "main" {
  default_route_table_id = "${aws_vpc.main.default_route_table_id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }
  tags {
    Name = "autotec-${var.name}-redshift"
  }
}

data "aws_region" "current" {}

resource "aws_vpc_endpoint" "s3" {
  service_name  = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_id        = "${aws_vpc.main.id}"
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  route_table_id  = "${aws_default_route_table.main.id}"
  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
}
