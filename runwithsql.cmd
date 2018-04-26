docker stop fabric.docker.interfaceengine
docker rm fabric.docker.interfaceengine
docker pull healthcatalyst/fabric.baseos:latest
docker build -t healthcatalyst/fabric.docker.interfaceengine . 

FOR /F "usebackq" %%i IN (`hostname`) DO SET MyHOSTNAME=%%i
ECHO %MyHOSTNAME%

@echo off

set /P sqlpwd=Enter Windows Password for %USERNAME%: 


docker run -p 8080:8080 -p 8443:8443 -p 6661:6661 -e SQLSERVER_USER=%USERNAME% -e SQLSERVER_PASSWORD=%sqlpwd%  -e SQLSERVER_DOMAIN=hqcatalyst.local -e SQLSERVER_AD_URL=hcsad1 -e SQLSERVER_SERVER=%MYHOSTNAME% -e SQLSERVER_DATABASE=MyRealtimeDb --rm --name fabric.docker.interfaceengine -t healthcatalyst/fabric.docker.interfaceengine