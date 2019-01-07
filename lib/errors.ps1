# Formats an exception string as such:
# exception@mouse(v1.0.0):[char~line~file]:[args]:[psmajor.psminor.psbuild]:[psedition:operatingsystem:osinfo]::CategoryInfo::FullyQualifiedErrorId::message::$HOME::$host.name

function Format-ErrorString {
    param(
        $_exception, 
        [string]$file = "0", 
        $c_args = "0", 
        [string]$version = "0.0.0"
    )
    $versi = $version
    $linen = $_exception.InvocationInfo.ScriptLineNumber
    $chars = $_exception.InvocationInfo.OffsetInLine
    $psver = $PsVersionTable.PsVersion.ToString()
    $pshed = $PsVersionTable.PsEdition
    $opsys = $PsVersionTable.OS
    $osinf = [environment]::OSVersion.Version.ToString()
    $messg = $_exception.ErrorDetails.Message
    $cinfo = $_exception.CategoryInfo.ToString()
    $fqeri = $_exception.FullyQualifiedErrorId

    return "exception@mouse(${versi}):[$chars~$linen~$file]:[$c_args]:[${psver}]:[${pshed}:${opsys}:${osinf}]::[$cinfo]::[$fqeri]::[$messg]::[$HOME]::[$($HOST.Name.ToString())]"
}

function Hash-ErrorString {
    param(
        [string]$text
    )
    $hasher = New-Object System.Security.Cryptography.SHA1Managed
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
    $hashByteArray = $hasher.ComputeHash($bytes)
    foreach($byte in $hashByteArray)
    {
         $hash += [System.String]::Format("{0:x2}", $byte)
    }
    return $hash;
}

function Get-ErrorString {
    param(
        $_exception, 
        [string]$file = "0", 
        $c_args = "0", 
        [string]$version = "0.0.0"
    )
    $errorString = Format-ErrorString $_exception $file $c_args $version
    $hash = Hash-ErrorString $errorString
    return "${errorString}@incident[${hash}]"
}

function Get-SentryErrorObject {
        param(
        $_exception, 
        [string]$file = "0", 
        $c_args = "0", 
        [string]$version = "0.0.0"
    )
    $messg = $_exception.ErrorDetails.Message 
    $datetime = [System.DateTime]::Now.ToString("o")
    $errstring = Get-ErrorString $_ $file $c_args $version
    $ferrstring = Format-ErrorString $_ $file $c_args $version
    $hash = Hash-ErrorString $ferrstring
    $linen = $_exception.InvocationInfo.ScriptLineNumber
    $chars = $_exception.InvocationInfo.OffsetInLine


    $errorobj = New-Object -Type PSObject
    $errorobj | Add-Member -NotePropertyName release -NotePropertyValue $version
    $errorobj | Add-Member -NotePropertyName platform -NotePropertyValue (Get-SentryPlatform)
    $errorobj | Add-Member -NotePropertyName message -NotePropertyValue $messg
    $errorobj | Add-Member -NotePropertyName errinfo -NotePropertyValue "${file}::${linen}::${chars}"
    $errorobj | Add-Member -NotePropertyName datetime -NotePropertyValue $datetime

    $errorobj | Add-Member -NotePropertyName ferrstring -NotePropertyValue $errstring
    $errorobj | Add-Member -NotePropertyName incident_id -NotePropertyValue $hash
    $errorobj | Add-Member -NotePropertyName errstring -NotePropertyValue $ferrstring

    return $errorobj
}

function Get-SentryPlatform {
    $psver = $PsVersionTable.PsVersion.ToString()
    $pshed = $PsVersionTable.PsEdition
    $opsys = $PsVersionTable.OS

    return "${psed}::${pshed}::${opsys}"
}