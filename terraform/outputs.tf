output "address" {
  value = "${aws_instance.ds.dns_name}"
}

output "ec2_private_ip" {
  value = "${aws_instance.ds.private_ip}"
}

output "ec2_public_ip" {
  value = "${aws_instance.ds.public_ip}"
}

output "ec2_instance_id" {
  value = "${aws_instance.ds.id}"
}
