module "ec2"{
        source                                          = "../../Modules/EC2"

        instance_name                           = "Service1"

        latest_ami                                      = "true"
        subnets                                         = ["subnet-c85e8884"]
        app_instance_type                       = "t2.micro"
        security_group_ids                      = ["sg-44f1b42b"]
        key_name                                        = "FinalProject"


        tags = {
                Service = "trail"
        }
}


output "private_ip"{
        value = "${module.ec2.private_ip}"
}
