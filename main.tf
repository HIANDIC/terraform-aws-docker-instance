# filter islemleri ile ilgili olarak
# descript instance in documentation dan kullanilabilecek argumentlere ulasiyoruz
# ayni duruma descript instance image den de ulasilabilmektedir.
# her iki taraftaki argument ler de kullanilabilmektedir
# bu ikisine de aws documentation dan ulasiyoruz. terraformda ilgili yerde link leri var


data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["amazon"] # Canonical
}

data "template_file" "userdata" {
  template = file("${abspath(path.module)}/userdata.sh")
  vars = {
    server-name = var.server_name
  }
}

resource "aws_instance" "tfmyec2" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance_type
  count                  = var.num_of_instance
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.tf-sec-gr.id]
  user_data              = data.template_file.userdata.rendered

  tags = {
    Name = var.tag
  }
}

resource "aws_security_group" "tf-sec-gr" {
  name        = "${var.tag}-terraform-sec-grp"
  description = "Allow SSH, HTTP, 8080 ports."

  dynamic "ingress" {
    for_each = var.docker-instance-ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.tag
  }
}


