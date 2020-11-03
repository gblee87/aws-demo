import json
import pandas as pd
import numpy as np
import requests

def lambda_handler(event, context):
    pandas_version = pd.__version__
    numpy_version = np.__version__

    r = requests.get("https://www.google.com")
    google_status_code = r.status_code

    return_statement = 'Pandas Version: ', pandas_version, 'Numpy version: ', numpy_version, \
                       'Google Status Code: ', google_status_code

    return {
        'statusCode': 200,
        'body': json.dumps(return_statement)
    }