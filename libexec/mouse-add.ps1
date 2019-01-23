# Usage: mouse add [file1] [file2] [file3] [options]
# Summary: Adds files to Mouse's repository.
# Help: The usual way to add files for directories to Mouse's repository to
#        backup to GitHub.
#
# To add file(s) or directories, type:
#      mouse add ~\.bashrc ~\.scoop C:\path\to\dir\
#
# Options:
#   -m, --message               Use a custom Git commit message
#   -n, --nosync                Don't synchronize repository with GitHub
#   -l, --showlogs             Output additional logging information.

Add-Type -assembly "System.IO.Compression.Filesystem"

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\getopt.ps1"
. "$psscriptroot\..\lib\config.ps1"

$opt, $files, $err = getopt $args 'm:nl' 'message', 'nosync', 'show-logs'
$TOUCH = ("$psscriptroot\..\lib\touch.ps1")
$message = $opt.message -or $opt.m
$nosync = $opt.nosync -or $opt.n

trap {
    . "$psscriptroot\..\lib\core.ps1"
    warn "An error occurred in Mouse. "
    log -level "error" -opt $opt -status 500 -msg "ADD: Error: $($_.ToString())"
    log -level "error" -opt $opt -status 106 -msg "ADD: Reporting previous error"
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
Set-Location $HOME/.mouse/dat
log -level "info" -opt $opt -status 100 -msg "Changing directory to $HOME/.mouse/dat"

if ($true) { # TODO: Implement --plumbing flag and change $true to if !($plumbing)
    Write-Host "Unlocking repository..." -NoNewline
    log -level "info" -opt $opt -status 108 -msg "ADD: Unlocking repository with key at $HOME/.mouse/git_crypt_key.key"
    git-crypt unlock $HOME/.mouse/git_crypt_key.key | out-null
    Write-Host " done" -f Green
}

Set-Location $HOME
log -level "info" -opt $opt -status 100 -msg "ADD: Changing directory to $HOME"

if ($err) {
    $err | ForEach-Object {
        error $err
        log -level "error" -opt $opt -status 401 -msg "ADD: Argument error: $err"
        exit 1
    }
}
else {
    log -level "success" -opt $opt -status 203 -msg "ADD: Successfully parsed arguments."
}

if (!$files) {
    abort "mouse: File or directory list not provided."
    log -level "error" -opt $opt -status 401 -msg "ADD: No directory or file list provided"
}

$files | ForEach-Object {
    log -level "info" -opt $opt -status 101 -msg "ADD: Processing file or directory $_"
    $rawpath = (friendly_path (friendly_path $_))
    $_ = unfriendly_path $_
    $name = fname $_
    info "Adding $_"
    $dtime = Get-Date
    
    $dirdest = "$HOME/.mouse/dat/${name}.zip"
    if ((Test-Path $_)) {
        $isDirectory = ((Get-Item $_) -is [System.IO.DirectoryInfo])
        if (!$isDirectory) {
            log -level "info" -opt $opt -status 104 -msg "ADD: $_ is a file"
            if (Test-Path "$HOME/.mouse/dat/${name}")
            {
                Remove-Item "$HOME/.mouse/dat/${name}"
                warn "Overwriting $name"
            }
            Copy-Item $_ ("$HOME/.mouse/dat/${name}")
            Set-Location ~\.mouse\dat\
            git add $name

            if (!$message) {
                git commit -q -m "Added and committed $name on $dtime"
            }
            else {
                git commit -q -m "${opt.message}"
            }
        }
        else {
            log -level "info" -opt $opt -status 100 -msg "ADD: Item $_ is a directory"
            if (Test-Path $dirdest) {
                log -level "warn" -opt $opt -status 301 -msg "ADD: Overwriting $dirdest"
                Remove-Item $dirdest
                warn "Overwriting $dirdest"
            }
            [IO.Compression.ZipFile]::CreateFromDirectory($_, $dirdest)
            Set-Location ~\.mouse\dat
            git add "${name}.zip"
            if (!$opt.message) {
                git commit -q -m "Added and committed $name on $dtime"
            }
            else {
                git commit -q -m "${opt.message}"
            }
        }

        $fileinfo = New-Object -TypeName PSObject
        $fileinfo | Add-Member -NotePropertyName opath -NotePropertyValue (friendly_path $rawpath)
        $fileinfo | Add-Member -NotePropertyName oname -NotePropertyValue $name
        $fileinfo | Add-Member -NotePropertyName obnme -NotePropertyValue $basename
        $fileinfo | Add-Member -NotePropertyName isdir -NotePropertyValue $isDirectory
        $fileinfo | Add-Member -NotePropertyName dates -NotePropertyValue (Get-Date)
        $filejson = $fileinfo | ConvertTo-Json
        if (!(Test-Path "$HOME/.mouse/dat/info")) {
            Set-Location ~\.mouse\dat\
            New-Item -Path . -Name "info" -ItemType "directory" > ..\dump.tmp
        }
        & $TOUCH ("$HOME\.mouse\dat\info\$name.info")
        Set-Content -Path ("$HOME\.mouse\dat\info\$name.info") -Value $filejson
        Set-Location ~\.mouse\dat\
        git add .
        git commit -q -m "Added $name.info info file"

    }
    else {
        abort "mouse: The file $_ does not exist or is hidden. "
        log -level "error" -opt $opt -status 404 -msg "ADD: Item $_ does not exist or is hidden."
    }
}

if (test_internet) {
    Set-Location ~\.mouse\dat\
    if (!$nosync) {
        git pull origin master --allow-unrelated-histories > "$psscriptroot\..\share\dump.tmp"
        git push origin master > "$psscriptroot\..\share\dump.tmp"
        info "Synchronized repository with GitHub."
        log -level "success" -opt $opt -status 201 -msg "ADD: Synchronized repository with GitHub."
    }
    else {
        info "Option --nosync set, skipping synchronization."
    }
    success "Successfully added files."
    log -level "success" -opt $opt -status 202 -msg "ADD: Completed command mouse add"
}

else {
    success "Successfully added files."
    log -level "success" -opt $opt -status 202 -msg "ADD: Completed command mouse add"
    warn "Mouse was unable to push to GitHub; there does not appear to be an internet connection."
    log -level "warn" -opt $opt -status 304 -msg "ADD: No internet connection, skipping synchronization with GitHub."
}

Pop-Location
