#A Script to initiate silent installations on selected programs and removes all MS built in Apps(except store)
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
 

#Set script path
Write-Host "Current script directory is $ScriptDir"
Set-Location $ScriptDir
cd installers

#Install MSI Files (Edge, Chrome, Firefox)
$msi = @('Edge.msi', 'Chrome.msi', 'Firefox.msi', 'dialpad.msi', 'AnyDesk.msi')

Start-Process msiexec " dialpad.msi" -ArgumentList /i, $_ , /quiet, /norestart, ACCEPT_EULA=1 -Wait
foreach($_ in $msi){
    Start-Process msiexec -ArgumentList /i, $_ , /quiet, /norestart, ACCEPT_EULA=1  -Wait 
	write-host "$_"
 }



# Path for the temporary downloadfolder. Script will run as system so no issues here
#$Installdir = "c:\temp\install_adobe"
#New-Item -Path $Installdir  -ItemType directory

# # Download the installer from the Adobe website. Always check for new versions!!
# $source = "ftp://ftp.adobe.com/pub/adobe/reader/win/AcrobatDC/1800920044/AcroRdrDC1800920044_en_US.exe"
# $destination = "AcroRdrDC1800920044_en_US.exe"
# Invoke-WebRequest $source -OutFile $destination

# # Start the installation when download is finished
Start-Process -FilePath "acrobat.exe" -ArgumentList "/sAll /rs /rps /msi /norestart /quiet EULA_ACCEPT=YES" -wait
 #Install EXE files (npp, dialpad, teamviewer)
 $exe = @('.\npp.exe',  '.\TeamViewer.exe')
 foreach($X in $exe){
     Start-Process $X /S -NoNewWindow -Wait 
     write-host("$X")
 }
#Move MSI installed items to Desktop
Move-Item -Path $dir -Destination $DesktopPath
Move-Item "C:\Program Files (x86)\AnyDeskMSI\AnyDeskMSI.exe" $DesktopPath


$dir = 'C:\Program Files (x86)\Dialpad Installer\dialpad.exe'
$DesktopPath = [Environment]::GetFolderPath("Desktop")
Move-Item -Path $dir -Destination $DesktopPath
Move-Item "C:\Program Files (x86)\AnyDeskMSI\AnyDeskMSI.exe" $DesktopPath

#Deletes Microsoft Built-in Apps
$ProvisionedAppPackageNames  =@(
    "Microsoft.BingWeather"
    "Microsoft.DesktopAppInstaller"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.HEIFImageExtension"
    "Microsoft.Messaging"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.MicrosoftStickyNotes"
    "Microsoft.MixedReality.Portal"
    "Microsoft.MSPaint"
    "Microsoft.Office.OneNote"
    "Microsoft.OneConnect"
    "Microsoft.People"
    "Microsoft.Print3D"
    "Microsoft.ScreenSketch"
    "Microsoft.SkypeApp"
    # Microsoft.StorePurchaseApp
    "Microsoft.VP9VideoExtensions"
    "Microsoft.Wallet"
    "Microsoft.WebMediaExtensions"
    "Microsoft.WebpImageExtension"
    "Microsoft.Windows.Photos"
    "Microsoft.WindowsAlarms"
    "Microsoft.WindowsCalculator"
    "Microsoft.WindowsCamera"
    "microsoft.windowscommunicationsapps"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsSoundRecorder"
    # Microsoft.WindowsStore
    "Microsoft.Xbox.TCUI"
    "Microsoft.XboxApp"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.YourPhone"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
)

foreach ($ProvisionedAppName in $ProvisionedAppPackageNames) {
    Get-AppxPackage -Name $ProvisionedAppName -AllUsers | Remove-AppxPackage
    Get-AppXProvisionedPackage -Online | Where-Object DisplayName -EQ $ProvisionedAppName | Remove-AppxProvisionedPackage -Online
}

