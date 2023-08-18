provider "aws" {
    region = "ap-south-1"
  
}

resource "aws_key_pair" "my_key" {
  key_name   = "my_key"
  public_key = file("C:/Users/shiva/Downloads/shivam.pub") 
}

data "template_file" "nginx_install" {
  template = <<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo apt-get install -y nginx
                sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
                sudo apt-get update 
                sudo apt-get install ansible
                # sudo ansible -i ansible_inventory all -m ping
                sudo systemctl start nginx  
               EOF

}




resource "aws_instance" "ansible"{
    ami = "ami-0f5ee92e2d63afc18"
    instance_type = "t2.micro"
    key_name = aws_key_pair.my_key.key_name
    vpc_security_group_ids = ["sg-074e601a0e7f7efc7"]
    user_data = data.template_file.nginx_install.rendered

    depends_on = [ aws_instance.managed ]
    tags = {
        Name = "ansible"
    }
    }



resource "null_resource" "ansible_inventory" {
  provisioner "local-exec" {
     command = "powershell.exe echo $terraform output > inventory.txt" 
    working_dir = "C:/Users/shiva/Downloads/"
  }
  depends_on = [ aws_instance.managed ]
}



resource "aws_instance" "managed" {
    ami = "ami-0f5ee92e2d63afc18"
    instance_type = "t2.micro"
    key_name = aws_key_pair.my_key.key_name
    vpc_security_group_ids = ["sg-074e601a0e7f7efc7"]
    tags = {
        Name = "managed_hosts"
    }
  }
    