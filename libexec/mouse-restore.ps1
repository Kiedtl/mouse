# Usage: mouse restore [file]
# Summary: Restore each file that was previously added to their original paths
# Help: Restore each file in the mouse repository to their original paths.

Add-Type -assembly "System.IO.Compression.Filesystem"

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\getopt.ps1"

$opt, $files, $err = getopt $args 'b:' 'blah'
$blah = $opt.blah -or $opt.b

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


$COWSAY = ("$psscriptroot\..\lib\cowsay.ps1")

Push-Location
Set-Location $HOME/.mouse/dat
if ($true) { # TODO: Implement --plumbing flag and change $true to if !($plumbing)
    Write-Host "Unlocking repository..." -NoNewline
    git-crypt unlock $HOME/.mouse/git_crypt_key.key | out-null
    Write-Host " done" -f Green
}
Set-Location $HOME/.mouse/dat/

# eE-a-s-t-e*-r  e-g-g
if ($blah) {
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
                warn "The directory $filepath already exists! "
                $confirmation = Read-Host "Overwrite? (y/N)"
                if ($confirmation -like "y*")
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
                warn "The directory $filepath already exists! "
                $confirmation = Read-Host "Overwrite? (y/N)"
                if ($confirmation -like "y*")
                {
                    Remove-Item $filepath -Force
                }
                else {
                    break
                }
            }
            unzip_dir $filepath $file
            else {
                error "The info file $file.info does not exist and Mouse was unable to restore the file or directory $file."
            }
        }
        else {
            error "The file or directory $_ does not exist or is hidden."
        }
    }

Set-location $HOME/.mouse/dat/
success "Restored files successfully."
Set-Location $HOME/.mouse/dat
git-crypt lock --force
Pop-Location

