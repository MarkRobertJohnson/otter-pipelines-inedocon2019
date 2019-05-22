param([int]$SizeKb)
$nlm = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]"{DCB00C01-570F-4A9B-8D69-199FDBA5723B}"))
$connections = $nlm.getnetworkconnections()
$connections | foreach {
    if (($_.getnetwork().getcategory() -eq 0) -and ($_.getnetwork().getcategory() -ne 2))
    {
        $_.getnetwork().setcategory(1)
    }
}
Set-Item WSMan:\localhost\MaxEnvelopeSizekb -Value $SizeKb