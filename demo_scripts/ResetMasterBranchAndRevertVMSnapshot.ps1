param(
  [string]$RepoPath = 'C:\dev\ws\chocofest',
  [string]$VmxPath = 'C:\Users\Mark Johnson\OneDrive\Documents2\Virtual Machines\s16-prod\s16-prod.vmx', 
  [string]$SnapShotName = 'Inedo Agent Installed'
)

<#
If you accidentally blow away a branch, you can use 

git reflog show remotes/origin/master

to see the previous commit, and then

git reset --hard <COMMIT> to recover

#>
function Reset-Branch {
  param([string]$Branch,
    [string]$Path,
    [string]$Commit
  )
  Write-Host -ForegroundColor Green "Reseting Git brach '$Branch' in repo '$Path' to commit '$Commit' ..."
  Push-Location .
  cd $Path
  git checkout $Branch
  git reset $Commit --hard
  git push --force
  Pop-Location
}

function Squash-AllCommits {
  param([string]$Branch,
    [string]$Path  
  )
  Write-Host -ForegroundColor Green "Squashing all commits in Git brach '$Branch' in repo '$Path' ..."
  
  Push-Location .
  Set-Location $Path
  
  #Squash dev commits to optimize
  git checkout $Branch

  git pull

  $numCommits = (git rev-list --first-parent --count $Branch) - 1

  # Reset the current branch to the commit just before the last 12:
  git reset --hard HEAD~$numCommits

  # HEAD@{1} is where the branch was just before the previous command.
  # This command sets the state of the index to be as it would just
  # after a merge from that commit:
  git merge --squash "HEAD@{1}"

  # Commit those squashed changes.  The commit message will be helpfully
  # prepopulated with the commit messages of all the squashed commits:
  git commit -m "Squashed all commits on branch $Branch"
  git push --force
  Pop-Location
}
function Reset-DemoVms {
  param([string]$VmxPath, 
  [string]$SnapShotName)
  
  Write-Host -ForegroundColor green "Reverting '$VmxPath' to Snapshot '$SnapShotName' ..."
  #restore VM snapshot
  & "C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe" -T ws revertToSnapshot "$VmxPath" "$SnapShotName"
  Write-Host -ForegroundColor green "Starting VM '$VmxPath' ..."
  & "C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe" -T ws start "$VmxPath"

}

function Prepare-OtterServerForDemo {
  Write-Host -ForegroundColor Green "Removing role from prod server"
  Invoke-WebRequest -Uri http://s16-dev:8626/api/infrastructure/servers/update/s16-dev?key=ChocoFest -Method POST -Body '{"roles": ["chocolatey-packages-build"], "raft": "Dev"}'
  Invoke-WebRequest -Uri http://s16-dev:8626/api/infrastructure/servers/update/s16-prod?key=ChocoFest -Method POST -Body '{"roles": [], "drift": "automaticallyRemediate","raftId": "3", "raft": "Prod"}'
  Invoke-WebRequest -Uri http://s16-dev:8626/api/infrastructure/servers/update/s16-test?key=ChocoFest -Method POST -Body '{"roles": ["chocolatey-packages-build"], "drift": "reportOnly","raftId": "4", "raft": "Test"}'

  Invoke-RestMethod -Uri http://s16-dev:8626/api/infrastructure/servers/list?key=ChocoFest


  Invoke-WebRequest -Uri http://s16-dev:8626/0x44/Otter.WebApplication/Inedo.Otter.WebApplication.Pages.Administration.ServiceMonitorPage/StopService
  Start-Sleep 5
  Invoke-WebRequest -Uri http://s16-dev:8626/0x44/Otter.WebApplication/Inedo.Otter.WebApplication.Pages.Administration.ServiceMonitorPage/StartService
  
  Write-Host -ForegroundColor Green "Running server checker ..."
  Invoke-WebRequest -Uri http://s16-dev:8626/0x44/Otter.WebApplication/Inedo.Otter.WebApplication.Pages.Administration.ServiceMonitorPage/RunExecuter?name=Server%20Checker -Method POST -Verbose 

  Write-Host -ForegroundColor Green "Running RoutineConfigurationRunner ..."
  Invoke-WebRequest -Uri http://s16-dev:8626/0x44/Otter.WebApplication/Inedo.Otter.WebApplication.Pages.Administration.ServiceMonitorPage/RunExecuter?name=RoutineConfigurationRunner -Method POST -Verbose
} 


#Reset master to the version with all of the bootstrap modules, but no chocolatey packages OLD: e9a66db194bcbb2bd16faa983a90922070645109 
Reset-Branch -Branch master -Path $RepoPath -Commit f9c494bdcfd726296d40f36341e6aa5267a36d4a  

#Reset dev to the version that does not have powershell-core-internal
#Reset-Branch -Branch dev -Path $RepoPath -Commit 34e737ea89301ec50087c54c46bd7e497370e1f2
<#
#Pre-demo 2 state: 2a300ac918f7bfd55d8c7d793d92932f36bb3f32

#Post-Demo 2 state: 


#>

#Reset to the version with no modules
#Reset-Branch -Branch master -Path $RepoPath -Commit 9a45b7122b0336bae65788be5c24837f658eb0c3

Squash-AllCommits -Branch dev -Path $RepoPath
Squash-AllCommits -Branch master -Path $RepoPath

Reset-DemoVms -VmxPath 'C:\Users\Mark Johnson\OneDrive\Documents2\Virtual Machines\s16-prod\s16-prod.vmx' -SnapShotName 'Inedo Agent Installed'
#Reset-DemoVms -VmxPath 'C:\Users\Mark Johnson\OneDrive\Documents2\Virtual Machines\s16-prod\s16-prod.vmx' -SnapShotName 'Initial Bootstrapping Applied'

#Reset-DemoVms -VmxPath 'C:\vms\s16-dev\s16-dev.vmx' -SnapShotName 'Pre-demo 2 v2'



Prepare-OtterServerForDemo