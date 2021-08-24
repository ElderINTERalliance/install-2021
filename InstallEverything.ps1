# General variables:
$DownloadPath = "https://github.com/microsoft/winget-cli/releases/download/v1.0.11451/DesktopAppInstallerPolicies.zip"
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$WorkPath = "$DesktopPath\INTERallianceInstall"
# Node.js variables:
$NodeName = "node-v16.3.0-win-x64"
$NodeURL = "https://nodejs.org/dist/v16.3.0/$NodeName.zip"
$NodeZipLocation = "$WorkPath\$NodeName.zip"
$InstallationDestination = "$env:userprofile" 
$RealInstallPath = "$InstallationDestination\$NodeName"

# Remove path if it already exists, so that this script can be run repeatedly
If (Test-Path $WorkPath){
	Remove-Item $WorkPath -Recurse
}
If (Test-Path $RealInstallPath){
	Remove-Item $RealInstallPath -Recurse
}

# We can't start the transcript before we delete the files
Start-Transcript -Path "$WorkPath\transcript_$(Get-Date -Format "MM-dd-yyyy_HH-mm").txt" -NoClobber

# Delete everything, so that we can run the script multiple times, if something goes wrong.
New-Item -ItemType directory -Path $WorkPath

echo "Download winget"
$Url = "https://github.com/microsoft/winget-cli/releases/download/v1.0.11692/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
$DownloadedLocation = "$WorkPath\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"

Invoke-WebRequest -Uri $Url -OutFile $DownloadedLocation 

echo ""
echo "Install Windows App Installer"
Add-AppxPackage -Path $DownloadedLocation

echo ""
echo "Use Windows App Installer to install other things:"
echo ""
echo "Installing VSCode..."
winget install --id=Microsoft.VisualStudioCode -e -h --scope "user" ; 
echo "Installing Windows Terminal..."
winget install --id=Microsoft.WindowsTerminal -e -h ;
echo "Installing Git..."
winget install -e --id Git.Git
echo "Installing Slack..."
winget install -e --id SlackTechnologies.Slack

echo ""
echo "Installing Node.JS ..."

echo "NodeURL = $NodeURL"
echo "NodeZipLocation = $NodeZipLocation"
echo ""

# Download zip file:
echo "Downloading Node.JS binary."
echo "This may take a while..."
(New-Object System.Net.WebClient).DownloadFile($NodeURL, $NodeZipLocation)

echo ""
echo "Extracting from zip file..."
Expand-Archive $NodeZipLocation -DestinationPath $InstallationDestination

echo ""
echo "Add nodejs path to user Env:Path"
$CurrentPath = [Environment]::GetEnvironmentVariable("Path", "User")
$AppendedPath = "$CurrentPath;$RealInstallPath;"
[Environment]::SetEnvironmentVariable("Path", $AppendedPath, "User")

Start-Sleep -s 5
