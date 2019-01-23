function Get-StatusCode {
    param (
        [string]$code
    )
    return "$($statuscodes.$code)"
}

[hashtable]$statuscodes = @{ "000" = "X0000 (PROGRAM OUTPUT)   " }

$statuscodes.Add("100", "I0064 (AMBIGUOUS INFO)   ")
$statuscodes.Add("101", "I0065 (EXECUTING COMMAND)")
$statuscodes.Add("102", "I0066 (RECIEVIED COMMAND)")
$statuscodes.Add("104", "I0068 (FILE FOUND)       ")
$statuscodes.Add("105", "I0069 (DIRECTORY FOUND)  ")
$statuscodes.Add("106", "I006A (REPORTING ERROR)  ")
$statuscodes.Add("107", "I006B (LOCKING REPO)     ")
$statuscodes.Add("108", "I006C (UNLOCKING REPO)   ")

$statuscodes.Add("200", "S00C8 (SUCCESS)          ")
$statuscodes.Add("201", "S00C9 (SYNCHRONIZED REPO)")
$statuscodes.Add("202", "S00CA (COMPLETED COMMAND)")
$statuscodes.Add("203", "S00CB (PARSED ARGUMENTS) ")

$statuscodes.Add("300", "W012C (WARNING)          ")
$statuscodes.Add("301", "W012D (OVERWRITING FILE) ")
$statuscodes.Add("302", "W012E (VCS GIT ERROR)    ")
$statuscodes.Add("303", "W012F (GIT_CRYPT ERROR)  ")
$statuscodes.Add("304", "W0130 (NO INTERNET)      ")

$statuscodes.Add("400", "UE190 (CLIENT ERROR)     ")
$statuscodes.Add("401", "UE191 (ARG PARSING ERROR)")
$statuscodes.Add("402", "UE192 (COMMAND ERROR)    ")
$statuscodes.Add("404", "UE194 (ITEM NOT FOUND)   ")

$statuscodes.Add("500", "IE1F4 (INTERNAL ERROR)   ")

