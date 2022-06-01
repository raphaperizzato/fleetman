data "aws_ami" "amzlinux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_key_pair" "key" {
  key_name   = "default"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDw60dmaxt8Ugt4rh9yfmuoyUNHpsnsAt2lnQkq0R6kEqx0eKriNoSRNcMPwCkXGkQsbAoQ4kyO7NL+fPKRUzh+vMXEJzPMxBXf/NFK+l3ImAWwIVSCz6UTkH64rvJU+2rsExGEeQtQ78BW/UEm2BJtSGomoacK0x4vWAYliRR4sFkjyA6+hFjP9QEOjs+pROEdhcJ83YLBWGbevYpl/ozTBxb862/sDfS9kj0SxXCeBahkmvFYUZr7WLIChCHV/YpBaNjIzijhomSi0OC4vGvxPZ/VQnj9+lN7p6tUsWtHdGUBA0/5WRZ8O7jsWzw03HD4FrI11YzB7AiqgiSrPJs6bcMX1w2JC/w1ytYtqgImoRxSrRqKUa4nyHUAMDMzG9hRSLsZ2VraL9gJ6WbSTV24ltki8V6YcyyKa+3t2wcZrhj9yiVtrjpvtHA4zCfS+mVYycRCrwAhK8tFwmIV/292DwpIny62zbQzzc9u4GTOKPxNRJFHhHHDB3aqnkw0/h0= rapha@DESKTOP-2022"
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "eks-bastion"

  ami                    = data.aws_ami.amzlinux.id
  instance_type          = "t3.micro"
  key_name               = "default"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.eks-cluster.id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    auto-delete = "no"
  }
}

output "ip" {
  value = module.ec2_instance.public_ip
}