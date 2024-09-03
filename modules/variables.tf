variable "cluster_name" {}
variable "cidr_block" {}
variable "vpc_name" {}
variable "aws_igw" {}
variable "aws_pub_name" {}
variable "aws_pub_sub_count" {}
variable "aws_pub_cidr_block" {
    type = list(string)
}
variable "aws_pub_avz" {
    type = list(string)
}
variable "aws_pri_name" {}
variable "aws_pri_sub_count" {}
variable "aws_pri_cidr_block" {type = list(string)}
variable "aws_pri_avz" {type = list(string)}
variable "aws_pub_rt_name" {}
variable "aws_eip" {}
variable "aws_pri_rt_name" {}


#eks

variable "eks-sg" {}


