
<p align="center">
<img src="http://kiedtl.surge.sh/img/mouse.png" alt="mouse logo yay"/></p>
<p align="center" ><h1 align="center">mouse(1)</h1>
</p>
<hr />
<p align="center"><a href="https://github.com/kiedtl/mouse"><img src="https://img.shields.io/github/languages/code-size/kiedtl/mouse.svg" alt="Code-Size" /></a>
<a href="https://github.com/kiedtl/mouse"><img src="https://img.shields.io/github/repo-size/kiedtl/mouse.svg" alt="Repository size" /></a>
 <a href="https://github.com/kiedtl/mouse"><img src="https://img.shields.io/badge/lines%20of%20code-2500%2B-yellow.svg" alt="Lines of code" /></a> <a href="https://travis-ci.org/Kiedtl/mouse"><img src="https://travis-ci.org/Kiedtl/mouse.svg?branch=master" alt="Travis-CI" /></a>
<a href="https://github.com/kiedtl/mouse/blob/master/LICENSE"><img src="https://img.shields.io/github/license/kiedtl/mouse.svg" alt="License" /></a></p>
</p><p align="center"><a href="http://spacemacs.org"><img src="https://cdn.rawgit.com/syl20bnr/spacemacs/442d025779da2f62fc86c2082703697714db6514/assets/spacemacs-badge.svg" /></a></p>


Mouse is a simple, cross-platform way to manage, store, and backup your configuration files using GitHub repositories.

## Features
- :computer: (Almost!) completely cross-platform - (should) works on macOS, Windows, and Linux.
- :moneybag: Absolutely free!
- :closed_lock_with_key: AES-256 encryption with Git-Crypt, so you can add your `.authinfo` file to Mouse without any worry.
- :wrench: Mouse worrie
s about updating itself and downloading patches, so you won't have to.
- :sparkles: Intuitive and memorable commands.
- :clock130: Speed that is best measured by a stopwatch, not a calendar.
- Automatically uploads everything to GitHub, so you can take your data to another computer as well.

## Installation Requirements

- Windows 7 SP1+
- [PowerShell 3](https://www.microsoft.com/en-us/download/details.aspx?id=34595) (or later) 
- [.NET Framework 4.5+](https://www.microsoft.com/net/download)
- The Powershell execution policy must be set to RemoteSigned or ByPass.
- [Git](http://git-scm.com) installed and configured.
- [Git LFS](http://github.com/git-lfs/git-lfs) must be installed.
- [Hub](http://github.com/github/hub) must installed and configured.
- [GnuPG](https://gnupg.org/) must be installed (for Git-Crypt)
- [Git-Crypt](http://github.com/agwa/git-crypt/) must be installed.

Most of the above can be installed with [Scoop](http://github.com/lukesampson/scoop) on Windows, and Homebrew on macOS. For example, on Windows one could run:

```powershell
scoop install pwsh git gpg
scoop install git-lfs hub git-crypt
```
...and Scoop would automatically download, install, and add each of these programs to your PATH.

## Installation

Simply run this command in PowerShell:
```powershell
iex (new-object net.webclient).downloadstring('https://getmouse.surge.sh')
```

Once the Mouse installer has completed, you can run `mouse --version` to check that it installed successfully. Try typing `mouse help` for help. By default, Mouse is installed in `$HOME\.mouse\, and unfortunately this cannot be changed in the current version of Mouse.

**NOTE**: Mouse will automatically export the Git-Crypt key to `$HOME/.mouse/git_crypt_key.key`. It is highly recommended that this file is backed up somewhere safe - if this key is lost, you will lose all your data in Mouse.

## Usage
Mouse tries to make it easy to manage your configuration files (e.g., like your Powershell profile or your `.vimrc`). It backs up your configuration file by uploading to a GitHub repository. 
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
and it will remove the `.mouse/app` folder, the `.mouse/dat` and remove `$HOME/.mouse/app/bin/mouse.ps1` from your PATH. The uninstallation script will **NOT** remove the `.mouse/git_crypt_key.key file`, nor will it remove the GitHub repository. This must be done manually.

### **Re-installing Mouse**
1. Uninstall Mouse as shown above, by executing the `mouse uninstall` command.
2. **Move the `.mouse/git_crypt_key.key` file to somewhere else, like `~/documents`.** 
3. Delete the `~/.mouse/` folder.
4. Re-install Mouse as normal, by executing (in Powershell) the command `iex (new-object net.webclient).downloadstring("http://getmouse.surge.sh/")`
5. Then, move the key file which you moved earlier in set 2 back to where it was, in `.mouse/git_crypt_key.key`, replacing the file that was there.
6. Run `mouse sync`.
7. There is no seventh step. You're done!

### **Mouse and the `protect` command**
The `protect` command was intended to be a bridge between the usual Mouse user and the underlying Git-Crypt instance that Mouse utilizes to encrypt/decrypt the local repository.

#### **Subcommands:**
- lock ( `mouse protect lock` )
- unlock ( `mouse protect unlock` )
- expkey ( `mouse protect expkey` )
- adduser ( `mouse protect adduser` )
- status ( `mouse protect status` )

##### `mouse protect lock`
This command **locks** the local repository with Git-Crypt (using the command `git crypt lock`).

##### `mouse protect unlock`
This command **unlocks** the local repository with Git-Crypt.
Use this command when you need to manually access the data in `$HOME/.mouse/dat` without the Mouse tool. Remember to lock the repository when you have finished.

##### `mouse protect expkey <path>`
Use this command to export the Git-Crypt key to a path.

##### `mouse protect adduser`
Use tis command to add a GPG user to Git-Crypt. See the Git-Crypt documentation at http://github.com/agwa/git-crypt.

##### `mouse protect status`
Use this command to get the Git-Crypt status, such as information on which files are encrypted and which files or directories aren't. See the Git-Crypt documentation for more information.


<!-- TRY TYPING "MOUSE PROTECT MOUSE" -->

## Easter eggs
I've buried around 8  easter eggs in Mouse. If you think you've found one, please file an issue with the `easter egg` label!

## Contributing
PR's are welcome, as long as they conform to the basic code style of this repository:
- In the command implementation files (e.g. `libexec/mouse-help.ps1`), the Powershell code should **NOT** use any aliases. (for example, type `Foreach-Object { ... }` instead of `% { ... }`.)
- In the supporting files, such as `lib/core.ps1`, code is expected to use every alias possible (type `gm` instead of `Get-Member`).
Remember to contribute all your work to branch `develop` - master is strictly for finished, tested, debugged code ready for deployment. Contributions to branch `master` **WILL NOT** be accepted.

### Setting up Mouse repository for development
When cloning the Mouse repository, use the `--recurse` parameter because the Mouse repository contains multile submodules:

**Without SSH**
`git clone http://github.com/kiedtl/mouse.git --recurse --verbose --progress`

**With SSH**
`git clone git@github.com:kiedtl/mouse.git --recurse --verbose --progress`

Also, make sure when installing Mouse to test and debug new features pushed to the develop branch, to run `mouse develop` to switch to the devlop branch.


### Project Layout
```

source/mouse
| LICENSE			               	The license for Mouse  
| README.md				             The README                
|                                                    
+-------bin					            Main entrypoint for Mouse
|
+-------lib					            Utility scripts and dependencies
|     |                                                
|     +---cows			          	Dependency for cowsay.ps1 
|     |                                            
|     |
|     +---fonts			         	Dependency for figlet.exe 
|     |                                            
|     |                                            
|     \---lib                                       
|                                                  
+---libexec				             Mouse command implementations
|   
+---libsrc                  Mouse submodules and code for lib dependencies  
| 
\---share				              	Shared data
```

## Credits
Thanks to the maintainers of [Scoop](http://github.com/lukesampson/scoop), especially Luke Sampson, from whose repository I stole a lot of stuff.

