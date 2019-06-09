$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. "$toolsDir\commonEnv.ps1"
. "$toolsDir\dependenciesEnv.ps1"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'starcraft-sor*'  #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
}
$uninstalled = $false
[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']
if ($key.Count -eq 1) {
  $key | % { 
    $packageArgs['file'] = "$($_.UninstallString)" #NOTE: You may need to split this if it contains spaces, see below
    if ($packageArgs['fileType'] -eq 'MSI') {
      $packageArgs['silentArgs'] = "$($_.PSChildName) $($packageArgs['silentArgs'])"
      $packageArgs['file'] = ''
    } else {
    }
    Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $($_.DisplayName)"}
}
Remove-Item "$starCraftDir\$SC_WMODE" -force
Remove-Item "$starCraftDir\$SC_WMODE_FIX" -force
Remove-Item "$lnkDesktop" -force
Remove-Item "$SOR_MAPS" -recurse -force
Remove-Item "$startMenuDir" -recurse -force
Remove-Item "$installLocation" -recurse -force
