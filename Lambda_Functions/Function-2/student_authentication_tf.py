import boto3
import json

import os
import sys
import subprocess
import io
import pickle


subprocess.call('pip install Pillow -t /tmp/ --no-cache-dir'.split(), stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
sys.path.insert(1, '/tmp/')
from PIL import Image 

s3 = boto3.client('s3')
rekognition = boto3.client('rekognition', region_name = 'us-east-1')

dynamodbTableName = 'class_student_tf'
dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
studentTable = dynamodb.Table(dynamodbTableName)
bucketName = 'class-images-tf'

dynamodbTableNameforRecords = 'attendance_records_tf'
studentsRecordsTable = dynamodb.Table(dynamodbTableNameforRecords)


def crop_face(image_bytes, face):
    print("Type of image_bytes:", type(image_bytes))  # Print type of image_bytes

    image_buffer = io.BytesIO(image_bytes)
    image = Image.open(image_buffer)
    print("Type of image:", type(image))  # Print type of image

    bounding_box = face['BoundingBox']
    width, height = image.width, image.height
    left, top, right, bottom = calculate_bounding_box_coordinates(bounding_box, width, height)

    try:
        return image.crop((left, top, right, bottom))
    except Exception as e:
        print(f"Error cropping face: {e}")
        return None


def calculate_bounding_box_coordinates(bounding_box, width, height):
  left = int(bounding_box['Left'] * width)
  top = int(bounding_box['Top'] * height)
  right = int(left + bounding_box['Width'] * width)
  bottom = int(top + bounding_box['Height'] * height)
  return left, top, right, bottom

  
def detect_and_search_faces(image_bytes):
  response = rekognition.detect_faces(
      Image={
          'Bytes': image_bytes
      },
      Attributes=['ALL']
  )
  faces = response.get('FaceDetails', [])

  searched_faces = []
  for face in faces:
    cropped_image = crop_face(image_bytes, face)
    if cropped_image:
      cropped_image_bytes = io.BytesIO()  # Create a buffer for cropped image
      cropped_image.save(cropped_image_bytes, format='JPEG')  # Save to buffer
      search_response = rekognition.search_faces_by_image(
          CollectionId='studentsImage_tf',
          Image={
              'Bytes': cropped_image_bytes.getvalue()
          }
      )
      searched_face = {
          'face': face,
          'search_results': search_response.get('FaceMatches', [])
      }
      searched_faces.append(searched_face)

  return searched_faces

  

def lambda_handler(event,context):
    print(event)
    objectKey = event['queryStringParameters']['objectKey']
    date_of_attendance = event['queryStringParameters']['date_of_attendance']
    response = s3.get_object(Bucket=bucketName, Key=objectKey)
    
    image = Image.open(response['Body'])
    with io.BytesIO() as buffer:
      image.save(buffer, format="JPEG")  
      image_bytes = buffer.getvalue()  
    searched_faces = detect_and_search_faces(image_bytes)
    print('Lengthhy')
    print(len(searched_faces))
    print('Faces')
    print(searched_faces)
    
    face_ids = []
    for item in searched_faces:
        search_results = item.get("search_results", [])
        for result in search_results:
            faces = result.get("Face", {})
            face_id = faces.get("FaceId")
            if face_id:
                face_ids.append(face_id)
    print(face_ids)
    
    results = []
    attendance_list = []
    for face_id in face_ids:
      response = studentTable.query(
          KeyConditionExpression='rekognitionId = :fid',
          ExpressionAttributeValues={':fid': face_id})
      if 'Items' in response and response['Items']:
          item = response['Items'][0] 
          results.append({
              'rekognitionId': item['rekognitionId'],
              'firstName': item['firstName'],
              'lastName': item['lastName']
          })
          attendance_list.append(item['firstName']+' '+item['lastName'])
          
    all_data_response = studentTable.scan()
    print("All table value responses :")
    print(all_data_response)
    
    unmatched_students = [item for item in all_data_response['Items'] if item['rekognitionId'] not in face_ids]
    print("Unmatched datasss")
    print(unmatched_students)
    
    print(results)
    print('Attendance List:')
    print(attendance_list)

    if len(results) == 0:
        return buildResponse(403, {'status': 'Fail','message':'No match found!','mylist':[],'absent_students':[]})
    else:
        add_to_table(date_of_attendance,attendance_list,unmatched_students)
        return buildResponse(200,{
                'status': 'Success',
                'message' : 'Following students attendance updated',
                'mylist' : results,
                'absent_message' : 'Following students are absent',
                'absent_students' : unmatched_students
            })
            
def buildResponse(statusCode, body=None):
    response = {
        'statusCode' : statusCode,
        'headers': {
            'Content-Type' : 'application/json',
            'Access-Control-Allow-Origin': '*'
            # 'Access-Control-Allow-Methods': 'OPTIONS,GET'
        }
    }
    if body is not None:
        response['body'] = json.dumps(body)
    return response

def add_to_table(date_of_attendance, attendance_list, unmatched_students):
    studentsRecordsTable.put_item(
        Item = {
            'date' : date_of_attendance,
            'classroom' : 'SWEN-514/614',
            'total_students' : len(attendance_list),
            'present_students' : attendance_list,
            'absent_students' : unmatched_students
        }
    )