# Usage: mouse backup
# Summary: Mouse will backup eachfile that was previously added
# Help: Mouse will make refresh the files in its repository with the files
#       currently in their respective diretories.
#
# For example, if you have previously added a .spacemacs
#       file and a .scoop file and you later type `mouse backup`
#       after those files were modified, Mouse will copy those two new

Add-Type -assembly "System.IO.Compression.Filesystem"

. "$psscriptroot\..\lib\core.ps1"

Push-Location
Set-Location $HOME/.mouse/dat/

Get-ChildItem info\*.info | Foreach-ChildItem {
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

Pop-Location

