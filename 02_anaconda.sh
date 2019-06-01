#!/bin/sh
# Go to home directory
cd ~

# https://stackoverflow.com/questions/22510705/get-the-latest-download-link-programmatically

# Determine latest version:
latestVer=$(curl 'https://repo.anaconda.com/archive/' | 
   grep -oP 'href="Anaconda3-\K[0-9]+\.[0-9]+' | 
   sort -t. -rn -k1,1 -k2,2 | head -1)

# Echo latest version:
echo "Anaconda3-${latestVer}-Linux-x86_64.sh" 
# Download latest versanaconda-navigatorion:
# curl "https://repo.anaconda.com/archive/Anaconda3-${latestVer}-Linux-x86_64.sh" > Anaconda3-latest-Linux-x86_64.sh

curl "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" > Anaconda3-latest-Linux-x86_64.sh

bash Anaconda3-latest-Linux-x86_64.sh -b -p /opt/anaconda
rm Anaconda3-latest-Linux-x86_64.sh
# echo '. /opt/anaconda/etc/profile.d/conda.sh' >> ~/.bashrc 

sudo ln -s /opt/anaconda/etc/profile.d/conda.sh /etc/profile.d/conda.sh
source /etc/profile.d/conda.sh

# Refresh basically
source $HOME/.bashrc
conda init

# Refresh basically
source $HOME/.bashrc
conda config --set auto_activate_base false

# Refresh basically
source $HOME/.bashrc

conda update conda
#conda install -c anaconda anaconda-navigator 

source /etc/profile.d/conda.sh

echo "Installation is complete :)"
