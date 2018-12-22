# Usage: mouse list
# Summary: List all files or folders that are managed by Mouse
# Help: List all the files and directories in the local Mouse repository.

. "$psscriptroot\..\lib\core.ps1"

# . "$psscriptroot\..\lib\getopt.ps1"
# $opt, $files, $err = getopt $args 'm:n' 'message', 'nosync'

$TOUCH = ("$psscriptroot\..\lib\touch.ps1")

Set-Location $HOME/.mouse/dat

Push-Location
Set-Location $HOME/.mouse/dat
git commit -q -a -m "Automatic modifications by Mouse"
git stash | Out-Null
Set-Location $HOME/.mouse/dat
git-crypt unlock $HOME/.mouse/git_crypt_key.key
Set-Location $HOME/.mouse/dat/info

$list = @{}

# Now the party starts
Get-ChildItem .\*.info | Foreach-Object {
    $filejson = Get-Content $_
    Write-Host "$filejson" -f Green
    $fileinfo = $filejson | ConvertFrom-Json
    $oname = $fileinfo.oname
    $opath = $fileinfo.opath
    $isdir = $fileinfo.isdir
    if ($isdir) { $otype = "Directory"}
    else { $otype = "File" }

    $list.add("$oname  ", $opath, $otype) # add padding
}

$list.getenumerator() | Sort-Object name | Format-Table -hidetablehead -autosize -wrap

Pop-Location
