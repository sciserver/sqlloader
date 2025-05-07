# Define the base URL
$baseUrl = "https://data.sdss.org/sas/dr19/data/cas-load/mtCSV/"

# Output folder for downloaded files
$outputFolder = "e:\dr19\csv0213"

# Credentials for authentication
$username = "sdss5"
$password = "panoPtic-5"

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

"minidb_dr19.dr19_cadence_epoch.csv",					
"minidb_dr19.dr19_cadence.csv",						
"minidb_dr19.dr19_skymapper_gaia.csv",					
"minidb_dr19.dr19_tess_toi.csv",						
"minidb_dr19.dr19_erosita_superset_stars.csv",			
"minidb_dr19.dr19_mwm_tess_ob.csv",					
"minidb_dr19.dr19_zari18pms.csv",						
"minidb_dr19.dr19_sagitta.csv",						
"minidb_dr19.dr19_gaia_unwise_agn.csv",				
"minidb_dr19.dr19_gaia_dr2_wd.csv",					
"minidb_dr19.dr19_gaiadr2_tmass_best_neighbour.csv",	
"minidb_dr19.dr19_gaia_dr2_ruwe.csv",					
"minidb_dr19.dr19_best_brightest.csv",					
"minidb_dr19.dr19_twomass_psc.csv",					
"minidb_dr19.dr19_catalog.csv",						
"minidb_dr19.dr19_unwise.csv",							
"minidb_dr19.dr19_bhm_csc.csv",						
"minidb_dr19.dr19_uvotssc1.csv",						
"minidb_dr19.dr19_tycho2.csv",							
"minidb_dr19.dr19_tic_v8.csv",							
"minidb_dr19.dr19_supercosmos.csv",					
"minidb_dr19.dr19_skymapper_dr2.csv",					
"minidb_dr19.dr19_sdss_dr16_specobj.csv",				
"minidb_dr19.dr19_sdss_dr13_photoobj_primary.csv",		
"minidb_dr19.dr19_guvcat.csv",							
"minidb_dr19.dr19_glimpse.csv",						
"minidb_dr19.dr19_catwise2020.csv",					
"minidb_dr19.dr19_allwise.csv",						
"minidb_dr19.dr19_bhm_efeds_veto.csv",
"minidb_dr19.dr19_carton.csv",						
"minidb_dr19.dr19_opsdb_apo_exposure.csv",			
"minidb_dr19.dr19_opsdb_apo_configuration.csv",	
"minidb_dr19.dr19_opsdb_apo_exposure_flavor.csv",	
"minidb_dr19.dr19_opsdb_apo_completion_status.csv",
"minidb_dr19.dr19_opsdb_apo_camera.csv",			
"minidb_dr19.dr19_sdssv_boss_conflist.csv"
    
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