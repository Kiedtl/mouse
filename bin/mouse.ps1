#requires -v 3
param($cmd)

set-strictmode -off

. "..\lib\core.ps1"
. (relpath '..\lib\commands')

$nvurl = "https://raw.githubusercontent.com/Kiedtl/mouse/master/share/version.dat"

$commands = commands
if ('--version' -contains $cmd -or (!$cmd -and '-v' -contains $args)) {
    Write-Host "Current Mouse Version: " -NoNewLine
    $currver = Get-Content "$psscriptroot\..\share\version.dat"
    Write-Host -f Green ("$currver")
    if (test_internet) {
        $newver = (New-Object Net.WebClient).DownloadString($nvurl)
        Write-Host "Latest Mouse Version: " -NoNewline
        Write-Host ("$newver") -f Blue
    }
}
elseif (@($null, '--help', '/?') -contains $cmd -or $args[0] -contains '-h') { exec 'help' $args }
elseif ($commands -contains $cmd) { exec $cmd $args }
else { "mouse: '$cmd' isn't a valid command. Try 'mouse help'."; exit 1 }
