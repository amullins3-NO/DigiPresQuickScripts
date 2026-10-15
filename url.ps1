# Base URL where the files are hosted
#$baseUrl = "https://{insert space name here].preserve.duracloud.org/"

#Prompt the user to enter the duracloud space
Write-Host "Enter the name of the Duracloud public bucket" -ForegroundColor Cyan
$CloudSpace = Read-Host 

# Prompt the user for the file path
Write-Host "Enter the path to the directory containing your files" -ForegroundColor Cyan
$filePath = Read-Host 

# Get a list of file names
$fileNames = Get-ChildItem -Path $filePath | Where-Object { !$_.PSIsContainer } | Select-Object -ExpandProperty Name

# Initialize an array to store filename-url pairs
$urlList = @()

# Iterate through each file name, replace spaces with "%20" and commas with "%2C" and create URLs
foreach ($fileName in $fileNames) {
    $encodedFileName = $fileName -replace " ", "%20" -replace ",", "%2C"
    $url = $baseUrl + $cloudSpace + "/" + $encodedFileName
    
    # Create a hashtable containing filename and URL
    $urlItem = @{
        FileName = $fileName
        URL = $url
    }
    
    # Add the hashtable to the URL list
    $urlList += New-Object PSObject -Property $urlItem
}

# Output the URL list to a CSV file in the specified file path
$urlList | Export-Csv -Path "$filePath\FileName_URL_List.csv" -NoTypeInformation

Write-Host "URL list has been saved to: $filePath\FileName_URL_List.csv" -ForegroundColor Magenta
