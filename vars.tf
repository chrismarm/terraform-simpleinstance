# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "PUBLIC_KEY_PATH" {
  type = "string"
  default = "~/Development/terraform/intro-to-terraform/single-web-server/simple.pub"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 8080
}

variable "region" {
  type = "string"
  description = "Chosen region. As a newbie, only N.Virginia is allowed for me"
  default = "us-east-1"
}

variable "availability-zone1" {
  type = "string"
  default = "us-east-1a"
}