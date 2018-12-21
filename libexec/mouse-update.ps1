# Usage: mouse update
# Summary: Updates Mouse
# Help: Updates Mouse to the latest version on GitHub with a simple
#       `git pull`.

. "$psscriptroot\..\lib\core.ps1"

$newver = dl_string $nvurl;
$nvurl = "https://raw.githubusercontent.com/Kiedtl/mouse/master/share/version.dat"
          
if (test_internet) {
    Push-Location;

    $updater = Invoke-Command -ComputerName $env:ComputerName -ScriptBlock {
        $newver = dl_string $nvurl;
        Set-Location "$HOME/.mouse/app";
        git pull origin master  > "$psscriptroot\..\share\dump.tmp";
        Set-Content -Path "share\version.dat" -Value $newver;
        git commit -a -q -m "Updated Mouse" > ..\app\share\dump.tmp;
    } -AsJob

    $sleeptime = 80;
    $text = "Updating Mouse..."
    
    while (($updater.State -eq "Running") -and ($updater.State -ne "NotStarted"))
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
        Write-Host " done                        " -f Green
        success "Successfully updated Mouse to $newver`n"
        Pop-Location
}
else {
    Write-Host "[ - ] Updating Mouse..." -NoNewline
    Start-Sleep -m 1000
    Write-Host " error" -f Red
    abort "mouse: ***** Unable to connect to the internet. Stop."
}
