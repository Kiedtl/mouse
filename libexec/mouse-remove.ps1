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

Set-Location $HOME

$files | Foreach-Object {
    $_ = unfriendly_path $_
    if (!$opt.directory) {
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
        git add .
        git commit -q -m "Removed $_"
        if (!$opt.directory) {
            if ((Test-Path ("$HOME\.mouse\dat\info\$_.info"))) {
                Remove-Item ("$HOME\.mouse\dat\info\$_.info")
            }
            else {
                warn "The file or directory info/$_.info does not exist. Please report this bug." 
            }
        }
        else {
            if ((Test-Path ("$HOME\.mouse\dat\info\$_.zip.info"))) {
                Remove-Item ("$HOME\.mouse\dat\info\$_.zip.info")
            }
            else {
                warn "The file or directory info/$_.zip.info does not exist. Please report this bug." 
            }
        }
        git add .
        git commit -q -m "Removed $_.info"
    }


if (test_internet) {
    git push origin master > ("$psscriptroot\..\share\dump.tmp")
    success "Removed items and pushed repository to GitHub."
}

else {
    success "Successfully added files."
    warn "Mouse was unable to push to GitHub: there does not appear to be an internet connection."
}

Pop-Location
