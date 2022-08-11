### Assumptions:
The tool server (aka bastion host) (aka jump box) has access to the internet




###
sudo yum -y update
sudo yum -y install yum-utils git
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo wget https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo

sudo yum -y install terraform jq apache-maven java-17-amazon-corretto-devel
sudo amazon-linux-extras install -y docker

terraform -install-autocomplete

sudo /usr/sbin/alternatives --set java /usr/lib/jvm/java-17-amazon-corretto.x86_64/bin/java
sudo /usr/sbin/alternatives --set javac /usr/lib/jvm/java-17-amazon-corretto.x86_64/bin/javac

sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user


wget https://github.com/acme-cms-challenge/f3/raw/main/patient_admit_out.zip
unzip patient_admit_out.zip
sed '1s/^/uuid,/' patient_admit_out.csv | awk '{printf "\"%1s\",%s\n", NR-1,$0}' | tail -c +5 > step3_patient_admit_out.csv


export BUCKETNAME=$(terraform output -json | jq -r '.local_BucketName.value | values')
aws s3 cp step3_patient_admit_out.csv s3://${BUCKETNAME}/patient_admit_out.csv
rm *patient_admit_out.*

