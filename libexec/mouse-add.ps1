# Usage: mouse add [file1] [file2] [file3] [options]
# Summary: Adds files to Mouse's repository.
# Help: The usual way to add files for directories to Mouse's repository to
#        backup to GitHub.
#
# To add file(s) or directories, type:
#      mouse add C:\Users\misspiggy\.bashrc C:\Users\misspiggy\.scoop C:\path\to\dir\
#
# Options:
#   -m, --message               Use a custom Git commit message


Add-Type -assembly "System.IO.Compression.Filesystem"

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\getopt.ps1"
. "$psscriptroot\..\lib\config.ps1"

$opt, $files, $err = getopt $args 'm:' 'message'


if ($err) {
    $err | ForEach-Object {
        error $err
        exit 1
    }
}

if (!$files) {
    abort "ERROR File list not provided. Stop."
}


$files | ForEach-Object {
    $name = $_.Name
    $basename = $_.BaseName
    $dtime = Get-Date
    $isDirectory = ((Get-Item $_) -is [System.IO.DirectoryInfo])
    $dirdest = "$psscriptroot\..\share\repo\${basename}.zip"
    if ((Test-Path $_)) {
        if (!$isDirectory) {
            if (Test-Path "$psscriptroot\..\share\repo\$name")
            {
                Remove-Item "$psscriptroot\..\share\repo\$name"
            }
            Copy-Item $_ ("$psscriptroot\..\share\repo\$name")
            git add $name

            if (!opt.message) {
                git commit -m "Added and committed $name on $dtime"
            }
            else {
                git commit -m "${opt.message}"
            }
        }
        else {
            if (Test-Path $dirdest) {
                Remove-Item $dirdest
            }
            [IO.Compression.ZipFile]::CreateFromDirectory($_, $dirdest)
            git add "${basename}.zip"
            if (!opt.message) {
                git commit -m "Added and committed $name on $dtime"
            }
            else {
                git commit -m "${opt.message}"
            }
        }

        $fileinfo = New-Object -TypeName PSObject
        $fileinfo | Add-Member -NotePropertyName opath -NotePropertyValue $_
        $fileinfo | Add-Member -NotePropertyName oname -NotePropertyValue $name
        $fileinfo | Add-Member -NotePropertyName obnme -NotePropertyValue $basename
        $fileinfo | Add-Member -NotePropertyName isdir -NotePropertyValue $isDirectory
        $fileinfo | Add-Member -NotePropertyName dates -NotePropertyValue (Get-Date)
        $filejson = $fileinfo | ConvertTo-Json
        if (!(Test-Path "$psscriptroot\..\share\repo\info")) {
            New-Item -Path . -Name "info" -ItemType "directory"
        }
        ($psscriptroot\..\lib\touch.ps1) ("$psscriptroot\..\share\repo\info\$name.mouseinfo")
        Set-Content -Path ("$psscriptroot\..\share\repo\info\$name.info") -Value $filejson

    }
    else {
        abort "The file or directory $basename does not exist or is hidden. Stop."
    }
}

git push origin master
success "Completed task and pushed repository to GitHub."
