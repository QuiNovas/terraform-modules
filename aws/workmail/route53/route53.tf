resource "aws_route53_record" "autodiscover" {
  name    = "autodiscover.${var.domain}"
  records = [
    "autodiscover.mail.us-east-1.awsapps.com."
  ]
  ttl     = 300
  type    = "CNAME"
  zone_id = "${var.zone_id}"
}

resource "aws_route53_record" "domain_keys" {
  count   = "${local.domain_key_prefixes_count}"
  name    = "${var.domain_key_prefixes[count.index]}._domainkey.${var.domain}"
  records = [
    "${var.domain_key_prefixes[count.index]}.dkim.amazonses.com."
  ]
  ttl     = 300
  type    = "CNAME"
  zone_id = "${var.zone_id}"
}

resource "aws_route53_record" "mx" {
  name    = "${var.domain}"
  records = [
    "${var.mx_record}"
  ]
  ttl     = 300
  type    = "MX"
  zone_id = "${var.zone_id}"
}

resource "aws_route53_record" "ses_verification" {
  name    = "_amazonses.${var.domain}"
  records = [
    "${var.verification_record}"
  ]
  ttl     = 300
  type    = "TXT"
  zone_id = "${var.zone_id}"
}