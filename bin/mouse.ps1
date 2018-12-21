#requires -v 3
# Copyright (c) 2018 Kied T Llaentenn

param($cmd)
set-strictmode -off

. "$psscriptroot\..\lib\core.ps1"
. (relpath '..\lib\commands')

$nvurl = "https://raw.githubusercontent.com/Kiedtl/mouse/master/share/version.dat"
$FIGLET = "$psscriptroot\..\lib\figlet.exe"
$SAY = "$psscriptroot\..\lib\say.ps1"

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
elseif ('yay' -contains $cmd -or (!$cmd -and '--yay' -contains $args)) {
    & $SAY yay!!! -v "Microsoft Zira Desktop" -r -5}
elseif ('mouse' -contains $cmd -or (!$cmd -and '--mouse' -contains $args)) {
    & $FIGLET -f small -c mouse
}
elseif (@($null, '--help', '/?') -contains $cmd -or $args[0] -contains '-h') {
    exec 'help' $args
}
elseif ($commands -contains $cmd) {
    exec $cmd $args
}
else {
    Write-Host "mouse: '$cmd' isn't a valid command. Try 'mouse help'." 
    exit 12
}
