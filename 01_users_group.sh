#!/bin/bash
apt install -y zip members


declare -a userNames=("lisa" "francesco" "abdallah" "islam" "yvonne" "allen" "paloma")

declare -a groupName='Team'

# Create a group from the groupName
groupadd $groupName

echo UEsFBgAAAAAAAAAAAAAAAAAAAAAAAA==  | openssl enc -d -base64 >  users.zip

for userName in "${userNames[@]}"
do

    if $userName passwd $1 > /dev/null 2>&1; then
        echo "yes the user exists"
    else
        echo "No, the user does not exist"


        echo "Welcome $userName"

    #  Start with creating a user:

        useradd -m -d /home/$userName -s /bin/bash $userName
    #
    #  Create a key pair from the client which you will use to `ssh` from:
    #
    #   ssh-keygen -t dsa
        ssh-keygen -o -t rsa -b 4096 -C "cc@$userName" -N "" -f $userName.key
        zip $userName.zip  $userName.key  $userName.key.pub 
        rm $userName.key
        rm $userName.key.pub
    #
    # Copy the public key `/home/username/.ssh/id_dsa.pub` onto the RedHat host into `/home/username/.ssh/authorized_keys`
    #
        chmod go+x  /home/$userName/
    # chmod -R 750 /home/$userName/
        rsync -a $userName.key.pub  /home/$userName/.ssh/
        cp $userName.key.pub  /home/$userName/.ssh/authorized_keys
    # Set correct permissions on the files on the RedHat host:
    #
        chown -R $userName:$userName /home/$userName/.ssh
        chmod 700 /home/$userName/.ssh
        chmod 600 /home/$userName/.ssh/authorized_keys

    # Ensure that Public Key authentication is enabled on the RedHat host:
    #
        grep  PubkeyAuthentication /etc/ssh/sshd_config
    #     echo " should output:"
    #     echo "PubkeyAuthentication yes"
    #
    # If not, change that directive to yes and restart the `sshd` service on the RedHat host.
    #
    # From the client start an `ssh` connection:
    #
    #     ssh $userName@redhathost
    #
    # It should automatically look for the key `id_dsa` in `~/.ssh/`. You can also specify an identity file using:
    #
    #     ssh -i ~/.ssh/id_dsa $userName@redhathost
        zip -g  users.zip $userName.zip
        rm $userName.zip

        echo "Add user $userName to $groupName"

        usermod -a -G $groupName $userName
    fi
done

echo "List all group members of $groupName" 
members $groupName

echo " Create shared dir "
