# ==========================================
# Create 5 Local Users
# ==========================================

$Password = "password-permenant"

$RDPUsers = @(
    "user1",
    "user2",
    "user3",
    "user4"
)

$AdminUser = "adminUser"

# ------------------------------------------
# Create RDP Users
# ------------------------------------------

foreach ($Username in $RDPUsers) {

    Write-Host "Creating $Username..." -ForegroundColor Cyan

    $Exists = Get-CimInstance Win32_UserAccount `
        -Filter "Name='$Username' AND LocalAccount=True"

    if (-not $Exists) {
        net user $Username $Password /add
    }

    # Password never expires
    net user $Username /expires:never

    # User cannot change password
    net user $Username /passwordchg:no

    # Enable account
    net user $Username /active:yes

    # Add to Remote Desktop Users
    net localgroup "Remote Desktop Users" $Username /add

    Write-Host "$Username configured." -ForegroundColor Green
}

# ------------------------------------------
# Create Administrator User
# ------------------------------------------

Write-Host ""
Write-Host "Creating $AdminUser..." -ForegroundColor Cyan

$Exists = Get-CimInstance Win32_UserAccount `
    -Filter "Name='$AdminUser' AND LocalAccount=True"

if (-not $Exists) {
    net user $AdminUser $Password /add
}

# Password never expires
net user $AdminUser /expires:never

# Admin user CAN change its own password
net user $AdminUser /passwordchg:yes

# Enable account
net user $AdminUser /active:yes

# Add to Administrators group
net localgroup Administrators $AdminUser /add

Write-Host "$AdminUser configured as Administrator." -ForegroundColor Green

# ------------------------------------------
# Display Results
# ------------------------------------------

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host " User Setup Completed"
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

Write-Host "RDP Users:" -ForegroundColor Cyan
$RDPUsers | ForEach-Object {
    Write-Host "  $_"
}

Write-Host ""
Write-Host "Administrator:"
Write-Host "  $AdminUser"

Write-Host ""
Write-Host "Password:"
Write-Host "  $Password"

Write-Host ""
Write-Host "All accounts:"
Write-Host "  - Password never expires"
Write-Host "  - RDP users cannot change their passwords"
Write-Host "  - adminUser can change passwords"
Write-Host ""