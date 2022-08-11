export BUCKETNAME=$(terraform output -json | jq -r '.local_BucketName.value | values')
aws s3 rm s3://${BUCKETNAME}/patient_admit_out.csv
terraform destroy -auto-approve