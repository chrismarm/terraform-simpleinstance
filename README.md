# terraform-simpleinstance
An instance inside a public subnet running a http server. Elements:

* VPC
* Subnet
* Internet gateway attached to the VPC
* Route table with default entry to IG no have access from internet
* Route table association with subnet
* Security group with open ports for http, ssh and ping
