#!/bin/bash

source_folder=$1
subfolder_name=$2
destination=$3

find "$source_folder" -name "$subfolder_name" -type d | while read dir; do
  # create new folder in the destination directory, preserving the original file structure and keeping the parent directory names and the subfolder name
  parent_folder=$(basename $(dirname "$dir"))
  mkdir -p "$destination/$parent_folder/$subfolder_name"
  # Copy the contents of the subdirectory to the new folder in the destination directory
  cp -R "$dir"/* "$destination/$parent_folder/$subfolder_name"
done

# You can run this script by typing the command bash scriptname.sh sourcefolder subfoldername destinationfolder. 
# For example, if the script is named copysubs.sh parent_folder subfoldername destination
# parent_dir
# ├── dir1
# │   ├── sub
# │   │   └── file
# │   └── sub1
# │       └── file
# ├── dir2
# │   ├── sub
# │   │   └── file
# │   └── sub1
# │       └── file
# └── dir3
#     ├── sub
#     │   └── file
#     └── sub1
#         └── file

# bash `copysubs.sh parent_dir sub1 destination`
# the output
# destination
# ├── dir1
# │   └── sub1
# │       └── file
# ├── dir2
# │   └── sub1
# │       └── file
# └── dir3
#     └── sub1
#         └── file