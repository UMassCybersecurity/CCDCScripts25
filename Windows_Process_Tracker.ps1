$processes = Get-WmiObject Win32_Process
Write-Output "Process listing started. Give it about 45 seconds."

$processDetails = @()

foreach ($process in $processes) {
    try {
        $processPath = $process.ExecutablePath

        $processInfo = Get-CimInstance Win32_Process -Filter "ProcessId = $($process.ProcessId)"
        $startTime = $processInfo.StartTime
        $cpuUsage = [math]::round($processInfo.KernelModeTime + $processInfo.UserModeTime, 2) / 10000000  # CPU time in seconds
        $memoryUsage = [math]::round($processInfo.WorkingSetSize / 1MB, 2)  # Memory usage in MB

        if ($processPath) {
            $processDetails += [PSCustomObject]@{
                "Process Name"     = $process.Name
                "PID"              = $process.ProcessId
                "Start Time"       = $startTime
                "CPU Usage (sec)"  = $cpuUsage
                "Memory Usage (MB)" = $memoryUsage
                "File Path"        = $processPath
            }
        }
        else {
            $processDetails += [PSCustomObject]@{
                "Process Name"     = $process.Name
                "PID"              = $process.ProcessId
                "Start Time"       = $startTime
                "CPU Usage (sec)"  = $cpuUsage
                "Memory Usage (MB)" = $memoryUsage
                "File Path"        = "Path not available"
            }
        }
    }
    catch {
        $processDetails += [PSCustomObject]@{
            "Process Name"     = $process.Name
            "PID"              = $process.ProcessId
            "Start Time"       = "N/A"
            "CPU Usage (sec)"  = "N/A"
            "Memory Usage (MB)" = "N/A"
            "File Path"        = "Error retrieving path"
        }
    }
}

$processDetails | Format-Table -Property `
    "Process Name", `
    "PID", `
    "Start Time", `
    "CPU Usage (sec)", `
    "Memory Usage (MB)", `
    "File Path" `
    -AutoSize

Write-Output ""
