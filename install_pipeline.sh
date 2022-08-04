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
sudo yum install -y java-1.8.0-devel


sudo amazon-linux-extras install -y docker
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user




mkdir -p eul8cg8q55dvgxjz
cd eul8cg8q55dvgxjz




https://docs.aws.amazon.com/neptune/latest/userguide/iam-auth-connect-prerq.html
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/create-container-image.html

