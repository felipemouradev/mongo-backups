set -e

echo "Job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)
FILE="$BASE_BACKUP_NAME-$DATE.tar.gz"

mkdir -p dump
mongodump \
  --host $MONGO_HOST \
  --port $MONGO_PORT \
  --username $MONGO_USER \
  --password $MONGO_PASSWORD \
  --authenticationDatabase admin

tar -zcvf $FILE dump/

RETENTION_BACKUP=$(eval $RETENTION_BACKUP)

if [ $RETENTION_BACKUP_FLAG == "no" ]
  then
    aws s3 cp $FILE s3://$AWS_BUCKET_NAME/$FILE
  else
    aws s3 cp $FILE s3://$AWS_BUCKET_NAME/$FILE --expire=$RETENTION_BACKUP
fi
rm $FILE
