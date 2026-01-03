# Audit-Firewall.ps1
# Audits Windows Firewall settings

function Get-FirewallStatus {
    try {
        $profiles = Get-NetFirewallProfile
        $status = @{}
        foreach ($profile in $profiles) {
            $profileName = $profile.Name
            $status["${profileName}Enabled"] = $profile.Enabled
            $status["${profileName}DefaultInboundAction"] = $profile.DefaultInboundAction
            $status["${profileName}DefaultOutboundAction"] = $profile.DefaultOutboundAction
        }
        return $status
    } catch {
        Write-Warning "Error retrieving Firewall status: $_"
        return $null
    }
}

# For testing or standalone run
if ($MyInvocation.InvocationName -ne '.') {
    $result = Get-FirewallStatus
    if ($result) {
        Write-Output "Windows Firewall Audit Results:"
        $result.GetEnumerator() | ForEach-Object {
            Write-Output "$($_.Key): $($_.Value)"
        }
    }
}