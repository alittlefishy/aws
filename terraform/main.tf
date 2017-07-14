# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "ds_security_group"
  description = "Fulfills DS needs"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # PORT 8888 access from anywhere
  ingress {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "ds" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    user = "ec2-user"

    # The connection will use the local SSH agent for authentication.
  }

  instance_type = "${var.instance_type}"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_amis, var.aws_region)}"

  # The name of our SSH keypair we created above.
  key_name = "${aws_key_pair.auth.id}"

  # Our Security group to allow HTTP, HTTPS, Port 8888 and SSH access
  security_groups = ["${aws_security_group.default.id}"]
  
  subnet_id = "${var.subnet_id}"

  # Provision PYTHON analytical environment
  provisioner "remote-exec" {
    inline = [
      "sudo yum upgrade -y",
      "sudo yum install vim bzip2 git python-virtualenv gcc gcc-gfortran gcc-c++ atlas lapack blas postgresql-devel -y",
      "git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it",
      "~/.bash_it/install.sh --silent",
      "rm ~/.bashrc.bak",
      "sudo yum -y install wget",
      "mkdir ~/downloads",
      "mkdir ~/applications",
      "wget https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh -O ~/downloads/anaconda.sh",
      "bash ~/downloads/anaconda.sh -b -p ~/applications/anaconda",
      "echo export PATH=~/applications/anaconda/bin:'$PATH' >> ~/.bashrc",
    ]
  }

  # Refresh local IP
  provisioner "local-exec" {
    command = "echo export ec2loc=ec2-user@${aws_instance.ds.public_ip} > ~/.ec2loc"
  }

}
