# Enterprise IT Support Simulation Lab

A portfolio-grade simulation of day-to-day L1/L2 enterprise support work across Windows, Microsoft 365, Entra ID, Intune, networking, printing, security, and identity.

## What this demonstrates

- Structured troubleshooting and evidence collection
- Clear escalation decisions
- Customer communication
- Root-cause analysis
- PowerShell automation
- Incident documentation
- Preventive recommendations

## Simulated environment

- 150 users across three offices
- Windows 11 endpoints
- Active Directory and Microsoft Entra ID
- Microsoft 365 and OneDrive
- Intune-managed devices
- Defender for Endpoint
- File, print, VPN, and Wi-Fi services

## Included scenarios

1. Microsoft 365 sign-in failure
2. OneDrive synchronization failure
3. Intune non-compliant device
4. Network printer unavailable
5. Windows Update failure
6. Repeated account lockout
7. Intermittent internet connectivity
8. BitLocker recovery prompt
9. Teams microphone unavailable
10. Group Policy not applying
11. Domain trust relationship failure
12. Suspicious sign-in report

## Run the case generator

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Enterprise_IT_Support_Simulation_Lab.ps1
```

The generator creates a timestamped case folder containing a ticket brief, technician worksheet, evidence checklist, escalation summary, and customer update template.

## Repository structure

```text
Enterprise_IT_Support_Simulation_Lab.ps1
scenarios/
docs/
templates/
sample-reports/
```

## Safety

This project is a simulation and documentation lab. It does not modify production systems or connect to live tenants.
