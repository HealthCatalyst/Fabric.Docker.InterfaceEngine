docker stop fabric.docker.interfaceengine
docker rm fabric.docker.interfaceengine
docker pull healthcatalyst/fabric.baseos:latest
docker build -t healthcatalyst/fabric.docker.interfaceengine .
