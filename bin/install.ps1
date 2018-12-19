# Copyright (c) 2018 Kied T Llaentenn
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Usage:
# `Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/Kiedtl/mouse/master/bin/install.ps1"))`
# Summary: Installs Mouse on a windows/Linux/macOS computer in ~/.mouse



$OLD_ERRORACTIONPREFERENCE = $erroractionpreference
$MOUSE_CORE_URL = 'https://raw.githubusercontent.com/kiedtl/mouse/master/lib/core.ps1'
$SCOOP_CORE_URL = 'https://raw.githubusercontent.com/lukesampson/scoop/master/lib/core.ps1'
$URL = 'https://github.com/kiedtl/mouse.git'

$erroractionpreference = 'stop' # quit if anything goes wrong

Write-Host "Initializing..." -NoNewline
Invoke-Expression (new-object net.webclient).downloadstring($MOUSE_CORE_URL)
Invoke-Expression (new-object net.webclient).downloadstring($SCOOP_CORE_URL)
Write-Host " done" -f Green

if (($PSVersionTable.PSVersion.Major) -lt 3) {
    error "PowerShell 3 or greater is required to run Mouse."
    error "Upgrade PowerShell: https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell"
    break
}

if ([System.Enum]::GetNames([System.Net.SecurityProtocolType]) -notcontains 'Tls12') {
    error "Mouse requires at least .NET Framework 4.5"
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

Push-Location


Write-Host "Downloading..." -NoNewline
Set-Location $HOME
New-Item -Path . -Name ".mouse" -ItemType "directory" > dump.tmp
Set-Location $HOME/.mouse
git clone -q http://github.com/kiedtl/mouse.git ./app
Write-Host " done" -f Green

Write-Host 'Adding Mouse to PATH...' -NoNewline
Set-Location "${HOME}/.mouse/app/"
./lib/shim.ps1 "./bin/mouse.ps1" 
Write-Host " done" -f Green

Write-Host "Creating directories..." -NoNewline
Set-Location "${HOME}/.mouse/"
New-Item -Path . -Name "dat" -ItemType "directory" > dump.tmp
Set-Location "${HOME}/.mouse/dat"
Write-Host " done" -f Green

Write-Host "Creating GitHub repository..." -NoNewline
git init > ../app/share/dump.tmp
$HUB_OUTPUT = hub.exe create my-mouse-repo -d "My personal Mouse repository;" | Out-String
Write-Host " done" -f Green 
Write-Host "Created GitHub repository $repo"

Write-Host "Initializing Git LFS" -NoNewline
Set-Location $HOME/.mouse/dat/
git lfs track "*.zip" > ../app/share/dump.tmp
git add .gitattributes > ../app/share/dump.tmp
git commit -a -q -m "Initialized Git LFS"
Write-Host " done" -f Green

Pop-Location
success "`nMouse was successfully installed!"
success "Type `mouse help` for instructions."

$erroractionpreference = $OLD_ERRORACTIONPREFERENCE
