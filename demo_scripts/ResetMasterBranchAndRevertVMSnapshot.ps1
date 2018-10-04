param([string]$RepoPath = 'C:\dev\ws\chocofest')


& "$PSScriptRoot\Reset-DemoGitRepo.ps1" -RepoPath $RepoPath

& "$PSScriptRoot\Reset-DemoVms.ps1" -VmxPath 'C:\Users\Mark Johnson\OneDrive\Documents2\Virtual Machines\s16-prod\s16-prod.vmx' -SnapShotName 'Inedo Agent Installed'

& "$PSScriptRoot\Prepare-OtterServerForDemo.ps1" 