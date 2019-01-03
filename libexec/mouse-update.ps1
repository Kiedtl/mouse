# Usage: mouse update
# Summary: Updates Mouse
# Help: Updates Mouse to the latest version on GitHub with a simple
#       `git pull`.

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\gitutils.ps1"

$newver = dl_string $nvurl;
$nvurl = "https://raw.githubusercontent.com/Kiedtl/mouse/master/share/version.dat"
$branch = Get-GitBranch

$git = try {
    Get-Command git -ErrorAction Stop
}
catch {
    $null
}

if (!$git) {
    abort "mouse update: Mouse utilises Git to update itself. Install Git and try again."
}


if (test_internet) {
    Write-Host "Updating Mouse..." -NoNewline
    $config = Get-Content "$HOME/.mouse/config.json" | ConvertFrom-Json
    $lastupdatetime = $config.lastupdatetime
    if (!$lastupdatetime)
    {
        $lastupdatetime = [System.DateTime]::Now.ToString("s")
    }
    Push-Location;
    $newver = dl_string $nvurl;
    Set-Location "$HOME/.mouse/app";
    git stash > $HOME/.mouse/dump.tmp
    git pull origin $branch --quiet --force | Out-Null

    Set-Content -Path "share\version.dat" -Value $newver;
    git commit -a -q -m "Updated Mouse" | Out-Null

    Write-Host " done" -f Green

    git --no-pager log --no-decorate --date=local --since="`"$lastupdatetime`"" --format="`"tformat: - %C(yellow)%h%Creset %<|(72,trunc)%s %C(cyan)%cr%Creset`"" HEAD

    $lastupdatetime = [System.DateTime]::Now.ToString("s")
    $config.lastupdatetime = $lastupdatetime
    $config_json = $config | ConvertTo-Json
    Set-Content -Path "$HOME/.mouse/config.json" -Value $config_json

    success "Successfully updated Mouse."
    Pop-Location
    break
}

else {
    spinner_sticks 5 80 "Updating Mouse... "
    Start-Sleep -m 1000
    Write-Host " error" -f Red
    abort "mouse: Unable to update Mouse: no internet."
}

