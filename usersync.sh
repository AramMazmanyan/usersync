#!/bin/bash

# GitHub API token and repository URL
    GITHUB_TOKEN=ithub_pat_11A6BAHBY0v4FgBb16gAde_KiWYD6ABr5LJcaJaqDTkgzX1B7y65N9inPqyASeSNEbNHVHR4LDJGkMfaM6
    REPO_URL=https://github.com/aregam96/usersync.git

# Clone the repository using the GitHub API token
    git clone "$REPO_URL"
    cd "$(basename "$REPO_URL" .git)"
    cd usersync

# File name and path for the csv file
    FILENAME="usersync.csv"
    FILEPATH="./$FILENAME"

#Parse the file
    while IFS="," read -r rec_column1 rec_column2 rec_column3
    do
        echo "Name-$rec_column1"
        echo "Email: $rec_column2"
        echo "Team: $rec_column3"
        echo ""
    done < <(tail -n +2 $FILENAME)

# Set the name of the CSV file
  #  csv_file=$FILENAME
  # # Set the name of the Azure AD tenant
  #   tenant_name="AregTestingEnv"
  # # Set the name of the Azure AD app
  #   app_name="aregtest"
  # azure login -u "$ApplicationId" --service-principal --tenant "$TenantId" -p "$password"

# Loop through each row in the CSV file for user check/creation
    while IFS=',' read -r name email team; do

    # Check if the user already exists in Azure AD
  if az ad user show --upn-or-object-id "$email" &>/dev/null; then
    echo "User $name ($email) already exists in Azure AD."

  else
    #Create the user in Azure AD
    password=$(openssl rand -base64 12)
    az ad user create \
      --display-name "$name" \
      --user-principal-name "$email" \
      --password "$password" \
      --output none
    echo "Created user $name ($email) with password $password." 
  fi

    done < <(tail -n +2 $FILENAME)

# Path to CSV file containing list of user principal names
    FILEPATH="./$FILENAME"
    # Loop through each line in the CSV file
    while read line || [ -n "$line" ]
    do
    
    # Extract the user principal name and team from the line
    email=$(echo $line | awk -F "," '{ print $2}')
    echo "email=$(echo $line | awk -F "," '{ print $2}')"
    
    team=$(echo $line | awk -F "," '{ print $3}')
    echo "team=$(echo $line | awk -F "," '{ print $3}')"

    # Get the object ID of the user using the Azure CLI
    user_id=$(az ad user show --id "$email" --query id --output tsv)

    # Check if the user is a member of the group
    az ad group member add --group "$team" --member-id "$user_id"
    echo "az ad group member add --group $team --member-id $user_id"

    done < <(tail -n +2 $FILENAME)