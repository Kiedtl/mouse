param(
    [int]$cycles
)

function spin_fan() {
    Pop-Location
    Set-Location $psscriptroot\..
    Set-Location fan_files/
    Get-ChildItem .\*.psgctff | Foreach-Object {
        $sequence = -join ((48..57) + (65..90) | Get-Random -Count 100 | % {[char]$_})
        Set-Content -Path $_ -Value $sequence 
    }
    Push-Location
}

[array]$files = (Get-Content -Path "$psscriptroot\..\line_list_files\cfiles.txt")

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

    $file = $files[(Get-Random -Maximum ($files.Length))]
    Write-Host "COMPILING file`t`t[ ${file} ]"
    spin_fan
    Write-Host "LINKING   file`t`t[ ${file} ]"
    spin_fan
}



