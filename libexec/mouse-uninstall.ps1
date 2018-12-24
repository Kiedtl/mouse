# Usage: mouse uninstall
# Summary: Uninstalls Mouse from the local machine.
# Help: Delete the local Mose directory and related data, but does not delete the remove repository.

. "$psscriptroot\..\lib\core.ps1"

$UNINSTALL_SCRIPT = "$psscriptroot\..\bin\uninstall.ps1"

warn 'This will uninstall Mouse and delete all local data!'
$conf = read-host 'Are you sure?? (y/N)'

# E a s t e r   e g g !!!!
if ($conf -like '*bla*') {
    success "Blah!"
    exit
}


if ($conf -notlike 'y*') {
    exit
}


& $UNINSTALL_SCRIPT
