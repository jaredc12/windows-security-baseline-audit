# Audit-Registry.ps1
# Audits registry settings for security

function Get-RegistryChecks {
    try {
        $checks = @{}
        # Example checks
        $checks["DisableTaskMgr"] = (Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableTaskMgr" -ErrorAction SilentlyContinue).DisableTaskMgr
        $checks["NoControlPanel"] = (Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoControlPanel" -ErrorAction SilentlyContinue).NoControlPanel
        $checks["DisableRegistryTools"] = (Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableRegistryTools" -ErrorAction SilentlyContinue).DisableRegistryTools
        # Add more as needed
        return $checks
    } catch {
        Write-Warning "Error retrieving Registry checks: $_"
        return $null
    }
}

# For testing or standalone run
if ($MyInvocation.InvocationName -ne '.') {
    $result = Get-RegistryChecks
    if ($result) {
        Write-Output "Registry Security Audit Results:"
        $result.GetEnumerator() | ForEach-Object {
            Write-Output "$($_.Key): $($_.Value)"
        }
    }
}