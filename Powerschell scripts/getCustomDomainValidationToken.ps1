# Define variables
$resourceGroupName = "rg-dmz-afd"
$frontDoorProfileName = "afd-dmz-arm"

# Login to Azure
#Connect-AzAccount

# Get the custom domains
$customDomains = Get-AzFrontDoorCdnCustomDomain -ResourceGroupName $resourceGroupName -ProfileName $frontDoorProfileName

# List custom domains and validation tokens

foreach ($domain in $customDomains) {
    $domainName = $domain.HostName
    $dnsAuthValue = ($domain.HostName -split ".")[0]
    $validationToken = $domain.ValidationPropertyValidationToken
    Write-Output "Domain: $domainName, DNS Auth entry :  _dnsauth.$dnsauthvalue Validation Token: $validationToken"
}
