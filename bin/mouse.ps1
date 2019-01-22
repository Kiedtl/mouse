#requires -v 4
# Copyright (c) 2018 Kied T Llaentenn and other Mouse contributers

param(
    $cmd
)
set-strictmode -off

# Load files with helper functions
# the gitutils files comes from the Posh-Git repository
# Used for determining the current branch

# Also load the commands file which loads
# Mouse command implementations
. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\gitutils.ps1"
. "$psscriptroot\..\lib\ravenclient.ps1"
. (relpath '..\lib\commands')

[string]$dsn = "https://c80867d30cd048ca9375d3e7f99e28a8:f426d337a9434aa7b7da0ec16166ca98@sentry.io/1364995"
[string]$nvurl = "https://raw.githubusercontent.com/lptstr/mouse/master/share/version.dat"

[string]$SAY = "$psscriptroot\..\lib\say.ps1"
[string]$PSGENACT = "$psscriptroot\..\lib\psgenact.ps1"
[array]$PSG_MSG = "found", "eas", "r eg", "g! `n"
$ravenClient = New-RavenClient -SentryDsn $dsn


# Validate the parameter $cmd
# Param $cmd ABSOLUTELY MUST be 
# of the type System.String
if ($cmd -is [int]) {
    if ($cmd -lt 100) {
        & $PSGENACT $cmd
        debug "You $(${PSG_MSG}[0]) the $(${PSG_MSG}[1])te$(${PSG_MSG}[2])$(${PSG_MSG}[3])" $true 
        debug "Share it with the GitHub community! https://github.com/Kiedtl/mouse#easter-eggs" $true
        exit 5
    }
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
elseif ('--yay' -contains $cmd -or (!$cmd -and '-y' -contains $args)) {
    & $SAY yay!!! -v "Microsoft Zira Desktop" -r -5
}
elseif ('--mouse' -contains $cmd -or (!$cmd -and '-z' -contains $args)) {
"
`t`t  _ __  ___ _  _ ___ ___
`t`t | '  \/ _ \ || (_-</ -_)
`t`t |_|_|_\___/\_,_/__/\___|
"
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
        $ravenClient.CaptureException($_)
        # DEPRECATED: We now use Ravenclient to handle exceptions now.
        # error "An unhandled exception was thrown in Mouse."
        # error "Please report the following error code:"
        # $err = (Get-ErrorString $_ "libexec/mouse-${cmd}.ps1@entrypoint/cmd_exec" "${cmd}|${args}" (getversion ))
        # info "`tError string: ${err}" 
    }
    finally {
        if (!($cmd -eq "protect")) {
            git-crypt lock
        }
    }
}
else {
    Write-Host "mouse: '$cmd' isn't a valid command. Try 'mouse help'." 
    exit 12
}
