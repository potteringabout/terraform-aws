#!/usr/bin/env python3
# Copyright 2015, MIT license, github.com/tedder.
# You know what the MIT license is, follow it.
import base64
import json
from Cryptodome.Cipher import AES # pycryptodomex
import boto3
import email
from email.header import decode_header
import os

bucket_name = 'potteringabout-uk-dev-remarkable'

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

s3 = boto3.client('s3', region_name="eu-west-2")

location_info = s3.get_bucket_location(Bucket=bucket_name)
bucket_region = location_info['LocationConstraint']
key_name="/in/13p36bpke346s6qllqsn5f48h9lscbkui8lah5g1"
object_info = s3.head_object(Bucket=bucket_name, Key=key_name)
metadata = object_info['Metadata']
material_json = object_info['Metadata']['x-amz-matdesc']
envelope_key = base64.b64decode(metadata['x-amz-key-v2'])
envelope_iv = base64.b64decode(metadata['x-amz-iv'])
encrypt_ctx = json.loads(metadata['x-amz-matdesc'])
original_size = metadata['x-amz-unencrypted-content-length']
kms = boto3.client('kms', region_name="eu-west-2")
decrypted_envelope_key = kms.decrypt(CiphertextBlob=envelope_key,EncryptionContext=encrypt_ctx)
s3.download_file(bucket_name, key_name, "xx")
b = decrypt_file(decrypted_envelope_key['Plaintext'], "xx", envelope_iv, int(original_size))
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
                folder_name = clean(subject)
                if not os.path.isdir(folder_name):
                    # make a folder for this email (named after the subject)
                    os.mkdir(folder_name)
                filepath = os.path.join(folder_name, filename)
                # download attachment and save it
                open(filepath, "wb").write(part.get_payload(decode=True))
else:
    # extract content type of email
    content_type = msg.get_content_type()
    # get the email body
    body = msg.get_payload(decode=True).decode()
    if content_type == "text/plain":
        # print only text email parts
        print(body)
if content_type == "text/html":
    # if it's HTML, create a new HTML file and open it in browser
    folder_name = clean(subject)
    if not os.path.isdir(folder_name):
        # make a folder for this email (named after the subject)
        os.mkdir(folder_name)
    filename = "index.html"
    filepath = os.path.join(folder_name, filename)
    # write the file
    open(filepath, "w").write(body)

print("="*100)
print("Flawless Victory!")
