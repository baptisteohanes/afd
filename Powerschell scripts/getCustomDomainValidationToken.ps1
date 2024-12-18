# Define variables
$resourceGroupName = "rg-dmz-afd"
$frontDoorProfileName = "afd-dmz-arm"

# Login to Azure
#Connect-AzAccount

# Get the custom domains
$customDomains = Get-AzFrontDoorCdnCustomDomain -ResourceGroupName $resourceGroupName -ProfileName $frontDoorProfileName

# List custom domains and validation tokens

$results =@()

foreach ($domain in $customDomains) {
    $domainName = $domain.HostName
    $dnsAuthValue = $domainName.split(".")[0]
    $domainSuffix = $domainName.split(".",2)[1]
    $validationToken = $domain.ValidationPropertyValidationToken
    Write-Output "Domain: $domainName, DNS Suffix : $domainSuffix, DNS Auth record :  _dnsauth.$dnsAuthValue Validation Token: $validationToken"
    $results += [PSCustomObject]@{ DomainName = $domainName; DNSAuthRecord = "_dnsauth.$dnsAuthValue"; ValidationToken = $validationToken }
}

$results | Export-Csv -Path ".\customDomainValidationTokens.csv" -NoTypeInformation
