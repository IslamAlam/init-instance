#!/bin/sh

# Add conda to the shell env
source /opt/anaconda/etc/profile.d/conda.sh


# conda install -y -c conda-forge nodejs   # or some other way to have a recent node
# conda activate

# conda environment in Jupyter Notebook
# conda install -y nb_conda


# Pip install Leaflet and ipyvolume
#apt install -y python3-pip

#pip3 install ipyleaflet
#jupyter nbextension enable --py --sys-prefix ipyleaflet  # can be skipped for notebook 5.3 and above
#jupyter labextension install jupyter-leaflet
#jupyter labextension install @jupyter-widgets/jupyterlab-manager

scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")


#####################################
# Jupyterlab section

conda env create -f $scriptDir/envs/jhub_docs.yml
# conda install -y -n jhub_docs -c conda-forge jupyterlab

conda activate jupyterhub

npm install -g configurable-http-proxy

jupyter labextension install @jupyterlab/hub-extension
jupyter labextension install @jupyter-widgets/jupyterlab-manager
jupyter labextension install ipyvolume
jupyter labextension install jupyter-threejs
jupyter labextension install jupyter-leaflet
jupyter labextension install @jupyter-widgets/jupyterlab-manager

# JupyterLab LaTeX
jupyter labextension install @jupyterlab/latex

# jupyterlab-drawio
jupyter labextension install jupyterlab-drawio

# jupyterlab-toc A Table of Contents
jupyter labextension install @jupyterlab/toc


# Go to definition extension for JupyterLab
jupyter labextension install @krassowski/jupyterlab_go_to_definition

# jupyterlab_code_formatter
pip install black
jupyter labextension install @ryantam626/jupyterlab_code_formatter
pip install jupyterlab_code_formatter
jupyter serverextension enable --py jupyterlab_code_formatter
# Remember to install one of the supported formatters (it's in the next section)

# jupyterlab-git
jupyter labextension install @jupyterlab/git
pip install jupyterlab-git
jupyter serverextension enable --py jupyterlab_git

#####################################


echo "Script dir: $scriptDir"

conda env create -f $scriptDir/envs/mdml.yml
conda env create -f $scriptDir/envs/pcp-env.yml

conda activate mdml

ipython kernel install

conda deactivate

conda activate pcp-env
ipython kernel install
conda deactivate
