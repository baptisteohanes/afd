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

# Loop through each domain in the CSV and run in parallel
$domains | ForEach-Object -Parallel {
    
    # Get the domain name and replace . per -
    $customDomainName = ($_.DomainName -replace "\.", "-")+ "-" + [guid]::NewGuid().ToString()
    
    # Add the custom domain to Azure Front Door
    
    New-AzFrontDoorCdnCustomDomain -ResourceGroupName $using:resourceGroupName `
                                   -ProfileName $using:frontDoorName `
                                   -CustomDomainName $customDomainName `
                                   -HostName $_.DomainName
    
    Write-Output "Custom domain $customDomainName has been added to Azure Front Door."

} -ThrottleLimit 10

Write-Output "Custom domains have been added to Azure Front Door."