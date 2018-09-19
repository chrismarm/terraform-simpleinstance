# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY A SINGLE EC2 INSTANCE
# This template uses runs a simple "Hello, World" web server on a single EC2 Instance
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ------------------------------------------------------------------------------

provider "aws" {
  region = "${var.region}"
}

# -----------------------------------------
# DEPLOY A SINGLE EC2 INSTANCE
# -----------------------------------------

resource "aws_instance" "example" {
  # Ubuntu Server 16.04 LTS (HVM), SSD Volume Type in us-east-1
  ami = "ami-04681a1dbd79675a5"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
  key_name = "${aws_key_pair.simplekeypair.key_name}"
  subnet_id = "${aws_subnet.simpleVpc-public-1.id}"

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  tags {
    Name = "terraform-example"
  }
}

# ------------------------------------------
# CREATE THE SECURITY GROUP
# ------------------------------------------

resource "aws_security_group" "instance" {
  vpc_id = "${aws_vpc.simpleVpc.id}"
  name = "terraform-example-instance"

  # SSH
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  # HTTP
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # ping
  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------------------------------
# CREATE DEFAULT VPC
# -------------------------------------------

# VPC
resource "aws_vpc" "simpleVpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    tags {
        Name = "SimpleVpc"
    }
}

# -------------------------------------------
# CREATE PUBLIC SUBNET INSIDE DEFAULT VPC
# -------------------------------------------

resource "aws_subnet" "simpleVpc-public-1" {
    vpc_id = "${aws_vpc.simpleVpc.id}"
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "${var.availability-zone1}"

    tags {
        Name = "simpleVpc-public-1"
    }
}

resource "aws_key_pair" "simplekeypair" {
  key_name = "simplekey"
  public_key = "${file("${var.PUBLIC_KEY_PATH}")}"
}

resource "aws_internet_gateway" "simple-gw" {
    vpc_id = "${aws_vpc.simpleVpc.id}"

    tags {
        Name = "SimpleIG"
    }
}

resource "aws_route_table" "simple-rt" {
    vpc_id = "${aws_vpc.simpleVpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.simple-gw.id}"
    }

    tags {
        Name = "simple-rt"
    }
}

resource "aws_route_table_association" "simple-rt-a" {
    subnet_id = "${aws_subnet.simpleVpc-public-1.id}"
    route_table_id = "${aws_route_table.simple-rt.id}"
}