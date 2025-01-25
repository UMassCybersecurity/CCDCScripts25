# Define the log file path
$logFile = "C:\Logs\scheduled_task_hardening_log.txt"

# Create or clear the log file if it exists
if (Test-Path $logFile) {
    Clear-Content -Path $logFile
} else {
    New-Item -ItemType File -Path $logFile
}

# Function to write log messages to the log file
function Write-Log {
    param (
        [string]$Message
    )
    Add-Content -Path $logFile -Value "$($Message)"
}

# Header for the log file
Write-Log "Scheduled Task Log"
Write-Log "Log generated on: $(Get-Date)"

#Log all scheduled tasks
Write-Log "### All Scheduled Tasks ###"
$tasks = Get-ScheduledTask | Select-Object TaskName, TaskPath, State, LastRunTime, NextRunTime, Author, User, Actions
$tasks | ForEach-Object {
    Write-Log "Task: $($_.TaskName) - Path: $($_.TaskPath) - State: $($_.State) - LastRun: $($_.LastRunTime) - NextRun: $($_.NextRunTime) - Author: $($_.Author) - User: $($_.User)"
}
Write-Log "`n---------------------------------------------------------------------------"

# tasks that require Administrator rights
Write-Log "### Tasks Running with Elevated Privileges (Administrator) ###"
$elevatedTasks = $tasks | Where-Object { $_.User -eq 'SYSTEM' -or $_.User -eq 'Administrator' }
$elevatedTasks | ForEach-Object {
    Write-Log "Task: $($_.TaskName) - User: $($_.User) - Path: $($_.TaskPath)"
}
Write-Log "`n---------------------------------------------------------------------------"

# tasks that run specific commands
Write-Log "### Tasks Running Specific Commands ###"
$tasksWithCommands = $tasks | Where-Object { $_.Actions -like "*cmd.exe*" -or $_.Actions -like "*powershell.exe*" -or $_.Actions -like "*at.exe*" -or $_.Actions -like "taskhostw.exe*" }
$tasksWithCommands | ForEach-Object {
    Write-Log "Task: $($_.TaskName) - User: $($_.User) - Path: $($_.TaskPath) - Action: $($_.Actions)"
}

Write-Log "`n---------------------------------------------------------------------------"

# Final log entry
Write-Log "End of log entry on $(Get-Date)"

