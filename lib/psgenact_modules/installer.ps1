param(
    [int]$cycles
)

function spinner_sticks {
    param(
        [int]$cycles,
        [int]$sleeptime,
        [string]$text
    )
    1..$cycles | % {
        write-host "`r`r[ / ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ - ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ \ ] $text" -NoNewline
        start-sleep -m $sleeptime
        write-host "`r`r[ | ] $text" -NoNewline
        start-sleep -m $sleeptime
    }
}

[array]$packages = (Get-Content -Path "$psscriptroot\..\line_list_files\packages.txt")

if ([console]::KeyAvailable)
{
    $key = [system.console]::readkey($true)
    if (($key.modifiers -band [consolemodifiers]"control") -and ($key.key -eq "c"))
    {
      Write-Host "Saving work to disk..." -NoNewline
      Start-Sleep -s 2
      Write-Host " done" -f Green
      break
    }
}


1..$cycles | Foreach-Object {
    if ([console]::KeyAvailable)
    {
        $key = [system.console]::readkey($true)
        if (($key.modifiers -band [consolemodifiers]"control") -and ($key.key -eq "C"))
        {
          Write-Host "Saving work to disk..." -NoNewline
          Start-Sleep -s 2
          Write-Host " done" -f Green
          break
        }
    }

    $pkg = $packages[(Get-Random -Maximum ($packages.Length))]

    spinner_sticks 7 80 "Downloading ${pkg}... " -NoNewline
    Write-Host "done" -f Green

    spinner_sticks 4 80 "Checking hash for ${pkg}... " -NoNewline
    Write-Host "ok" -f Green

    spinner_sticks 10 80 "Installing ${pkg}... " -NoNewline
    Write-Host "done`n" -f Green
}


