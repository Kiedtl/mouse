#requires -v 3
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

param($cmd)

set-strictmode -off

. "..\lib\core.ps1"
. (relpath '..\lib\commands')

$nvurl = "https://raw.githubusercontent.com/Kiedtl/mouse/master/share/version.dat"

$commands = commands
if ('--version' -contains $cmd -or (!$cmd -and '-v' -contains $args)) {
    Write-Host "Current Mouse Version: " -NoNewLine
    $currver = Get-Content "$psscriptroot\..\share\version.dat"
    Write-Host -f Green ("$currver")
    if (test_internet) {
        $newver = (New-Object Net.WebClient).DownloadString($nvurl)
        Write-Host "Latest Mouse Version: " -NoNewline
        Write-Host ("$newver") -f Blue
    }
}
elseif (@($null, '--help', '/?') -contains $cmd -or $args[0] -contains '-h') { exec 'help' $args }
elseif ($commands -contains $cmd) { exec $cmd $args }
else { "mouse: '$cmd' isn't a valid command. Try 'mouse help'."; exit 1 }
