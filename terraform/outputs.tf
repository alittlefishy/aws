output "address" {
  value = "${aws_elb.web.dns_name}"
}

output "ec2_private_ip" {
  value = "${aws_instance.web.private_ip}"
}

output "ec2_public_ip" {
  value = "${aws_instance.web.public_ip}"
}

output "ec2_instance_id" {
  value = "${aws_instance.web.id}"
}
