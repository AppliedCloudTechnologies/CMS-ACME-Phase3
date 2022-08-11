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


