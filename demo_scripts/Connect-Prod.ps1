param($username = "mark johnson",
$password = ("skor4me!" | ConvertTo-SecureString -asPlainText -Force)
)
$credential = New-Object System.Management.Automation.PSCredential ($username,$password)

enter-pssession -ComputerName s16-dev -credential $credential