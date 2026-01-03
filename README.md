# Windows Security Baseline Audit

An entry-level cybersecurity tool for auditing Windows systems against security baselines. This project provides PowerShell scripts to check common security settings and generate reports on findings.

## Features

- **Windows Defender Audit**: Checks antivirus, antispyware, and real-time protection status.
- **Firewall Audit**: Verifies firewall profiles and default actions.
- **User Account Control (UAC) Audit**: Examines UAC settings for privilege escalation protection.
- **Password Policy Audit**: Reviews password complexity and lockout policies.
- **Audit Policy Audit**: Inspects system audit settings.
- **Service Status Audit**: Checks critical services like Remote Desktop and SMB.
- **Registry Security Checks**: Scans registry for security-related settings.
- **Automated Reporting**: Generates CSV reports of all audit findings.

## Prerequisites

- Windows 10/11 or Windows Server
- PowerShell 5.1 or higher
- Administrative privileges (for some checks)

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/windows-security-baseline-audit.git
   cd windows-security-baseline-audit
   ```

2. Ensure PowerShell execution policy allows script running:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

## Usage

### Run Full Audit

To perform a complete security audit and generate a report:

```powershell
.\scripts\Run-Audit.ps1
```

This will:
- Run all individual audits
- Display progress in the console
- Generate `AuditReport.csv` with all findings
- Show a summary of checked settings

### Run Individual Audits

You can run specific audits individually:

```powershell
.\scripts\Audit-Defender.ps1
.\scripts\Audit-Firewall.ps1
.\scripts\Audit-UAC.ps1
.\scripts\Audit-PasswordPolicy.ps1
.\scripts\Audit-AuditPolicy.ps1
.\scripts\Audit-Services.ps1
.\scripts\Audit-Registry.ps1
```

### Custom Output Location

Specify a custom path for the report:

```powershell
.\scripts\Run-Audit.ps1 -OutputPath "C:\Reports\MyAudit.csv"
```

## Output

The audit generates a CSV file with columns:
- **Category**: The type of security check (e.g., Defender, Firewall)
- **Setting**: The specific setting audited
- **Value**: The current value or status

Example output:
```
Category,Setting,Value
Defender,AntivirusEnabled,True
Firewall,DomainEnabled,True
UAC,EnableLUA,1
```

## Security Considerations

- This tool only reads system settings and does not modify them.
- Some checks require administrative privileges.
- Always review the generated report and consult security best practices.
- For domain environments, ensure you have appropriate permissions.

## Contributing

We welcome contributions! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-audit-check`
3. Make your changes and test thoroughly
4. Ensure scripts handle errors gracefully
5. Update documentation as needed
6. Submit a pull request

### Adding New Audits

When adding new audit functions:
- Create a new `Audit-*.ps1` file in the `scripts/` directory
- Follow the naming convention: `Get-*Status` or `Get-*Checks`
- Include error handling with try-catch blocks
- Return hashtables or custom objects for results
- Update `Run-Audit.ps1` to include the new audit
- Test on multiple Windows versions if possible

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

This tool is provided for educational and informational purposes. It is not a substitute for professional security auditing or compliance tools. Always verify results and consult with security experts for critical systems.
