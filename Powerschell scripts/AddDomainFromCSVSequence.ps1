$resourceGroupName = "rg-dmz-afd"
$frontDoorName = "afd-dmz-we"

# Import the Azure module
Import-Module Az.FrontDoor

# Connect to Azure account
#Connect-AzAccount

# Define the CSV file path
$csvFilePath = ".\domainListSmall.csv"

# Import the CSV file
$domains = Import-Csv -Path $csvFilePath

$sw = [Diagnostics.Stopwatch]::StartNew()

foreach ($domain in $domains) {

    # Generate a single object name per domain
    $sanitizedDomainName = $domain.DomainName -replace "\.", "-"
    $uniqueId = [guid]::NewGuid().ToString().Substring(0, 4)
    $customDomainName = $sanitizedDomainName + "-" + $uniqueId
    $hostName = $domain.DomainName

    # Add the custom domain to the Azure Front Door
    New-AzFrontDoorCdnCustomDomain -ResourceGroupName $resourceGroupName `
                                   -ProfileName $frontDoorName `
                                   -CustomDomainName $customDomainName `
                                   -HostName $hostName

    Write-Output "Custom domain $customDomainName, using $hostName has been added to Azure Front Door $frontDoorName in resource group $resourceGroupName. Time taken: $($sw.Elapsed.TotalSeconds) seconds."
}
$sw.Stop()

Write-Output "Custom domains have been added to Azure Front Door. Time taken: $($sw.Elapsed)"