import email
import boto3
import json

read_bucket = 'potteringabout-uk-dev-remarkable' # name of the bucket where the emails are saved
s3 = boto3.resource('s3')
#write_bucket = 'attachment buckets'  # name of the bucket where the attachments are to be saved

def lambda_handler(event, context):
    messageID = event['Records'][0]['ses']['mail']['messageId']

    # get the email from s3
    key = f'/in/{messageID}'
    read_obj = s3.Object(read_bucket, key)
    print(read_obj)
    body = read_obj.get()['Body'].read().decode('utf8')

    # get attachments from email body
    msg = email.message_from_string(body)
    payloads = msg.get_payload()

    # convert the attachments into files and upload to s3
    for attachment in payloads[1:]:
        name = attachment.get_filename()
        data = attachment.get_payload(decode=True)
        key = f'{name}'
        #s3.Bucket(write_bucket).put_object(Key=key, Body=data)

    # delete the email from s3 (optional)
    #read_obj.delete()
    return {
        'statusCode': 200,
        'body': json.dumps('Email Processed Successfully')
    }
