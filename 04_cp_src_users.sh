#!/bin/sh

scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

file=01_start_jupyter.sh
filePath=$scriptDir/src/01_start_jupyter.sh

# First command-line arg is the file to be copied
for homedir in /home/* ; do 
    if [ -d "$homedir" ] ; then
#     echo "cp $file $homedir/"
     cp $filePath $homedir/
         user=$(ls -ld $homedir | awk '{print $3}')
         chown --verbose $user:$user $homedir/$file
    fi
done
