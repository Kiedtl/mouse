$OLD_ERRORACTIONPREFERENCE = $erroractionpreference
$MOUSE_CORE_URL = 'https://raw.github.com/kiedtl/mouse/master/lib/core.ps1'
$SCOOP_CORE_URL = 'https://raw.github.com/lukesampson/scoop/lib/core.ps1'
$URL = 'https://github.com/kiedtl/mouse.git'

$erroractionpreference = 'stop' # quit if anything goes wrong

Write-Host "Initializing..." -NoNewline
Invoke-Expression (new-object net.webclient).downloadstring($CORE_URL)
Write-Host " done" -f Green

if (($PSVersionTable.PSVersion.Major) -lt 3) {
    error "PowerShell 3 or greater is required to run Scoop."
    error "Upgrade PowerShell: https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell"
    break
}

if ([System.Enum]::GetNames([System.Net.SecurityProtocolType]) -notcontains 'Tls12') {
    error "Scoop requires at least .NET Framework 4.5"
    error "Please download and install it first:"
    error "https://www.microsoft.com/net/download"
    break
}

if ((Get-ExecutionPolicy) -gt 'RemoteSigned' -or (Get-ExecutionPolicy) -eq 'ByPass') {
    error "PowerShell requires an execution policy of 'RemoteSigned' to run Scoop."
    error "To make this change please run:"
    error "'Set-ExecutionPolicy RemoteSigned -scope CurrentUser'"
    break
}

if (installed 'scoop') {
    warn "Scoop appears to be installed. Mouse will be installed with Scoop."
    scoop bucket add open-scoop http://github.com/kiedtl/open-scoop.git
    scoop install mouse
    break
}

Write-Host "Downloading..." - NoNewline
Set-Location $HOME
git clone -q http://github.com/kiedtl/mouse.git ./.mouse
Write-Host " done" -f Green

Write-Host 'Adding Mouse to PATH...' -NoNewline
Set-Location $HOME/.mouse/
./lib/shim.ps1 "./bin/mouse.ps1" 
Write-Host " done`n" -f Green

Write-Host "Creating directories..." -NoNewline
Set-Location $HOME/.mouse/
New-Item -Path . -Name "share" -ItemType "directory"
Set-Location $HOME/.mouse/share/
New-Item -Path . -Name "repo" -ItemType "directory"
Write-Host " done" -f Green

Write-Host "Creating GitHub repository..." -NoNewline
Set-Location $HOME/.mouse/share/repo/
git init
$HOME/.mouse/lib/hub.exe create my-mouse-repo -d "My Mouse repository"
Write-Host " done`n" -f Green 
success "Created GitHub repository 'my-mouse-repo'"

if (!$isWindows) {
    warn "You are using an unsupported platform." 
}

if ($isMacOS) {
    warn "Mouse has not been tested on macOS."
}

if ($isLinux) {
    warn "Mouse has not been tested on Linux." 
}

Set-Location $HOME
success '`nMouse was successfully installed!'
success "Type 'mouse help' for instructions."

$erroractionpreference = $OLD_ERRORACTIONPREFERENCE