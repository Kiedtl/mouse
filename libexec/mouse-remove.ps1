# Usage: mouse remove [file1] [file2] [file3] [options]
# Summary: Removes files to Mouse's repository.
# Help: The usual way to remove files for directories to Mouse's repository to
#        backup to GitHub.
#
# To remove file(s) or directories, type:
#      mouse remove C:\Users\misspiggy\.bashrc C:\Users\misspiggy\.scoop C:\path\to\dir\
#
# Options:
#   -m, --message               Use a custom Git commit message
#   -d, --directory             The item to remove was a directory.


Add-Type -assembly "System.IO.Compression.Filesystem"

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\getopt.ps1"
. "$psscriptroot\..\lib\config.ps1"

$opt, $files, $err = getopt $args 'dm:' 'directory', 'message'


if ($err) {
    $err | ForEach-Object {
        error $err
        exit 1
    }
}

if (!$files) {
    abort "mouse: ***** File or directory list not provided. Stop."
}

$files | Foreach-Object {
    if ((Test-Path ("$psscriptroot\..\share\repo\$_"))) {
        if (!opt.directory) {
            Remove-Item ("$psscriptroot\..\share\repo\$_")
        }
        else {
            Remove-Item ("$psscriptroot\..\share\repo\$_.zip")
        }
        git add .
        git commit -q -m "Removed $_"
    }
    else {
       error "The file or directory $_ does not exist." 
    }

    if ((Test-Path ("$psscriptroot\..\share\repo\$_.info"))) {
        if (!opt.directory) {
            Remove-Item ("$psscriptroot\..\share\repo\$_.info")
        }
        else {
            Remove-Item ("$psscriptroot\..\share\repo\$_.zip.info")
        }
        git add .
        git commit -q -m "Removed $_.info"
    }
    else {
        error "The file or directory $_.info does not exist. Please report this bug." 
    }
}

if (test_internet) {
    git push origin master > ("$psscriptroot\..\share\dump.tmp")
    success "Removed items and pushed repository to GitHub."
}

else {
    success "Successfully added files."
    warn "Mouse was unable to push to GitHub: there does not appear to be an internet connection."
}
