data "terraform_remote_state" "MONITOR" {
    backend = "local"
    config {
        path = "../EC2/terraform.tfstate"
    }
}


module "monitor"{
        source                          = "../../Modules/MONITOR/"
         key_name                                        = "FinalProject"
        subnets                                         = ["subnet-c85e8884"]
        ip = ["${data.terraform_remote_state.MONITOR.private_ip}"]
}
