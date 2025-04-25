import os

parent_folder = "D:/vids/re-encode-output"

# Initialize counters
total_folders = 0
passed_folders = 0
failed_folders = 0

# Loop through all subfolders
for subfolder_name in os.listdir(parent_folder):
    subfolder_path = os.path.join(parent_folder, subfolder_name)
    
    # Check if the current item is a directory
    if os.path.isdir(subfolder_path):
        hls_folder_path = os.path.join(subfolder_path, "hls")
        
        # Check if the "hls" folder exists
        if os.path.isdir(hls_folder_path):
            manifest_file_path = os.path.join(hls_folder_path, "manifest.m3u8")
            total_folders += 1
            
            # Check if the "manifest.m3u8" file exists
            if os.path.isfile(manifest_file_path):
                print(f"Manifest file {manifest_file_path} exists.")
                passed_folders += 1
            else:
                print(f"Folder {hls_folder_path} does not contain the 'manifest.m3u8' file.")
                failed_folders += 1

# Print summary
print(f"{total_folders} folders checked, {passed_folders} passed, {failed_folders} failed.")