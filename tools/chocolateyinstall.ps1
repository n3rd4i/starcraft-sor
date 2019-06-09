$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. "$toolsDir\commonEnv.ps1"
. "$toolsDir\dependenciesEnv.ps1"

$url = Get-ModdbDlUrl 'https://www.moddb.com/downloads/start/176655'
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = "$installLocation"
  url           = $url
  softwareName  = 'starcraft-sor*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
  checksum      = '67DE15ECBFC42F103F180FBF867CD157'
  checksumType  = 'md5' #default is md5, can also be sha1, sha256 or sha512
}
Install-ChocolateyZipPackage @packageArgs # https://chocolatey.org/docs/helpers-install-chocolatey-zip-package

## Needed for window mode if desired
Copy-Item "$installLocation\$SC_WMODE" -Destination "$starCraftDir\$SC_WMODE" -Force
Copy-Item "$installLocation\$SC_WMODE_FIX" -Destination "$starCraftDir\$SC_WMODE_FIX" -Force

## Copy also the maps (does not work!)
New-Item -type directory $SOR_MAPS
Copy-Item "$installLocation\Maps\*" "$SOR_MAPS" -Recurse -Force

## StartMenu
Install-ChocolateyShortcut -ShortcutFilePath "$startMenuDir\StarCraft $ModName ReadMe.lnk" `
  -TargetPath "$installLocation\Patch Note & Information.txt"

Install-ChocolateyShortcut -ShortcutFilePath "$startMenuDir\StarCraft $ModName.lnk" `
  -TargetPath "$installLocation\$SOR_EXE" `
  -WorkingDirectory "$installLocation"
Install-ChocolateyShortcut -ShortcutFilePath "$startMenuDir\StarCraft $ModName AI.lnk" `
  -TargetPath "$installLocation\$SOR_AI_EXE" `
  -WorkingDirectory "$installLocation"

## Desktop
Install-ChocolateyShortcut -ShortcutFilePath "$lnkDesktop" `
  -TargetPath "$installLocation\$SOR_EXE" `
  -WorkingDirectory "$installLocation"
