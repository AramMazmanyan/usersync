#!/bin/bash

#GitHub API token and repository URL
GITHUB_TOKEN=ithub_pat_11A6BAHBY0v4FgBb16gAde_KiWYD6ABr5LJcaJaqDTkgzX1B7y65N9inPqyASeSNEbNHVHR4LDJGkMfaM6
REPO_URL=https://github.com/aregam96/usersync.git

#File name and path for the csv file
FILENAME="usersync.csv"
FILEPATH="./$FILENAME"

#Clone the repository using the GitHub API token
git clone "$REPO_URL" --quiet
cd "$(basename "$REPO_URL" .git)"

#parse the file version 3
while IFS="," read -r rec_column1 rec_column2 rec_column3
do
  echo "Name-$rec_column1"
  echo "Email: $rec_column2"
  echo "Team: $rec_column3"
  echo ""
done < <(tail -n +2 $FILENAME)

# Set the name of the CSV file
csv_file=$FILENAME

# Set the name of the Azure AD tenant
#tenant_name="AregTestingEnv"

# Set the name of the Azure AD app
app_name="aregtest"

# Authenticate to Azure using the Azure CLI
az login

# Loop through each row in the CSV file
while IFS=',' read -r name email team; do

# Check if the user already exists in Azure AD
  if az ad user show --upn-or-object-id "$email" &>/dev/null; then
    echo "User $name ($email) already exists in Azure AD."
  else
    # Create the user in Azure AD
    password=$(openssl rand -base64 12)
    az ad user create \
      --display-name "$name" \
      --user-principal-name "$email" \
      --password "$password" \
      --output none
    echo "Created user $name ($email) with password $password." 
  fi
  
done < "$csv_file"