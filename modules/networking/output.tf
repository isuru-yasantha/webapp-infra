/* Output values from networking module */

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "public_subnets_id" {
  value = aws_subnet.public_subnet.*.id
}

output "private_subnets_id" {
  value = aws_subnet.private_subnet.*.id
}


output "alb_sg_id" {
  value = "${aws_security_group.alb-sg.id}"
}

output "service_sg_id" {
  value = "${aws_security_group.service-sg.id}"
}

