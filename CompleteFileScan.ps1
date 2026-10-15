# Prompt the user to enter the directory path
Write-Host "Enter the directory path to scan" -ForegroundColor Cyan
$directoryPath = Read-Host 

# Check if the directory exists
if (-not (Test-Path $directoryPath -PathType Container)) {
    Write-Host "Directory not found: $directoryPath"
    exit
}

# Get all files in the specified directory and its subdirectories
$files = Get-ChildItem -Path $directoryPath -File -Recurse

Write-Host "Prepping File Count..." -ForegroundColor Magenta

# Group files by extension and count occurrences
$fileTypes = $files | Group-Object Extension | ForEach-Object {
    [PSCustomObject]@{
        Extension = $_.Name
        Count = $_.Count
    }
}

# Create a CSV file with the results
$fileTypes | Export-Csv -Path "$directoryPath\FileTypeCount.csv" -NoTypeInformation

# Notify that file count has finished
Write-Host "File Count finished." -ForegroundColor Magenta

# Display the results of the file count in the console
$fileTypes | Format-Table -AutoSize

# Loop to check multiple file types before moving to checksum inventory
# Ask to review a particular file type
Write-Host "Would you like an inventory of a particular file type? (Y/N)" -ForegroundColor Cyan
$typeConfirmation = Read-Host 
    
   if ($typeConfirmation -match "^[Yy]$") {
   do {
        # Ask for file extension (without the period)
        Write-Host "Enter the file type extension (no periods)" -ForegroundColor Cyan
        $fileType = Read-Host 

        # Filter files by the provided extension and store in an array
        $typeResults = @($files | Where-Object { $_.Extension -eq ".$fileType" } | ForEach-Object {
            [PSCustomObject]@{
                Name = $_.Name
                FullName = $_.FullName
                FileType = $_.Extension.TrimStart('.')
            }
        })

        # Display results in the console if files are found
        if ($typeResults.Count -gt 0) {
            Write-Host "Generating inventory for .$fileType files..."
            $typeResults | Format-Table -AutoSize

            # Export the results to CSV
            $typeResults | Export-Csv -Path "$directoryPath\$fileType.csv" -NoTypeInformation
            Write-Host "Inventory for .$fileType saved to $directoryPath\$fileType.csv"
        } else {
            Write-Host "No files found with the .$fileType extension."
        }

        # Ask if the user wants to check another file type
        Write-Host "Would you like to check another file type? (Y/N)" -ForegroundColor Cyan
        $repeatCheck = Read-Host 
    } while ($repeatCheck -match "^[Yy]$")  # Continue the loop if the user enters Y/y
}

# Ask if the user wants to continue with the checksum inventory
Write-Host "Would you like to continue with the checksum inventory?" -ForegroundColor Cyan
$hashConfirmation = Read-Host 

# Check user input and proceed accordingly
if ($hashConfirmation -match "^[Yy]$") {
    Write-Host "Continuing..." -ForegroundColor Magenta
    # Continue with the rest of the script
} else {
    Write-Host "Exiting script." -ForegroundColor Magenta
    exit
}

# Function to calculate MD5 hash
function Get-FileHashMD5 {
    param (
        [string]$FilePath
    )
    $fileStream = [System.IO.File]::OpenRead($FilePath)
    $hash = [System.Security.Cryptography.MD5]::Create().ComputeHash($fileStream)
    $fileStream.Close()
    $hashString = [System.BitConverter]::ToString($hash) -replace '-', ''
    return $hashString
}

#function to get mime type
function Get-MimeType {
    param([string]$FilePath)

    try {
        Add-Type -AssemblyName System.Web -ErrorAction SilentlyContinue
        $mime = [System.Web.MimeMapping]::GetMimeMapping($FilePath)
        if ($mime) { return $mime }
    } catch { }

    $extension = [System.IO.Path]::GetExtension($FilePath).ToLower()
    if ($extension) {
        try {
            $contentType = (Get-ItemProperty -Path "HKCR:\$extension" -ErrorAction Stop)."Content Type"
            if ($contentType) { return $contentType }
        } catch { }
    }

    return "application/octet-stream"
}

# Initialize an empty array to store the results
$results = @()

# Iterate through each file
foreach ($file in $files) {
    $fileName = $file.Name
    $fileExtension = $file.Extension
    $fullName = $file.FullName
    $lastWriteTime = $file.LastWriteTime
    $md5Hash = Get-FileHashMD5 -FilePath $file.FullName
    $mimeType = Get-MimeType -FilePath $file.FullName

    # Create an object to store file information
    $fileInfo = New-Object PSObject -Property @{
        FileName = $fileName
        FileExtension = $fileExtension
        FullName = $fullName
        LastWriteTime = $lastWriteTime
        MD5Hash = $md5Hash
        MimeType = $mimeType
    }

    # Add the object to the results array
    $results += $fileInfo
}

# Export the results to a CSV file in the specified directory
$results | Export-Csv -Path "$directoryPath\FilesInfo.csv" -NoTypeInformation

Write-Host "Scan completed. Results exported to $directoryPath\FilesInfo.csv" -ForegroundColor Magenta

Write-Host "Scan completed. Results saved to: $directoryPath" -ForegroundColor Magenta