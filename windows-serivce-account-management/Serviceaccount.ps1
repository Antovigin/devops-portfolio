Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
# Service Account Setup

$Username = "svcAccount"
$Password = "password-permenant"

Write-Host "Creating/configuring service account..." -ForegroundColor Cyan

# Create account if it doesn't exist
$user = Get-CimInstance Win32_UserAccount -Filter "Name='$Username' AND LocalAccount=True"

if (-not $user) {
    net user $Username $Password /add /fullname:"Service Account" /comment:"Local service account"
}

# Configure account
net user $Username $Password
net user $Username /expires:never
net user $Username /passwordchg:no
net user $Username /active:yes

# Set password to never expire
$wmic = "$env:windir\System32\wbem\wmic.exe"

if (Test-Path $wmic) {
    & $wmic UserAccount Where "Name='$Username' and LocalAccount=True" Set PasswordExpires=False
}

# Get SID
$SID = (Get-CimInstance Win32_UserAccount `
    -Filter "Name='$Username' AND LocalAccount=True").SID

Write-Host "SID: $SID" -ForegroundColor Green

# Grant Log on as a service
$Temp = "$env:TEMP\service-policy.inf"

secedit /export /cfg $Temp /quiet

$Policy = Get-Content $Temp

$Line = $Policy | Where-Object { $_ -like "SeServiceLogonRight*" }

if ($Line -and $Line -notmatch [regex]::Escape($SID)) {
    $Policy = $Policy -replace `
        [regex]::Escape($Line), `
        "SeServiceLogonRight = $($Line -replace '^SeServiceLogonRight\s*=\s*',''),*$SID"

    Set-Content $Temp $Policy -Encoding Unicode
}
elseif (-not $Line) {
    Add-Content $Temp "SeServiceLogonRight = *$SID"
}

secedit /configure /db "$env:TEMP\service.sdb" /cfg $Temp /areas USER_RIGHTS /quiet

gpupdate /force | Out-Null

# Verification
Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host " Service Account Created Successfully"
Write-Host "=========================================="
Write-Host ""
Write-Host "Username              : .\$Username"
Write-Host "Password              : $Password"
Write-Host "SID                   : $SID"
Write-Host "Account enabled       : YES"
Write-Host "Account never expires : YES"
Write-Host "Password never expires: YES"
Write-Host "Password change       : NO"
Write-Host "Log on as a service   : GRANTED"
Write-Host ""