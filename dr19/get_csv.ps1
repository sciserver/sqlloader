# Define the base URL
$baseUrl = "https://data.sdss.org/sas/dr19/data/cas-load/mtCSV/"

# Output folder for downloaded files
$outputFolder = "e:\dr19\csv-new"

# Credentials for authentication
$username = "sdss5"
$password = "###REDACTED###"
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $securePassword)

# Ensure the output folder exists
if (-not (Test-Path -Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder
}

# Get the webpage content
$response = Invoke-WebRequest -Uri $baseUrl -Credential $credential

# List of CSV files to download
$csvFilesToDownload = @(


    "minidb_dr19.dr19_sdss_id_flat.csv",
    "minidb_dr19.dr19_sdss_id_stacked.csv",
    "minidb_dr19.dr19_sdss_id_to_catalog.csv",
    "minidb_dr19.dr19_catalog_to_mangatarget.csv",
    "minidb_dr19.dr19_mangatarget.csv",
    "minidb_dr19.dr19_catalog_to_mastar_goodstars.csv",
    "minidb_dr19.dr19_mastar_goodstars.csv",
    "minidb_dr19.dr19_mastar_goodvisits.csv",
    "minidb_dr19.dr19_catalog_to_allstar_dr17_synspec_rev1.csv",
    "minidb_dr19.dr19_allstar_dr17_synspec_rev1.csv",
    "minidb_dr19.dr19_catalog_to_marvels_dr11_star.csv",
    "minidb_dr19.dr19_marvels_dr11_star.csv",
    "minidb_dr19.dr19_catalog_to_marvels_dr12_star.csv",
    "minidb_dr19.dr19_marvels_dr12_star.csv",
    "minidb_dr19.dr19_catalog_to_sdss_dr16_specobj.csv",
    "minidb_dr19.dr19_sdss_dr16_specobj.csv",
    "minidb_dr19.dr19_catalog_to_sdss_dr17_specobj.csv",
    "minidb_dr19.dr19_sdss_dr17_specobj.csv",
    "minidb_dr19.dr19_mangadapall.csv",
    "minidb_dr19.dr19_mangadrpall.csv"
    
)

# Parse the links to CSV files
$csvLinks = $response.Links | Where-Object { $_.href -in $csvFilesToDownload } | Select-Object -ExpandProperty href

# Download each CSV file
foreach ($csvLink in $csvLinks) {
    # Combine base URL with the relative link
    $fileUrl = "$baseUrl$csvLink"

    # Create the output file path
    $outputFile = Join-Path -Path $outputFolder -ChildPath $csvLink

    Write-Host "Downloading $csvLink..."
    
    # Download the file
    Invoke-WebRequest -Uri $fileUrl -OutFile $outputFile -Credential $credential
}

Write-Host "Selected CSV files have been downloaded to $outputFolder"