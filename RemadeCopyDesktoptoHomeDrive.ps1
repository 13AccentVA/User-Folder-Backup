###########################################################################################
##            This script is used to copy User folders from a computer to a location to a
##            network drive location.
##            Network Drive location:
##            
## History:   2022/06/16 - Original Created by 13AccentVA
###########################################################################################

# Prompt for UserID Info to be copied
Clear
$CopyUserID = Read-Host -Prompt 'Enter UserID to Be copied'
$CopyUserID = $CopyUserID.ToUpper()
Clear
$Name = Read-Host -Prompt 'Enter Full Name'
$Name = (Get-Culture).TextInfo.ToTitleCase($Name)
Clear
$Name
Clear
$DTLT = Read-Host -Prompt 'Desktop or Laptop'
$DTLT = (Get-Culture).TextInfo.ToTitleCase($DTLT)
$AssetID = hostname
$RunBy = $env:username
$RunBy = $RunBy.ToUpper()
Clear

# Testing Backup Path
$Folder="C:\users\$CopyUserID\"
$BackupPath="(your backup path here)\$Name $DTLT - $AssetID\"

# Production Backup Path
## $Folder="C:\users\$CopyUserID\"
## $BackupPath="(your backup path here)\$Name $DTLT - $AssetID\"

# Log Path
$LogFile = "$BackupPath Log.txt"
$LogFile

# Get Source Directory Info
$NumOfFiles = (get-ChildItem $Folder -Recurse -Force).Count
$SizeofFiles = "{0:0.00} MB" -f ((Get-ChildItem $Folder -Recurse -Force | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
$today=Get-Date -Format "yyyy-MM-dd" 
$time= Get-Date -Format "HH:mm"
Clear

# Copy Process
Copy-Item $Folder -Destination $BackupPath -Force -Recurse -Verbose

# Get Backup Directory Info
$BKNumOfFiles = (get-ChildItem $BackupPath -Recurse -Force).Count
$BKSizeofFiles = "{0:0.00} MB" -f ((Get-ChildItem $BackupPath -Recurse -Force | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)

# Get Comparable File Tree
$VSource = Get-ChildItem -Recurse -Force -Path $Folder
$VDest = Get-ChildItem -Recurse -Force -Path $BackupPath
Clear

# Display Results
Clear
Write-Host Complete
Write-Host 
Write-Host Started:
Write-Host $today
Write-Host $time
Write-Host
Write-Host $NumOfFiles = Number of Source files from $Folder
Write-Host $BKNumOfFiles = Number of Destination files to $BackupPath
Write-Host
Write-Host $SizeofFiles = Size of Source files
Write-Host $BKSizeofFiles = Size of Destination files
Write-Host
Write-Host Run By $RunBy
Write-Host
Write-Host Missing files will be displayed and written to:
Write-Host $LogFile
Write-Host
Pause

# Log Results
Clear
"Complete"  | Out-File $LogFile
" " | Out-File -FilePath $LogFile -Append
"Started:" | Out-File -FilePath $LogFile -Append
$today | Out-File -FilePath $LogFile -Append
$time | Out-File -FilePath $LogFile -Append
" " | Out-File -FilePath $LogFile -Append
"$NumOfFiles = Number of Source files from $Folder" | Out-File -FilePath $LogFile -Append
"$BKNumOfFiles = Number of Destination files to $BackupPath" | Out-File -FilePath $LogFile -Append
" " | Out-File -FilePath $LogFile -Append
"$SizeofFiles = Size of Source files" | Out-File -FilePath $LogFile -Append
"$BKSizeofFiles = Size of Destination files" | Out-File -FilePath $LogFile -Append
" " | Out-File -FilePath $LogFile -Append
"Run By $RunBy" | Out-File -FilePath $LogFile -Append
" " | Out-File -FilePath $LogFile -Append
"Missing files will be displayed and written to:" | Out-File -FilePath $LogFile -Append
$LogFile | Out-File -FilePath $LogFile -Append
" " | Out-File -FilePath $LogFile -Append

# Display and Log Missing files
Compare-Object -ReferenceObject $VSource -DifferenceObject $VDest | Out-File -FilePath $LogFile -Append
Compare-Object -ReferenceObject $VSource -DifferenceObject $VDest

Pause