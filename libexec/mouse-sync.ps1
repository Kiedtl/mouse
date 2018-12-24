# Usage: mouse sync
# Summary: Synchronizes the local repository with GitHub.
# Help: The usual way synchronize the local repository with the remote repository on GitHub.

. "$psscriptroot\..\lib\core.ps1"

. "$psscriptroot\..\lib\getopt.ps1"
$opt, $cmd, $err = getopt $args 'ef' 'eeeee', 'fffff'
$TOUCH = ("$psscriptroot\..\lib\touch.ps1")
$DINORUN = ("$psscriptroot\..\lib\dinorun.exe")

if ($opt.eeeee) {
    if ($IsWindows) {
        & $DINORUN
    }
    elseif ($opt.fffff) {
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
