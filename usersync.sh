#!/bin/bash

#GitHub API token and repository URL
GITHUB_TOKEN=ithub_pat_11A6BAHBY0v4FgBb16gAde_KiWYD6ABr5LJcaJaqDTkgzX1B7y65N9inPqyASeSNEbNHVHR4LDJGkMfaM6
REPO_URL=https://github.com/aregam96/usersync.git

#file name and path for the usersync.csv file
FILENAME="usersync.csv"
FILEPATH="./$FILENAME"

# Clone the repository using the GitHub API token
git clone "$REPO_URL" --quiet
cd "$(basename "$REPO_URL" .git)"