docker stop fabric.docker.interfaceengine
docker rm fabric.docker.interfaceengine
docker pull healthcatalyst/fabric.baseos:latest
docker build -t healthcatalyst/fabric.docker.interfaceengine . 
docker run -p 8085:8085 -p 8443:8443 -p 6661:6661 -e HTTP_PORT=8085 -e HTTPS_PORT=8443 -e HTTP_CONTEXTPATH="/mirth/" -e SERVER_HOSTNAME="localhost" -e MYSQL_USER2=mysqluser -e MYSQL_PASSWORD=mysqlpassword --rm --name fabric.docker.interfaceengine -t healthcatalyst/fabric.docker.interfaceengine