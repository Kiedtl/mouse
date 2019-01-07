function Get-StatusCode {
    param (
        [string]$code
    )
    return "$($statuscodes.$code)"
}

[hashtable]$statuscodes = @{ "000" = "X0000 (PROGRAM OUTPUT)   " }
$statuscodes.Add("100", "I0100 (AMBIGUOUS INFO)   ")
$statuscodes.Add("101", "I0101 (EXECUTING COMMAND)")
$statuscodes.Add("102", "I0102 (RECIEVIED COMMAND)")
$statuscodes.Add("104", "I0104 (FILE FOUND)       ")
$statuscodes.Add("105", "I0105 (DIRECTORY FOUND)  ")
$statuscodes.Add("106", "I0106 (REPORTING ERROR)  ")
$statuscodes.Add("200", "S0200 (SUCCESS)          ")
$statuscodes.Add("201", "S0201 (SYNCHRONIZED REPO)")
$statuscodes.Add("202", "S0202 (COMPLETED COMMAND)")
$statuscodes.Add("203", "S0203 (PARSED ARGUMENTS) ")
$statuscodes.Add("300", "W0300 (WARNING)          ")
$statuscodes.Add("301", "W0301 (OVERWRITING FILE) ")
$statuscodes.Add("302", "W0302 (VCS GIT ERROR)    ")
$statuscodes.Add("303", "W0303 (GIT_CRYPT ERROR)  ")
$statuscodes.Add("400", "UE400 (CLIENT ERROR)     ")
$statuscodes.Add("401", "UE401 (ARG PARSING ERROR)")
$statuscodes.Add("402", "UE402 (COMMAND ERROR)    ")
$statuscodes.Add("404", "UE404 (ITEM NOT FOUND)   ")
$statuscodes.Add("500", "IE500 (INTERNAL ERROR)   ")

# This variable should be updated using the ConvertTo-JSON cmdlet.
#
# [string]$statuscodesjson = ( $statuscodes | ConvertTo-Json -Compress -Depth 3 ) -replace "`"", "```""  
#
#
[string]$statuscodesjson = "{`"300`":`"W0300 (WARNING)          `",`"201`":`"S0201 (SYNCHRONIZED REPO)`",`"203`":`"S0203 (PARSED ARGUMENTS) `",`"101`":`"I0101 (EXECUTING COMMAND)`",`"200`":`"S0200 (SUCCESS)          `",`"302`":`"W0302 (VCS GIT ERROR)    `",`"106`":`"I0106 (REPORTING ERROR)  `",`"100`":`"I0100 (AMBIGUOUS INFO)   `",`"202`":`"S0202 (COMPLETED COMMAND)`",`"104`":`"I0104 (FILE FOUND)       `",`"401`":`"UE401 (ARG PARSING ERROR)`",`"303`":`"W0303 (GIT_CRYPT ERROR)  `",`"105`":`"I0105 (DIRECTORY FOUND)  `",`"500`":`"IE500 (INTERNAL ERROR)   `",`"402`":`"UE402 (COMMAND ERROR)    `",`"400`":`"UE400 (CLIENT ERROR)     `",`"404`":`"UE404 (ITEM NOT FOUND)   `",`"102`":`"I0102 (RECIEVIED COMMAND)`",`"000`":`"X0000 (PROGRAM OUTPUT)   `",`"301`":`"W0301 (OVERWRITING FILE) `"}"