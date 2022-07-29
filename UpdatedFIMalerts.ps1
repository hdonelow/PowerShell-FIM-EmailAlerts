﻿
Write-Host ""
Write-Host "what would you like to do?"
Write-Host ""
Write-Host "    A) Collect new Baseline?"
Write-Host "    B) Begin monitoring files with saved Baseline?"
Write-Host ""

$response = Read-Host -Prompt "Please enter 'A' or 'B'"
Write-Host ""

Function Calculate-File-Hash($filepath) {
    Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash 
}

Function Erase-Baseline-If-Already-Exists() {
    $baselineExists = Test-Path -Path .\baseline.txt
    
    if ($baselineExists) {
        # Delete it
        Remove-Item -Path .\baseline.txt
    } 
}

if ($response -eq "A".ToUpper()) {
    #Delete baseline.txt if it already exists
     Erase-Baseline-If-Already-Exists
    
    # Calculate Hash from the target files and store in baseline.txt
    # Collect all files in the target foler
    $files = Get-ChildItem -Path .\Files
   
    # For each file, calculate the hash, and write to baseline.txt
    foreach ($f in $files) {
        $hash = Calculate-File-Hash $f.FullName
        "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath ./baseline.txt -Append
    }

}
elseif ($response -eq "B".ToUpper()) {
   
    $fileHashDictionary = @{}
    
    # Load file|hash from baseline.txt and store them in a dictionary
    $filePathsandHashes = Get-Content -Path.\baseline.txt
  
    foreach ($f in $filePathsandHashes) {
         $fileHashDictionary.Add($f.Split("|")[0],$f.Split("|")[1])     
    }
    
     # Begin (continuously) monitorig files with saved Baseline
     while ($true) {
         Start-Sleep -Seconds 5

         $files = Get-ChildItem -Path .\Files
   
    # For each file, calculate the hash, and write to baseline.txt
    foreach ($f in $files) {
        $hash = Calculate-File-Hash $f.FullName
        #"$($hash.Path)|$($hash.Hash)" | Out-File -FilePath ./baseline.txt -Append

         # Notify if a new file has been created
         if ($fileHashDictionary[$hash.Path] -eq $null) {
             # A new file has been created!
             Write-Host "$($hash.Path) has been created!" -ForegroundColor Green
         }

         if ($fileHashDictionary[$hash.Path] -eq $null) {
             # ALERT! new file has been created!
            Send-MailMessage @mailParams1
         }
         else {

         # Notify if a new file has been changed
         if ($fileHashDictionary[$hash.Path] -eq $hash.Hash) {
            # The file has not changed
         }

         # Alert a new file has been changed
         if ($fileHashDictionary[$hash.Path] -eq $hash.Hash) {
            Send-MailMessage @mailParams
         }
         else {
             # File file has been compromised!, notify the user
             Write-Host "$($hash.Path) has changed!!!" -ForegroundColor Red
    }
         }

         

         
       
    
     }

     foreach ($key in $fileHashDictionary.Keys) {
             $baselineFileStillExists = Test-Path -Path $key
             if (-Not $baselineFileStillExists) {
                 # One of the baseline files must have been deleted, notify the user
                 Write-Host "$($key) has been deleted!" -ForegroundColor DarkRed -BackgroundColor Gray

             }

        }
        foreach ($key in $fileHashDictionary.Keys) {
             $baselineFileStillExists = Test-Path -Path $key
             if (-Not $baselineFileStillExists) {
                 # One of the baseline files must have been deleted, notify the user
                 Send-MailMessage @mailParams2

             }

        }
}






}

# Get the credential
$credential = Get-Credential

## Define the Send-MailMessage parameters
$mailParams = @{
    SmtpServer                 = 'smtp-mail.outlook.com'
    Port                       = '587' # or '25' if not using TLS
    UseSSL                     = $true ## or not if using non-TLS
    Credential                 = $credential
    From                       = 'hdonelowps@outlook.com'
    To                         = 'hdonelowpsalerts@gmail.com', 'hdonelowpsalerts@gmail.com'
    Subject                    = "ALERT1"
    Body                       = 'A file has been edited!!!'
    DeliveryNotificationOption = 'OnFailure', 'OnSuccess'
}

## Send the message
Send-MailMessage @mailParams

$mailParams1 = @{
    SmtpServer                 = 'smtp-mail.outlook.com'
    Port                       = '587' # or '25' if not using TLS
    UseSSL                     = $true ## or not if using non-TLS
    Credential                 = $credential
    From                       = 'hdonelowps@outlook.com'
    To                         = 'hdonelowpsalerts@gmail.com', 'hdonelowpsalerts@gmail.com'
    Subject                    = "ALERT2"
    Body                       = 'A file has been created!!!'
    DeliveryNotificationOption = 'OnFailure', 'OnSuccess'
}

## Send the message
Send-MailMessage @mailParams1

$mailParams2 = @{
    SmtpServer                 = 'smtp-mail.outlook.com'
    Port                       = '587' # or '25' if not using TLS
    UseSSL                     = $true ## or not if using non-TLS
    Credential                 = $credential
    From                       = 'hdonelowps@outlook.com'
    To                         = 'hdonelowpsalerts@gmail.com', 'hdonelowpsalerts@gmail.com'
    Subject                    = "ALERT3"
    Body                       = 'A file has been deleted!!!'
    DeliveryNotificationOption = 'OnFailure', 'OnSuccess'
}

## Send the message
Send-MailMessage @mailParams2

