data "template_file" "index_html" {
  template = <<HTML
<html>
<header><title>$${name_prefix} Yum Repo</title></head>
<body>
<h1>This is the $${name_prefix} yum repository</h1>
</body>
</html>
HTML
  vars {
    name_prefix = "${var.name_prefix}"
  }
}

resource "aws_s3_bucket_object" "index_html" {
  bucket  = "${aws_s3_bucket.yum_repo.bucket}"
  content = "${data.template_file.index_html.rendered}"
  content_type = "text/html"
  key     = "index.html"
}