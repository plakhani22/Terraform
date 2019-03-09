resource "null_resource" "cluster" {
        count                   = "${length(var.subnets)}"

        connection {
                host                    = "${element(var.ip,count.index)}"
                user                    = "ubuntu"
                private_key             = "${file("/home/ubuntu/Project/keys/${var.key_name}.pem")}"
        }

        provisioner "file" {
                source                  = "config.json"
                destination             = "/home/ubuntu/config.json"
        }

        provisioner "file" {
                source                  = "node_exporter.service"
                destination             = "/home/ubuntu/node_exporter.service"
        }

        provisioner "remote-exec" {
                inline = [
                        "sleep 100",
                        "sudo apt-get update -y",
                        "sudo apt-get upgrade -y",
                        "sudo apt-get install unzip -y",
                        "sudo apt-get install git -y",
                        "sudo wget https://releases.hashicorp.com/consul/1.2.2/consul_1.2.2_linux_amd64.zip",
                        "sudo unzip consul_1.2.2_linux_amd64.zip",
                        "sudo rm consul_1.2.2_linux_amd64.zip",
                        "sudo mv consul /usr/bin/",
                        "sudo mkdir consul-test",
                        "sudo mkdir consul-test/config",
                        "sudo mkdir consul-test/consul.d",
                        "sudo useradd -rs /bin/false node_exporter",
                        "sudo curl -LO https://github.com/prometheus/node_exporter/releases/download/v0.16.0/node_exporter-0.16.0.linux-amd64.tar.gz",
                        "sudo tar -xvf node_exporter-0.16.0.linux-amd64.tar.gz",
                        "sudo mv node_exporter-0.16.0.linux-amd64/node_exporter /usr/local/bin/",
                        "sudo sed -i 's/Client/Client${count.index}/g' /home/ubuntu/config.json",
                        "sudo cat /home/ubuntu/config.json",
                        "sudo mv /home/ubuntu/config.json /home/ubuntu/consul-test/config",
                        "sudo mv /home/ubuntu/node_exporter.service /etc/systemd/system/node_exporter.service",
                        "sudo nohup consul agent --config-dir /home/ubuntu/consul-test/config &",
                        "sudo ps -ef | grep consul",
                        "sudo apt-get install systemd -y",
                        "sudo systemctl daemon-reload",
                        "sudo systemctl start node_exporter",
                        "sudo systemctl status node_exporter",
                        "sudo systemctl enable node_exporter",
                        "sudo hostname -i"

                ]
        }

}

variable "key_name" {}
variable "subnets" {type="list"}
variable "ip" {type="list"}