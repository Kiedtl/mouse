# Usage: mouse list
# Summary: List all files or folders that are managed by Mouse
# Help: List all the files and directories in the local Mouse repository.

. "$psscriptroot\..\lib\core.ps1"

. "$psscriptroot\..\lib\getopt.ps1"
$opt, $files, $err = getopt $args 'm' 'mice'
$mice = $opt.m -or $opt.mice

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

Set-Location $HOME/.mouse/dat

Push-Location
Set-Location $HOME/.mouse/dat

if ($mice) {
    spinner_ucva 10 80 "Listing mice..."
    [int32]$mc = 1
    1..10 | Foreach-Object {
        $fname = -join ((65..90) | Get-Random -Count 100 | % {[char]$_})
        $lname = -join ((65..90) | Get-Random -Count 100 | % {[char]$_})
        info "MOUSE $mc: Mo$fname Mi$lname"
        $mc++
    }
    break
}

git commit -q -a -m "Automatic modifications by Mouse" | Out-Null
git stash | Out-Null
Set-Location $HOME/.mouse/dat
git-crypt unlock $HOME/.mouse/git_crypt_key.key
Set-Location $HOME/.mouse/dat/info

# Now the party starts
Get-ChildItem .\*.info | Foreach-Object {
    $filejson = Get-Content $_
    $fileinfo = $filejson | ConvertFrom-Json
    $oname = $fileinfo.oname
    $opath = $fileinfo.opath
    $isdir = $fileinfo.isdir
    if ($isdir) { $otype = "[Directory]"}
    else { $otype = "[File]     " }

    Write-Host "$otype`t" -ForegroundColor Yellow -NoNewline
    Write-Host "$oname`t" -NoNewline -ForegroundColor White
    Write-Host "$opath" -ForegroundColor DarkCyan

}

Pop-Location
