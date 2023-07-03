resource "aws_vpc" "ctfd-a-web-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Testing"
  }
}



resource "aws_internet_gateway" "ctfd-a-web-gw" {
  vpc_id = aws_vpc.ctfd-a-web-vpc.id
}


resource "aws_route_table" "ctfd-a-web-route-table" {
  vpc_id = aws_vpc.ctfd-a-web-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ctfd-a-web-gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.ctfd-a-web-gw.id
  }

  tags = {
    Name = "ctfd-a-web-routetable"
  }
}



resource "aws_subnet" "ctfd-a-web-subnet" {
  vpc_id            = aws_vpc.ctfd-a-web-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "ctfd-a-web-subnet"
  }
}


resource "aws_route_table_association" "ctfd-a-web-rta" {
  subnet_id      = aws_subnet.ctfd-a-web-subnet.id
  route_table_id = aws_route_table.ctfd-a-web-route-table.id
}

resource "aws_network_interface" "ctfd-a-web-nic" {
  subnet_id       = aws_subnet.ctfd-a-web-subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_access.id]

}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.ctfd-a-web-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.ctfd-a-web-gw]
}