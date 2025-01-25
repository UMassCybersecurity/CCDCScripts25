$url = "https://github.com/Graylog2/collector-sidecar/releases/download/1.5.0/graylog_sidecar_installer_1.5.0-1.exe"
$output = "$env:USERPROFILE\Downloads\graylog_sidecar_installer_1.5.0-1.exe"
$web_client = New-Object System.Net.WebClient
$web_client.DownloadFile($url, $output)
./Downloads\graylog_sidecar_installer_1.5.0-1.exe
Write-Host "Download Finished"