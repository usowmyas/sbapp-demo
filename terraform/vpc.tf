resource "aws_vpc" "cpesvpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags {
    Name = "${var.Environment}-vpc"
	Contact = "${var.Contact}"
	Environment = "${var.Environment}"
  }
}

resource "aws_internet_gateway" "mtdefaultig" {
  vpc_id = "${aws_vpc.cpesvpc.id}"

  tags {
    Name = "${var.Environment}-gateway"
	Contact = "${var.Contact}"
	Environment = "${var.Environment}"
  }
}

/*
  Public Subnet
*/
resource "aws_subnet" "eu-central-public" {
  vpc_id            = "${aws_vpc.cpesvpc.id}"
  count             = "${length(split(",", lookup(var.azs, var.region)))}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr, 4, count.index)}"
  availability_zone = "${element(split(",", lookup(var.azs, var.region)), count.index+2)}"

  tags {
    Name = "${var.Environment}-public-${element(split(",", lookup(var.azs, var.region)), count.index)}"
	Contact = "${var.Contact}"
	Environment = "${var.Environment}"
  }
}

resource "aws_route_table" "eu-central-public" {
  vpc_id = "${aws_vpc.cpesvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.mtdefaultig.id}"
  }

  tags {
    Name = "Public Subnet"
	Contact = "${var.Contact}"
	Environment = "${var.Environment}"
  }
}

resource "aws_route_table_association" "eu-central-public" {
  count = "2"
  subnet_id = "${element(aws_subnet.eu-central-public.*.id, count.index)}"
  route_table_id = "${aws_route_table.eu-central-public.id}"
}

/*
  Private Subnet
*/
resource "aws_subnet" "eu-central-private" {
  vpc_id            = "${aws_vpc.cpesvpc.id}"
  count             = "${length(split(",", lookup(var.azs, var.region)))}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr, 4, count.index+2)}"
  availability_zone = "${element(split(",", lookup(var.azs, var.region)), count.index)}"
  map_public_ip_on_launch = false

  tags {
    Name = "${var.Environment}-private-${element(split(",", lookup(var.azs, var.region)), count.index)}"
	Contact = "${var.Contact}"
	Environment = "${var.Environment}"
  }
}

resource "aws_route_table" "eu-central-private" {
  vpc_id = "${aws_vpc.cpesvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.bastion.id}"
  }

  tags {
    Name = "Private Subnet"
	Contact = "${var.Contact}"
	Environment = "${var.Environment}"
  }
}

resource "aws_route_table_association" "eu-central-private" {
  count = "2"
  subnet_id = "${element(aws_subnet.eu-central-private.*.id, count.index)}"
  route_table_id = "${aws_route_table.eu-central-private.id}"
}

/*
  NAT Instance
*/

resource "aws_security_group" "nat" {
  name = "${var.Environment}-nat-sg"
  description = "Allow traffic to pass from the private subnet to the internet"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${aws_subnet.eu-central-private.0.cidr_block}"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${aws_subnet.eu-central-private.1.cidr_block}"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["${aws_subnet.eu-central-private.0.cidr_block}"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["${aws_subnet.eu-central-private.1.cidr_block}"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["${aws_subnet.eu-central-private.0.cidr_block}"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["${aws_subnet.eu-central-private.1.cidr_block}"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  vpc_id = "${aws_vpc.cpesvpc.id}"

  tags {
    Name = "${var.Environment}-nat-sg"
	Contact = "${var.Contact}"
	Environment = "${var.Environment}"
  }
}

