module "terraform" {
  allowed_user_arns = "${var.terraform_allowed_user_arns}"
  source            = "github.com/QuiNovas/terraform-modules//aws/roles/terraform"
}