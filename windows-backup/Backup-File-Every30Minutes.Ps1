$sourceFile = "C:\Users\antov\Workspace\DevOps\Ex1 Backup & Deletion\Source\File1.txt"
$backupFolder = "C:\Users\antov\Workspace\DevOps\Ex1 Backup & Deletion\Backup"
$logFolder = "C:\Users\antov\Workspace\DevOps\Ex1 Backup & Deletion\Logs"
$logFile = Join-Path $logFolder "Backup-Log.txt"

# Create required folders if they don't exist
if (!(Test-Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder | Out-Null
}

if (!(Test-Path $logFolder)) {
    New-Item -ItemType Directory -Path $logFolder | Out-Null
}

# Function to write to log
function Write-Log {
    param (
        [string]$Message
    )

    $timestamp = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
    $logMessage = "$timestamp - $Message"

    Add-Content -Path $logFile -Value $logMessage
    Write-Host $logMessage
}

Write-Log "Backup process started."

# Check if source file exists
if (!(Test-Path $sourceFile)) {

    Write-Log "ERROR - File1.txt was not found at: $sourceFile"
    Write-Log "Backup process stopped."

    exit
}

Write-Log "Source file found: $sourceFile"

# Run backup process for 5 hours
$endTime = (Get-Date).AddHours(5)

while ((Get-Date) -lt $endTime) {

    # Check that the source file still exists
    if (!(Test-Path $sourceFile)) {

        Write-Log "ERROR - File1.txt is no longer available."
        Write-Log "Backup process stopped."

        exit
    }

    try {

        $timestamp = Get-Date -Format "ddMMyyyyHHmmss"

        $destinationFile = Join-Path `
            $backupFolder `
            "File1-$timestamp.txt"

        Copy-Item `
            -Path $sourceFile `
            -Destination $destinationFile `
            -ErrorAction Stop

        Write-Log "SUCCESS - Backup created: $destinationFile"

    }
    catch {

        Write-Log "ERROR - Backup failed. $($_.Exception.Message)"
    }

    # Wait 30 minutes
    Start-Sleep -Seconds 1800
}

Write-Log "Backup process completed after 5 hours."