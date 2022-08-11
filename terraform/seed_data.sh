wget https://github.com/acme-cms-challenge/f3/raw/main/patient_admit_out.zip
unzip patient_admit_out.zip
sed '1s/^/uuid,/' patient_admit_out.csv | awk '{printf "\"%1s\",%s\n", NR-1,$0}' | tail -c +5 > step3_patient_admit_out.csv
export BUCKETNAME=$(terraform output -json | jq -r '.local_BucketName.value | values')
aws s3 cp step3_patient_admit_out.csv s3://${BUCKETNAME}/patient_admit_out.csv
rm *patient_admit_out.*