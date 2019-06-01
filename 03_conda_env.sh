#!/bin/sh
# Go to home directory
cd ~

conda env create -f envs/mdml.yml
conda env create -f envs/pcp-env.yml

conda activate mdml

ipython kernel install

conda deactivate

conda activate pcp-env
ipython kernel install
conda deactivate
