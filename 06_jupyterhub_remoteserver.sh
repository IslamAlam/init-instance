#!/bin/bash
# link: https://github.com/jupyterhub/jupyterhub/wiki/Installation-of-Jupyterhub-on-remote-server
# https://zonca.github.io/2016/04/jupyterhub-sdsc-cloud.html

# Installing Python3 (dependency of jupyterhub is on python3)
apt-get -y install python3-pip

# Install nodejs/npm
apt-get -y install npm nodejs

# Install proxy with npm (you may need to use sudo)

npm install -g configurable-http-proxy

# Install Jupyterhub (you may need to use sudo)
pip3 install jupyterhub

# Install Jupyter notebook (/upgrade) (you may need to use sudo)
pip3 install --upgrade notebook

# Create Jupyterhub configuration file
jupyterhub --generate-config /etc/jupyterhub


## Run jupyterhub as a system service

declare -a fileNames=('/lib/systemd/system/jupyterhub.service' '/etc/systemd/system/jupyterhub.service'

for file_location in "${fileNames[@]}"
do
   echo "$file_location"
   if [ -e $file_location ]; then
     echo "File $file_location already exists!"
     rm $file_location
   fi
cat > $file_location <<EOF
[Unit]
Description=Jupyterhub

[Service]
User=root
Environment="PATH=/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/anaconda/bin"
ExecStart=/usr/local/bin/jupyterhub -f /etc/jupyterhub/jupyterhub_config.py

[Install]
WantedBy=multi-user.target

EOF
   
done

# 2. systemctl daemon-reload  to load the config
systemctl daemon-reload

# 4. To ensure it runs at startup
systemctl enable jupyterhub.service

# Start with a specific config file
jupyterhub -f /etc/jupyterhub/jupyterhub_config.py

# Configure using command line options
#     jupyterhub --ip 10.0.1.2 --port 443 --ssl-key my_ssl.key --ssl-cert my_ssl.cert

<<COMMENT

 ## Installation of Jupyterhub on remote server

1.  Linux Anaconda Installation (Anaconda conveniently installs Python, the Jupyter Notebook, and other commonly used packages for scientific computing and data science. )

    *   Go to : [Continuum Analytics - Anaconda Downloads](https://www.continuum.io/download)

    *   Under Linux Anaconda Installation (copy link of 64 bit): On Terminal

        `$ wget https://repo.continuum.io/archive/Anaconda3-2018.12-Linux-x86_64.sh`

        It will download Anaconda*.sh file

    *   Installing by using following command:

        `$ bash Anaconda3-2018.12-Linux-x86_64.sh`

        Enter(many times) >> yes >> give directory or keep it as Default

2.  Installing Python3 (dependency of jupyterhub is on python3)

    `$ sudo apt-get -y install python3-pip`

3.  Install nodejs/npm

    `$ sudo apt-get -y install npm nodejs`

4.  Install proxy with npm (you may need to use `sudo`)

    `$ npm install -g configurable-http-proxy`

5.  Install Jupyterhub (you may need to use `sudo`)

    `$ pip3 install jupyterhub`

6.  Install Jupyter notebook (/upgrade) (you may need to use `sudo`)

    `$ pip3 install --upgrade notebook`

7.  Test Jupyterhub default configuration

    `$ jupyterhub --no-ssl`

    This will start session in localhost:8000

    *   Go to [http://your_ip_address:8000](http://www.example.com)

    ** Make sure that port isn't protected under Firewall of your system

8.  It is recommended to use secure SSL certificate file for the public facing interface of the proxy. To produce personal security certificates commands are as follows:

    `$ openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mykey.key -out mycert.pem`

    **Fill in the credentials.(even if you dont..It's ok!)

9.  Create Jupyterhub configuration file

    `$ jupyterhub --generate-config`
    
 '
 COMMENT
