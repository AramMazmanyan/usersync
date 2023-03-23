#!/bin/bash 

GITHUB_USERNAME=aregam96 
REPO_NAME=usersync
ACCESS_TOKEN=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 

CSV_URL=$(curl -s -H "Authorization: token $ACCESS_TOKEN" 
https://api.github.com/repos/$GITHUB_USERNAME/$REPO_NAME/contents/usersync.csv?ref=main | grep -o 'download_url.*' | cut -d 
'"' -f 3)

git clone $CSV_URL users

username=($(awk -F ',' '{print $2}' users/usersync.csv))

for username in "${usernames[@]}"; do
    if ! az ad user show --id $username@<tenant> >/dev/null 2>&1; then
        # user does not exist in Azure AD, create the user using the Azure CLI
        az ad user create --user-principal-name $username@<tenant> --display-name 
$username
    fi
done
