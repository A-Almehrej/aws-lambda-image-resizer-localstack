from PIL import Image
import boto3
import os

s3 = boto3.client('s3', endpoint_url='http://host.docker.internal:4566')

def lambda_handler(event, context):
    print("Event:", event)
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    download_path = f'/tmp/{key}'
    upload_path = f'/tmp/resized-{key}'

    s3.download_file(bucket, key, download_path)

    with Image.open(download_path) as img:
        img.thumbnail((128, 128))
        img.save(upload_path)

    s3.upload_file(upload_path, 'my-resized-bucket', f'resized-{key}')
    return {'statusCode': 200, 'body': 'Image resized'}
