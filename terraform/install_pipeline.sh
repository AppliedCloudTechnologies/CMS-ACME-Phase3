sudo yum -y update
sudo yum -y install yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum-config-manager --add-repo https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo

sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo

sudo yum -y install terraform jq apache-maven java-17-amazon-corretto-devel
sudo amazon-linux-extras install -y docker

sudo /usr/sbin/alternatives --set java /usr/lib/jvm/java-17-amazon-corretto.x86_64/bin/java
sudo /usr/sbin/alternatives --set javac /usr/lib/jvm/java-17-amazon-corretto.x86_64/bin/javac

sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user

chmod +x seed_data.sh
chmod +x install.sh
chmod +x cleanup.sh

cd ../cms-acme-api
mvn clean compile jib:dockerBuild
cd ../terraform
./install.sh