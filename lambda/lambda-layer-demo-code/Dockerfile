FROM amazon/aws-cli
RUN yum update && yum install -y python3 zip
COPY *.sh ./
COPY lambda_function.py ./
RUN ls -al

ENTRYPOINT ["/bin/bash", "entrypoint.sh"]