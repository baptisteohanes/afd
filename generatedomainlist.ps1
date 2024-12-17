# Generate a list of 600 domain names ending with ".jazuregrave.fr"
$domainList = @()
for ($i = 1; $i -le 600; $i++) {
    $domainName = "domain$i.jazuregrave.fr"
    $domainList += [PSCustomObject]@{ DomainName = $domainName }
}

# Export the list to a CSV file
$csvFilePath = "C:\domainList.csv"
$domainList | Export-Csv -Path $csvFilePath -NoTypeInformation

Write-Output "Domain list exported to $csvFilePath successfully."