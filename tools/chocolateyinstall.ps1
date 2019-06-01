$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installLocation = "$ENV:LocalAppData\Programs\StarCraft SOR"
$shortcutPath = "$ENV:UserProfile\Desktop\SC SOR.lnk"
$shortcutAIPath = "$ENV:UserProfile\Desktop\SC SOR AI.lnk"
$starcraftLocation = "$ENV:LocalAppData\Programs\StarCraft"
$SOR_EXE = "SOR 4.7.exe"
$SOR_AI_EXE = "SOR 4.7-Ai.exe"
$srcURL = 'https://www.moddb.com/downloads/start/176655'
$tokenURL = '(https://www.moddb.com/downloads/mirror/176655/\w+/\w+)'
$content = (Invoke-WebRequest $srcURL -UseBasicParsing).Content
$url = (select-string -Input $content -Pattern $tokenURL).Matches[0]
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = "$installLocation"
  url           = $url
  softwareName  = 'starcraft-sor*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
  checksum      = '67DE15ECBFC42F103F180FBF867CD157'
  checksumType  = 'md5' #default is md5, can also be sha1, sha256 or sha512
}
Install-ChocolateyZipPackage @packageArgs # https://chocolatey.org/docs/helpers-install-chocolatey-zip-package

New-Item -itemtype symboliclink -force -path "$starcraftLocation" `
  -name "$SOR_EXE" -value "$installLocation\$SOR_EXE"
Install-ChocolateyShortcut -ShortcutFilePath "$shortcutPath" `
  -TargetPath "$starcraftLocation\$SOR_EXE" `
  -IconLocation "$installLocation\$SOR_EXE" `
  -WorkingDirectory "$starcraftLocation"

New-Item -itemtype symboliclink -force -path "$starcraftLocation" `
  -name "$SOR_AI_EXE" -value "$installLocation\$SOR_AI_EXE"
Install-ChocolateyShortcut -ShortcutFilePath "$shortcutAIPath" `
  -TargetPath "$starcraftLocation\$SOR_AI_EXE" `
  -IconLocation "$installLocation\$SOR_AI_EXE" `
  -WorkingDirectory "$starcraftLocation"