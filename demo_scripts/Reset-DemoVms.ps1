param([string]$VmxPath, 
[string]$SnapShotName)

Write-Host -ForegroundColor green "Reverting '$VmxPath' to Snapshot '$SnapShotName' ..."
#restore VM snapshot
& "C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe" -T ws revertToSnapshot "$VmxPath" "$SnapShotName"
Write-Host -ForegroundColor green "Starting VM '$VmxPath' ..."
& "C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe" -T ws start "$VmxPath" 