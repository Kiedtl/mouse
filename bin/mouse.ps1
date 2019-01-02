#requires -v 3
# Copyright (c) 2018 Kied T Llaentenn

param($cmd)
set-strictmode -off

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\gitutils.ps1"
. (relpath '..\lib\commands')

$nvurl = "https://raw.githubusercontent.com/Kiedtl/mouse/master/share/version.dat"
$FIGLET = "$psscriptroot\..\lib\figlet.exe"
$SAY = "$psscriptroot\..\lib\say.ps1"
$CRAFT = "$psscriptroot\..\lib\craft.exe"

if (mouse_outdated) {
    mouse update
}

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
elseif ('--craft' -contains $cms -or (!$cmd -and '-x' -contains $args)) {
    if ($IsWindows) {
        & $CRAFT
    }
    else {
        warn "MouseCraft is compatible with Win32 systems only."
        $yn = Read-Host "Start anyway? (y/N)"
        if ($yn -notlike 'y*') {
            break
        }
        else {
            & $CRAFT
        }
    }
}
elseif ('--yay' -contains $cmd -or (!$cmd -and '-y' -contains $args)) {
    & $SAY yay!!! -v "Microsoft Zira Desktop" -r -5}
elseif ('--mouse' -contains $cmd -or (!$cmd -and '-z' -contains $args)) {
    if ($IsWindows) {
        & $FIGLET -f small -c mouse
    }
    else {
        "
`t`t  _ __  ___ _  _ ___ ___
`t`t | '  \/ _ \ || (_-</ -_)
`t`t |_|_|_\___/\_,_/__/\___|
"
    }
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
