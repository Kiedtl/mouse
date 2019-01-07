param(
    [int]$cycles
)

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

$modules = "installer",
           "kernel",
           "compiler"

$selectedModule = $modules[(Get-Random -Maximum ($modules.Length))]
& "$psscriptroot\psgenact_modules\${selectedModule}.ps1" ($cycles)
break