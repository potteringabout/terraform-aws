import json
import boto3
from urllib.parse import unquote_plus

bucket = 'potteringabout-uk-dev-remarkable'

s3 = boto3.client('s3')

def lambda_handler(event, context):

  for record in event['Records']:

    bucket = record['s3']['bucket']['name']
    key = unquote_plus(record['s3']['object']['key'])
    print(f"{bucket}/{key}")

    textract = boto3.client('textract')

    try:
      response = textract.analyze_document(
        Document={
            'S3Object': {
                'Bucket': bucket,
                'Name': key
              }
          },
          FeatureTypes=[ 'TABLES','FORMS','LAYOUT']
      )

      for b in response["Blocks"]:
        print(f"BlockType {b["BlockType"]} Confidence {b["Confidence"]} TextType {b["TextType"]}  Text {b["Text"]}")

      return_result = {"Status": "Success"}
      return return_result
    except Exception as error:
      return {"Status": "Failed", "Reason": json.dumps(error, default=str)}
