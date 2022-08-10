### Assumptions:
The tool server (aka bastion host) (aka jump box) has access to the internet




###
sudo yum update -y
sudo yum install -y yum-utils git
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
sudo yum -y install java
terraform -install-autocomplete




sudo wget https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven
sudo yum install -y java-17-amazon-corretto-devel
sudo /usr/sbin/alternatives --set java /usr/lib/jvm/java-17-amazon-corretto.x86_64/bin/java
sudo /usr/sbin/alternatives --set javac /usr/lib/jvm/java-17-amazon-corretto.x86_64/bin/javac


sudo amazon-linux-extras install -y docker
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user



working_dir=$(pwd)
aws_account_number=$(aws sts get-caller-identity --query "Account" --output text)
cd $working_dir/cms-acme-api
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${aws_account_number}.dkr.ecr.us-east-1.amazonaws.com
docker tag cms-acme:v1 ${aws_account_number}.dkr.ecr.us-east-1.amazonaws.com/cms-acme:v1
docker push ${aws_account_number}.dkr.ecr.us-east-1.amazonaws.com/cms-acme:v1


cp patient_admit_out.csv step0_patient_admit_out.csv
sed '1s/^/uuid,/' step0_patient_admit_out.csv > step1_patient_admit_out.csv
awk '{printf "\"%1s\",%s\n", NR-1,$0}' step1_patient_admit_out.csv > step2_patient_admit_out.csv
tail -c +5 step2_patient_admit_out.csv > step3_patient_admit_out.csv
aws s3 cp step3_patient_admit_out.csv s3://patientadmitout/patient_admit_out.csv


https://docs.aws.amazon.com/neptune/latest/userguide/iam-auth-connect-prerq.html
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/create-container-image.html

