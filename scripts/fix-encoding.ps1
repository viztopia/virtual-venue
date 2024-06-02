param (
    [Parameter(Mandatory=$true, Position=0)]
    [string]$InputFolder,

    [Parameter(Mandatory=$true, Position=1)]
    [string]$OutputFolder
)

# Ensure the output directory exists
if (!(Test-Path -Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder
}

# Get all video files in the input directory
$videoFiles = Get-ChildItem -Path $InputFolder -Include *.mp4 -Recurse

foreach ($file in $videoFiles) {
    $inputPath = $file.FullName
    $outputPath = Join-Path -Path $OutputFolder -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension($file.Name) + ".mov")

    # Check if the input file has an audio stream
    $hasAudio = ffmpeg -i $inputPath 2>&1 | Select-String "Stream.*Audio"

    if ($hasAudio) {
        # Audio stream exists, copy audio and change frame rate
        ffmpeg -i $inputPath -r 24 -c:v libx264 -acodec copy $outputPath
    } else {
        # No audio stream, add silent audio and change frame rate
        ffmpeg -i $inputPath -r 24 -c:v libx264 -f lavfi -i anullsrc -c:v copy -c:a aac -shortest $outputPath
    }
}
