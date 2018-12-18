function Get-UserAgent() {
    $version = Get-Content ("$psscriptroot\..\share\version.dat")
    return ("Mouse/$version (+http://mouse.projects.kiedtl.surge.sh/) PowerShell/$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor) (Windows NT $([System.Environment]::OSVersion.Version.Major).$([System.Environment]::OSVersion.Version.Minor); $(if($env:PROCESSOR_ARCHITECTURE -eq 'AMD64'){'Win64; x64; '})$(if($env:PROCESSOR_ARCHITEW6432 -eq 'AMD64'){'WOW64; '})$PSEdition)")
}
function abort($msg, [int] $exit_code=1) { write-host $msg -f red; exit $exit_code }
function error($msg) { write-host "ERROR $msg" -f darkred }
function warn($msg) {  write-host "WARN  $msg" -f darkyellow }
function info($msg) {  write-host "INFO  $msg" -f darkgray }
function debug($msg, $indent = $false) {
    if($indent) {
        write-host "    DEBUG $msg" -f darkcyan
    } else {
        write-host "DEBUG $msg" -f darkcyan
    }
}
function success($msg) { write-host $msg -f darkgreen }
function test_internet() {
    $conn = (Test-Connection -ComputerName google.com -Count 2 -Quiet)
    return $conn
}
function download($src, $dest) {
    $wc = New-Object Net.Webclient
    $wc.headers.add('Referer', (strip_filename $src))
    $wc.Headers.Add('User-Agent', (Get-UserAgent))
    $wc.downloadFile($url, $dest)
}
function dl_string($src, $dest) {
    $wc = New-Object Net.Webclient
    $wc.headers.add('Referer', (strip_filename $src))
    $wc.Headers.Add('User-Agent', (Get-UserAgent))
    return $wc.downloadString($url)
}
function is_directory([String] $path) {
    return (Test-Path $path) -and (Get-Item $path) -is [System.IO.DirectoryInfo]
}
function friendly_path($path) {
    $h = (Get-PsProvider 'FileSystem').home
    if(!$h.endswith('\')) { $h += '\' }
    if($h -eq '\') { return $path }
    return "$path" -replace ([regex]::escape($h)), "~\"
}
function unfriendly_path($path) { return "$path" -replace "~", "$HOME" }


