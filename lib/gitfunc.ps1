function AddAndCommit-SingleFile {
    param(
        [string]$File,
        [string]$Message,
        [bool]$IsNew = $false
    )
    $flags = if ($IsNew) { "--add" } else { "" }
    git update-index $flags $File
    $fullTreeID = git write-tree
    $treeID = ConvertSHATo-ID $fullTreeID
    $parentFullCommitID = git rev-parse HEAD
    $parentCommitID = ConvertSHATo-ID $parentFullCommitID
    git commit-tree $treeID -p $parentCommitID -m $Message
} 

function ConvertSHATo-ID {
    param(
        [string]$SHA
    )
    return $SHA.SubString(0, 7)
}