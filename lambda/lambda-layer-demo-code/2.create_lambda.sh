#!/bin/bash
export LAMBDA_NAME='gbl-lambda-layer-demo-function'
export LAMBDA_LAYER_NAME='gbl-lambda-layer-demo'

echo 'step 1. zip lambda function'
echo '========================================================================='
zip -r $LAMBDA_NAME.zip lambda_function.py


echo 'step 2. create lambda function'
echo '========================================================================='
nohup aws lambda create-function \
    --function-name $LAMBDA_NAME \
    --runtime python3.8 \
    --zip-file fileb://$LAMBDA_NAME.zip \
    --handler lambda_function.lambda_handler \
    --role arn:aws:iam::656494853935:role/lambda_layer_demo_role

echo 'step 3. create lambda layer'
echo '========================================================================='
nohup aws lambda publish-layer-version \
    --layer-name $LAMBDA_LAYER_NAME \
    --description "My Python layer pandas numpy requests" \
    --license-info "MIT" \
    --content S3Bucket=$LAMBDA_LAYER_NAME,S3Key=$LAMBDA_LAYER_NAME.zip \
    --compatible-runtimes python3.8

LAYER_ARN=$(aws lambda list-layer-versions --layer-name gbl-lambda-layer-demo  --query 'LayerVersions[0].LayerVersionArn' --output text)
aws lambda update-function-configuration --function-name $LAMBDA_NAME --layers $LAYER_ARN