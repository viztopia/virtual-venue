ffmpeg -loop 1 -i blank.jpg -i input.mp3 -c:v libx264 -c:a copy -shortest -pix_fmt yuv420p output.mp4

ffmpeg -i 119.mp4 -vf scale=1920:1080 -sws_flags lanczos 119_1080p_video.mp4

ffmpeg -i 47.mp4 -f lavfi -i anullsrc -c:v copy -c:a aac -shortest output.mp4

ffmpeg -i i.mp4 -vf "scale=trunc(oh*a/1):1080,sws_flags=lanczos" o_1080p.mp4
ffmpeg -i i.mp4 -vf "scale=trunc(oh*a/1):1080" o_1080p.mp4
ffmpeg -i i.mp4 -vf "scale=trunc((oh*a/2)/2)*2:1080" o_1080p.mp4