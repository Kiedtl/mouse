# Usage: mouse backup
# Summary: Backup each file that was previously added
# Help: Mouse will make refresh the files in its repository with the files
#       currently in their respective diretories.
#
# For example, if you have previously added a .spacemacs
#       file and a .scoop file and you later type `mouse backup`
#       after those files were modified, Mouse will copy those two new
#
# Options:
#   -n, --nosync               Don't synchronize repository with GitHub

Add-Type -assembly "System.IO.Compression.Filesystem"

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\getopt.ps1"

$opt, $blah, $err = getopt $args 'yn:' 'yay', 'nosync'
$yay = $opt.yay -or $opt.y
$nosync = $opt.nosync -or $opt.n

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


$SNAKES = "$psscriptroot\..\lib\snake.ps1"

Push-Location
Set-Location $HOME/.mouse/dat/

if ($true) { # TODO: Implement --plumbing flag and change $true to if !($plumbing)
    Write-Host "Unlocking repository..." -NoNewline
    git-crypt unlock $HOME/.mouse/git_crypt_key.key | out-null
    Write-Host " done" -f Green
}

if ($yay) {
    & $SNAKES
}

Get-ChildItem info\*.info | Foreach-Object {
    $name = $_.Name
    $basename = $_.BaseName

    $fileinfo = Get-Content $_ | ConvertFrom-Json
    $filepath = (unfriendly_path $fileinfo.opath)
    $friendly_filepath = $fileinfo.opath
    $filename = $fileinfo.oname
    $isdir = $fileinfo.isdir

    if (!$isdir) {
        Copy-Item -Path $filepath -Destination $file -Force
        info "Backed up the file ${friendly_filepath}"
    }
    else {
        if ((Test-Path "$HOME\.mouse\dat\${filename}.zip")) {
            Remove-Item "$HOME\.mouse\dat\${filename}.zip"
        }
        [IO.Compression.ZipFile]::CreateFromDirectory($filepath, "$HOME\.mouse\dat\${filename}.zip")
    }
    git commit -a -q -m "Backed up file $friendly_filepath" | Out-Null
}

Set-location $HOME/.mouse/dat/

if (test_internet) {
    if (!$nosync) {
        git pull origin master --allow-unrelated-histories | Out-Null
        git push origin master > ../app/share/dump.tmp
        success "Synchronized repository with GitHub"
    }
    else {
        warn "Option --nosync set, skipping synchronization"
    }
    success "Backed up files successfully."
}
else {
    success "Backed up file successfully."
    warn "Synchronization was skipped because there is not internet connaction."
}
Set-Location $HOME/.mouse/dat
git-crypt lock
Pop-Location

