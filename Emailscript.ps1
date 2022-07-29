# Get the credential
$credential = Get-Credential

## Define the Send-MailMessage parameters
$mailParams = @{
    SmtpServer                 = 'smtp-mail.outlook.com'
    Port                       = '587' # or '25' if not using TLS
    UseSSL                     = $true ## or not if using non-TLS
    Credential                 = $credential
    From                       = 'sample123@outlook.com'
    To                         = 'YourEmail@gmail.com', 'YourEmail@gmail.com'
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
    From                       = 'sample123@outlook.com'
    To                         = 'YourEmail@gmail.com', 'YourEmail@gmail.com'
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
    From                       = 'sample123@outlook.com'
    To                         = 'YourEmail@gmail.com', 'YourEmail@gmail.com'
    Subject                    = "ALERT3"
    Body                       = 'A file has been deleted!!!'
    DeliveryNotificationOption = 'OnFailure', 'OnSuccess'
}

## Send the message
Send-MailMessage @mailParams2

