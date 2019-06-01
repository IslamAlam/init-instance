#!/bin/bash

source /opt/anaconda/etc/profile.d/conda.sh

conda activate base

jupyter lab --port=8888 --no-browser --ip='127.0.0.1'
