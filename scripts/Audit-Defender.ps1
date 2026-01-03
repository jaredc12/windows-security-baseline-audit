# Audit-Defender.ps1
# Audits Windows Defender status

function Get-DefenderStatus {
    try {
        $defender = Get-MpComputerStatus
        $status = @{
            "AntivirusEnabled" = $defender.AntivirusEnabled
            "AntispywareEnabled" = $defender.AntispywareEnabled
            "BehaviorMonitorEnabled" = $defender.BehaviorMonitorEnabled
            "IoavProtectionEnabled" = $defender.IoavProtectionEnabled
            "OnAccessProtectionEnabled" = $defender.OnAccessProtectionEnabled
            "RealTimeProtectionEnabled" = $defender.RealTimeProtectionEnabled
            "LastFullScan" = $defender.LastFullScanEndTime
            "LastQuickScan" = $defender.LastQuickScanEndTime
        }
        return $status
    } catch {
        Write-Warning "Error retrieving Defender status: $_"
        return $null
    }
}

# For testing or standalone run
if ($MyInvocation.InvocationName -ne '.') {
    $result = Get-DefenderStatus
    if ($result) {
        Write-Output "Windows Defender Audit Results:"
        $result.GetEnumerator() | ForEach-Object {
            Write-Output "$($_.Key): $($_.Value)"
        }
    }
}