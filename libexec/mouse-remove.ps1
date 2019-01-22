# Usage: mouse remove [file1] [file2] [file3] [options]
# Summary: Removes files to Mouse's repository.
# Help: The usual way to remove files for directories to Mouse's repository to
#        backup to GitHub.
#
# To remove file(s) or directories, type:
#      mouse remove ~\.bashrc ~\.scoop C:\path\to\dir\
#
# Options:
#   -m, --message               Use a custom Git commit message
#   -d, --directory             The item to remove was a directory.


Add-Type -assembly "System.IO.Compression.Filesystem"

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\getopt.ps1"
. "$psscriptroot\..\lib\config.ps1"

$opt, $files, $err = getopt $args 'dm:' 'directory', 'message'
$directory = $opt.directory -or $opt.d
$message = $opt.message -or $opt.m

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


Push-Location

if ($err) {
    $err | ForEach-Object {
        error $err
        exit 1
    }
}

if (!$files) {
    abort "mouse: ***** File or directory list not provided. Stop."
}

Set-Location $HOME/.mouse/dat
if ($true) { # TODO: Implement --plumbing flag and change $true to if !($plumbing)
    Write-Host "Unlocking repository..." -NoNewline
    git-crypt unlock $HOME/.mouse/git_crypt_key.key | out-null
    Write-Host " done" -f Green
}
Set-Location $HOME

$files | Foreach-Object {
    $_ = unfriendly_path $_
    if (!$directory) {
        if ((Test-Path ("$HOME\.mouse\dat\$_"))) {
            Remove-Item ("$HOME\.mouse\dat\$_")
        }
        else {
            error "The file or directory $_ does not exist."
        }
    }
    else {
        if ((Test-Path ("$HOME\.mouse\dat\$_.zip"))) {
                    Remove-Item ("$HOME\.mouse\dat\$_.zip")
        }
    }
    git add . > "$psscriptroot\..\share\dump.tmp"
    git commit -q -m "Removed $_" > "$psscriptroot\..\share\dump.tmp"
        if (!$opt.directory) {
            if ((Test-Path ("$HOME\.mouse\dat\info\$_.info"))) {
                Remove-Item ("$HOME\.mouse\dat\info\$_.info")
            }
            else {
                warn "The file or directory info/$_.info does not exist." 
            }
        }
        else {
            if ((Test-Path ("$HOME\.mouse\dat\info\$_.info"))) {
                Remove-Item ("$HOME\.mouse\dat\info\$_.info")
            }
            else {
                warn "The file or directory info/$_.zip.info does not exist. Please report this bug." 
            }
        }
    git add . > "$psscriptroot\..\share\dump.tmp"
    git commit -q -m "Removed $_.info" > "$psscriptroot\..\share\dump.tmp"
    }


if (test_internet) {
    if (!$nosync) {
        git push origin master > ("$psscriptroot\..\share\dump.tmp")
        success "Removed items and pushed repository to GitHub."
    }
    else {
        warn "Option --nosync set, skipping synchronization"
        success "Removed items."
    }
}
else {
    success "Successfully added files."
    warn "Mouse was unable to push to GitHub: there does not appear to be an internet connection."
}

Set-Location $HOME/.mouse/dat
git-crypt lock

Pop-Location
