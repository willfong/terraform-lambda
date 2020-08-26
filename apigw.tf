resource "aws_api_gateway_rest_api" "tlexample" {
  name        = "tlexample"
  description = "tlexample"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_resource" "tlexample" {
  rest_api_id = aws_api_gateway_rest_api.tlexample.id
  parent_id   = aws_api_gateway_rest_api.tlexample.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "tlexample" {
  rest_api_id   = aws_api_gateway_rest_api.tlexample.id
  resource_id   = aws_api_gateway_resource.tlexample.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "tlexample" {
  rest_api_id = aws_api_gateway_rest_api.tlexample.id
  resource_id = aws_api_gateway_method.tlexample.resource_id
  http_method = aws_api_gateway_method.tlexample.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.tlexample.invoke_arn
}

resource "aws_api_gateway_method" "tlexample_root" {
  rest_api_id   = aws_api_gateway_rest_api.tlexample.id
  resource_id   = aws_api_gateway_rest_api.tlexample.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "tlexample_root" {
  rest_api_id = aws_api_gateway_rest_api.tlexample.id
  resource_id = aws_api_gateway_method.tlexample_root.resource_id
  http_method = aws_api_gateway_method.tlexample_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.tlexample.invoke_arn
}

resource "aws_api_gateway_deployment" "tlexample" {
  depends_on = [
    aws_api_gateway_integration.tlexample,
    aws_api_gateway_integration.tlexample_root,
  ]

  rest_api_id = aws_api_gateway_rest_api.tlexample.id
  stage_name  = "test"
}


resource "aws_api_gateway_domain_name" "tlexample" {
  certificate_arn = aws_acm_certificate_validation.tlexample.certificate_arn
  domain_name     = var.domain_name
  endpoint_configuration {
    types = ["EDGE"]
  }
}


resource "aws_api_gateway_base_path_mapping" "tlexample" {
  api_id      = aws_api_gateway_rest_api.tlexample.id
  stage_name  = aws_api_gateway_deployment.tlexample.stage_name
  domain_name = aws_api_gateway_domain_name.tlexample.domain_name
}
