resource "aws_security_group" "bservices" {
  name = "${var.Environment}-sg-private"
  description = "Allow incoming database connections."
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
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
    from_port = 1389
    to_port = 1389
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 4444
    to_port = 4444
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 8989
    to_port = 8989
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 58989
    to_port = 58989
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
    from_port = 5444
    to_port = 5444
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.cpesvpc.id}"

  tags {
    Name = "${var.Environment}-sg-private"
    Environment = "${var.Environment}"
    Contact = "${var.Contact}"
  }
}

/*
  Security Group for frontend services
*/
  resource "aws_security_group" "fservices" {
  name        = "${var.Environment}-sg-public"
  description = "Allow incoming HTTP connections."
  depends_on  = ["aws_internet_gateway.mtdefaultig"]

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.cpesvpc.id}"

  tags {
    Name        = "${var.Environment}-sg-public"
    Environment = "${var.Environment}"
    Contact     = "${var.Contact}"
  }
}

/*
  Security Group for bastion
*/
resource "aws_security_group" "bastion" {
  name        = "${var.Environment}-sg-bastion"
  description = "Allow incoming SSH connections."

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.cpesvpc.id}"

  tags {
    Name        = "${var.Environment}-sg-bastion"
    Contact     = "${var.Contact}"
    Environment = "${var.Environment}"
  }
}
