# Usage: mouse add <filepath>
# Summary: Add a file to the Mouse repository to backup and manage.
# Help: This file adds a file to this repository to backup and manage.

Add-Type -assembly "System.IO.Compression.Filesystem"

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\getopt.ps1"
. "$psscriptroot\..\lib\config.ps1"

$opt, $files, $err = getopt $args 'fnm:' 'directory', 'message', 'notag'

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
    $dtime = Get-Date
    $dirdest = "$psscriptroot\..\share\repo\${name}.zip"
    if ((Test-Path $_)){
        if (!opt.directory) {
            if (Test-Path "$psscriptroot\..\share\repo\$name")
            {
                Remove-Item "$psscriptroot\..\share\repo\$name"
            }
            Copy-Item $_ ("$psscriptroot\..\share\repo\$name")
            Add-Content ("$psscriptroot\..\share\repo\mouseconfig.files") "$_")
        }
        else {
            if (Test-Path $dirdest) {
                Remove-Item $dirdest
            }
            [IO.Compression.ZipFile]::CreateFromDirectory($_, $dirdest) 
        }
    git add $name
    git commit -m "Added and committed $name on $dtime"
    }
    else {
        error "File $name does not exist, is hidden, or Mouse does not have access to it."
    }
}

if (!opt.notag) {
    $latestcommit = git rev-parse HEAD
	  git tag -a -m "Automatically_added_tag_$version" "v$" $latestcommit 

}
