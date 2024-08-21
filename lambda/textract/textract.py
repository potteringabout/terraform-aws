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

      blocks = response['Blocks']
      text = ""
      for block in blocks:
        if block['BlockType'] == 'WORD':
          text += block['Text']
        # text formation based upon Line block type
        # elif (block['BlockType'] == 'LINE':
        #     text += block['Text']
      print(text)

      for b in response["Blocks"]:
        print(b)
        #print(f"BlockType {b["BlockType"]} TextType {b["TextType"]}  Text {b["Text"]}")

      return_result = {"Status": "Success"}
      return return_result

    except Exception as error:
      return {"Status": "Failed", "Reason": json.dumps(error, default=str)}
