# Parent directory path
$parent_directory = "D:\vids\output"

# Get all subdirectories
$subdirectories = Get-ChildItem -Path $parent_directory -Directory

# Process each subdirectory
foreach ($subdirectory in $subdirectories) {
    # Get the name of the subdirectory
    $name = $subdirectory.Name

    # If the name length is less than 3
    if ($name.Length -lt 3) {
        # Pad the name with leading zeros to make it 3 digits
        $new_name = $name.PadLeft(3, '0')

        # Rename the subdirectory with the new name
        Rename-Item -Path $subdirectory.FullName -NewName $new_name
    }
}