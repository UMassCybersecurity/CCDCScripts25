# Script to change all local user passwords, excluding Admin

# Function to generate a random password
Function Get-RandomPassword {
    # Define parameter with password length
    param([int]$PasswordLength = 20)

    # Store combinations in a set
    $CharacterSet = @{
            Lowercase   = (97..122) | Get-Random -Count 10 | % {[char]$_}
            Uppercase   = (65..90)  | Get-Random -Count 10 | % {[char]$_}
            Numeric     = (48..57)  | Get-Random -Count 10 | % {[char]$_}
            SpecialChar = (33..47)+(58..64)+(91..96)+(123..126) | Get-Random -Count 10 | % {[char]$_}
    }

    # Frame random password
    $StringSet = $CharacterSet.Lowercase + $CharacterSet.Uppercase + $CharacterSet.Numeric + $CharacterSet.SpecialChar
    -join(Get-Random -Count $PasswordLength -InputObject $StringSet)
  

}

# Need to change path and "Admin" if username for admin is different
$users = Get-LocalUser | Where-Object {$_.Name -notlike "Administrator"}
# $users = Get-LocalUser

# Query and change password for each user
foreach ($user in $users) {
   $username = $user.Name
   $plainPassword = Get-RandomPassword
   $newPassword = ConvertTo-SecureString $plainPassword -AsPlainText -Force
   Write-Output("Username: $username, New Password: $plainPassword")
   Set-LocalUser -Name $username -Password $newPassword
   
} 
Write-Output("Done")
