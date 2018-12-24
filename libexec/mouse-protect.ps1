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

$TOUCH = ("$psscriptroot\..\lib\touch.ps1")
$ea_cats = Get-Random -Maximum 100

Push-Location
Set-Location $HOME/.mouse/dat
git-crypt unlock $HOME/.mouse/git_crypt_key.key

if ($cmd -eq $null) {
    abort "mouse: ***** Command or action not provided. Stop."
}
elseif ($cmd -eq "mouse") {
    spinner_ugva 10 80 "Protecting mice..."
    info "Removed rat traps"
    info "Removed rat poison"

    error "Unable to drown first cat."

    spinner_sticks 10 80 "Drowning $cats cats..."
    [int32]$catcount = 2

    1..$cats | Foreach-Object {
        info "Drowned ${catcount}th cat..."
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
