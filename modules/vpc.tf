locals {
  cluster_name = var.cluster_name
}

resource "aws_vpc" "vpc" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = var.vpc_name
    }
}


resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id

    tags = {
      Namen = var.aws_igw
    }
  depends_on = [ aws_vpc.vpc ]
}

resource "aws_subnet" "aws-public-subnet" {
    vpc_id = aws_vpc.vpc.id
    count = var.aws_pub_sub_count
    cidr_block = element(var.aws_pub_cidr_block, count.index)
    availability_zone = element(var.aws_pub_avz, count.index)
    map_public_ip_on_launch = true

    tags = {
      Name = "${var.aws_pub_name}-${count.index + 1}"
    }

    depends_on = [ aws_vpc.vpc ]
}

resource "aws_subnet" "aws-private-subnet" {
    vpc_id = aws_vpc.vpc.id
    count = var.aws_pri_sub_count
    cidr_block = element(var.aws_pri_cidr_block, count.index)
    availability_zone = element(var.aws_pri_avz, count.index)
    map_public_ip_on_launch = false

    tags = {
      Name = "${var.aws_pri_name}-${count.index + 1}"
    }

    depends_on = [ aws_vpc.vpc ]
}


resource "aws_route_table" "aws-public-rt" {
    vpc_id = aws_vpc.vpc.id
   
   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
    
    tags = {
      Name = var.aws_pub_rt_name
    }
    depends_on = [ aws_vpc.vpc ]
  
}

resource "aws_route_table_association" "pub-rt-association" {
    count = 2
    route_table_id = aws_route_table.aws-public-rt.id
    subnet_id = aws_subnet.aws-public-subnet[count.index].id
    depends_on = [ aws_vpc.vpc, aws_subnet.aws-public-subnet ]
}

resource "aws_eip" "eip" {
    domain = "vpc"

    tags = {
      Name = var.aws_eip
    }
}

resource "aws_nat_gateway" "aws_nat_gate" {
    allocation_id = aws_eip.eip.id
    subnet_id = aws_subnet.aws-public-subnet[0].id


    depends_on = [ aws_vpc.vpc, aws_eip.eip ]
}

resource "aws_route_table" "aws-private-rt" {
    vpc_id = aws_vpc.vpc.id
   
   route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.aws_nat_gate.id

  }
    
    tags = {
      Name = var.aws_pri_rt_name
    }
    depends_on = [ aws_vpc.vpc ] 
}


resource "aws_route_table_association" "pri-rt-association" {
    count = 2
    route_table_id = aws_route_table.aws-private-rt.id
    subnet_id = aws_subnet.aws-private-subnet[count.index].id

    depends_on = [ aws_vpc.vpc, aws_subnet.aws-private-subnet ]
  
}

resource "aws_security_group" "eks-cluster-sg" {
  name        = var.eks-sg
  description = "Allow 443 from Jump Server only"

  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // It should be specific IP range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.eks-sg
  }
}

