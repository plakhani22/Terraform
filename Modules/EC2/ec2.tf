provider "aws" {
region     = "us-east-2"
}



data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
owners = ["099720109477"] # Canonical
}


resource "aws_instance" "app-instance1" {
        count                  = "${length(var.subnets)}"
        ami                    = "${data.aws_ami.ubuntu.id}"
        instance_type          = "${var.app_instance_type}"
        vpc_security_group_ids = "${var.security_group_ids}"
        subnet_id              = "${element(var.subnets, count.index)}"
        tags                   = "${merge(var.tags,
                                                                map("NAME",var.instance_name),
                                                                map("Name",var.instance_name))}"
        key_name               = "${var.key_name}"
        associate_public_ip_address = true

}

output "private_ip"{
	value = "${aws_instance.app-instance1.*.private_ip}"
}

variable "instance_name" {}
variable "latest_ami" {}
variable "app_instance_type" {}
variable "key_name" {}
variable "subnets" {type="list"}
variable "security_group_ids" {type="list"}
variable "tags" {type="map"}
