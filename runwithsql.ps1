docker stop fabric.docker.interfaceengine
docker rm fabric.docker.interfaceengine
docker pull healthcatalyst/fabric.baseos:latest

$password=""
while ([string]::IsNullOrWhiteSpace($password)) {
    Do {$password = Read-Host -assecurestring -Prompt "Please type in password for [$env:UserName]"} while ($($password.Length) -lt 1)
    $password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
}

$SqlServerName="$env:COMPUTERNAME"

docker run -p 8080:8080 -p 8443:8443 -p 6661:6661 -e SQLSERVER_USER=$env:UserName -e SQLSERVER_PASSWORD=$password  -e SQLSERVER_DOMAIN=hqcatalyst.local -e SQLSERVER_AD_URL=hcsad1 -e SQLSERVER_SERVER=$SqlServerName -e SQLSERVER_DATABASE=FabricRealtime --rm --name fabric.docker.interfaceengine -t healthcatalyst/fabric.docker.interfaceengine