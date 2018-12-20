# Usage: mouse restore [file]
# Summary: Restore each file that was previously added to their original paths
# Help: Restore each file in the mouse repository to their original paths.

Add-Type -assembly "System.IO.Compression.Filesystem"

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\getopt.ps1"

$opt, $files, $err = getopt $args 'b:' 'blah'
$COWSAY = ("$psscriptroot\..\lib\cowsay.ps1")

Push-Location
Set-Location $HOME/.mouse/dat
git-crypt unlock
Set-Location $HOME/.mouse/dat/

# Easter egg
if ($opt.blah) {
    & $COWSAY -f dragon Blah!
} 

if (!$files) {
    
    Get-ChildItem info\*.info | Foreach-Object {
        $name = $_.Name
        $basename = $_.BaseName
    
        $fileinfo = Get-Content $_ | ConvertFrom-Json
        $filepath = (unfriendly_path $fileinfo.opath)
        $friendly_filepath = $fileinfo.opath
        $filename = $fileinfo.oname
        $isdir = $fileinfo.isdir
    
        if (!$isdir) {
            if ((Test-Path $filepath)) {
                $confirmation = Read-Host "The file ${friendly_filepath} already exists! Overwrite? (y/N)"
                if ($confirmation -eq "N" -or $confirmation -eq "n") {
                    break
                }
                elseif ($confirmation -eq "Y" -or $confirmation -eq "y") 
                {
                    Remove-Item $filepath -Force
                }
                else {
                    break
                }
            }
            Copy-Item -Path $file -Destination $filepath -Force
            info "Restored the file ${friendly_filepath}"
        }
        else {
            if ((Test-Path $filepath)) {
                $confirmation = Read-Host "The directory $filepath already exists! Overwrite? (y/N)"
                if ($confirmation -eq "N" -or $confirmation -eq "n") {
                    break
                }
                elseif ($confirmation -eq "Y" -or $confirmation -eq "y") 
                {
                    Remove-Item -Path $filepath -Force
                }
                else {
                    break
                }
            }
            unzip_dir $filepath $file
        }
    }
}
else {
    $files | Foreach-Object {
        $file = fname $_
        Set-Location $HOME/.mouse/dat
        if ((Test-Path $file)) {
            if ((Test-Path info/$file.info)) {
                $fileinfo = Get-Content info/$file.info | ConvertFrom-Json
                $filepath = (unfriendly_path $fileinfo.opath)
                $friendly_filepath = $fileinfo.opath
                $filename = $fileinfo.oname
                $isdir = $fileinfo.isdir

                        if (!$isdir) {
            if ((Test-Path $filepath)) {
                $confirmation = Read-Host "The file ${friendly_filepath} already exists! Overwrite? (y/N)"
                if ($confirmation -eq "N" -or $confirmation -eq "n") {
                    break
                }
                elseif ($confirmation -eq "Y" -or $confirmation -eq "y") 
                {
                    Remove-Item $filepath -Force
                }
                else {
                    break
                }
            }
            Copy-Item -Path $file -Destination $filepath -Force
            info "Restored the file ${friendly_filepath}"
        }
        else {
            if ((Test-Path $filepath)) {
                $confirmation = Read-Host "The directory $filepath already exists! Overwrite? (y/N)"
                if ($confirmation -eq "N" -or $confirmation -eq "n") {
                    break
                }
                elseif ($confirmation -eq "Y" -or $confirmation -eq "y") 
                {
                    Remove-Item -Path $filepath -Force
                }
                else {
                    break
                }
            }
            unzip_dir $filepath $file
        }
    }
            }
            else {
                error "The info file $file.info does not exist and Mouse was unable to restore the file or directory $file."
            }
        }
        else {
            error "The file or directory $_ does not exist or is hidden."
        }
    }
}

Set-location $HOME/.mouse/dat/
success "Restored files successfully."
Set-Location $HOME/.mouse/dat
git-crypt lock
Pop-Location

