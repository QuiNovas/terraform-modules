data "aws_s3_bucket" "log_bucket" {
  bucket = "${var.log_bucket}"
}

resource "aws_cloudfront_origin_access_identity" "origin" {
  comment = "${var.distribution_name}"
}

resource "aws_cloudfront_distribution" "distribution" {
  aliases                 = [
    "${var.aliases}"
  ]
  comment                 = "${var.comment}"
  custom_error_response   = [
    "${var.custom_error_responses}"
  ]
  default_cache_behavior {
    allowed_methods = [
      "HEAD",
      "GET"
    ]
    cached_methods = [
      "HEAD",
      "GET"
    ]
    default_ttl             = 3600
    forwarded_values {
      cookies {
        forward = "none"
      }
      query_string = false
    }
    lambda_function_association {
      event_type = "origin-request"
      lambda_arn = "${aws_lambda_function.redirector.qualified_arn}"
    }
    max_ttl                 = 86400
    min_ttl                 = 0
    target_origin_id        = "${var.distribution_name}"
    viewer_protocol_policy  = "redirect-to-https"
  }
  default_root_object     = "${var.default_root_object}"
  depends_on              = [
    "aws_lambda_permission.redirector"
  ]
  enabled                 = true
  is_ipv6_enabled         = true
  lifecycle {
    ignore_changes = [
      "default_cache_behavior"
    ]
  }
  logging_config {
    bucket          = "${data.aws_s3_bucket.log_bucket.bucket_domain_name}"
    include_cookies = false
    prefix          = "cloudfront/${var.distribution_name}/"
  }
  ordered_cache_behavior  = [
    "${var.ordered_cache_behaviors}"
  ]
  origin {
    domain_name = "${aws_s3_bucket.origin.bucket_domain_name}"
    origin_id   = "${var.distribution_name}"
    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin.cloudfront_access_identity_path}"
    }
  }
  price_class             = "${var.price_class}"
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  tags                    = "${local.tags}"
  viewer_certificate {
    acm_certificate_arn       = "${var.acm_certificate_arn}"
    cloudfront_default_certificate = "${length(var.acm_certificate_arn) > 0 ? false : true}"
    minimum_protocol_version  = "TLSv1.1_2016"
    ssl_support_method        = "sni-only"
  }
  web_acl_id          = "${var.web_acl_id}"
}
