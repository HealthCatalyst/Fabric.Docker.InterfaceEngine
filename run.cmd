docker stop fabric.docker.interfaceengine
docker rm fabric.docker.interfaceengine
docker pull healthcatalyst/fabric.baseos:latest
docker build -t healthcatalyst/fabric.docker.interfaceengine . 
docker run -p 8080:8080 -p 8443:8443 -p 6661:6661 -e MYSQL_USER2=mysqluser -e MYSQL_PASSWORD=mysqlpassword --rm --name fabric.docker.interfaceengine -t healthcatalyst/fabric.docker.interfaceengine