. "$psscriptroot\..\lib\gitutils.ps1"
Add-Type -AssemblyName System.IO.Compression.FileSystem

function getmouseversion  {
    return "v0.3.0"
}

function unzip_dir {
    param([string]$src, [string]$dest)
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}
function zip_dir {
    param([string]$src, [string]$dest)
    [IO.Compression.ZipFile]::CreateFromDirectory($src, "$dest")
}
function Get-UserAgent() {
    $version = Get-Content ("$psscriptroot\..\share\version.dat")
    return ("Mouse/$version (+http://getmouse.surge.sh/) PowerShell/$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor) (Windows NT $([System.Environment]::OSVersion.Version.Major).$([System.Environment]::OSVersion.Version.Minor); $(if($env:PROCESSOR_ARCHITECTURE -eq 'AMD64'){'Win64; x64; '})$(if($env:PROCESSOR_ARCHITEW6432 -eq 'AMD64'){'WOW64; '})$PSEdition)")
}
function abort($msg, [int] $exit_code=1) { write-host $msg -f red; exit $exit_code }
function error($msg) { write-host "ERROR $msg" -f red }
function warn($msg) {  write-host "WARN  $msg" -f yellow }

function info($msg) {  write-host "INFO  $msg" -f gray }
function debug($msg, $indent = $false) {
    if($indent) {
        write-host "`tDEBUG $msg" -f magenta
    } else {
        write-host "DEBUG $msg" -f magenta
    }
}
function success($msg) { write-host $msg -f green }
function fname($path) { split-path $path -leaf }
function strip_ext($fname) { $fname -replace '\.[^\.]*$', '' }
function strip_filename($path) { $path -replace [regex]::escape((fname $path)) }
function strip_fragment($url) { $url -replace (new-object uri $url).fragment }
function test_internet() {
    $conn = (Test-Connection -ComputerName google.com -Count 2 -Quiet)
    return $conn
}
function download($src, $dest) {
    $wc = New-Object Net.Webclient
    $wc.Headers.add('Referer', (strip_filename $src))
    $wc.Headers.Add('User-Agent', (Get-UserAgent))
    $wc.downloadFile($url, $dest)
}
function dl_string($src) {
    $wc = New-Object Net.Webclient
    $wc.headers.add('Referer', (strip_filename $src))
    $wc.Headers.Add('User-Agent', (Get-UserAgent))
    return $wc.downloadString($src)
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
function is_local($path) { ($path -notmatch '^https?://') -and (test-path $path) }
function relpath($path) { "$($myinvocation.psscriptroot)\$path" }
function spinner_sticks {
    param(
        [int]$cycles,
        [int]$sleeptime,
        [string]$text
    )
    1..$cycles | % {
        write-host "`r`r[ | ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ / ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ - ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ \ ] $text" -NoNewline
        start-sleep -m $sleeptime
    }
}
function spinner_ucva {
    param(
        [int]$cycles,
        [int]$sleeptime,
        [string]$text
    )
    1..$cycles | % {
        write-host "`r`r[ u ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ c ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ v ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ a ] $text" -NoNewline
        start-sleep -m $sleeptime
    }
}

function spinner_stars {
    param(
        [int]$cycles,
        [int]$sleeptime,
        [string]$text
    )
    1..$cycles | % {
        write-host "`r`r[ * ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ + ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ x ] $text" -NoNewline
        start-sleep -m $sleeptime
    }
}
function spinner_o1 {
    param(
        [int]$cycles,
        [int]$sleeptime,
        [string]$text
    )
    1..$cycles | % {
        write-host "`r`r(●    ) $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r( ●   ) $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r(  ●  ) $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r(   ● ) $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r(    ●) $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r(   ● ) $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r(  ●  ) $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r( ●   ) $text" -NoNewline
        start-sleep -m $sleeptime
    }
}
function spinner_o2 {
    param(
        [int]$cycles,
        [int]$sleeptime,
        [string]$text
    )
    1..$cycles | % {
        write-host "`r`r( ●●●●●●) $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r(  ●●●●●) $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r(   ●●●●) $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r(●   ●●●) $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r(●●   ●●) $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r(●●●   ●) $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r(●●●●   ) $text" -NoNewline
        start-sleep -m $sleeptime
    }
}
function spinner_eq1 {
    param(
        [int]$cycles,
        [int]$sleeptime,
        [string]$text
    )
    1..$cycles | % {
        write-host "`r`r[=    ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ =   ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[  =  ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[   = ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[    =] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[   = ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[  =  ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ =   ] $text" -NoNewline
        start-sleep -m $sleeptime
    }
}
function spinner_eq2 {
    param(
        [int]$cycles,
        [int]$sleeptime,
        [string]$text
    )
    1..$cycles | % {
        write-host "`r`r[ ======] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[  =====] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[   ====] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[=   ===] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[==   ==] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[===   =] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[===    ] $text" -NoNewline
        start-sleep -m $sleeptime
    }
}
function spinner_braille {
    param(
        [int]$cycles,
        [int]$sleeptime,
        [string]$text
    )
    1..$cycles | % {
        write-host "`r`r[ ⣾ ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ ⣷ ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ ⣯ ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ ⣟ ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ ⡿ ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ ⢿ ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ ⣻ ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ ⣽ ] $text" -NoNewline
        start-sleep -m $sleeptime

    }
}
function is_prime {
    param(
        [Parameter(ValueFromPipeline=$true)]
        [int32]$number
    )
    Process {
        $prime = $true;
        if ($number -eq 1) {
            $prime = $false;
        }
        if ($number -gt 3) {
            $sqrt = [math]::Sqrt($number); 
            for($i = 2; $i -le $sqrt; $i++) {
                if ($number % $i -eq 0) {
                    $prime = $false;
                    break;
                }
            }
        }
        return $prime;
    }
}
function getmousehome() {
    return "$HOME/.mouse/"
}
function mouse_outdated() {
    if (!(Test-Path (getmouseconfig))) {
        createconfig
    }
    $conf = loadconfig
    $last_update_str = $conf.lastupdatetime
    if($null -eq $last_update_str) {
        return $true
    }
    try {
        $last_update = [System.DateTime]::Parse($last_update_str)
    }
    catch {
        return $true
    }
    $now = [System.DateTime]::Now
    return $last_update.AddHours(13) -lt $now.ToLocalTime()
}
function getversion() {
    return (Get-Content ("$psscriptroot\..\share\version.dat"))
}
function getmouseconfig() {
    return "$(getmousehome)app/share/config.json"
}
function createconfig() {
    [string]$config_boilerplate = "{ `"lastupdatetime`": `"`", 
                                     `"git_crypt_key`": `"$(getmousehome)git_crypt_key.key`"  
                                   }"
    ni -path (getmouseconfig) -force
    sc -path (getmouseconfig) -value $config_boilerplate
}
function loadconfig() {
    return gc (getmouseconfig) | ConvertFrom-Json
}
function lock_repo {
    cd (getmousehome/dat)
    git-crypt lock
}
