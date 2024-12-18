$resourceGroupName = "rg-dmz-afd"
$frontDoorName = "afd-dmz-axa"

# Import the Azure module
Import-Module Az.FrontDoor

# Connect to Azure account
#Connect-AzAccount

# Define the CSV file path
$csvFilePath = ".\domainList.csv"

# Import the CSV file
$domains = Import-Csv -Path $csvFilePath
$sw = [Diagnostics.Stopwatch]::StartNew()

# Loop through each domain in the CSV and run in parallel
$domains | ForEach-Object -Parallel {
    
    # Get the domain name and replace . per -
    $sanitizedDomainName = $_.DomainName -replace "\.", "-"
    $uniqueId = [guid]::NewGuid().ToString().Substring(0, 4)
    $customDomainName = $sanitizedDomainName + "-" + $uniqueId
    $hostName = $_.DomainName
    
    # Add the custom domain to Azure Front Door
    
    New-AzFrontDoorCdnCustomDomain -ResourceGroupName $using:resourceGroupName `
                                   -ProfileName $using:frontDoorName `
                                   -CustomDomainName $customDomainName `
                                   -HostName $hostName
    
    Write-Output "Custom domain $customDomainName has been added to Azure Front Door."

} -ThrottleLimit 50

$sw.Stop()

Write-Output "Custom domains have been added to Azure Front Door. Time taken: $($sw.Elapsed)"