docker stop fabric.docker.interfaceengine
docker rm fabric.docker.interfaceengine
docker pull healthcatalyst/fabric.baseos:latest

$password=""
while ([string]::IsNullOrWhiteSpace($password)) {
    Do {$password = Read-Host -assecurestring -Prompt "Please type in password for [$env:UserName]"} while ($($password.Length) -lt 1)
    $password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
}

$USERNAME=$($env:USERNAME)
$AD_DOMAIN=$env:USERDNSDOMAIN
$AD_DOMAIN_SERVER=$($env:LOGONSERVER).Replace("\\","")
$SqlServerName="$env:computername"

Write-Host "======================================================================"
Write-Host "IMPORTANT: If you're connecting to your local machine, make sure you are connected to VPN and restart your MS Sql service after connecting to VPN"
Write-Host "(otherwise you will get Cannot create SSPI context errors)"
Write-Host "======================================================================"

docker run -p 8080:8080 -p 8443:8443 -p 6661:6661 -e SQLSERVER_USER=$env:UserName -e SQLSERVER_PASSWORD=$password  -e SQLSERVER_DOMAIN=$AD_DOMAIN -e SQLSERVER_AD_URL=$AD_DOMAIN_SERVER -e SQLSERVER_SERVER=$SqlServerName -e SQLSERVER_DATABASE=FabricRealtime --rm --name fabric.docker.interfaceengine -t healthcatalyst/fabric.docker.interfaceengine