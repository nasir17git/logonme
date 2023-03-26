resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "pubrt"
  }
}

resource "aws_route_table_association" "prta" {
  subnet_id      = aws_subnet.pub1.id
  route_table_id = aws_route_table.pubrt.id
}

resource "aws_network_interface" "nat" {
  subnet_id = aws_subnet.pub1.id

  tags = {
    Name = "nat_nw_interface"
  }
}

resource "aws_route_table" "prirt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_instance.bastion.primary_network_interface_id
  }

  tags = {
    Name = "prirt"
  }
}

resource "aws_route_table_association" "pri1rta" {
  subnet_id      = aws_subnet.pri1.id
  route_table_id = aws_route_table.prirt.id
}

resource "aws_route_table_association" "pri2rta" {
  subnet_id      = aws_subnet.pri2.id
  route_table_id = aws_route_table.prirt.id
}
resource "aws_route_table_association" "pri3rta" {
  subnet_id      = aws_subnet.pri3.id
  route_table_id = aws_route_table.prirt.id
}