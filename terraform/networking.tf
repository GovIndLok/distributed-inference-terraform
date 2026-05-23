# State can be either: available, information, impaired, or unavailable
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "di_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    project = "di_assignment"
    name    = "di-vpc"
  }
}

resource "aws_subnet" "public_sn" {
  vpc_id            = aws_vpc.di_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    project = "di_assignment"
    name    = "public-sn"
  }
}

resource "aws_subnet" "private_sn" {
  vpc_id            = aws_vpc.di_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    project = "di_assignment"
    name    = "private-sn"
  }
}

resource "aws_internet_gateway" "di_igw" {
  vpc_id = aws_vpc.di_vpc.id

  tags = {
    project = "di_assignment"
    name    = "di-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.di_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.di_igw.id
  }

  tags = {
    project = "di_assignment"
    name    = "public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_sn.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    project = "di_assignment"
    name    = "public-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_sn.id

  depends_on = [aws_internet_gateway.di_igw]

  tags = {
    project = "di_assignment"
    name    = "nat"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.di_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    project = "di_assignment"
    name    = "private-rt"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_sn.id
  route_table_id = aws_route_table.private_rt.id
}


