/*
resource "aws_lambda_function" "test_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function_name"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "exports.test"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "nodejs12.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}
*/


data "archive_file" "tlexample" {
  type        = "zip"
  source_file = "${path.module}/app/tlexample.js"
  output_path = "${path.module}/app/tlexample.zip"
}

resource "aws_lambda_function" "tlexample" {
  role          = aws_iam_role.tlexample.arn
  filename      = "${path.module}/app/tlexample.zip"
  function_name = "tlexample"
  handler       = "tlexample.handler"
  //source_code_hash = "${data.archive_file.shortcutcodes.output_base64sha256}"
  source_code_hash = data.archive_file.tlexample.output_base64sha256
  runtime          = "nodejs12.x"
}

resource "aws_lambda_permission" "tlexample" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tlexample.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.tlexample.execution_arn}/*/*"
}
