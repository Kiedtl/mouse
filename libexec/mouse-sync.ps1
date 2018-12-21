# Usage: mouse sync
# Summary: Synchronizes the local repository with GitHub.
# Help: The usual way synchronize the local repository with the remote repository on GitHub.

. "$psscriptroot\..\lib\core.ps1"

# . "$psscriptroot\..\lib\getopt.ps1"
# $opt, $files, $err = getopt $args 'm:n' 'message', 'nosync'

$TOUCH = ("$psscriptroot\..\lib\touch.ps1")

Push-Location
Set-Location $HOME/.mouse/dat

git pull origin master --allow-unrelated-histories
git push origin master

success "Synchronized repository with GitHub."
