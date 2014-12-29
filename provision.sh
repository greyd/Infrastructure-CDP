#!/bin/bash
##### Utils
sudo apt-get install -y software-properties-common python-software-properties unzip

##### Git
sudo apt-get install -y git-core

##### Java
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update -y
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install -y oracle-java7-installer

##### Node.js
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install -y build-essential
sudo apt-get install -y nodejs

##### Mongo DB
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
sudo apt-get update
sudo apt-get install -y mongodb-org mongodb-org-tools

##### Gulp
sudo npm install -g gulp

##### Nginx
sudo apt-get install -y nginx

##### MySQL
echo mysql-server mysql-server/root_password password sonar | debconf-set-selections
echo mysql-server mysql-server/root_password_again password sonar | debconf-set-selections
sudo apt-get install -y mysql-server

##### Configure MySQL for the Sonar
wget https://raw.githubusercontent.com/SonarSource/sonar-examples/master/scripts/database/mysql/create_database.sql
mysql -u root "-psonar" < create_database.sql
rm create_database.sql

##### Sonar Qube
wget http://dist.sonar.codehaus.org/sonarqube-4.5.1.zip
unzip sonarqube-4.5.1.zip
sudo mv sonarqube-4.5.1 /opt/sonar
rm sonarqube-4.5.1.zip
echo sonar.jdbc.username=sonar >> /opt/sonar/conf/sonar.properties
echo sonar.jdbc.password=sonar >> /opt/sonar/conf/sonar.properties
echo sonar.jdbc.url=jdbc:mysql://localhost:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance >> /opt/sonar/conf/sonar.properties

echo sonar.web.host=127.0.0.1 >> /opt/sonar/conf/sonar.properties
echo sonar.web.port=80 >> /opt/sonar/conf/sonar.properties
echo sonar.web.context=/sonar >> /opt/sonar/conf/sonar.properties

##### Sonar as a service
sudo wget https://gist.githubusercontent.com/greyd/e3c43e10129d4bacd274/raw/e9dc956106617bb30082e4335b1ccbec69844ad3/sonar.sh -O /etc/init.d/sonar
sudo update-rc.d -f sonar remove
sudo chmod 755 /etc/init.d/sonar
sudo update-rc.d sonar defaults

##### Jenkins
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
echo 'deb http://pkg.jenkins-ci.org/debian binary/' | sudo tee /etc/apt/sources.list.d/jenkins.list
sudo apt-get update
sudo apt-get install -y jenkins
