import boto3
# from SendEmail import send_email

s3 = boto3.client('s3')
rekognition = boto3.client('rekognition', region_name = 'us-east-1')

dynamodbTableName = 'class_student_tf'
dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
employeeTable = dynamodb.Table(dynamodbTableName)

# Please add the email di to test
# sender = "youremail"
# receiver = "youremail"

# subject = "Student Registered successfully."

# body_text = "This is automated email body please do not use it for your reference."
# body_html = """<html>
#     <head></head>
#     <body>
#     <h1>Hey Hi...</h1>
#     <p>Dear Student of class SWEN 514/614. Your image is successfully registered into the attendance system. Have Fun!</a>.</p>
#     </body>
#     </html>
#                 """

def lambda_handler(event, context):
    print('Hi event')
    print(event)
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    try:
        response = index_employee_image(bucket, key)
        print('Hi response')
        print(response)
        if response['ResponseMetadata']['HTTPStatusCode'] == 200:
            faceId = response['FaceRecords'][0]['Face']['FaceId']
            name = key.split('.')[0].split('_')
            firstName = name[0]
            lastName = name[1]
            # emailId = name[2]
            # register_employee(faceId, firstName,lastName, emailId)
            register_employee(faceId, firstName,lastName)
            # send_email(sender,receiver,body_html, body_text,subject)
        return response
    except Exception as e:
        print(e)
        print('Error processing employee image {} from bucket{}.'.format(key, bucket))
        raise e
    

def index_employee_image(bucket, key):
    response = rekognition.index_faces(
        Image={
            'S3Object' : 
            {
                'Bucket' : bucket,
                'Name' : key
            }
        },
        CollectionId = "studentsImage_tf"
    )

    return response

# def register_employee(faceId, firstName,lastName,email_id):
def register_employee(faceId, firstName,lastName):
    employeeTable.put_item(
        Item = {
            'rekognitionId' : faceId,
            'firstName' : firstName,
            'lastName' : lastName
            # 'email' : email_id
        }
    )


# import boto3
# from SendEmail import send_email

# s3 = boto3.client('s3')
# rekognition = boto3.client('rekognition', region_name = 'us-east-1')

# dynamodbTableName = 'class_student_tf'
# dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
# employeeTable = dynamodb.Table(dynamodbTableName)

# # Please add the email di to test
# sender = "youremail"
# receiver = "youremail"

# subject = "Student Registered successfully."

# body_text = "This is automated email body please do not use it for your reference."
# body_html = """<html>
#     <head></head>
#     <body>
#     <h1>Hey Hi...</h1>
#     <p>Dear Student of class SWEN 514/614. Your image is successfully registered into the attendance system. Have Fun!</a>.</p>
#     </body>
#     </html>
#                 """

# def lambda_handler(event, context):
#     print(event)
#     bucket = event['Records'][0]['s3']['bucket']['name']
#     key = event['Records'][0]['s3']['object']['key']

#     try:
#         response = index_employee_image(bucket, key)
#         print(response)
#         if response['ResponseMetadata']['HTTPStatusCode'] == 200:
#             faceId = response['FaceRecords'][0]['Face']['FaceId']
#             name = key.split('.')[0].split('_')
#             firstName = name[0]
#             lastName = name[1]
#             emailId = name[2]
#             register_employee(faceId, firstName,lastName, emailId)
#             send_email(sender,receiver,body_html, body_text,subject)
#         return response
#     except Exception as e:
#         print(e)
#         print('Error processing employee image {} from bucket{}.'.format(key, bucket))
#         raise e
    

# def index_employee_image(bucket, key):
#     response = rekognition.index_faces(
#         Image={
#             'S3Object' : 
#             {
#                 'Bucket' : bucket,
#                 'Name' : key
#             }
#         },
#         CollectionId = "studentsImage_tf"
#     )

#     return response

# def register_employee(faceId, firstName,lastName,email_id):
#     employeeTable.put_item(
#         Item = {
#             'rekognitionId' : faceId,
#             'firstName' : firstName,
#             'lastName' : lastName,
#             'email' : email_id
#         }
#     )