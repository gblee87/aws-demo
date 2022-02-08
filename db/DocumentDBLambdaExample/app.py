import json
import pymongo
import boto3
import base64
import configparser
import os
import ast
from botocore.exceptions import ClientError
from botocore.vendored import requests

secret_name = os.environ['secret_name']
region_name = os.environ['region']
document_db_port=os.environ['db_port']
pem_locator=os.environ['pem_locator']

session = boto3.session.Session()
client = session.client(service_name='secretsmanager', region_name=region_name)

get_secret_value_response = "null"
# GET THE SECRET ARN
try:
    get_secret_arn_response = client.list_secrets(MaxResults=1)
except ClientError as e:
    raise e
    
secret_arn = get_secret_arn_response['SecretList'][0]['ARN']

try:
    get_secret_value_response = client.get_secret_value(SecretId=secret_arn)
except ClientError as e:
    raise e

secret_data = json.loads(get_secret_value_response['SecretString'])

username = secret_data['username']
password = secret_data['password']
docdb_host=secret_data['host']

db_client = pymongo.MongoClient('mongodb://'+username+':'+password+'@'+docdb_host+':'+document_db_port+'/?ssl=true&ssl_ca_certs='+pem_locator)

def lambda_handler(event, context):

    httpmethod = event["httpMethod"]
    queryval=''
    if httpmethod == "GET" :
        print(event['body'])
        query=(event['body'])
    else :
        print(event['body'])
        query=(event['body'])

    print("Query type " + query)
    querylower=queryval.lower()

    #A simple error message for usage, Just to get the body right
    errorstring="Invalid Query, please pass 'total number of events', 'number of mentions for {keyword}, most talked event"
    return_val= {
                "isBase64Encoded": "true",
                "statusCode": 200,
                "headers": { "headerName": "headerValue"},
                "body": errorstring
            }


    try:
        db = db_client['cast']
        querydict = json.loads(query)
        print(querydict)
        countMovies = 0
        print(db.collection_names())
        for quest in db.collection_names():
            print(quest)
            queryString = db[quest].find(querydict)
            counttotal = queryString.count()
            countMovies = countMovies + counttotal
        return_val['body'] = "Movie Count is "+str(countMovies)
        return return_val
    except Exception as ex:
        # Send some context about this error to Lambda Logs
        print(ex)
