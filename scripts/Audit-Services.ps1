# Audit-Services.ps1
# Audits critical service statuses

function Get-ServiceStatus {
    try {
        $services = @("TermService", "LanmanServer")  # Remote Desktop, SMB
        $status = @{}
        foreach ($service in $services) {
            $svc = Get-Service -Name $service -ErrorAction Stop
            $status["${service}Status"] = $svc.Status
            $status["${service}StartType"] = $svc.StartType
        }
        return $status
    } catch {
        Write-Warning "Error retrieving Service status: $_"
        return $null
    }
}

# For testing or standalone run
if ($MyInvocation.InvocationName -ne '.') {
    $result = Get-ServiceStatus
    if ($result) {
        Write-Output "Service Status Audit Results:"
        $result.GetEnumerator() | ForEach-Object {
            Write-Output "$($_.Key): $($_.Value)"
        }
    }
}