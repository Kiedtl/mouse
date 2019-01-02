function Get-GitBranch() {
    return "$(git rev-parse --abbrev-ref HEAD)"
}
