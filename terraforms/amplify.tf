# data "local_file" "api_invoke_url" {
#   filename = "api_invoke_url.txt"

#   depends_on = [ null_resource.write_output_to_file ]
# }

# data "local_file" "user_pool_client_id" {
#   filename = "user_pool_client_id.txt"

#   depends_on = [ null_resource.write_output_to_file ]
# }

# data "local_file" "user_pool_id" {
#   filename = "user_pool_id.txt"

#   depends_on = [ null_resource.write_output_to_file ]
# }

# New datas
resource "aws_amplify_app" "my_app" {
  name       = "Attendance_Automation"
  repository = "https://github.com/SWEN-614-Team6/Attendance_Automation"
  access_token = var.token

  //Configure the branch that Amplify will use
  build_spec = <<-EOT
      version: 1
      frontend:
        phases:
          preBuild:
            commands:
                - cd homepage
                - npm install
          build:
            commands:
                - echo "REACT_APP_API_ENDPOINT= ${data.local_file.api_invoke_url.content}" >> .env.production
                - echo "REACT_APP_aws_cognito_identity_pool_id=${data.local_file.aws_cognito_identity_pool_id.content}" >> .env.production
                - echo "REACT_APP_aws_user_pools_id=${data.local_file.aws_user_pools_id.content}" >> .env.production
                - echo "REACT_APP_aws_user_pools_web_client_id=${data.local_file.aws_user_pools_web_client_id.content}" >> .env.production
                - npm run build
                - pwd
                - ls
        artifacts:
            baseDirectory: homepage/build   
            files:
            - '**/*'
        cache:
          paths: 
            - node_modules/**/*
    EOT 
  depends_on = [ data.local_file.api_invoke_url, aws_cognito_identity_pool.my_identity_pool, aws_cognito_user_pool.my_user_pool, aws_cognito_user_pool_client.my_user_pool_client ]  
}

resource "aws_amplify_branch" "amplify_branch" {
  app_id      = aws_amplify_app.my_app.id
  branch_name = "dev-version4"
}


# resource "aws_amplify_app" "my_app" {
#   name       = "Attendance_Automation"
#   repository = "https://github.com/SWEN-614-Team6/Attendance_Automation"
#   access_token = var.token

#   //Configure the branch that Amplify will use
#   build_spec = <<-EOT
#       version: 1
#       frontend:
#         phases:
#           preBuild:
#             commands:
#                 - cd homepage
#                 - npm install
#           build:
#             commands:
#                 - echo "REACT_APP_API_ENDPOINT= ${data.local_file.api_invoke_url.content}" >> .env.production
#                 - echo "REACT_APP_aws_cognito_identity_pool_id=us-east-1:34872535-0ab2-49f6-8938-7e29732adc08" >> .env.production
#                 - echo "REACT_APP_aws_user_pools_id=us-east-1_rhTV292X4" >> .env.production
#                 - echo "REACT_APP_aws_user_pools_web_client_id=5rm5najpcjj97i9pcn9ns5vgf6" >> .env.production
#                 - npm run build
#                 - pwd
#                 - ls
#         artifacts:
#             baseDirectory: homepage/build   
#             files:
#             - '**/*'
#         cache:
#           paths: 
#             - node_modules/**/*
#     EOT 
#   depends_on = [ data.local_file.api_invoke_url, aws_cognito_identity_pool.my_identity_pool, aws_cognito_user_pool.my_user_pool, aws_cognito_user_pool_client.my_user_pool_client ]  
# }


# resource "aws_amplify_app" "my_app" {
#   name       = "Attendance_Automation"
#   repository = "https://github.com/SWEN-614-Team6/Attendance_Automation"
#   access_token = var.token

#   //Configure the branch that Amplify will use
#   build_spec = <<-EOT
#       version: 1
#       frontend:
#         phases:
#           preBuild:
#             commands:
#                 - cd homepage
#                 - npm install
#                 - npm install dotenv  # Install the dotenv package
#                 - npm install path-browserify
#                 - npm install dotenv-cli --save-dev
#           build:
#             commands:
#                 - echo "REACT_APP_API_ENDPOINT= ${data.local_file.api_invoke_url.content}" >> .env.production
#                 - echo "REACT_aws_cognito_identity_pool_id=us-east-1:34872535-0ab2-49f6-8938-7e29732adc08" >> .env.production
#                 - echo "REACT_aws_user_pools_id=us-east-1_rhTV292X4" >> .env.production
#                 - echo "REACT_aws_user_pools_web_client_id=5rm5najpcjj97i9pcn9ns5vgf6" >> .env.production
#                 - npm run build
#                 - pwd
#                 - ls
#         artifacts:
#             baseDirectory: homepage/build   
#             files:
#             - '**/*'
#         cache:
#           paths: 
#             - node_modules/**/*
#     EOT 
#   depends_on = [ data.local_file.api_invoke_url, aws_cognito_identity_pool.my_identity_pool, aws_cognito_user_pool.my_user_pool, aws_cognito_user_pool_client.my_user_pool_client ]  
# }
# resource "aws_amplify_app" "my_app" {
#   name       = "Attendance_Automation"
#   repository = "https://github.com/SWEN-614-Team6/Attendance_Automation"
#   access_token = var.token

#   //Configure the branch that Amplify will use
#   build_spec = <<-EOT
#       version: 1
#       frontend:
#         phases:
#           preBuild:
#             commands:
#                 - cd homepage
#                 - npm install
#           build:
#             commands:
#                 - echo "REACT_APP_API_ENDPOINT= ${data.local_file.api_invoke_url.content}" >> .env.production
#                 - echo "REACT_aws_cognito_identity_pool_id= ${data.local_file.aws_cognito_identity_pool_id.content}" >> .env.production
#                 - echo "REACT_aws_user_pools_id=${data.local_file.aws_user_pools_id.content}" >> .env.production
#                 - echo "REACT_aws_user_pools_web_client_id=${data.local_file.aws_user_pools_web_client_id.content}" >> .env.production
#                 - npm run build
#         artifacts:
#             baseDirectory: homepage/build   
#             files:
#             - '**/*'
#         cache:
#           paths: 
#             - node_modules/**/*
#     EOT 
#   depends_on = [ data.local_file.api_invoke_url, aws_cognito_identity_pool.my_identity_pool, aws_cognito_user_pool.my_user_pool, aws_cognito_user_pool_client.my_user_pool_client ]  
# }

# resource "aws_amplify_app" "my_app" {
#   name       = "Attendance_Automation"
#   repository = "https://github.com/SWEN-614-Team6/Attendance_Automation"
#   access_token = var.token

#   //Configure the branch that Amplify will use
#   build_spec = <<-EOT
#       version: 1
#       frontend:
#         phases:
#           preBuild:
#             commands:
#                 - cd homepage
#                 - npm install
#           build:
#             commands:
#                 - echo "REACT_APP_API_ENDPOINT= ${data.local_file.api_invoke_url.content}" >> .env.production
#                 - echo "REACT_APP_USER_POOL_ID= ${data.local_file.user_pool_client_id.content}" >> .env.production
#                 - echo "REACT_APP_USER_POOL_CLIENT_ID=${data.local_file.user_pool_id.content}" >> .env.production
#                 - npm run build
#         artifacts:
#             baseDirectory: homepage/build   
#             files:
#             - '**/*'
#         cache:
#           paths: 
#             - node_modules/**/*
#     EOT 
#   depends_on = [ data.local_file.api_invoke_url, aws_cognito_user_pool.my_user_pool, aws_cognito_user_pool_client.my_user_pool_client ]  
# }



# resource "aws_amplify_domain_association" "domain_association" {
#   app_id      = aws_amplify_app.my_app.id
#   domain_name = "awsamplifyapp.com"
#   wait_for_verification = false

#   sub_domain {
#     branch_name = aws_amplify_branch.amplify_branch.branch_name
#     prefix      = "dev"
#   }
# }






# data "local_file" "api_invoke_url" {
#   filename = "api_invoke_url.txt"

#   depends_on = [ null_resource.write_output_to_file ]
# }


# resource "aws_amplify_app" "my_app" {
#   name       = "Attendance_Automation"
#   repository = "https://github.com/SWEN-614-Team6/Attendance_Automation"
#   access_token = var.token

#   # Configure the branch that Amplify will use
#   build_spec = <<-EOT
#       version: 1
#       frontend:
#         phases:
#           preBuild:
#             commands:
#                 - cd homepage
#                 - npm install
#           build:
#             commands:
#                 - echo "REACT_APP_API_ENDPOINT= ${data.local_file.api_invoke_url.content}" >> .env.production
#                 - npm run build
#         artifacts:
#             baseDirectory: homepage/build   
#             files:
#             - '**/*'
#         cache:
#           paths: 
#             - node_modules/**/*
#     EOT 
#   depends_on = [ data.local_file.api_invoke_url ]  
# }

# resource "aws_amplify_branch" "amplify_branch" {
#   app_id      = aws_amplify_app.my_app.id
#   branch_name = "main"
# }

# # resource "aws_amplify_domain_association" "domain_association" {
# #   app_id      = aws_amplify_app.my_app.id
# #   domain_name = "awsamplifyapp.com"
# #   wait_for_verification = false

# #   sub_domain {
# #     branch_name = aws_amplify_branch.amplify_branch.branch_name
# #     prefix      = "dev"
# #   }
# # }
