param([string]$VmxPath, 
[string]$SnapShotName)

<<<<<<< HEAD
Write-Host -ForegroundColor green "Reverting 'C:\Users\Mark Johnson\OneDrive\Documents2\Virtual Machines\s16-prod\s16-prod.vmx' to Snapshot 'Inedo Agent Installed' "
#restore VM snapshot
& "C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe" -T ws revertToSnapshot "C:\Users\Mark Johnson\OneDrive\Documents2\Virtual Machines\s16-prod\s16-prod.vmx" "Inedo Agent Installed"
Write-Host -ForegroundColor green "Starting VM 'C:\Users\Mark Johnson\OneDrive\Documents2\Virtual Machines\s16-prod\s16-prod.vmx' to Snapshot 'Inedo Agent Installed'"
& "C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe" -T ws start "C:\Users\Mark Johnson\OneDrive\Documents2\Virtual Machines\s16-prod\s16-prod.vmx" 
=======
Write-Host -ForegroundColor green "Reverting '$VmxPath' to Snapshot '$SnapShotName' ..."
#restore VM snapshot
& "C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe" -T ws revertToSnapshot "$VmxPath" "$SnapShotName"
Write-Host -ForegroundColor green "Starting VM '$VmxPath' ..."
& "C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe" -T ws start "$VmxPath" 
>>>>>>> dev
