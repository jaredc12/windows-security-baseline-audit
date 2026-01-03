# Audit-PasswordPolicy.ps1
# Audits Password policies

function Get-PasswordPolicy {
    try {
        $policy = Get-ADDefaultDomainPasswordPolicy -ErrorAction Stop
        $status = @{
            "MinPasswordLength" = $policy.MinPasswordLength
            "PasswordHistoryCount" = $policy.PasswordHistoryCount
            "MaxPasswordAge" = $policy.MaxPasswordAge
            "MinPasswordAge" = $policy.MinPasswordAge
            "LockoutThreshold" = $policy.LockoutThreshold
            "LockoutDuration" = $policy.LockoutDuration
            "LockoutObservationWindow" = $policy.LockoutObservationWindow
        }
        return $status
    } catch {
        # For non-domain systems, try local policy
        try {
            $localPolicy = net accounts
            $status = @{
                "MinPasswordLength" = ($localPolicy | Select-String "Minimum password length:").ToString().Split(":")[1].Trim()
                "PasswordHistoryCount" = ($localPolicy | Select-String "Length of password history maintained:").ToString().Split(":")[1].Trim()
                "MaxPasswordAge" = ($localPolicy | Select-String "Maximum password age").ToString().Split(":")[1].Trim()
                "MinPasswordAge" = ($localPolicy | Select-String "Minimum password age").ToString().Split(":")[1].Trim()
                "LockoutThreshold" = ($localPolicy | Select-String "Lockout threshold:").ToString().Split(":")[1].Trim()
                "LockoutDuration" = ($localPolicy | Select-String "Lockout duration").ToString().Split(":")[1].Trim()
                "LockoutObservationWindow" = ($localPolicy | Select-String "Lockout observation window").ToString().Split(":")[1].Trim()
            }
            return $status
        } catch {
            Write-Warning "Error retrieving Password Policy: $_"
            return $null
        }
    }
}

# For testing or standalone run
if ($MyInvocation.InvocationName -ne '.') {
    $result = Get-PasswordPolicy
    if ($result) {
        Write-Output "Password Policy Audit Results:"
        $result.GetEnumerator() | ForEach-Object {
            Write-Output "$($_.Key): $($_.Value)"
        }
    }
}