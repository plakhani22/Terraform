resource "null_resource" "cluster" {
        count                   = "${length(var.subnets)}"

        connection {
                host                    = "${element(var.ip,count.index)}"
                user                    = "ubuntu"
                private_key             = "${file("/home/ubuntu/Project/keys/${var.key_name}.pem")}"
        }

        provisioner "remote-exec" {
		
        inline = [
		"sudo git clone https://github.com/callicoder/spring-boot-file-upload-download-rest-api-example.git",
		"sudo cd spring-boot-file-upload-download-rest-api-example",
		"sudo mvn spring-boot:run"
                ]
        }

}

variable "key_name" {}
variable "subnets" {type="list"}
variable "ip" {type="list"}
