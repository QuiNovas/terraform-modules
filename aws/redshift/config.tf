module "availability_zones_count" {
  source  = "github.com/QuiNovas/terraform-modules//common/pass-thru-string"
  value   = "${length(var.availability_zones)}"
}
