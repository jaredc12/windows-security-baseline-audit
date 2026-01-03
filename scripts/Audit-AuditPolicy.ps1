# Audit-AuditPolicy.ps1
# Audits Audit policies

function Get-AuditPolicy {
    try {
        $auditPolicies = auditpol /get /category:* | Select-String -Pattern "^\s*(.+?)\s+(.+)$" | ForEach-Object {
            $parts = $_.Matches[0].Groups
            @{
                "Category" = $parts[1].Value.Trim()
                "Setting" = $parts[2].Value.Trim()
            }
        }
        return $auditPolicies
    } catch {
        Write-Warning "Error retrieving Audit Policy: $_"
        return $null
    }
}

# For testing or standalone run
if ($MyInvocation.InvocationName -ne '.') {
    $result = Get-AuditPolicy
    if ($result) {
        Write-Output "Audit Policy Audit Results:"
        $result | ForEach-Object {
            Write-Output "$($_.Category): $($_.Setting)"
        }
    }
}