#!/bin/bash
export BUCKET_NAME='gbl-lambda-layer-demo'

echo 'step 1. make directory [ ./python/lib/python3.8/site-packages/ ]'
echo '========================================================================='
mkdir -p ./python/lib/python3.8/site-packages/

echo 'step 2. install pandas and requests library (numpy is install with pandas)'
echo '========================================================================='
pip3 install https://files.pythonhosted.org/packages/4d/51/bafcff417cd857bc6684336320863b5e5af280530213ef8f534b6042cfe6/pandas-1.1.4-cp36-cp36m-manylinux1_x86_64.whl -t python/lib/python3.8/site-packages/
pip3 install https://files.pythonhosted.org/packages/77/0b/41e345a4f224aa4328bf8a640eeeea1b2ad0d61517f7d0890f167c2b5deb/numpy-1.19.4-cp38-cp38-manylinux1_x86_64.whl -t python/lib/python3.8/site-packages/
pip3 install requests -t python/lib/python3.8/site-packages/
rm -rf python/lib/python3.8/site-packages/*.dist-info
rm -rf python/lib/python3.8/site-packages/__pycache__


echo 'step 3. zip library'
ls -al
zip -r $BUCKET_NAME.zip python

echo 'step 4. check s3 bucket for lambda layer. if exist bucket just upload zip to bucket'
echo '        if not exist bucket make s3 bucket (name: gbl-lambda-layer-demo)'
echo '========================================================================='
if [[ $(aws s3api list-buckets --query 'Buckets[?Name == `'$BUCKET_NAME'`].[Name]' --output text) == $BUCKET_NAME ]]; then 
    echo "already exsites s3 bucket name : $BUCKET_NAME"; 
else
    aws s3 mb "s3://$BUCKET_NAME"
    echo "s3 $BUCKET_NAME is created"
fi

aws s3 cp $BUCKET_NAME.zip s3://$BUCKET_NAME