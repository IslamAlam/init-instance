#!/bin/sh

scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

conda install -c -y conda-forge nodejs   # or some other way to have a recent node
jupyter labextension install @jupyter-widgets/jupyterlab-manager
jupyter labextension install ipyvolume
jupyter labextension install jupyter-threejs

conda install -c -y conda-forge ipyleaflet
jupyter labextension install jupyter-leaflet
jupyter labextension install @jupyter-widgets/jupyterlab-manager

# Pip install Leaflet and ipyvolume
#apt install -y python3-pip

#pip3 install ipyleaflet
#jupyter nbextension enable --py --sys-prefix ipyleaflet  # can be skipped for notebook 5.3 and above
#jupyter labextension install jupyter-leaflet
#jupyter labextension install @jupyter-widgets/jupyterlab-manager

# Go to home directory
# cd ~
source /opt/anaconda/etc/profile.d/conda.sh


echo "Script dir: $scriptDir"

conda env create -f $scriptDir/envs/mdml.yml
conda env create -f $scriptDir/envs/pcp-env.yml

conda activate mdml

ipython kernel install

conda deactivate

conda activate pcp-env
ipython kernel install
conda deactivate
