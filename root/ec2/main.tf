provider "aws" {
  region  = var.region
}

module "ec2" {
  source            = "../../modules/ec2"
  app_name          = var.app_name
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = var.subnet_id
  vpc_id            = var.vpc_id
  availability_zone = var.availability_zone
  aws_profile       = var.aws_profile
  environment       = var.environment

  key_name          = var.key_name
  public_key_path   = var.public_key_path
  security_group_id = var.security_group_id
  iam_role_name     = var.iam_role_name
  extra_policy_arn  = var.extra_policy_arn
  root_volume_id    = var.root_volume_id
  root_volume_size  = var.root_volume_size
  user_data_file    = var.user_data_file

  tags              = local.selected_tags
}
