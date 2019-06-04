#!/bin/sh

# This script will run all sciprts in sqeuecne to configure the virtual machine

scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")


echo "Script dir: $scriptDir"


read -p "Please enter group of usres < mdml || lab >: " group

read -p "Please enter the authentication method of users < pass || ssh >: " auth_method

echo "Please enter in the next line the password for the users:"
while true; do
    read -s -p "Password: " password
    echo
    read -s -p "Password (again): " password2
    echo
    [ "$password" = "$password2" ] && break
    echo "Please try again"
done


chmod +x $scriptDir

bash $scriptDir/01_users_group.sh -m $auth_method -g $group -p '$password'

bash $scriptDir/02_anaconda.sh

bash $scriptDir/03_conda_env.sh

bash $scriptDir/04_cp_src_users.sh

bash $scriptDir/05_nodejs_server.sh

bash $scriptDir/06_jupyterhub_remoteserver.sh
