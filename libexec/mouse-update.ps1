
# Usage: mouse update
# Summary: Updates Mouse
# Help: Updates Mouse to the latest version on GitHub by a simple
#       `git pull`.

. "$psscriptroot\..\lib\core.ps1"

spinner_sticks 10 80 "Updating Mouse..."
$nvurl = "https://raw.githubusercontent.com/Kiedtl/mouse/master/share/version.dat"
if (test_internet) {
    $newver = dl_string $nvurl
    Push-Location
    Set-Location "$HOME/.mouse/app"
    git pull origin master -q > "$psscriptroot\..\share\dump.tmp"
    Set-Content -Path "share\version.dat" -Value $newver
    git commit -a -q -m "Updated Mouse" > ..\app\share\dump.tmp
    Write-Host " done" -f Green
    success "Successfully updated Mouse to $newver`n"
    Pop-Location
}
else {
    Write-Host " error" -f Red
    abort "mouse: ***** Unable to connect to the network. Stop."
}
