. "$psscriptroot\..\lib\core.ps1"

# Remove from the PATH
Remove-Item "$HOME\AppData\Local\shims\mouse.cmd" -Force
Remove-Item "$HOME\AppData\Local\shims\mouse.ps1" -Force
success "Removed Mouse from your PATH"

# Delete Mouse
Remove-Item -Recurse -Force "$HOME/.mouse/dat"
success "Deleted .mouse/dat directory"

Remove-Item -Recurse -Force "$HOME/.mouse/app"
success "Finished uninstalling Mouse."
info "Mouse cannot delete your GitHub repository. You must delete this yourself."

break
