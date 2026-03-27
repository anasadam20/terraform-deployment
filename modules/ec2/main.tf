
# ---------------------------
# Key Pair (existing or new)
# ---------------------------
resource "tls_private_key" "this" {
  count     = var.key_name == "" ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  count      = var.key_name == "" ? 1 : 0
  key_name   = "${var.app_name}-key"
  public_key = tls_private_key.this[0].public_key_openssh
}

resource "local_file" "pem" {
  count    = var.key_name == "" ? 1 : 0
  filename = "${path.module}/${var.app_name}-key.pem"
  content  = tls_private_key.this[0].private_key_pem
}

locals {
  effective_key_name = var.key_name != "" ? var.key_name : aws_key_pair.this[0].key_name
}

# ---------------------------
# Security Group (existing or new)
# ---------------------------
resource "aws_security_group" "this" {
  count       = var.security_group_id == "" ? 1 : 0
  name        = "${var.app_name}-sg"
  description = "Security group for ${var.app_name}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

locals {
  effective_sg_id = var.security_group_id != "" ? var.security_group_id : aws_security_group.this[0].id
}

# ---------------------------
# IAM Role + Instance Profile
# ---------------------------
resource "aws_iam_role" "this" {
  count = var.iam_role_name == "" ? 1 : 0
  name  = "${var.app_name}-role"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
  tags               = var.tags
}

data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  count      = var.iam_role_name == "" ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "extra" {
  count      = var.extra_policy_arn == "" ? 0 : 1
  role       = aws_iam_role.this[0].name
  policy_arn = var.extra_policy_arn
}

resource "aws_iam_instance_profile" "this" {
  count = var.iam_role_name == "" ? 1 : 0
  name  = "${var.app_name}-profile"
  role  = aws_iam_role.this[0].name
  tags  = var.tags
}

locals {
  effective_instance_profile = var.iam_role_name != "" ? var.iam_role_name : aws_iam_instance_profile.this[0].name
}
/*
# ---------------------------
# Root Volume (existing or new)
# ---------------------------
resource "aws_ebs_volume" "root" {
  count             = var.root_volume_id == "" ? 1 : 0
  availability_zone = data.aws_subnet.selected.availability_zone
  size              = var.root_volume_size
  encrypted         = true
  tags              = var.tags
}

locals {
  effective_root_volume_id = var.root_volume_id != "" ? var.root_volume_id : aws_ebs_volume.root[0].id
}

resource "aws_volume_attachment" "root_attach" {
  device_name = "/dev/sda1"
  volume_id   = local.effective_root_volume_id
  instance_id = aws_instance.this.id
}
*/


# ---------------------------
# EC2 Instance
# ---------------------------
resource "aws_instance" "this" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  subnet_id            = var.subnet_id
  key_name             = local.effective_key_name
  vpc_security_group_ids = [local.effective_sg_id]
  iam_instance_profile = local.effective_instance_profile

  dynamic "root_block_device" {
    for_each = var.root_volume_id == "" ? [1] : []
    content {
      volume_size = var.root_volume_size
      encrypted   = true
    }
  }

  user_data = file("${path.root}/root/ec2/${var.user_data_file}")
  tags      = var.tags
}
