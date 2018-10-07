param(
    $username = "mark johnson",
    $password = ("skor4me!" | ConvertTo-SecureString -asPlainText -Force),
    $computerName = 's16-dev'
)
$credential = New-Object System.Management.Automation.PSCredential ($username,$password)
$session = New-PSSession -ComputerName $computerName -Credential $credential 
Invoke-Command -Session $session -ScriptBlock { 
    if(Test-Path "c:\ProgramData\Chocolatey\bin\RefreshEnv.cmd") { 
        . "c:\ProgramData\Chocolatey\bin\RefreshEnv.cmd"
    }
    
}
[PSCustomObject] @{ 
        CommandLine= '. "c:\ProgramData\Chocolatey\bin\RefreshEnv.cmd"'; 
        ExecutionStatus = "Completed"; 
        StartExecutionTime=(Get-Date).ToString(); 
        EndExecutionTime=(Get-Date).ToString() } | Add-History 
enter-pssession -Session $session 
