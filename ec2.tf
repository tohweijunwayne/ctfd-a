resource "aws_instance" "ctfd-a-web" {
  ami               = "ami-0de4e14ede8812678"
  instance_type     = "t3.medium"
  availability_zone = "ap-southeast-1a"
  key_name          = "terraformtestkey"
  user_data         = (file("bastion.ps1"))

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.ctfd-a-web-nic.id
  }

  tags = {
    Name = "ctfd-a-web"
  }
}

resource "aws_route53_zone" "primary" {
  name = "voltex-corp.com"
}

resource "aws_route53_record" "ctfd-a-web" {
  zone_id = "Z021522675EF9ZJX942H"
  name    = "ctfd-a-web"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.ctfd-a-web.public_ip]
}