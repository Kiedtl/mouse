# Usage: mouse update
# Summary: Updates Mouse
# Help: Updates Mouse to the latest version on GitHub by a simple
#       `git pull`.

. "$psscriptroot\..\lib\core.ps1"

Write-Host "Updating..." -NoNewline
$nvurl = "https://raw.githubusercontent.com/Kiedtl/mouse/master/share/version.dat"
if (test_internet) {
    $newver = dl_string $nvurl
    Push-Location
    Set-Location "$psscriptroot\..\"
    git pull origin master -q > "$psscriptroot\..\share\dump.tmp"
    Set-Content -Path "share\version.dat" -Value $newver
    Write-Host " done" -f Green
    success "Successfully updated Mouse to version $newver!"
}
else {
    Write-Host " error" -f Red
    abort "mouse: ***** Mouse was unable to connect to the network. Stop."
}