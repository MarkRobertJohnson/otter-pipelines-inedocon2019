Write-Host -ForegroundColor Green "Running server checker ..."
Invoke-WebRequest -Uri http://s16-dev:8626/0x44/Otter.WebApplication/Inedo.Otter.WebApplication.Pages.Administration.ServiceMonitorPage/RunExecuter?name=Server%20Checker -Method POST -Verbose 

Write-Host -ForegroundColor Green "Running RoutineConfigurationRunner ..."
Invoke-WebRequest -Uri http://s16-dev:8626/0x44/Otter.WebApplication/Inedo.Otter.WebApplication.Pages.Administration.ServiceMonitorPage/RunExecuter?name=RoutineConfigurationRunner -Method POST -Verbose