# Terraform + Lambda

Work in progress...

## Getting Started

This example uses ACM to generate HTTPS certificates, with DNS validation. Ensure your domain name is set to use AWS's DNS servers before proceeding.

We can create the hosted zone in Route53 first, which will give us a list of DNS servers:
`terraform apply -var="domain_name=example.com" -target aws_route53_zone.tlexample`

Update your domain name with the DNS servers listed in the output.

Then we can deploy the full solution
`terraform apply -var="domain_name=example.com"`

Test your code:
`curl https://example.com/`


Destroy everything to start fresh:
`terraform destroy -var="domain_name=example.com"`


## Todo

- Enable Cloudwatch monitoring for the API gateway.

## Notes

https://learn.hashicorp.com/tutorials/terraform/lambda-api-gateway
