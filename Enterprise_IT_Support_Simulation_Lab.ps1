#requires -Version 5.1
[CmdletBinding()]
param(
    [string]$ScenarioId,
    [string]$OutputPath
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$scenarioFile = Join-Path $root 'scenarios/scenario-catalog.csv'

if (-not (Test-Path $scenarioFile)) {
    throw "Scenario catalog not found: $scenarioFile"
}

$scenarios = Import-Csv $scenarioFile

if ([string]::IsNullOrWhiteSpace($ScenarioId)) {
    Write-Host 'Available enterprise support scenarios' -ForegroundColor Cyan
    $scenarios | Select-Object Id,Title,Category,Priority | Format-Table -AutoSize
    $ScenarioId = Read-Host 'Enter scenario ID'
}

$scenario = $scenarios | Where-Object Id -eq $ScenarioId | Select-Object -First 1
if (-not $scenario) {
    throw "Unknown scenario ID: $ScenarioId"
}

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $OutputPath = Join-Path ([Environment]::GetFolderPath('Desktop')) 'Enterprise_IT_Support_Cases'
}

$caseId = 'CASE-{0}-{1}' -f (Get-Date -Format 'yyyyMMdd-HHmmss'), $scenario.Id
$casePath = Join-Path $OutputPath $caseId
New-Item -Path $casePath -ItemType Directory -Force | Out-Null

$brief = @"
# Support Case Brief

**Case ID:** $caseId  
**Scenario:** $($scenario.Title)  
**Category:** $($scenario.Category)  
**Priority:** $($scenario.Priority)  
**Affected service:** $($scenario.Service)  

## User report

$($scenario.UserReport)

## Business impact

$($scenario.BusinessImpact)

## Initial clues

$($scenario.InitialClues)

## Goal

Investigate the symptom, preserve useful evidence, identify the most likely root cause, resolve safely, and document escalation criteria.
"@

$worksheet = @"
# Technician Worksheet

## 1. Clarifying questions

- When did the issue start?
- Is one user, one device, or multiple users affected?
- What changed before the issue started?
- Can the issue be reproduced?
- What is the business impact?

## 2. Initial hypothesis

Record the most likely cause and at least two alternatives.

## 3. Evidence collected

| Time | Evidence | Result | Interpretation |
|---|---|---|---|
| | | | |

## 4. Troubleshooting actions

| Step | Action | Expected result | Actual result |
|---|---|---|---|
| 1 | | | |

## 5. Root cause

Document the confirmed or most likely root cause and supporting evidence.

## 6. Resolution

Document the fix, validation steps, and user confirmation.

## 7. Prevention

Record monitoring, configuration, training, or process improvements.
"@

$evidence = @"
# Evidence Checklist

- [ ] User and device identifiers recorded
- [ ] Exact error message captured
- [ ] Date and time confirmed
- [ ] Scope of impact confirmed
- [ ] Relevant Windows event logs reviewed
- [ ] Network and DNS state recorded where applicable
- [ ] Account, licence, compliance, or policy state reviewed
- [ ] Before-and-after evidence retained
- [ ] Sensitive information removed from shared reports
"@

$escalation = @"
# Escalation Summary

**Case ID:** $caseId

## Escalate when

$($scenario.EscalationCriteria)

## Information to include

- User and device affected
- Business impact and priority
- Exact error and timestamps
- Troubleshooting already completed
- Evidence files and relevant logs
- Workaround status
- Requested action from the next support tier
"@

$customer = @"
Subject: Update on support case $caseId

Hi,

We have investigated the reported issue affecting $($scenario.Service).

Current status:
- Impact: $($scenario.BusinessImpact)
- Investigation: [summarize completed checks]
- Outcome: [resolved / workaround applied / escalated]
- Next step: [state the next action and expected timing]

Please confirm whether the service is now working as expected.

Regards,
IT Support
"@

$brief | Set-Content (Join-Path $casePath '01-case-brief.md') -Encoding UTF8
$worksheet | Set-Content (Join-Path $casePath '02-technician-worksheet.md') -Encoding UTF8
$evidence | Set-Content (Join-Path $casePath '03-evidence-checklist.md') -Encoding UTF8
$escalation | Set-Content (Join-Path $casePath '04-escalation-summary.md') -Encoding UTF8
$customer | Set-Content (Join-Path $casePath '05-customer-update.txt') -Encoding UTF8

$scenario | ConvertTo-Json -Depth 4 | Set-Content (Join-Path $casePath 'scenario.json') -Encoding UTF8

Write-Host "Case created: $casePath" -ForegroundColor Green
