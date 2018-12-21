# WARNING: THIS FILE IS STILL UNDER DEVELOPMENT.
# IT IS NOT RECOMMENDED FOR USERS TO USE THE FUNCTIONS
# DEFINED IN THIS FILE.


# Usage: mouse protect [ item | lock | unlock | expkey | adduser | status]
# Summary: Manage Mouse's encryption functions with Git-Crypt.
# Help: Configure Mouse to protect a particular file or directory, to lock or  
#        or unlock the repository, to export the encryption key to a file,
#        to add a GPG user to access the repository, or to get the status of
#        the repository.
#
# To protect a file, run:
#    mouse protect file .authinfo
# 
# To protect a directory, run:
#    mouse protect dir .emacs.d
#
# To unlock or lock the repository with Git-Crypt, run:
#    mouse protect lock  # OR
#    mouse protect unlock
#
# Use the expkey command to export the Git-Crypt key to a repository of choice.
# To do this, run:
#    mouse protect expkey "path/to/key/blah"
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

Push-Location
Set-Location $HOME

if ($cmd -eq $null) {
    abort "mouse: ***** Command or action not provided. Stop."
}
elseif ($cmd -eq "file") {
    $file = $arg1
    Set-Location $HOME/.mouse/dat
    git-crypt unlock
        Add-Content -Path .gitattributes -Value "$file filter=git-crypt diff=git-crypt"
        git add .gitattributes > ../app/share/dump.tmp
        git commit -a -q -m "Protected file $file with Git-Crypt"
        git-crypt lock
}
elseif ($cmd -eq "dir") {
    $dir = "${arg1}.zip"
    $rdir = $arg1
    Set-Location $HOME/.mouse/dat
    git-crypt unlock

        Add-Content -Path .gitattributes -Value "$dir filter=git-crypt diff=git-crypt"
        git add .gitattributes > ../app/share/dump.tmp
        git commit -a -q -m "Protected directory $rdir with Git-Crypt"

    git-crypt lock
}
elseif ($cmd -eq "lock") {
    Set-Location $HOME/.mouse/dat
    git-crypt lock
}
elseif ($cmd -eq "unlock") {
    Set-Location $HOME/.mouse/dat
    Set-Location $HOME/.mouse/dat
    git-crypt unlock
}
elseif ($cmd -eq "expkey") {
    Set-Location $HOME/.mouse/dat
    git-crypt unlock
    git-crypt export-key $arg1
    git-crypt lock
}
elseif ($cmd -eq "adduser") {
    Set-Location $HOME/.mouse/dat
    git-crypt unlock
    git-crypt add-gpg-user $arg1
    git-crypt lock
}
elseif ($cmd -eq "status") {
    Set-Location $HOME/.mouse/dat
    git-crypt unlock
    git-crypt status
    git-crypt lock
}
else {
    abort "mouse: ***** Provided command `' $arg1 `' not recognized. Stop."
}

Pop-location
