# Usage: mouse uninstall
# Summary: Uninstalls Mouse from the local machine.
# Help: Delete the local Mose directory and related data, but does not delete the remove repository.

. "$psscriptroot\..\lib\core.ps1"

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


$UNINSTALL_SCRIPT = "$psscriptroot\..\bin\uninstall.ps1"

warn 'This will uninstall Mouse and delete all local data!'
$conf = read-host 'Are you sure?? (y/N)'

# E a s t e r   e g g !!!!
if ($conf -like '*bla*') {
    success "Blah!"
    exit
}

if ($conf -notlike 'y*') {
    exit 0
}


& $UNINSTALL_SCRIPT
