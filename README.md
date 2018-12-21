
<p align="center">
<img src="http://kiedtl.surge.sh/img/mouse.png" alt="mouse logo yay"/></p>
<p align="center" ><h1 align="center">Mouse</h1>
</p>
<hr />
<p align="center"><a href="https://github.com/kiedtl/mouse"><img src="https://img.shields.io/github/languages/code-size/kiedtl/mouse.svg" alt="Code-Size" /></a>
<a href="https://github.com/kiedtl/mouse"><img src="https://img.shields.io/github/repo-size/kiedtl/mouse.svg" alt="Repository size" /></a>
 <a href="https://github.com/kiedtl/mouse"><img src="https://img.shields.io/badge/lines%20of%20code-1720%2B-yellow.svg" alt="Lines of code" /></a> <a href="https://travis-ci.org/Kiedtl/mouse"><img src="https://travis-ci.org/Kiedtl/mouse.svg?branch=master" alt="Travis-CI" /></a>
<a href="https://github.com/kiedtl/mouse/blob/master/LICENSE"><img src="https://img.shields.io/github/license/kiedtl/mouse.svg" alt="License" /></a></p>
</p><p align="center"><a href="http://spacemacs.org"><img src="https://cdn.rawgit.com/syl20bnr/spacemacs/442d025779da2f62fc86c2082703697714db6514/assets/spacemacs-badge.svg" /></a></p>


Mouse is a simple, cross-platform way to manage, store, and backup your configuration files using GitHub repositories.

## Installation Requirements

- Windows 7 SP1+ / Windows Server 2008+
- [PowerShell 3](https://www.microsoft.com/en-us/download/details.aspx?id=34595) (or later) 
- [.NET Framework 4.5+](https://www.microsoft.com/net/download)
- The Powershell execution policy must be set to RemoteSigned or ByPass.
- [Git](http://git-scm.com) installed and configured.
- [Git LFS](http://github.com/git-lfs/git-lfs) must be installed.
- [Hub](http://github.com/github/hub) must installed and configured.
- Gnu Privacy Guard (GPG)
- Git-Crypt
Most of the above, except the .NET Framework, can be installed with [Scoop](http://github.com/lukesampson/scoop) on Windows, and Homebrew on macOS. For example, on Windows one could run:
```powershell
scoop install pwsh git gpg
scoop install git-lfs hub git-crypt
```
...and Scoop would automatically download, install, and add each of these apps to your PATH.

## Installation

Simply run this command in PowerShell:
```powershell
iex (new-object net.webclient).downloadstring('https://getmouse.surge.sh')
```

Once the Mouse installer has completed, you can run `mouse --version` to check that it installed successfully. Try typing `mouse help` for help. By default, Mouse is installed in `$HOME\.mouse\`, and unfortunately this cannot be changed in the current version of Mouse.

## What can Mouse do?

Mouse tries to make it easy to manage your configuration files (e.g., like your Powershell profile or your `.vimrc`). It backs up your configuration file by uploading to a GitHub repository. (Unless you make the GitHub repository private, anybody - *anybody* can see what is in the repository. For this reason, be very careful not add your `.authinfo` file or any other file that might contain passwords or other sensitive data.)
For example, to configure Mouse to track your Powershell profile, run the following code:
```powershell
mouse add $PROFILE
```
Mouse would then copy that file to its repository (located in `$HOME/.mouse/dat/`), commit the file, and then push its changes to GitHub.

To remove the file, run:
```powershell
mouse remove Microsoft.PowerShell_profile.ps1
```

### **Backup and Restore**
If you changed the file and need to back up the file again, instead of running `mouse add` again, you can simply type:
```powershell
mouse backup
```
and it would refresh all files in its repository.

Let's say that you backed up a bunch of files on one computer, and you want it on another. Just install Mouse on that comuter and run:
```powershell
mouse restore
```
If you wanted to restore only ONE file, run:
```powershell
mouse restore <blah>
```

### **Updating Mouse**
Every so often, I release a new version of Mouse via the `master` branch of this repo. You can update to the latest version of Mouse by running:
```powershell
mouse update
```

### **Uninstalling Mouse**
If you don't like Mouse, you think its buggy and unpredictable, or if you just don't like its name, thats okay. Just run in the terminal:
```powershell
mouse uninstall
```
and it will remove the `.mouse` folder and remove `$HOME/.mouse/app/bin/mouse.ps1` from your PATH.

## Easter eggs
I've buried at least 10 easter eggs in Mouse. If you think you've found one, remember to file an issue!

## Contributing
PR's are welcome, as long as they conform to the basic code style of this repository:
- In the command implementation files (e.g. `libexec/mouse-help.ps1`), the Powershell code should **NOT** use any aliases. (for example, type `Foreach-Object { ... }` instead of `% { ... }`.)
- In the supporting files, such as `lib/core.ps1`, code is expected to use every alias possible (type `gm` instead of `Get-Member`).
Remember to contribute all your work to branch `develop` - master is strictly for finished, tested, debugged code ready for deployment. Contributions to branch `master` **WILL NOT** be accepted.

### Project Tree
```
kiedtl ~\source\mouse git: master ≣ ~3 -8 ! ❯❯❯ gc tree.json | convertfrom-json | treewiz -d -q

source/mouse
| LICENSE			    	The license for Mouse  
| README.md				    The README                
|                                                    
+---bin					    Main scripts for Mouse
|       install.ps1			Installation script
|       mouse.ps1			Main entrypoint for Mouse
|
+---lib					    Utility scripts and dependencies
|   |   commands.ps1		Command parser
|   |   core.ps1			Collection of helper functions
|   |   cow-conversion.txt	Dependency for cowsay.ps1 and cowthink.ps1
|   |   cowsay.ps1			Dependency
|   |   cowthink.ps1		Dependency
|   |   figlet.exe			Dependency
|   |   getopt.ps1			Command argument parser
|   |   git.ps1
|   |   help.ps1			Help parser
|   |   hub.exe				Dependency for installation script
|   |   json.ps1
|   |   say.ps1				Dependency
|   |   shim.ps1			Dependency for installation script
|   |   touch.ps1			Dependency
|   |
|   +---cows				Dependency for cowsay.ps1
|   |       ...
|   |
|   +---fonts				Dependency for figlet.exe
|   |       ...
|   |
|   \---lib				
|           opts.ps1		Argument parser (same as getopt.ps1)
|
+---libexec				    Mouse command implementations
|       mouse-add.ps1		'Add' command
|       mouse-backup.ps1	'Backup' command
|       mouse-help.ps1		'Help' command
|       mouse-remove.ps1	'Remove' command
|       mouse-restore.ps1	'Restore' command
|       mouse-update.ps1	'Update' command
|
\---share					Shared data
        dump.tmp
        version.dat			Latest version data
```

## Credits
Thanks to the maintainers of [Scoop](http://github.com/lukesampson/scoop), especially Luke Sampson, from whose repository I stole a lot of stuff.

