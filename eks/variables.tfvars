cluster_name = "eks-cluster"
aws_region = "ap-south-1"
cidr_block = "10.16.0.0/16"
vpc_name = "eks-vpc"
igw_name = "vpc-igw-pass"
aws_pub_name = "eks-public-subnet"
aws_pub_sub_count  = 2
aws_pub_cidr_block = ["10.16.0.0/20", "10.16.16.0/20"]
aws_pub_avz = ["ap-south-1a", "ap-south-1b"]
aws_pri_name = "eks-private-subnet"
aws_pri_sub_count = 2
aws_pri_cidr_block = ["10.16.32.0/20", "10.16.128.0/20"]
aws_pri_avz = ["ap-south-1a", "ap-south-1b"]
aws_pub_rt_name = "public-route-table"
aws_eip = "eks-eip"
aws_pri_rt_name = "private-route-table"

#eks

eks-sg = "eks-sg"




