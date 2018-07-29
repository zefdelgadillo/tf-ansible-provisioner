output "managed_instance_public_ip" {
  value = "${aws_instance.zd_ansible_1.public_ip}"
}
