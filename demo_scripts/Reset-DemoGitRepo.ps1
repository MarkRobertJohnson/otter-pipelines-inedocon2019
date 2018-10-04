param([string]$RepoPath = 'C:\dev\ws\chocofest')

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

Reset-Branch -Branch master -Path $RepoPath -Commit 69738a331beb6bf9203b1b0a05534749f1b9adc8

Squash-AllCommits -Branch dev -Path $RepoPath
Squash-AllCommits -Branch master -Path $RepoPath

