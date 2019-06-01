#!/bin/sh
# Go to home directory
cd ~

scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")


conda env create -f $scriptDir/envs/mdml.yml
conda env create -f $scriptDir/envs/pcp-env.yml

conda activate mdml

ipython kernel install

conda deactivate

conda activate pcp-env
ipython kernel install
conda deactivate
