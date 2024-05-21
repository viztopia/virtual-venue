param (
    [Parameter(Mandatory=$true)]
    [string]$filePath
)

$durationInSeconds = [double]$(ffprobe -v error -hide_banner -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $filePath)
# $durationInMilliseconds = $durationInSeconds * 1000

Write-Output $durationInSeconds

# $filename = "duration.txt"
# Set-Content -Path $filename -Value $durationInSeconds