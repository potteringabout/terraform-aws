import json
import boto3
from urllib.parse import unquote_plus

bucket = 'potteringabout-uk-dev-remarkable'

s3 = boto3.client('s3')
kms = boto3.client('kms')

def lambda_handler(event, context):

  for record in event['Records']:

    bucket = record['s3']['bucket']['name']
    key = unquote_plus(record['s3']['object']['key'])
    print(f"{bucket}/{key}")
