import base64
import json
from Cryptodome.Cipher import AES # pycryptodomex
import boto3
import email
from email.header import decode_header
import os
import random
import string
import tempfile
from botocore.exceptions import ClientError

bucket = 'potteringabout-uk-dev-remarkable'

def clean(text):
  # clean text for creating a folder
  return "".join(c if c.isalnum() else "_" for c in text)

def decrypt_file(key, in_filename, iv, original_size, chunksize=16*1024):
  b = bytearray()
  with open(in_filename, 'rb') as infile:
    decryptor = AES.new(key, AES.MODE_GCM, iv)
    while True:
      chunk = infile.read(chunksize)
      if len(chunk) == 0:
        break
      b.extend(decryptor.decrypt(chunk))
  return b

def upload_file(file_name, bucket, object_name=None):
  # If S3 object_name was not specified, use file_name
  if object_name is None:
    object_name = os.path.basename(file_name)

  # Upload the file
  s3_client = boto3.client('s3')
  response = s3_client.upload_file(file_name, bucket, object_name)

s3 = boto3.client('s3')
kms = boto3.client('kms')

def lambda_handler(event, context):
  messageID = event['Records'][0]['ses']['mail']['messageId']

  # get the email from s3
  key_name = f'/in/{messageID}'

  object_info = s3.head_object(Bucket=bucket, Key=key_name)
  metadata = object_info['Metadata']
  envelope_key = base64.b64decode(metadata['x-amz-key-v2'])
  envelope_iv = base64.b64decode(metadata['x-amz-iv'])
  encrypt_ctx = json.loads(metadata['x-amz-matdesc'])
  original_size = metadata['x-amz-unencrypted-content-length']

  decrypted_envelope_key = kms.decrypt(CiphertextBlob=envelope_key,EncryptionContext=encrypt_ctx)

  tmpf = tempfile.gettempdir() + "/" + str(''.join(random.choices(string.ascii_uppercase + string.digits, k=8)))

  s3.download_file(bucket, key_name, tmpf)
  b = decrypt_file(decrypted_envelope_key['Plaintext'], tmpf, envelope_iv, int(original_size))
  msg = email.message_from_bytes(b)


  subject, encoding = decode_header(msg["Subject"])[0]
  if isinstance(subject, bytes):
    # if it's a bytes, decode to str
    subject = subject.decode(encoding)
  # decode email sender
  From, encoding = decode_header(msg.get("From"))[0]
  if isinstance(From, bytes):
    From = From.decode(encoding)
  print("Subject:", subject)
  print("From:", From)
  # if the email message is multipart
  if msg.is_multipart():
    # iterate over email parts
    for part in msg.walk():
      # extract content type of email
      content_type = part.get_content_type()
      content_disposition = str(part.get("Content-Disposition"))
      try:
        # get the email body
        body = part.get_payload(decode=True).decode()
      except:
        pass
      if content_type == "text/plain" and "attachment" not in content_disposition:
        # print text/plain emails and skip attachments
        print(body)
      elif "attachment" in content_disposition:
        # download attachment
        filename = part.get_filename()
        if filename:
          filepath = tempfile.gettempdir() + "/" + filename
          # download attachment and save it
          open(filepath, "wb").write(part.get_payload(decode=True))
          upload_file(filepath, bucket, object_name=f'/out/{messageID}')

    return {
      'statusCode': 200,
      'body': json.dumps('Email Processed Successfully')
    }
