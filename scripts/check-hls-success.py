import os

parent_folder = "D:/vids/re-encode-output"

# Loop through all subfolders
for subfolder_name in os.listdir(parent_folder):
    subfolder_path = os.path.join(parent_folder, subfolder_name)
    
    # Check if the current item is a directory
    if os.path.isdir(subfolder_path):
        hls_folder_path = os.path.join(subfolder_path, "hls")
        
        # Check if the "hls" folder exists
        if os.path.isdir(hls_folder_path):
            h264_480p_folder_path = os.path.join(hls_folder_path, "h264_480p")
            print(f"Hls folder {hls_folder_path} exists.")
            
            # Check if the "h264_480p" folder exists
            if not os.path.isdir(h264_480p_folder_path):
                print(f"Subfolder {subfolder_name} does not contain the 'h264_480p' folder inside the 'hls' folder.")
        