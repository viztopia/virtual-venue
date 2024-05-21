# Check if an input directory and output directory are provided
if ($args.Length -lt 2) {
    Write-Host "Usage: $0 <input_directory> <output_directory>"
    exit
}

# Input directory provided as the first argument
$input_directory = $args[0]
$output_directory = $args[1]

# Get all video files in the input directory
$video_files = Get-ChildItem -Path $input_directory -Include *.mp4, *.mov -Recurse

# Process each video file
foreach ($video_file in $video_files) {
    $input_filename = $video_file.FullName
    $output_path = Join-Path $output_directory $video_file.BaseName

    $transcoded_source_path = Join-Path $output_path "transcoded"
    $hls_output_path = Join-Path $output_path "hls"

    # Check if the the transcoded file path exists, otherwise create it
    if (!(Test-Path $transcoded_source_path -PathType Container)) {
        # If it doesn't exist, create it
        New-Item -ItemType Directory -Force -Path $transcoded_source_path
        Write-Host "Directory created: $transcoded_source_path"
    }
    else {
        Write-Host "Directory already exists: $transcoded_source_path"
    }

    # Check if the the hls output file path exists, otherwise create it
    if (!(Test-Path $hls_output_path -PathType Container)) {
        # If it doesn't exist, create it
        New-Item -ItemType Directory -Force -Path $hls_output_path
        Write-Host "Directory created: $hls_output_path"
    }
    else {
        Write-Host "Directory already exists: $hls_output_path"
    }

    # Get the duration of the video in seconds
    $duration = & .\get-video-duration.ps1 $input_filename

    # Combine the output path and the file name
    $full_output_path = Join-Path -Path $output_path -ChildPath "duration.txt"
    
    # Write the duration to a text file
    Set-Content -Path $full_output_path -Value $duration

    # transcode to 1080p
    ffmpeg -i $input_filename `
        -c:a aac -b:a 128k `
        -vf "scale=-2:1080" `
        -c:v libx264 -profile:v high -level:v 4.2 `
        -x264-params scenecut=0:open_gop=0:min-keyint=72:keyint=72 `
        -minrate 6000k -maxrate 6000k -bufsize 6000k -b:v 6000k `
        -y (Join-Path $transcoded_source_path "h264_high_1080p_6000.mp4")

    # transcode to 720p
    ffmpeg -i $input_filename `
        -c:a aac -b:a 128k `
        -vf "scale=-2:720" `
        -c:v libx264 -profile:v main -level:v 4.0 `
        -x264-params scenecut=0:open_gop=0:min-keyint=72:keyint=72 `
        -minrate 3000k -maxrate 3000k -bufsize 3000k -b:v 3000k `
        -y (Join-Path $transcoded_source_path "h264_main_720p_3000.mp4")

    # transcode to 480p
    ffmpeg -i $input_filename `
        -c:a aac -b:a 128k `
        -vf "scale=-2:480" `
        -c:v libx264 -profile:v main -level:v 3.1 `
        -x264-params scenecut=0:open_gop=0:min-keyint=72:keyint=72 `
        -minrate 1000k -maxrate 1000k -bufsize 1000k -b:v 1000k `
        -y (Join-Path $transcoded_source_path "h264_main_480p_1000.mp4")

    # transcode to 360p
    ffmpeg -i $input_filename `
        -c:a aac -b:a 128k `
        -vf "scale=-2:360" `
        -c:v libx264 -profile:v baseline -level:v 3.0 `
        -x264-params scenecut=0:open_gop=0:min-keyint=72:keyint=72 `
        -minrate 600k -maxrate 600k -bufsize 600k -b:v 600k `
        -y (Join-Path $transcoded_source_path "h264_baseline_360p_600.mp4")

    # package the above
    packager `
        "in=$(Join-Path $transcoded_source_path 'h264_baseline_360p_600.mp4'),stream=audio,segment_template=$(Join-Path $hls_output_path 'audio/$Number$.aac'),playlist_name=$(Join-Path $hls_output_path 'audio/main.m3u8'),hls_group_id=audio,hls_name=ENGLISH" `
        "in=$(Join-Path $transcoded_source_path 'h264_main_480p_1000.mp4'),stream=video,segment_template=$(Join-Path $hls_output_path 'h264_480p/$Number$.ts'),playlist_name=$(Join-Path $hls_output_path 'h264_480p/main.m3u8'),iframe_playlist_name=$(Join-Path $hls_output_path 'h264_480p/iframe.m3u8')" `
        "in=$(Join-Path $transcoded_source_path 'h264_main_720p_3000.mp4'),stream=video,segment_template=$(Join-Path $hls_output_path 'h264_720p/$Number$.ts'),playlist_name=$(Join-Path $hls_output_path 'h264_720p/main.m3u8'),iframe_playlist_name=$(Join-Path $hls_output_path 'h264_720p/iframe.m3u8')" `
        "in=$(Join-Path $transcoded_source_path 'h264_high_1080p_6000.mp4'),stream=video,segment_template=$(Join-Path $hls_output_path 'h264_1080p/$Number$.ts'),playlist_name=$(Join-Path $hls_output_path 'h264_1080p/main.m3u8'),iframe_playlist_name=$(Join-Path $hls_output_path 'h264_1080p/iframe.m3u8')" `
        --hls_master_playlist_output (Join-Path $hls_output_path "manifest.m3u8")
}