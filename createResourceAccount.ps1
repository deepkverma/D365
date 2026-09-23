
# Prompt the user for input
$UserPrincipalName = Read-Host -Prompt "Enter the New Teams Resource Account email address"
$DisplayName = Read-Host -Prompt "Enter the New Teams Resource Account Name, ex: D365 Sales Resource Account"
$AppId = Read-Host -Prompt "Enter the Dynamics App ID from the phone number setting page"
$AcsResourceId = Read-Host -Prompt "Enter the Organization's ACS immutable resource ID from the Dynamics Phone Number Setting Page"

# Create a new Teams resource account and capture the output
try {
    $teamsResourceAccount = New-CsOnlineApplicationInstance -UserPrincipalName $UserPrincipalName -DisplayName $DisplayName -ApplicationID $AppId
    Write-Host "Created new Teams resource account successfully." -ForegroundColor Green
    Write-Host "Output: $teamsResourceAccount" -ForegroundColor Green
} catch {
    Write-Host "Failed to create new Teams resource account: $_" -ForegroundColor Red
    exit
}

# Extract the Teams Resource Account object ID from the output
$TeamsResourceAccountId = $teamsResourceAccount.ObjectId

# Print the Teams Resource Account object ID
Write-Host "Teams Resource Account Object ID: $TeamsResourceAccountId" -ForegroundColor Yellow

# Sleep before trying next steps
$retryCount = 5
$retryDelay = 30 # seconds
$success = $false
Write-Host "Sleep before proceeding: $retryDelay seconds, do not exit or do anything"
Start-Sleep -Seconds $retryDelay


# Set the application instance with the provided ACS resource ID
try {
    $setAppInstanceOutput = Set-CsOnlineApplicationInstance -Identity $TeamsResourceAccountId -ApplicationId $AppId -AcsResourceId $AcsResourceId
    Write-Host "Set application instance successfully." -ForegroundColor Green
    Write-Host "Output: $setAppInstanceOutput" -ForegroundColor Green
} catch {
    Write-Host "Failed to set application instance: $_" -ForegroundColor Red
    exit
}

# Sync the application instance
try {
    $syncAppInstanceOutput = Sync-CsOnlineApplicationInstance -ObjectId $TeamsResourceAccountId -ApplicationId $AppId -AcsResourceId $AcsResourceId
    Write-Host "Synced application instance successfully." -ForegroundColor Green
    Write-Host "Output: $syncAppInstanceOutput" -ForegroundColor Green
    Write-Host "Teams Resource Account setup completed successfully." -ForegroundColor Green
} catch {
    Write-Host "Failed to sync application instance: $_" -ForegroundColor Red
    exit
}