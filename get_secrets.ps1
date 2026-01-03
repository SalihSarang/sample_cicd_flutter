$keystorePath = "android\app\upload-keystore.jks"
$keyPropsPath = "android\key.properties"

Write-Host "`n=== 1. KEYSTORE_BASE64 ===" -ForegroundColor Cyan
if (Test-Path $keystorePath) {
    $bytes = [System.IO.File]::ReadAllBytes($keystorePath)
    $b64 = [System.Convert]::ToBase64String($bytes)
    Write-Host "Copy the string below (it is very long):" -ForegroundColor Yellow
    Write-Host $b64
} else {
    Write-Host "Error: Could not find $keystorePath" -ForegroundColor Red
}

Write-Host "`n=== 2. KEY_PROPERTIES ===" -ForegroundColor Cyan
if (Test-Path $keyPropsPath) {
    $props = Get-Content $keyPropsPath -Raw
    Write-Host "Copy the content below:" -ForegroundColor Yellow
    Write-Host $props
} else {
    Write-Host "Error: Could not find $keyPropsPath" -ForegroundColor Red
}

Write-Host "`n=== 3. PLAY_STORE_CREDENTIALS ===" -ForegroundColor Cyan
Write-Host "You must generate this manually from the Google Cloud Console." -ForegroundColor Yellow
Write-Host "Steps:"
Write-Host "1. Go to Google Cloud Console (https://console.cloud.google.com/)"
Write-Host "2. Select your project."
Write-Host "3. Go to IAM & Admin > Service Accounts."
Write-Host "4. Create a Service Account (name it 'github-actions')."
Write-Host "5. Click on the newly created email -> Keys tab."
Write-Host "6. Add Key -> Create new key -> JSON."
Write-Host "7. Open that JSON file and copy the entire content."
Write-Host "`nThen go to GitHub -> Settings -> Secrets -> Actions -> New Repository Secret to add all three."
