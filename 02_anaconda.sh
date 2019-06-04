#!/bin/sh
# Go to home directory
cd ~

# https://stackoverflow.com/questions/22510705/get-the-latest-download-link-programmatically
# https://docs.anaconda.com/anaconda/install/silent-mode/

# Determine latest version:
latestVer=$(curl 'https://repo.anaconda.com/archive/' | 
   grep -oP 'href="Anaconda3-\K[0-9]+\.[0-9]+' | 
   sort -t. -rn -k1,1 -k2,2 | head -1)

# Echo latest version:
echo "Anaconda3-${latestVer}-Linux-x86_64.sh" 
# Download latest versanaconda-navigatorion:
curl "https://repo.anaconda.com/archive/Anaconda3-${latestVer}-Linux-x86_64.sh" > Anaconda3-latest-Linux-x86_64.sh

# curl "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" > Anaconda3-latest-Linux-x86_64.sh

# Installing in silent mode
bash Anaconda3-latest-Linux-x86_64.sh -f -b -p /opt/anaconda

# To run the silent installation of Miniconda for macOS or Linux, specify the -b and -p arguments of the bash installer. The following arguments are supported:

# -b—Batch mode with no PATH modifications to ~/.bashrc. Assumes that you agree to the license agreement. Does not edit the .bashrc or .bash_profile files.
# -p—Installation prefix/path.
# -f—Force installation even if prefix -p already exists.


rm Anaconda3-latest-Linux-x86_64.sh

# The installer will not prompt you for anything, including setup of your shell to activate conda. To add this activation in your current shell session:
eval "$(/opt/anaconda/bin/conda shell.bash hook)"

# With this activated shell, you can then install conda’s shell functions for easier access in the future:
conda init

# If you’d prefer that conda’s base environment not be activated on startup, set the auto_activate_base parameter to false:

conda config --set auto_activate_base false

conda update conda
# echo '. /opt/anaconda/etc/profile.d/conda.sh' >> ~/.bashrc 

# sudo ln -s /opt/anaconda/etc/profile.d/conda.sh /etc/profile.d/conda.sh
# source /etc/profile.d/conda.sh

# Refresh basically
# source $HOME/.bashrc
# conda init

# Refresh basically
# source $HOME/.bashrc

# Refresh basically
# source $HOME/.bashrc


#conda install -c anaconda anaconda-navigator 

# source /etc/profile.d/conda.sh

echo "Installation is complete :)"
