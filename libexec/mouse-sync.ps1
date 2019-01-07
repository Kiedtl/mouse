# Usage: mouse sync
# Summary: Synchronizes the local repository with GitHub.
# Help: The usual way synchronize the local repository with the remote repository on GitHub.

. "$psscriptroot\..\lib\core.ps1"

. "$psscriptroot\..\lib\getopt.ps1"
$opt, $cmd, $err = getopt $args 'ef' 'eeeee', 'fffff'
$eeeee = $opt.eeeee -or $opt.e
$fffff = $opt.f -or $opt.fffff

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


$TOUCH = ("$psscriptroot\..\lib\touch.ps1")
$DINORUN = ("$psscriptroot\..\lib\dinorun.exe")

if ($eeeee) {
    if ($IsWindows) {
        & $DINORUN
    }
    elseif ($fffff) {
        & $DINORUN
    }
    else {
        success "Eeeeeeee `naeeeee `nse `nteeeeee `nee `nreeeeeeeee `ne `ngeee. `nGeee `nseee `n!ee."
        break
    }
}

Push-Location
Set-Location $HOME/.mouse/dat
git-crypt lock

git pull origin master --allow-unrelated-histories
git push origin master

success "Synchronized repository with GitHub."
