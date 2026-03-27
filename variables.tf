variable "app_name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "vpc_id" {}
variable "availability_zone" {}

variable "aws_profile" {}
variable "environment" {}

variable "key_name" { default = "" }
variable "public_key_path" { default = "" }

variable "security_group_id" { default = "" }

variable "iam_role_name" { default = "" }
variable "extra_policy_arn" { default = "" }

variable "root_volume_id" { default = "" }
variable "root_volume_size" { default = 20 }

variable "user_data_file" { default = "userdata.sh" }

variable "tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
}
