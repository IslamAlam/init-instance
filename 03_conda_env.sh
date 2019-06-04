#!/bin/sh

# Add conda to the shell env
source /opt/anaconda/etc/profile.d/conda.sh




conda install -y -c conda-forge nodejs   # or some other way to have a recent node
conda activate

# conda environment in Jupyter Notebook
conda install -y nb_conda


# Install ipvloume and ipyleaflet
jupyter labextension install @jupyter-widgets/jupyterlab-manager
jupyter labextension install ipyvolume
jupyter labextension install jupyter-threejs

conda install -y -c conda-forge ipyleaflet
jupyter labextension install jupyter-leaflet
jupyter labextension install @jupyter-widgets/jupyterlab-manager

# Pip install Leaflet and ipyvolume
#apt install -y python3-pip

#pip3 install ipyleaflet
#jupyter nbextension enable --py --sys-prefix ipyleaflet  # can be skipped for notebook 5.3 and above
#jupyter labextension install jupyter-leaflet
#jupyter labextension install @jupyter-widgets/jupyterlab-manager

scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

curl -fsSL https://raw.githubusercontent.com/jupyterhub/jupyterhub/master/docs/environment.yml -o $scriptDir/envs/jhub_docs.yml

conda env create -f $scriptDir/envs/jhub_docs.yml
conda install -n jhub_docs -c conda-forge jupyterlab 
conda activate jhub_docs
jupyter labextension install @jupyterlab/hub-extension


echo "Script dir: $scriptDir"

conda env create -f $scriptDir/envs/mdml.yml
conda env create -f $scriptDir/envs/pcp-env.yml

conda activate mdml

ipython kernel install

conda deactivate

conda activate pcp-env
ipython kernel install
conda deactivate
