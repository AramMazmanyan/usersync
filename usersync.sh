#!/bin/bash

echo "Username: $1"
echo "Password: $2"
echo "Tenant: $3"

aergertshsetr

# GitHub API token and repository URL
 #     GITHUB_TOKEN=ithub_pat_11A6BAHBY0v4FgBb16gAde_KiWYD6ABr5LJcaJaqDTkgzX1B7y65N9inPqyASeSNEbNHVHR4LDJGkMfaM6
 #     REPO_URL=https://github.com/aregam96/usersync.git

# # Clone the repository using the GitHub API token
 #     git clone "$REPO_URL"
 #     cd "$(basename "$REPO_URL" .git)"

# File name and path for the csv file
    FILENAME="usersync.csv"
    FILEPATH="./$FILENAME"
 
# #Create the log file
#   log_file="log_file.log"
#   log=log_file.log
#   date >> $log

# # Define the log function
#  function log() {
#     local message="$1"
#     local severity="$2"
#     local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
#     echo "[$timestamp] [$severity] $message" >> "$log"
#     echo "[$timestamp] [$severity] $message" 
#  }

#  log in azure ad using Service Principle
az login --service-principal --username "$1" -p="$2" --tenant "$3"
# az login --service-principal --username 8a839d12-a3c5-4dc7-8561-a7c1a80bafb4 -p=lCD8Q~SENxUhx5lFWtQl1Rz232mEo__uHUXEJa9Y --tenant 7c2be92f-7fb6-4331-9453-11501f1f57e3

# # Loop through each row in the CSV file for user check/creation
#  while read line || [ -n "$line" ]
#  do 
#     # Extract the user principal name and team from the line
#     name=$(echo "$line" | awk -F "," '{ print $1}')
#     email=$(echo "$line" | awk -F "," '{ print $2}')
#     team=$(echo "$line" | awk -F "," '{ print $3}')
#     # Check if the user already exists in Azure AD
#     if az ad user show --id "$email" &>/dev/null; then 
#         log "User $name ($email) already exists in Azure AD." "INFO"
#     else
#         #Create the user in Azure AD
#         password=$(openssl rand -base64 12)
#         az ad user create \
#             --display-name "$name" \
#             --user-principal-name "$email" \
#             --password "$password" \
#             --output none
#         log "Created user $name ($email) with password $password." "INFO"
#     fi 

#  done < <(tail -n +2 "$FILENAME")

# # Loop through each line in the CSV file for group check/add
#  while read line || [ -n "$line" ]
#  do 
#     # Extract the user principal name and team from the line
#     email=$(echo "$line" | awk -F "," '{ print $2}')
#     team=$(echo "$line" | awk -F "," '{ print $3}')

#     # Get the object ID of the user using the Azure CLI
#     user_id=$(az ad user show --id "$email" --query id --output tsv)

#     # Check if the user is a member of the group
#     # msg=az ad group member add --group "$team" --member-id "$user_id" 2>&1
#     if az ad group member add --group "$team" --member-id "$user_id" >/dev/null 2>&1; then
#         log "Added user $email to group $team" "INFO"
#     else
#         error_code=$?
#         log "Error $error_code:" "ERROR"
#     fi
#  done < <(tail -n +2 "$FILENAME")