<# 
.NAME
    Mouse_Installer
#>

Add-Type -AssemblyName System.Windows.Forms

[int]$ii = 0

function startins() {
}

function increment() {
    $ii++
    $textcab.text = "Installing: ${ii}%"
}

function error {
    param(
        [string]$text,
        [string]$caption
    )
    [System.Windows.Forms.MessageBox]::Show($text, $caption, 0, 16)
}
function warn {
    param(
        [string]$text,
        [string]$caption
    )
    [System.Windows.Forms.MessageBox]::Show($text, $caption, 0, 48)
}

function info {
    param(
        [string]$text,
        [string]$caption
    )
    [System.Windows.Forms.MessageBox]::Show($text, $caption, 0, 64)
}

function msg {
    param(
        [string]$text,
        [string]$caption
    )
    [System.Windows.Forms.MessageBox]::Show($text, $caption, 0, 0)
}


function is_unix() { $PSVersionTable.Platform -eq 'Unix' }

if((is_unix)) {
    return # get the heck outta here
}


[System.Windows.Forms.Application]::EnableVisualStyles()

$Mouse_Setup                     = New-Object system.Windows.Forms.Form
$Mouse_Setup.ClientSize          = '806,478'
$Mouse_Setup.text                = "mouse(1) Setup"
$Mouse_Setup.BackColor           = "#ffffff"
$Mouse_Setup.TopMost             = $false

$title                           = New-Object system.Windows.Forms.Label
$title.text                      = "mouse(1) Setup"
$title.AutoSize                  = $true
$title.width                     = 25
$title.height                    = 10
$title.location                  = New-Object System.Drawing.Point(31,33)
$title.Font                      = 'Consolas,34,style=Bold'

$textlab                         = New-Object system.Windows.Forms.Label
$textlab.text                    = "This installer will install the Mouse program on your computer."
$textlab.AutoSize                = $true
$textlab.width                   = 25
$textlab.height                  = 10
$textlab.location                = New-Object System.Drawing.Point(31,117)
$textlab.Font                    = 'Verdana,13'

$textbab                         = New-Object system.Windows.Forms.Label
$textbab.text                    = "Mouse will be installed in your ~\.mouse\ directory."
$textbab.AutoSize                = $true
$textbab.width                   = 25
$textbab.height                  = 10
$textbab.location                = New-Object System.Drawing.Point(31,145)
$textbab.Font                    = 'Verdana,13'

$textcab                         = New-Object system.Windows.Forms.Label
$textcab.text                    = "For more information, see github.com/kiedtl/mouse`nAuthor: Kied Llaentenn`nLicense: AGPL-3.0"
$textcab.AutoSize                = $true
$textcab.width                   = 25
$textcab.height                  = 10
$textcab.location                = New-Object System.Drawing.Point(31,213)
$textcab.Font                    = 'Verdana,13'

$start_button                    = New-Object system.Windows.Forms.Button
$start_button.BackColor          = "#ffffff"
$start_button.text               = "Start Installation"
$start_button.width              = 161
$start_button.height             = 45
$start_button.Anchor             = 'right,bottom'
$start_button.location           = New-Object System.Drawing.Point(588,393)
$start_button.Font               = 'Verdana,10,style=Bold'


$Mouse_Setup.controls.AddRange(@($title,$textlab,$textbab,$textcab,$start_button))
$start_button.Add_Click({ startins })

$mouse = try {
    Get-Command mouse -ErrorAction Stop
} catch { $null }

if ($mouse) {
    $textlab.text = "Oops! It looks like you already have Mouse installed."
    $textbab.text = "To update Mouse, try `"mouse update`"."
    $textcab.text = " " 
    $start_button.Enabled = $false
}


[void]$Mouse_Setup.ShowDialog()