#requires -v 3
param($cmd)

set-strictmode -off

. "..\lib\core.ps1"
. (relpath '..\lib\commands')

$commands = commands
if ('--version' -contains $cmd -or (!$cmd -and '-v' -contains $args)) {
    Write-Host "Mouse: " -NoNewLine
    Write-Host -f Green "v0.1.0"
}
elseif (@($null, '--help', '/?') -contains $cmd -or $args[0] -contains '-h') { exec 'help' $args }
elseif ($commands -contains $cmd) { exec $cmd $args }
else { "mouse: '$cmd' isn't a valid command. Try 'mouse help'."; exit 1 }
