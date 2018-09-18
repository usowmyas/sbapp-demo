output "bastion" {
  value = "${aws_instance.bastion.public_ip}"
}

output "private_subnet_ids" {
  value = ["${join(",", aws_subnet.eu-central-private.*.id)}"]
}

output "private_subnet_cidr" {
  value = ["${join(",", aws_subnet.eu-central-private.*.cidr_block)}"]
}

output "public_subnet_ids" {
  value = ["${join(",", aws_subnet.eu-central-public.*.id)}"]
}

output "public_subnet_cidr" {
  value = ["${join(",", aws_subnet.eu-central-public.*.cidr_block)}"]
}

output "availability_zone" {
  value = "${split(",", lookup(var.azs, var.region))}"
}

output "vpc" {
  value = "${aws_vpc.cpesvpc.id}"
}