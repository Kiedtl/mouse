# Usage: mouse protect [  lock | unlock | expkey | adduser | status]
# Summary: Manage Mouse's encryption functions with Git-Crypt.
# Help: Configure Mouse to lock or unlock the repository, to export the
#        encryption key to a file, to add a GPG user to access the repository,
#        or to get the status of the repository.
#
# To unlock or lock the repository with Git-Crypt, run:
#    mouse protect lock  # OR
#    mouse protect unlock
#
# Use the expkey command to export the Git-Crypt key to a repository of choice.
# To do this, run:
#    mouse protect expkey "path/to/key/blah.key"
#
# Use the adduser command to add a GPG user as a collaborator.
# To do this, run:
#    mouse protect adduser <GPG-USER-ID>
#
# To view the status of git-crypt in the repository, run:
#    mouse protect status

param (
    [string]$cmd,
    [string]$arg1,
    [string]$arg2
)
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


$TOUCH = ("$psscriptroot\..\lib\touch.ps1")
$ea_cats = Get-Random -Maximum 100

Push-Location
Set-Location $HOME/.mouse/dat

if ($true) { # TODO: Implement --plumbing flag and change $true to if !($plumbing)
    Write-Host "Unlocking repository..." -NoNewline
    git-crypt unlock $HOME/.mouse/git_crypt_key.key | out-null
    Write-Host " done" -f Green
}

if ($cmd -eq $null) {
    abort "mouse: ***** Command or action not provided. Stop."
}
elseif ($cmd -eq "mouse") {
    spinner_ucva 10 80 "Protecting mice..."
    info "`nRemoved rat traps"
    info "Removed rat poison"

    info "Found $cats cats to drown"
    error "Unable to drown first cat."
    spinner_sticks 10 80 "Drowning $cats cats..."
    [int32]$catcount = 1
    Write-Host "`n" -NoNewline
    1..$cats | Foreach-Object {
        info "Drowned cat number ${catcount}..."
        if ($catcount -eq $cats) {
            success "Finished protecting mice, removed traps, and drowning cats."
            break
        }
        $catcount++
    }
}
elseif ($cmd -eq "lock") {
    Set-Location $HOME/.mouse/dat
    git-crypt lock
}
elseif ($cmd -eq "unlock") {
    Set-Location $HOME/.mouse/dat
    git-crypt unlock $HOME/.mouse/git_crypt_key.key
}
elseif ($cmd -eq "expkey") {
    git-crypt export-key $arg1
}
elseif ($cmd -eq "adduser") {
    git-crypt add-gpg-user $arg1
}
elseif ($cmd -eq "status") {
    git-crypt status
}
else {
    abort "mouse: ***** Provided command `' $arg1 `' not recognized. Stop."
}

git-crypt lock
Pop-location
