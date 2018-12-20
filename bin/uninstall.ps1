. "$psscriptroot\..\lib\core.ps1"

# Remove from the PATH
Remove-Item "$HOME\AppData\Local\shims\mouse.cmd" -Force
Remove-Item "$HOME\AppData\Local\shims\mouse.ps1" -Force
success "Removed Mouse from your PATH"

# Delete the .mouse directory
Remove-Item -Recurse -Force "$HOME/.mouse"
success "Deleted .mouse directory"
info "Mouse cannot delete your GitHub repository. You must delete this yourself."
break
