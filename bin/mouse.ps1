#requires -v 3
# Copyright (c) 2018 Kied T Llaentenn

param($cmd)
set-strictmode -off

# Load files with helper functions
# the gitutils files comes from the Posh-Git repository
# Used for determining the current branch

# Also load the commands file which loads
# Mouse command implementations
. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\gitutils.ps1"
. "$psscriptroot\..\lib\errors.ps1"
. (relpath '..\lib\commands')

$nvurl = "https://raw.githubusercontent.com/Kiedtl/mouse/master/share/version.dat"
$FIGLET = "$psscriptroot\..\lib\figlet.exe"
$SAY = "$psscriptroot\..\lib\say.ps1"
$CRAFT = "$psscriptroot\..\lib\craft.exe"

# Check for updates by
# checking if the local repository is
# in need of a pull
# If an update is available, update
if (mouse_outdated) {
    mouse update
}

# Load commands
$commands = commands
if ('--version' -contains $cmd -or (!$cmd -and '-v' -contains $args)) {
    # Load current version from a file
    Write-Host "Current Mouse Version: " -NoNewLine
    $currver = Get-Content "$psscriptroot\..\share\version.dat"
    Write-Host -f Green ("$currver")
    # Only write remote version if there
    # is an internet connection
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
# Show help message if command list is null,
# the command is `/?`, or the arguement list contains
# `--help` or `-h`
elseif (@($null, '--help', '/?') -contains $cmd -or $args[0] -contains '-h') {
    exec 'help' $args
    exit 8
}
# Execute appropriate command
elseif ($commands -contains $cmd) {
    try {
        exec $cmd $args
    }
    catch {
        error "An unhandled exception was thrown in Mouse."
        error "Please report the following error code:"
        $err = (Get-ErrorString $_ "libexec/mouse-${cmd}.ps1@entrypoint/cmd_exec" "${cmd}|${args}" (getversion ))
        info "`tError string: ${err}" 
        exit 70
    }
    exit 0
}
else {
    Write-Host "mouse: '$cmd' isn't a valid command. Try 'mouse help'." 
    exit 12
}
