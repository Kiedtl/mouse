# Usage: mouse develop
# Summary: Turns Mouse development mode on or off.
# Help: Changes the Mouse branch from master to develop or from develop to
#       master, depending on the current branch.

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\gitutils.ps1"

Pop-Location
Set-Location $HOME/.mouse/

$curr_branch = Get-GitBranch

if ($curr_branch -eq "master") {
    info "On branch master"
    info "Switching to branch develop"
    git checkout develop --force
}
else {
    info "On branch develop"
    info "Switching to branch master"
    git checkout master --force
}

Push-Location
