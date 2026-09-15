$backupFolder = "C:\Users\antov\Workspace\DevOps\Ex1 Backup & Deletion\Backup"
$logFolder = "C:\Users\antov\Workspace\DevOps\Ex1 Backup & Deletion\Logs"
$logFile = Join-Path $logFolder "Backup-Log.txt"

# Create log folder if it doesn't exist
if (!(Test-Path $logFolder)) {
    New-Item -ItemType Directory -Path $logFolder | Out-Null
}

# Function to write messages to the log
function Write-Log {
    param (
        [string]$Message
    )

    $timestamp = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
    $logMessage = "$timestamp - $Message"

    Add-Content -Path $logFile -Value $logMessage
    Write-Host $logMessage
}

Write-Log "Retention cleanup process started."

# Check if Backup folder exists
if (!(Test-Path $backupFolder)) {

    Write-Log "ERROR - Backup folder does not exist: $backupFolder"
    Write-Log "Retention cleanup stopped."

    exit
}

# Get all backup files
$backupFiles = Get-ChildItem -Path $backupFolder -Filter "File1-*.txt" -File

# Check if any backup files exist
if ($backupFiles.Count -eq 0) {

    Write-Log "WARNING - No backup files found."
    Write-Log "Retention cleanup completed."

    exit
}

# Sort backup files by LastWriteTime
$sortedFiles = $backupFiles | Sort-Object LastWriteTime -Descending

# Select the latest backup
$latestBackup = $sortedFiles | Select-Object -First 1

Write-Log "Latest backup identified: $($latestBackup.Name)"

# Delete all older backups
$oldBackups = $sortedFiles | Select-Object -Skip 1

foreach ($file in $oldBackups) {

    try {

        Remove-Item -Path $file.FullName -Force -ErrorAction Stop

        Write-Log "SUCCESS - Deleted old backup: $($file.Name)"

    }
    catch {

        Write-Log "ERROR - Failed to delete $($file.Name). $($_.Exception.Message)"
    }
}

Write-Log "Latest backup retained: $($latestBackup.Name)"
Write-Log "Retention cleanup process completed."