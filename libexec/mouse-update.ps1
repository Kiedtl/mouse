# Usage: mouse update
# Summary: Updates Mouse
# Help: Updates Mouse to the latest version on GitHub with a simple
#       `git pull`.

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\gitutils.ps1"

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
    $config = loadconfig
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
    Set-Content -Path (getmouseconfig) -Value $config_json

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

