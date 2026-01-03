# Audit-UAC.ps1
# Audits User Account Control settings

function Get-UACStatus {
    try {
        $uacSettings = @{}
        $uacSettings["EnableLUA"] = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -ErrorAction Stop).EnableLUA
        $uacSettings["ConsentPromptBehaviorAdmin"] = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -ErrorAction Stop).ConsentPromptBehaviorAdmin
        $uacSettings["PromptOnSecureDesktop"] = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -ErrorAction Stop).PromptOnSecureDesktop
        return $uacSettings
    } catch {
        Write-Warning "Error retrieving UAC status: $_"
        return $null
    }
}

# For testing or standalone run
if ($MyInvocation.InvocationName -ne '.') {
    $result = Get-UACStatus
    if ($result) {
        Write-Output "User Account Control Audit Results:"
        $result.GetEnumerator() | ForEach-Object {
            Write-Output "$($_.Key): $($_.Value)"
        }
    }
}