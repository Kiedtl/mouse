
# Usage: mouse update
# Summary: Updates Mouse
# Help: Updates Mouse to the latest version on GitHub by a simple
#       `git pull`.

. "$psscriptroot\..\lib\core.ps1"

$newver = dl_string $nvurl;
$nvurl = "https://raw.githubusercontent.com/Kiedtl/mouse/master/share/version.dat"
if (test_internet) {
    Push-Location;

    $slp = Invoke-Command -ComputerName $env:ComputerName -ScriptBlock { start-sleep -m 500; } -AsJob
    $sleeptime = 80;
    $text = "Updating Mouse... "
    
    while (($slp.State -eq "Running") -and ($slp.State -ne "NotStarted"))
    {
        write-host "`r`r[ | ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ / ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ - ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ \ ] $text" -NoNewline
        start-sleep -m $sleeptime
    }

    $sleep = Invoke-Command -ComputerName $env:ComputerName -ScriptBlock { start-sleep -m 800; } -AsJob
    $sleeptime = 80;
    $text = "Updating Mouse... initializing"
    
    while (($sleep.State -eq "Running") -and ($sleep.State -ne "NotStarted"))
    {
        write-host "`r`r[ | ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ / ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ - ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ \ ] $text" -NoNewline
        start-sleep -m $sleeptime
    }

    $getstring = Invoke-Command -ComputerName $env:ComputerName -ScriptBlock { $newver = dl_string $nvurl; Set-Location "$HOME/.mouse/app"; } -AsJob
    $sleeptime = 80;
    $text = "Updating Mouse... retrieving online data"
    
    while (($getstring.State -eq "Running") -and ($getstring.State -ne "NotStarted"))
    {
            write-host "`r`r[ | ] $text" -NoNewline
            start-sleep -m $sleeptime
            write-host "`r`r[ / ] $text" -NoNewline
            start-sleep -m $sleeptime
            write-host "`r`r[ - ] $text" -NoNewline
            start-sleep -m $sleeptime
            write-host "`r`r[ \ ] $text" -NoNewline
            start-sleep -m $sleeptime
    }
    
    $gitpull = Invoke-Command -ComputerName $env:ComputerName -ScriptBlock { git pull origin master -q > "$psscriptroot\..\share\dump.tmp"; } -AsJob
    $text = "Updating Mouse... pulling from origin/master"
    
    while (($gitpull.State -eq "Running") -and ($gitpull.State -ne "NotStarted"))
    {
            write-host "`r`r[ | ] $text" -NoNewline
            start-sleep -m $sleeptime
            write-host "`r`r[ / ] $text" -NoNewline
            start-sleep -m $sleeptime
            write-host "`r`r[ - ] $text" -NoNewline
            start-sleep -m $sleeptime
            write-host "`r`r[ \ ] $text" -NoNewline
            start-sleep -m $sleeptime
    }
    
    $savechanges = Invoke-Command -ComputerName $env:ComputerName -ScriptBlock { Set-Content -Path "share\version.dat" -Value $newver; git commit -a -q -m "Updated Mouse" > ..\app\share\dump.tmp } -AsJob
    $text = "Updating Mouse... commiting changes          "
    
    while (($savechanges.State -eq "Running") -and ($savechanges.State -ne "NotStarted"))
    {
            write-host "`r`r[ | ] $text" -NoNewline
            start-sleep -m $sleeptime
            write-host "`r`r[ / ] $text" -NoNewline
            start-sleep -m $sleeptime
            write-host "`r`r[ - ] $text" -NoNewline
            start-sleep -m $sleeptime
            write-host "`r`r[ \ ] $text" -NoNewline
            start-sleep -m $sleeptime
    }
    
        Write-Host "`r`r[ - ] Updating Mouse..." -NoNewline
        Write-Host " done                     " -f Green
        success "Successfully updated Mouse to $newver`n"
        Pop-Location
}
else {
    Write-Host " error" -f Red
    abort "mouse: ***** Unable to connect to the network. Stop."
}
