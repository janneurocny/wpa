<#
Windows Profile Autoremover
Jan Neurocny - NeuroLabs
https://neurolabs.sk
https://github.com/janneurocny
#>

$olderThan = 7 #days
$exludeUsers = "administrator|Public|Ctx_StreamingSvc|NetworkService|Localservice|systemprofile" #usernames separate by pipe (user1|user2|user3)

# do not edit
$registryPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\ProfileList" #path to profile list in registry

Get-ChildItem $registryPath | ForEach-Object {
	$profilePath = $_.GetValue("ProfileImagePath") 
	$sid =  Split-Path $_ -Leaf

	$lastLogon = ''        
	if (Test-Path -Path "$profilePath\ntuser.dat" -ErrorAction SilentlyContinue) {
		$lastLogon = (Get-Item "$profilePath\ntuser.dat" -Force -ea Stop).LastWriteTime
	}
	 
	if ($profilePath -notmatch $exludeUsers -and $lastLogon -and $profilePath -and $lastLogon -lt (Get-Date).AddDays(-$olderThan)) {
		Write-Host "REMOVE: Last logon: $lastLogon | Profile path: $profilePath | SID: $sid" -ForegroundColor green
		# Remove profile folder
		cmd.exe /c "rd /s /q $profilePath"
		# Remove user from registry
		Remove-Item -Path "$registryPath\$sid" -Recurse
	} elseif ($profilePath -match $exludeUsers) {
		Write-Host "SKIP: User in exclude list | SID: $sid" -Fore blue -Back white
	} elseif (!$profilePath) {
		Write-Host "SKIP: Empty profile path | SID: $sid" -Fore blue -Back white
	} elseif (!$lastLogon) {
		Write-Host "SKIP: Empty last logon | SID: $sid" -Fore blue -Back white
	} else {
		Write-Host "SKIP: Last logon < $olderThan days | Last logon: $lastLogon | Profile path: $profilePath | SID: $sid" -Fore blue -Back white
	}
}