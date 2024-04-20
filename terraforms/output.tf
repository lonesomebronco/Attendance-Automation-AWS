output "API_invoke_url" {
  value = aws_api_gateway_deployment.deployment.invoke_url
   depends_on = [
    aws_api_gateway_deployment.deployment
   ]
}

output "amplify_app_id" {
  value = aws_amplify_app.my_app.id
}

#create a files : 
data "local_file" "api_invoke_url" {
  filename = "api_invoke_url.txt"

  depends_on = [ null_resource.write_output_to_file ]
}

data "local_file" "aws_cognito_identity_pool_id" {
  filename = "aws_cognito_identity_pool_id.txt"

  depends_on = [ null_resource.write_output_to_file ]
}

data "local_file" "aws_user_pools_id" {
  filename = "aws_user_pools_id.txt"

  depends_on = [ null_resource.write_output_to_file ]
}

data "local_file" "aws_user_pools_web_client_id" {
  filename = "aws_user_pools_web_client_id.txt"

  depends_on = [ null_resource.write_output_to_file ]
}



#insert into files : 
resource "null_resource" "write_output_to_file" {
  provisioner "local-exec" {
    command = "echo '${aws_api_gateway_deployment.deployment.invoke_url}' | tr -d '\n' > api_invoke_url.txt"
  }

  depends_on = [
    aws_api_gateway_deployment.deployment
  ]
}

# output "amplify_app_url" {
#   value = aws_amplify_domain_association.domain_association.domain_name
# }