# Usage: mouse list
# Summary: List all files or folders that are managed by Mouse
# Help: List all the files and directories in the local Mouse repository.

. "$psscriptroot\..\lib\core.ps1"

. "$psscriptroot\..\lib\getopt.ps1"
$opt, $files, $err = getopt $args 'm' 'mice'
$TOUCH = ("$psscriptroot\..\lib\touch.ps1")

Set-Location $HOME/.mouse/dat

Push-Location
Set-Location $HOME/.mouse/dat

if ($opt.mice) {
    spinner_ugva 10 80 "Listing mice..."
    [int32]$mc = 1
    1..10 | Foreach-Object {
        $fname = -join ((65..90) | Get-Random -Count 100 | % {[char]$_})
        $lname = -join ((65..90) | Get-Random -Count 100 | % {[char]$_})
        info "MOUSE $mc: Mo$fname Mi$lname"
        $mc++
    }
    break
}

git commit -q -a -m "Automatic modifications by Mouse" | Out-Null
git stash | Out-Null
Set-Location $HOME/.mouse/dat
git-crypt unlock $HOME/.mouse/git_crypt_key.key
Set-Location $HOME/.mouse/dat/info

# Now the party starts
Get-ChildItem .\*.info | Foreach-Object {
    $filejson = Get-Content $_
    $fileinfo = $filejson | ConvertFrom-Json
    $oname = $fileinfo.oname
    $opath = $fileinfo.opath
    $isdir = $fileinfo.isdir
    if ($isdir) { $otype = "[Directory]"}
    else { $otype = "[File]     " }

    Write-Host "$otype`t" -ForegroundColor Yellow -NoNewline
    Write-Host "$oname`t" -NoNewline -ForegroundColor White
    Write-Host "$opath" -ForegroundColor DarkCyan

}

Pop-Location
