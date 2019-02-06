# Usage: mouse backup
# Summary: Backup each file that was previously added
# Help: Mouse will make refresh the files in its repository with the files
#	   currently in their respective diretories.
#
# For example, if you have previously added a .spacemacs
#	   file and a .scoop file and you later type `mouse backup`
#	   after those files were modified, Mouse will copy those two new
#
# Options:
#   -n, --nosync			   Don't synchronize repository with GitHub
	
try {
	Add-Type -assembly "System.IO.Compression.Filesystem"
	
	. "$psscriptroot\..\lib\core.ps1"
	. "$psscriptroot\..\lib\getopt.ps1"
	
	$opt, $blah, $err = getopt $args 'yn:' 'yay', 'nosync'
	$yay = $opt.yay -or $opt.y
	$nosync = $opt.nosync -or $opt.n
	
	$SNAKES = "$psscriptroot\..\lib\snake.ps1"
	
	Push-Location
	Set-Location $HOME/.mouse/dat/
	
	if ($true) { # TODO: Implement --plumbing flag and change $true to if !($plumbing)
		Write-Host "Unlocking repository..." -NoNewline
		git-crypt unlock $HOME/.mouse/git_crypt_key.key | out-null
		Write-Host " done" -f Green
	}
	
	if ($yay) {
		& $SNAKES
	}
	
	$ball = [System.Text.Encoding]::UTF8.GetString((226,151,143))
	
	$spinner = "( ${ball}${ball}${ball}${ball}${ball}${ball}${ball})", 
			"(  ${ball}${ball}${ball}${ball}${ball}${ball})", 
			"(   ${ball}${ball}${ball}${ball}${ball})",
			"(${ball}   ${ball}${ball}${ball}${ball})",
			"(${ball}${ball}   ${ball}${ball}${ball})",
			"(${ball}${ball}${ball}   ${ball}${ball})", 
			"(${ball}${ball}${ball}	${ball})", 
			"(${ball}${ball}${ball}${ball}	)", 
			"(${ball}${ball}${ball}${ball}${ball}   )", 
			"(${ball}${ball}${ball}${ball}${ball}${ball}  )"
			
	$spin_c = 0
	$i = 0
	$errors = @()
	
	Get-ChildItem info\*.info | Foreach-Object {
		$name = $_.Name
		$basename = $_.BaseName	

		$fileinfo = Get-Content $_ | ConvertFrom-Json
		$filepath = (unfriendly_path $fileinfo.opath)
		$friendly_filepath = $fileinfo.opath
		$filename = $fileinfo.oname
		$isdir = $fileinfo.isdir

		if ($isdir) { $type = "directory" } else { $type = "file" }
		if (!(test-path $_)) { $errors += "UE194: ${type} $($filepath) was not found!"; continue }
		write-host "`r`r$($spinner[$spin_c % ($spinner.Length)]) Processing $type ${basename} ...                              " -nonewline

		if (!$isdir) {
			Copy-Item -Path $filepath -Destination $file -Force
		}
		else {
			if ((Test-Path "$HOME\.mouse\dat\${filename}.zip")) {
				Remove-Item "$HOME\.mouse\dat\${filename}.zip"
			}
			[IO.Compression.ZipFile]::CreateFromDirectory($filepath, "$HOME\.mouse\dat\${filename}.zip")
		}
		git commit -a -q -m "Backed up file $friendly_filepath" | Out-Null
		$i++
		$spin_c++
	}
	
	Set-location $HOME/.mouse/dat/
	
	if (test_internet) {
		if (!$nosync) {
			git push origin master > ../app/share/dump.tmp
			write-host "`r`r$($spinner[$spin_c % ($spinner.Length)]) Synchronizing repository ...                            " -nonewline
		}
		else {
			write-host "`r`r$($spinner[$spin_c % ($spinner.Length)]) Skipping synchronization ...                            " -nonewline
		}
		$spin_c++
	}
	else {
		write-host "`r`r$($spinner[$spin_c % ($spinner.Length)]) Skipping synchronization, no internet connection ...          " -nonewline
		$spin_c++
	}
	
	write-host "`r`rBackup: processed $i items, with $($errors.Length) errors." -f Green
	if (($errors.Length) -ne 0) {
		$errors | foreach-object {
			error $_
		}
	}
	Pop-Location
	
} catch {
	Write-Host "Reporting internal error... " -NoNewline
	. "$psscriptroot\..\lib\ravenclient.ps1"
	[uint64]$d_snn = 16850863275
	[string]$directory_singular_nuisance = "https://c80867d30cd048ca9375d3e7f99e28a8:f426d337a9434aa7b7da0ec16166ca98@sentry.io/$($d_snn / 12345)"
	$ravenClient = New-RavenClient -SentryDsn $dsn
	$ravenClient.CaptureException($_)
	Write-Host "done" -f Green
}
