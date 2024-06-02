param (
    [Parameter(Position=0, Mandatory=$true)]
    [string]$basePath,
    [Parameter(Position=1, Mandatory=$true)]
    [string]$folderName
)

# 1) Create a folder called refest2024-transcoded
New-Item -ItemType Directory -Force -Path "$basePath\$folderName-transcoded"

# Get all subfolders in refest2024
$subfolders = Get-ChildItem -Path "$basePath\$folderName" -Directory

foreach ($subfolder in $subfolders) {
    # 2) Create the corresponding number of subfolders inside refest2024-transcoded
    New-Item -ItemType Directory -Force -Path "$basePath\$folderName-transcoded\$($subfolder.Name)"

    # 3) Move the transcoded child folder of each subfolder from refest2024 to refest2024-transcoded
    Move-Item -Path "$basePath\$folderName\$($subfolder.Name)\transcoded" -Destination "$basePath\$folderName-transcoded\$($subfolder.Name)"
}