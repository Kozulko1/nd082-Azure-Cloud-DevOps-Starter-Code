#!/bin/bash
az policy definition create \
    --name tagging-policy \
    --description "Ensuring all resources are tagged" \
    --display-name "Tagging Policy" \
    --mode Indexed \
    --rules project/policy/policy.json

az policy assignment create \
    --name tagging-policy-assignment \
    --display-name "Tagging Policy Assignment" \
    --policy tagging-policy

echo -e "Would you like to use default values? [y/n]: "
while true; do
    read -n1 answer
    case $answer in
        [y] ) break;;
        [n] ) break;;
        * ) printf "\nPlease answer y or n\n";;
    esac
done
printf "\n"

if [[ $answer == "Y" || $answer == "y" ]]; then
    printf "This may take a while, don't turn off your computer.\n"
    bash bash/default.sh
else
    bash bash/params.sh
fi