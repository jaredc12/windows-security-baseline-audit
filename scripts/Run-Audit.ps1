# Run-Audit.ps1
# Main script to run all security audits and generate report

param(
    [string]$OutputPath = ".\AuditReport.csv"
)

# Import audit functions
. .\Audit-Defender.ps1
. .\Audit-Firewall.ps1
. .\Audit-UAC.ps1
. .\Audit-PasswordPolicy.ps1
. .\Audit-AuditPolicy.ps1
. .\Audit-Services.ps1
. .\Audit-Registry.ps1

function Run-AllAudits {
    $results = @()

    Write-Output "Starting Windows Security Baseline Audit..."

    # Defender
    Write-Output "Auditing Windows Defender..."
    $defender = Get-DefenderStatus
    if ($defender) {
        $results += $defender.GetEnumerator() | ForEach-Object { [PSCustomObject]@{ Category = "Defender"; Setting = $_.Key; Value = $_.Value } }
    }

    # Firewall
    Write-Output "Auditing Firewall..."
    $firewall = Get-FirewallStatus
    if ($firewall) {
        $results += $firewall.GetEnumerator() | ForEach-Object { [PSCustomObject]@{ Category = "Firewall"; Setting = $_.Key; Value = $_.Value } }
    }

    # UAC
    Write-Output "Auditing UAC..."
    $uac = Get-UACStatus
    if ($uac) {
        $results += $uac.GetEnumerator() | ForEach-Object { [PSCustomObject]@{ Category = "UAC"; Setting = $_.Key; Value = $_.Value } }
    }

    # Password Policy
    Write-Output "Auditing Password Policy..."
    $password = Get-PasswordPolicy
    if ($password) {
        $results += $password.GetEnumerator() | ForEach-Object { [PSCustomObject]@{ Category = "PasswordPolicy"; Setting = $_.Key; Value = $_.Value } }
    }

    # Audit Policy
    Write-Output "Auditing Audit Policy..."
    $audit = Get-AuditPolicy
    if ($audit) {
        $results += $audit | ForEach-Object { [PSCustomObject]@{ Category = "AuditPolicy"; Setting = $_.Category; Value = $_.Setting } }
    }

    # Services
    Write-Output "Auditing Services..."
    $services = Get-ServiceStatus
    if ($services) {
        $results += $services.GetEnumerator() | ForEach-Object { [PSCustomObject]@{ Category = "Services"; Setting = $_.Key; Value = $_.Value } }
    }

    # Registry
    Write-Output "Auditing Registry..."
    $registry = Get-RegistryChecks
    if ($registry) {
        $results += $registry.GetEnumerator() | ForEach-Object { [PSCustomObject]@{ Category = "Registry"; Setting = $_.Key; Value = $_.Value } }
    }

    Write-Output "Audit complete. Generating report..."

    # Export to CSV
    $results | Export-Csv -Path $OutputPath -NoTypeInformation

    Write-Output "Report saved to $OutputPath"

    # Display summary
    Write-Output "Summary of findings:"
    $results | Group-Object Category | ForEach-Object {
        Write-Output "$($_.Name): $($_.Count) settings checked"
    }
}

# Run the audit
Run-AllAudits