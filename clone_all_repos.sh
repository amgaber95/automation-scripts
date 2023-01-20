#!/bin/bash

# This script clones all the repositories of a GitHub user account. For example, if you run the script with the following command:
# ```./script.sh https://github.com/ANYbotics 50 ```
# The script will clone all the repositories of the GitHub user account at https://github.com/ANYbotics into a new folder named ANYbotics in the current directory,
# and will use 50 parallel processes to clone the repositories.


# Get the GitHub account URL from the first command line argument
account_url=$1

# Get the number of parallel processes from the second command line argument
parallel_processes=${2:-50}

# Extract the account name from the URL
account_name=${account_url##*/}

# Check if the URL is valid by making a request to the API
response_code=$(curl -s -o /dev/null -w "%{http_code}" https://api.github.com/users/$account_name)

if [ $response_code -ne 200 ]; then
  # Log the error
  echo "Error: Invalid URL. HTTP response code: $response_code"
  exit 1
fi

# Check if the folder for the GitHub account already exists
if [ ! -d "$account_name" ]; then
  # If the folder does not exist, create it
  mkdir "$account_name"
fi

# Change the current directory to the newly created folder
cd "$account_name"

# echo how many parallel processes are being used
echo "Using $parallel_processes parallel processes"

# Fetch all repositories of the user, handling pagination
page=1
while true; do
  repos=$(curl -s "https://api.github.com/users/$account_name/repos?per_page=100&page=$page" | jq -r '.[].ssh_url')

  if [ -z "$repos" ]; then
    # If no repositories were returned, we have fetched all pages
    break
  fi

  # Clone each repository using xargs
  echo "$repos" | tr ' ' '\n' | xargs -n 1 -P $parallel_processes git clone
  ((page++))
done
