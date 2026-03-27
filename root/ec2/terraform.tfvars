region            = "us-east-1"
aws_profile       = "myprofile"
environment       = "dev"
app_name          = "teamsecond"

ami_id            = "ami-02dfbd4ff395f2a1b"
instance_type     = "t3.micro"
subnet_id         = "subnet-09ba8630cf40c93a1"
vpc_id            = "vpc-01dbd05626989426b"
availability_zone = "us-east-1a"

key_name          = ""                
public_key_path   = "id_rsa.pub"
security_group_id = "sg-0348f5a264d2a2c67"
iam_role_name     = ""
extra_policy_arn  = ""
root_volume_id    = ""
root_volume_size  = 30
user_data_file = "userdata.sh"

