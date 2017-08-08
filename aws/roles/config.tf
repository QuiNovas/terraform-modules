module "terraform" {
  allowed_user_arns   = "${var.terraform_allowed_user_arns}"
  allowed_user_names  = "${var.terraform_allowed_user_names}"
  source              = "github.com/QuiNovas/terraform-modules//aws/roles/terraform"
}