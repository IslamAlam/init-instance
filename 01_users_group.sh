#!/bin/bash
apt install -y zip members



declare -a userNames1=("lisa" "francesco" "abdallah" "islam" "yvonne" "allen" "paloma")

declare -a userNames2=("louise" "xianbin" "islam" "magdalena")

declare -a groupName='Team'

usage() { echo "Usage: $0 [-m <ssh||pass>] [-p <password as string>]  [-g <mdml||lab>] []" 1>&2; exit 1; }


while getopts ":m:p:g:" o; do
    case "${o}" in
        m)
            m=${OPTARG}
            #((s == 45 || s == 90)) || usage
            echo "The -m method of login is: ${OPTARG}"
            ;;
        p)
            PASSWORD=${OPTARG}
            echo "The password is ${OPTARG}"
            ;;
        g)
            g=${OPTARG}
            echo "You have choosen group -g: ${OPTARG}"
            ;;
        *)
            usage
            ;;
    esac
done

case "$g" in 
    *mdml*)
        # Do stuff
        echo "The created users will be for MDML: $userNames1"
        userNames=$userNames1
        ;;
    *lab*)
      echo "The created users will be for TUM-Data-Lab: $userNames2"
      userNames=$userNames2
      ;;
#    centos|rhel)
#      echo "Hey! It is my favorite Server OS!"
#      ;;
#    windows)
#      echo "Very funny..."
#      ;; 
    *)
      echo "Hmm, i do not know this input :("
      ;;
esac

# Create a group from the groupName
groupadd $groupName
if [ -z $m ]
then
  echo "sorry you didn't give me a value for -m as <ssh||pass>"
  exit 2
elif [[ $m == *"ssh"* ]] #[[ ! -z $m ]] && 
then  
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
    
elif [[ $m == *"pass"* ]] # [[ ! -z $m  ]] &&
then 

    for userName in "${userNames[@]}"
    do
        if $userName passwd $1 > /dev/null 2>&1; then
            echo "yes the user exists"
        else
            echo "No, the user $userName does not exist"
            echo "creating new user: $userName"
            echo $userName:$PASSWORD::::/home/$userName:/bin/bash | sudo newusers

            #  Start with creating a user:

            # useradd -m -d /home/$userName -s /bin/bash $userName

            echo "Add user $userName to $groupName"

            usermod -a -G $groupName $userName
        fi
    done
fi

echo "List all group members of $groupName" 
members $groupName

echo " Create shared dir "

