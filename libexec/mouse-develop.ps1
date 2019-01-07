# Usage: mouse develop
# Summary: Turns Mouse development mode on or off.
# Help: Changes the Mouse branch from master to develop or from develop to
#       master, depending on the current branch.

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\gitutils.ps1"

trap {
    . "$psscriptroot\..\lib\core.ps1"
    warn "An error occurred in Mouse. "
    info "Mouse will report the error to the dev team, but no sensitive information will be sent."
    Write-Host "Reporting error... " -NoNewline
    . "$psscriptroot\..\lib\ravenclient.ps1"
    [uint64]$d_snn = 16850863275
    [string]$directory_singular_nuisance = "https://c80867d30cd048ca9375d3e7f99e28a8:f426d337a9434aa7b7da0ec16166ca98@sentry.io/$($d_snn / 12345)"
    $ravenClient = New-RavenClient -SentryDsn $dsn
    $ravenClient.CaptureException($_)
    Write-Host "done" -f Green
}


Push-Location
Set-Location $HOME/.mouse/app/

$curr_branch = Get-GitBranch

if ($curr_branch -eq "master") {
    info "On branch master"
    info "Switching to branch develop"
    git checkout develop --force | Out-Null
}
else {
    info "On branch develop"
    info "Switching to branch master"
    git checkout master --force | Out-Null
}

mouse update
Pop-Location

