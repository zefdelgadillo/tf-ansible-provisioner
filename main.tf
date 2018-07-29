resource "aws_instance" "zd_ansible_1" {
  instance_type               = "t2.small"
  key_name                    = "zefdelgadillo-cr-mbp"
  ami                         = "ami-a9d09ed1"
  subnet_id                   = "subnet-9ea6a9d6"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]

  tags {
    Name     = "Terraform + Ansible Testing"
    hostname = "zd-ansible-1"
  }

  user_data = <<EOF
    #!/bin/bash
    sudo yum install git -y
    sudo amazon-linux-extras install ansible2 -y
    sudo ansible-pull -U https://github.com/zefdelgadillo/ansible-pull-playbooks -e hostname=zd-ansible-1
  EOF
}

resource "aws_ebs_volume" "zd_ansible_1_storage" {
  availability_zone = "us-west-2a"
  size              = 40

  tags {
    Name = "Terraform + Ansible Testing"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdb"
  volume_id   = "${aws_ebs_volume.zd_ansible_1_storage.id}"
  instance_id = "${aws_instance.zd_ansible_1.id}"
}

# Just to make SSH easier
resource "aws_route53_record" "zd_ansible_1" {
  zone_id = "ZH4DT6HJH5B2J"
  name    = "zd-ansible-1.bigbother.co.uk"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.zd_ansible_1.public_ip}"]
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "vpc-8f17bff6"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
