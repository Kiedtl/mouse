$UNINSTALL_SCRIPT = "$psscriptroot\..\bin\uninstall.ps1"

$confirmation = Read-Host "Are you sure?? (y/N)"
$conf = $comfirmation.ToLower()

if (($conf -eq "yes") -or ($conf -eq "y")) {
    & $UNINSTALL_SCRIPT
}
else {
    break
}
