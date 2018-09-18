resource "aws_instance" "bastion" {
  ami = "${lookup(var.amis, var.aws_region)}"
  availability_zone = "${element(split(",", lookup(var.azs, var.region)), count.index)}"
  instance_type = "t2.micro"
  key_name = "${var.aws_bastionkey_name}"
  security_groups = ["${aws_security_group.nat.id}"]
  subnet_id = "${aws_subnet.eu-central-public.0.id}"
  associate_public_ip_address = true
  source_dest_check = false
  tags {
    Name = "${var.Environment}-bastion"
	Environment = "${var.Environment}"
    Contact = "${var.Contact}"
  }
}

