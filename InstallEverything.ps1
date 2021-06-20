$DownloadPath = "https://github.com/microsoft/winget-cli/releases/download/v1.0.11451/DesktopAppInstallerPolicies.zip"
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$WorkPath = "$DesktopPath\INTERallianceInstall"

# Delete everything, so that we can run the script multiple times, if something goes wrong.
Remove-Item $WorkPath -Recurse
New-Item -ItemType directory -Path $WorkPath

echo "Download winget"
$Url = "https://github.com/microsoft/winget-cli/releases/download/v1.0.11451/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle"
$DownloadedLocation = "$WorkPath\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle"

Invoke-WebRequest -Uri $Url -OutFile $DownloadedLocation 

echo "Install Windows App Installer"
Add-AppxPackage -Path $DownloadedLocation

echo "Use Windows App Installer to install other things"
winget install --id=Microsoft.VisualStudioCode -e -h --scope "user" ; 
winget install --id=Microsoft.WindowsTerminal -e -h ;
winget install -e --id Git.Git

# Untested:


Start-Sleep -s 5