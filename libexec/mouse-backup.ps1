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

$opt, $blah, $err = getopt $args 'n:' 'nosync'

Push-Location
Set-Location $HOME/.mouse/dat/

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
        [IO.Compression.ZipFile]::CreateFromDirectory($filepath, "$HOME\.mouse\dat\${filename}")
    }
}

Set-location $HOME/.mouse/dat/

if (test_internet) {
    if (!$opt.nosync) {
        git push orign master > ../app/share/dump.tmp
        success "Synchronized repository with GitHub"
    }
    else {
        info "Option --nosync set, skipping synchronization"
    }
    success "Backed up files successfully."
}
else {
    success "Backed up file successfully."
    warn "Synchronization was skipped because there is not internet connaction."
}
Pop-Location

