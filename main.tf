provider "aws" {}

provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}

variable "domain_name" {
  type = string
}

output "name_servers_tlexample" {
  value = "${aws_route53_zone.tlexample.name_servers}"
}

output "lambda_url" {
  value = aws_api_gateway_deployment.tlexample.invoke_url
}
