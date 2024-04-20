
# TO CHANGE
# Create Cognito User Pool
# resource "aws_cognito_user_pool" "my_user_pool" {
#   name = "my-user-pool"

#   schema {
#     name = "Email"
#     attribute_data_type = "String"
#     mutable = true
#     developer_only_attribute = false
#   }

#   # Define user pool policies and attributes
#   password_policy {
#     minimum_length    = 8
#     require_lowercase = true
#     require_numbers   = false
#     require_symbols   = false
#     require_uppercase = false
#   }
#   email_configuration {
#     email_sending_account = "COGNITO_DEFAULT"
  
#   }

#   auto_verified_attributes = ["email"]
#   username_configuration {
#     case_sensitive = true
#   }

#   account_recovery_setting {
#     recovery_mechanism {
#       name = "verified_email"
#       priority = 1
#     }
#   }

#   username_attributes = ["email"]
# }

# # Create Cognito User Pool Client
# resource "aws_cognito_user_pool_client" "my_user_pool_client" {
#   name                   = "my-user-pool-client"
#   supported_identity_providers = [ "COGNITO" ]
#   user_pool_id           = aws_cognito_user_pool.my_user_pool.id
#   //explicit_auth_flows = [ "ALLOW_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_PASSWORD" ]
#   generate_secret        = false
#   # prevent_user_existence_errors = "LEGACY"
#   prevent_user_existence_errors = "ENABLED"
#   explicit_auth_flows = [
#     "ALLOW_REFRESH_TOKEN_AUTH",
#     "ALLOW_USER_PASSWORD_AUTH",
#     "ALLOW_ADMIN_USER_PASSWORD_AUTH"
#   ]
#   refresh_token_validity = 1
#   access_token_validity  = 1
#   id_token_validity      = 1
#   token_validity_units {
#     access_token = "hours"
#     id_token = "hours"
#     refresh_token = "hours"
#   }
# }

# resource "aws_cognito_identity_pool" "my_identity_pool" {
#   identity_pool_name = "my-identity-pool"
#   allow_unauthenticated_identities = false

#   # Define the Cognito Identity Provider
#   cognito_identity_providers {
#     client_id             = aws_cognito_user_pool_client.my_user_pool_client.id
#     provider_name         = aws_cognito_user_pool.my_user_pool.endpoint
#     server_side_token_check = true
#   }
# }

#  TO CHANGE

# resource "aws_cognito_user_pool_domain" "cognito-domain" {
#   domain       = "gabrielaraujo"
#   user_pool_id = "${aws_cognito_user_pool.my_user_pool.id}"
# }

# Output Cognito User Pool and User Pool Client IDs
# output "user_pool_id" {
#   value = aws_cognito_user_pool.my_user_pool.id
# }

# output "user_pool_client_id" {
#   value = aws_cognito_user_pool_client.my_user_pool_client.id
# }






# Define the Cognito User Pool
# resource "aws_cognito_user_pool" "my_user_pool" {
#   name = "my-user-pool"

#   schema {
#     name                  = "email"
#     attribute_data_type   = "String"
#     mutable               = true
#     required              = true
#     developer_only_attribute = false
#   }

#   password_policy {
#     minimum_length    = 8
#     require_lowercase = true
#     require_numbers   = true
#     require_symbols   = true
#     require_uppercase = true
#   }

#   auto_verified_attributes = ["email"]
# }

# # Define the Cognito User Pool Client
# resource "aws_cognito_user_pool_client" "my_user_pool_client" {
#   name                        = "my-user-pool-client"
#   user_pool_id                = aws_cognito_user_pool.my_user_pool.id
#   generate_secret             = true
#   allowed_oauth_flows_user_pool_client = true
#   allowed_oauth_flows        = ["code"]
#   allowed_oauth_scopes       = ["openid", "email", "profile"]
#   # callback_urls              = ["http://localhost:3000/callback"]
#   # logout_urls                = ["http://localhost:3000/logout"]
#   supported_identity_providers = ["COGNITO"]
# }

# # Define the Cognito Identity Pool
# resource "aws_cognito_identity_pool" "my_identity_pool" {
#   identity_pool_name             = "my-identity-pool"
#   allow_unauthenticated_identities = false

#   cognito_identity_providers {
#     client_id               = aws_cognito_user_pool_client.my_user_pool_client.id
#     provider_name           = aws_cognito_user_pool.my_user_pool.endpoint
#     server_side_token_check = true
#   }
# }

# # Define IAM roles for authenticated and unauthenticated users
# resource "aws_iam_role" "authenticated_role" {
#   name               = "authenticated_role"
#   assume_role_policy = jsonencode({
#     Version   = "2012-10-17",
#     Statement = [{
#       Effect    = "Allow",
#       Principal = { Federated = "cognito-identity.amazonaws.com" },
#       Action    = "sts:AssumeRoleWithWebIdentity",
#       Condition = {
#         StringEquals = {
#           "cognito-identity.amazonaws.com:aud" = aws_cognito_identity_pool.my_identity_pool.id
#         }
#       }
#     }]
#   })
# }

# resource "aws_iam_role" "unauthenticated_role" {
#   name               = "unauthenticated_role"
#   assume_role_policy = jsonencode({
#     Version   = "2012-10-17",
#     Statement = [{
#       Effect    = "Allow",
#       Principal = { Federated = "cognito-identity.amazonaws.com" },
#       Action    = "sts:AssumeRoleWithWebIdentity",
#       Condition = {
#         StringEquals = {
#           "cognito-identity.amazonaws.com:aud" = aws_cognito_identity_pool.my_identity_pool.id
#         }
#       }
#     }]
#   })
# }

# # Attach policies to roles
# resource "aws_iam_policy_attachment" "authenticated_policy_attachment" {
#   name       = "authenticated_policy_attachment"
#   roles      = [aws_iam_role.authenticated_role.name]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonCognitoReadOnly"
# }

# resource "aws_iam_policy_attachment" "unauthenticated_policy_attachment" {
#   name       = "unauthenticated_policy_attachment"
#   roles      = [aws_iam_role.unauthenticated_role.name]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonCognitoReadOnly"
# }

# / Resources
resource "aws_cognito_user_pool" "my_user_pool" {
  name = "my_user_pool"

  username_attributes = ["email"]
  auto_verified_attributes = ["email"]
  password_policy {
    minimum_length = 6
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject = "Account Confirmation"
    email_message = "Your confirmation code is {####}"
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }
}

resource "aws_cognito_user_pool_client" "my_user_pool_client" {
  name = "my_user_pool_client"

  user_pool_id = aws_cognito_user_pool.my_user_pool.id
  generate_secret = false
  refresh_token_validity = 90
  prevent_user_existence_errors = "ENABLED"
  explicit_auth_flows         = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
  
}

# resource "aws_cognito_user_pool_domain" "cognito-domain" {
#   domain       = "gabrielaraujo"
#   user_pool_id = "${aws_cognito_user_pool.user_pool.id}"
# }

resource "aws_cognito_identity_pool" "my_identity_pool" {
  identity_pool_name = "my_identity_pool"
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.my_user_pool_client.id
    provider_name           = aws_cognito_user_pool.my_user_pool.endpoint
    server_side_token_check = true
  }
}

resource "aws_cognito_identity_pool_roles_attachment" "roles_attachment" {
  identity_pool_id = aws_cognito_identity_pool.my_identity_pool.id

  roles = {
    "authenticated" = aws_iam_role.authenticated_role.arn
  }
}

resource "aws_iam_role" "authenticated_role" {
  name               = "Cognito_AuthenticatedRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement": [{
      "Effect"   : "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action"   : "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": aws_cognito_identity_pool.my_identity_pool.id
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "authenticated"
        }
      }
    }]
  })

  # Define policies for the authenticated role as necessary
}

resource "aws_iam_role_policy_attachment" "cognito_policy_attachment" {
  role       = aws_iam_role.authenticated_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonCognitoReadOnly"
}





output "cognito_parameters" {
  value = {
    aws_cognito_identity_pool_id = aws_cognito_identity_pool.my_identity_pool.id
    aws_user_pools_id            = aws_cognito_user_pool.my_user_pool.id
    aws_user_pools_web_client_id = aws_cognito_user_pool_client.my_user_pool_client.id
  }
}


#insert into files : 
resource "null_resource" "write_aws_cognito_identity_pool_id" {
  provisioner "local-exec" {
    command = "echo '${aws_cognito_identity_pool.my_identity_pool.id}' | tr -d '\n' > aws_cognito_identity_pool_id.txt"
  }
}

resource "null_resource" "write_aws_user_pools_id" {
  provisioner "local-exec" {
    command = "echo '${aws_cognito_user_pool.my_user_pool.id}' | tr -d '\n' > aws_user_pools_id.txt"
  }
}

resource "null_resource" "write_aws_user_pools_web_client_id" {
  provisioner "local-exec" {
    command = "echo '${aws_cognito_user_pool_client.my_user_pool_client.id}' | tr -d '\n' > aws_user_pools_web_client_id.txt"
  }
}

# resource "null_resource" "write_aws_cognito_identity_pool_id" {
#   provisioner "local-exec" {
#     command = "echo 'us-east-1:34872535-0ab2-49f6-8938-7e29732adc08' | tr -d '\n' > aws_cognito_identity_pool_id.txt"
#   }
# }

# resource "null_resource" "write_aws_user_pools_id" {
#   provisioner "local-exec" {
#     command = "echo 'us-east-1_rhTV292X4' | tr -d '\n' > aws_user_pools_id.txt"
#   }
# }

# resource "null_resource" "write_aws_user_pools_web_client_id" {
#   provisioner "local-exec" {
#     command = "echo '5rm5najpcjj97i9pcn9ns5vgf6' | tr -d '\n' > aws_user_pools_web_client_id.txt"
#   }
# }


# # Create Cognito User Pool
# resource "aws_cognito_user_pool" "my_user_pool" {
#   name = "my-user-pool"

#   # Define user pool policies and attributes
#   password_policy {
#     minimum_length    = 8
#     require_lowercase = true
#     require_numbers   = true
#     require_symbols   = true
#     require_uppercase = true
#   }

#   username_attributes = ["email"]
# }

# # Create Cognito User Pool Client
# resource "aws_cognito_user_pool_client" "my_user_pool_client" {
#   name                   = "my-user-pool-client"
#   user_pool_id           = aws_cognito_user_pool.my_user_pool.id
#   generate_secret        = true
#   refresh_token_validity = 30
#   access_token_validity  = 5
#   id_token_validity      = 5
# }

# # Output Cognito User Pool and User Pool Client IDs
# output "user_pool_id" {
#   value = aws_cognito_user_pool.my_user_pool.id
# }

# output "user_pool_client_id" {
#   value = aws_cognito_user_pool_client.my_user_pool_client.id
# }







# # Create Cognito User Pool
# resource "aws_cognito_user_pool" "my_user_pool" {
#   name = "my-user-pool"

#   # Define user pool policies and attributes
#   password_policy {
#     minimum_length    = 8
#     require_lowercase = true
#     require_numbers   = true
#     require_symbols   = true
#     require_uppercase = true
#   }

#   username_attributes = ["email"]
# }

# # Create Cognito User Pool Client
# resource "aws_cognito_user_pool_client" "my_user_pool_client" {
#   name                   = "my-user-pool-client"
#   user_pool_id           = aws_cognito_user_pool.my_user_pool.id
#   generate_secret        = true
#   refresh_token_validity = 30
#   access_token_validity  = 5
#   id_token_validity      = 5
# }

# # Output Cognito User Pool and User Pool Client IDs
# output "user_pool_id" {
#   value = aws_cognito_user_pool.my_user_pool.id
# }

# output "user_pool_client_id" {
#   value = aws_cognito_user_pool_client.my_user_pool_client.id
# }
