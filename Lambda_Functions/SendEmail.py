import boto3
from botocore.exceptions import ClientError

# Sender = "naikpraneet44@gmail.com"
# receiver = "naikpraneet44@gmail.com"
# region = "us-east-1"
# subject = "Student Registered successfully."
# body_text = "This is automated email body please do not use it for your reference."
# body_html = """<html>
#     <head></head>
#     <body>
#     <h1>Hey Hi...</h1>
#     <p>This email was sent with
#         <a href='https://aws.amazon.com/ses/'>Amazon SES CQPOCS</a> using the
#         <a href='https://aws.amazon.com/sdk-for-python/'>
#         AWS SDK for Python (Boto)</a>.</p>
#     </body>
#     </html>
#                 """
Charset = "UTF-8"

def send_email(Sender, Receiver, body_html, body_text, subject):
    client = boto3.client('ses', region = "us-east-1")

    try:
        response = client.send_email(
            Destination={
                'ToAddresses': [
                    Receiver,
                ],
            },
            Message = {
                'Body':{
                    'Html':{
                        'Data': body_html
                    },
                    'Text': {
                        'Data': body_text
                    },
                },
                'Subject': {
                    'Data': subject
                },
            },
            Source = Sender
        )
    except ClientError as e:
        print(e.response['Error']['Message'])
    else:
        print("Email sent! Message ID:", end=" ")
        print(response['MessageId'])
