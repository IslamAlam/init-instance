# init-instance

Repo clone:

  `git clone https://github.com/IslamAlam/init-instance.git scripts`
  
  To run all the scripts one time: run the following commnad
  
  `sudo bash ./scripts/00_run_all.sh`


To run it one by one, please run the following:

  `chmod +x scripts/`

  `sudo bash ./scripts/01_users_group.sh -m pass -g lab -p 'D6!o7PuEid2JvS*EeC%zU7qKWzn!%q'`

  `sudo bash ./scripts/02_anaconda.sh`
  
  `sudo bash ./scripts/03_conda_env.sh`
  
  `sudo bash ./scripts/04_cp_src_users.sh`
  
  `sudo bash ./scripts/05_nodejs_server.sh`
  
  `sudo bash ./scripts/06_jupyterhub_remoteserver.sh`
  
  ` `
  
  ## Credit
  1. [Installation of Jupyterhub on remote server](https://github.com/jupyterhub/jupyterhub/wiki/Installation-of-Jupyterhub-on-remote-server)
  
  2. [JupyterLab on JupyterHub](https://jupyterlab.readthedocs.io/en/stable/user/jupyterhub.html#jupyterlab-on-jupyterhub)
  
  3. [Installation JupyterLab](https://jupyterlab.readthedocs.io/en/stable/getting_started/installation.html)
  
  4. [ Jupyterhub NGINX reverse proxy with SSL, replace HOSTNAME with a hostname or _ ](https://gist.github.com/zonca/08c413a37401bdc9d2a7f65a7af44462)
  
  5. [nb_conda_kernels](https://github.com/Anaconda-Platform/nb_conda_kernels)
  
  6. [ A service (init.d) script for jupyterhub ](https://gist.github.com/zonca/aaeaf3c4e7339127b482d759866e5f39)
  
  7. [Deploy Jupyterhub on a Virtual Machine for a Workshop](https://zonca.github.io/2016/04/jupyterhub-sdsc-cloud.html)
  
  8. [Quick Jupyterhub deployment for workshops with pre-built image](https://zonca.github.io/2016/04/jupyterhub-image-sdsc-cloud.html)
  9.[Installation of Jupyterhub on remote server](https://github.com/jupyterhub/jupyterhub/wiki/Installation-of-Jupyterhub-on-remote-server)
  
