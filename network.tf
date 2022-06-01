module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "rapha-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  tags = {
    "terraform" = "true"
    "owner"     = "raphael"
  }

}

resource "aws_security_group" "eks-cluster" {
  name   = "SG-eks-cluster"
  vpc_id = module.vpc.vpc_id

  # Egress allows Outbound traffic from the EKS cluster to the  Internet 

  egress { # Outbound Rule
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Ingress allows Inbound traffic to EKS cluster from the  Internet 

  ingress { # Inbound Rule
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


