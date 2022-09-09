data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name      = "stage-vpc",
    terraform = "true",
  }
}


resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(data.aws_availability_zones.available.names)
  cidr_block              = element(var.pub_cidr, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true


  tags = {
    Name      = "Stage-Pub-subnet-${count.index + 1}"
    terraform = "true"

  }

}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(data.aws_availability_zones.available.names)
  cidr_block        = element(var.private_cidr, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name      = "Stage-Private-subnet-${count.index + 1}"
    terraform = "true"
  }
}

resource "aws_subnet" "data" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(data.aws_availability_zones.available.names)
  cidr_block        = element(var.data_cidr, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name      = "Stage-Data-subnet-${count.index + 1}"
    terraform = "true"

  }

}

# #igw 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name      = "stage-igw"
    terraform = "true"
  }
}

# #eip
resource "aws_eip" "eip" {
  vpc = true
  tags = {
    Name      = "stage-eip"
    terraform = "true"
  }

}

# #nat-gateway
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name      = "stage-natgw",
    terraform = "true"
    # Project     = var.project,
    # Environment = var.environment
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  #   # on the Internet Gateway for the VPC.
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name      = "stage-route-Public",
    terraform = "true"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name      = "stage-route-Private",
    terraform = "true"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "data" {
  count          = length(var.private_cidr)
  subnet_id      = aws_subnet.data[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.private_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}