#!/usr/bin/env bash

#TF_TEMPLATED_VALUES
TF_BUCKET_NAME="${tf_bucket_name}"
TF_HTML_FILE="${tf_stack_key_path}/files/index.html"
TF_CLOUDWATCH_LOGGROUP="${tf_cloudwatch_loggroup}"
TF_AWS_REGION="${tf_aws_region}"
TF_EXTERNAL_NGINX_PORT="${tf_app_external_port}"

SCRIPT_FOLDER="/root/scripts"
NGINX_CONFIG_DIR="/root/nginx/html"

yum update -y
yum install -y yum-utils awslogs jq docker

mkdir -p $SCRIPT_FOLDER
mkdir -p $NGINX_CONFIG_DIR


cat > /etc/docker/daemon.json <<EOF
{
  "log-driver": "awslogs",
  "log-opts": {
    "awslogs-region": "$TF_AWS_REGION",
    "awslogs-group" : "$TF_CLOUDWATCH_LOGGROUP"
  }
}
EOF
systemctl start docker


#############
# Init docker container
#############
docker run --name nginx -p $TF_EXTERNAL_NGINX_PORT:80 -v $NGINX_CONFIG_DIR:/usr/share/nginx/html:ro -d nginx:stable-alpine


#################
# Metrics
#################
# https://devcloud.co.za/ecs-monitor-container-level-cpu-and-memory-using-docker-stats-and-cloudwatch-metrics/

cat > $SCRIPT_FOLDER/monitor.sh << 'EOF'
#!/bin/bash

REGION=$(curl http://169.254.169.254/latest/meta-data/placement/region 2> /dev/null)

INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id 2> /dev/null)

STATS=$(docker stats --no-stream --format "{\"container\": \"{{ .Container }}\",\"name\": \"{{ .Name }}\", \"memory\": { \"raw\": \"{{ .MemUsage }}\", \"percent\": \"{{ .MemPerc }}\"}, \"cpu\": \"{{ .CPUPerc }}\"}" | jq '.' -s -c )

NUM_CONTAINERS=$(echo "$STATS" | jq '. | length')

for (( i=0; i<$NUM_CONTAINERS; i++ ))
do CPU=$(echo "$STATS" | jq -r .[$i].cpu | sed 's/%//')
MEMORY=$(echo "$STATS" | jq -r .[$i].memory.percent | sed 's/%//')
CONTAINER=$(echo $STATS | jq -r .[$i].container)
CONTAINER_NAME=$(echo $STATS | jq -r .[$i].name)

aws cloudwatch put-metric-data --metric-name CPU --namespace DockerStats --unit Percent --value $CPU --dimensions InstanceId=$INSTANCE_ID,ContainerName=$CONTAINER_NAME --region $REGION
aws cloudwatch put-metric-data --metric-name Memory --namespace DockerStats --unit Percent --value $MEMORY --dimensions InstanceId=$INSTANCE_ID,ContainerName=$CONTAINER_NAME --region $REGION

done
EOF

chmod +x $SCRIPT_FOLDER/monitor.sh
echo "* * * * * root bash $SCRIPT_FOLDER/monitor.sh" > /etc/cron.d/docker-stats

#create CRONJOB
cat > $SCRIPT_FOLDER/s3_sync.sh <<EOF
#!/bin/bash

if test -f "$NGINX_CONFIG_DIR/index.html"; then

  LOCAL_MD5=\$(md5sum $NGINX_CONFIG_DIR/index.html | awk '{ print \$1 }')
  S3_MD5=\$(aws s3api head-object --bucket $TF_BUCKET_NAME --key $TF_HTML_FILE --query ETag --output text | tr -d '"')

  if [[ "\$LOCAL_MD5" == "\$S3_MD5" ]]; then
    exit 0
  fi
fi

aws s3 cp s3://$TF_BUCKET_NAME/$TF_HTML_FILE $NGINX_CONFIG_DIR
exit 0

EOF

chmod +x $SCRIPT_FOLDER/s3_sync.sh
echo "* * * * * root bash $SCRIPT_FOLDER/s3_sync.sh" > /etc/cron.d/s3_sync
