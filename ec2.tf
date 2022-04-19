provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "ap-south-1"
}

resource "aws_instance" "web" {
  count = length(var.instance_names)
  ami           = "ami-0851b76e8b1bce90b"
  instance_type = var.instance_type


  tags = {
    Name = var.instance_names[count.index]
  }
}
resource "aws_network_interface_sg_attachment" "sg_attachment" {
  count = length(var.instance_names)
  security_group_id    = var.security_grp_id
  network_interface_id = aws_instance.web[count.index].primary_network_interface_id
}

output "instance_name_with_ids" {
  value = zipmap(aws_instance.web[*].id, aws_instance.web[*].tags["Name"])
  
}
