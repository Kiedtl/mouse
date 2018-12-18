function abort($msg, [int] $exit_code=1) { write-host $msg -f red; exit $exit_code }
function error($msg) { write-host "ERROR $msg" -f darkred }
function warn($msg) {  write-host "WARN  $msg" -f darkyellow }
function info($msg) {  write-host "INFO  $msg" -f darkgray }
function debug($msg, $indent = $false) {
    if($indent) {
        write-host "    DEBUG $msg" -f darkcyan
    } else {
        write-host "DEBUG $msg" -f darkcyan
    }
}
function success($msg) { write-host $msg -f darkgreen }
function test_internet() {
    $conn = (Test-Connection -ComputerName google.com -Count 2 -Quiet)
    return $conn
}
