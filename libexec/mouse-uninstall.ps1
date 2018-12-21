# Usage: mouse uninstall
# Summary: Uninstalls Mouse from the local machine.
# Help: Delete the local Mose directory and related data, but does not delete the remove repository.

$UNINSTALL_SCRIPT = "$psscriptroot\..\bin\uninstall.ps1"

$confirmation = Read-Host "Are you sure?? (y/N)"
if ($confimation -eq $null) {
    break
}
$conf = $confirmation.ToLower()

if (($conf -eq "yes") -or ($conf -eq "y")) {
    & $UNINSTALL_SCRIPT
}
else {
    break
}
