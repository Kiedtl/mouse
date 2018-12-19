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


Add-Type -assembly "System.IO.Compression.Filesystem"

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\getopt.ps1"
. "$psscriptroot\..\lib\config.ps1"

$opt, $files, $err = getopt $args 'm:' 'message'
$TOUCH = ("$psscriptroot\..\lib\touch.ps1")

Push-Location
Set-Location $HOME

if ($err) {
    $err | ForEach-Object {
        error $err
        exit 1
    }
}

if (!$files) {
    abort "mouse: ***** File or directory list not provided. Stop."
}

$files | ForEach-Object {
    $_ = unfriendly_path $_
    $name = fname $_
    info "Adding $_"
    $dtime = Get-Date
    $isDirectory = ((Get-Item $_) -is [System.IO.DirectoryInfo])
    $dirdest = "$HOME/.mouse/dat/${name}.zip"
    if ((Test-Path $_)) {
        if (!$isDirectory) {
            if (Test-Path "$HOME/.mouse/dat/${name}")
            {
                Remove-Item "$HOME/.mouse/dat/${name}"
                warn "Overwriting $name"
            }
            Copy-Item $_ ("$HOME/.mouse/dat/${name}")
            Set-Location ~\.mouse\dat\
            git add $name

            if (!$opt.message) {
                git commit -q -m "Added and committed $name on $dtime"
            }
            else {
                git commit -q -m "${opt.message}"
            }
        }
        else {
            if (Test-Path $dirdest) {
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
        $fileinfo | Add-Member -NotePropertyName opath -NotePropertyValue (friendly_path$_)
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
        error "The file $_ does not exist or is hidden."
    }
}

if (test_internet) {
    Set-Location ~\.mouse\dat\
    git push origin master > ("$psscriptroot\..\share\dump.tmp")
    success "Added items and pushed repository to GitHub."
}

else {
    success "Successfully added files."
    warn "Mouse was unable to push to GitHub; there does not appear to be an internet connection."
}

Pop-Location
