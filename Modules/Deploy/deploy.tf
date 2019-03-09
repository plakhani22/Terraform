resource "null_resource" "cluster" {
        count                   = "${length(var.subnets)}"

        connection {
                host                    = "${element(var.ip,count.index)}"
                user                    = "ubuntu"
                private_key             = "${file("/home/ubuntu/Project/keys/${var.key_name}.pem")}"
        }

        provisioner "remote-exec" {
		
        inline = [
		"sudo apt-get install default-jdk -y",
		"sudo git clone git@github.com:plakhani22/Project.git",
		"sudo mvn spring-boot:run"
                ]
        }

}

variable "key_name" {}
variable "subnets" {type="list"}
variable "ip" {type="list"}
