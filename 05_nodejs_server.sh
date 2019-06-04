#!/bin/sh

$
# Declare input for the script 
domain="jupyterhub.ddns.net" # Setup a domain (needed for SSL certificate)
HOSTNAME="jupyterhub" # The hostname of the server


sudo apt install -y nginx

git clone https://github.com/letsencrypt/letsencrypt
cd letsencrypt
sudo service nginx stop
./letsencrypt-auto certonly --standalone -d $domain

mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bk

file_location='/etc/nginx/nginx.conf'
if [ -e $file_location ]; then
  echo "File $file_location already exists!"
else
  cat > $file_location <<EOF

user www-data;
worker_processes 4;
pid /run/nginx.pid;

events {
  worker_connections 1024;
}

http {

        include /etc/nginx/mime.types;
        default_type application/octet-stream;

    server {
        listen 80;
        server_name $HOSTNAME;
        rewrite        ^ https://$host$request_uri? permanent;
    }

    server {
        listen 443;
        client_max_body_size 50M;

        server_name $HOSTNAME;

        ssl on;
        ssl_certificate /etc/letsencrypt/live/$domain/cert.pem;
        ssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem;
        # ssl_certificate /etc/nginx/ssl/nginx.crt;
        # ssl_certificate_key /etc/nginx/ssl/nginx.key;

        ssl_ciphers "AES128+EECDH:AES128+EDH";
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_prefer_server_ciphers on;
        ssl_session_cache shared:SSL:10m;
        add_header Strict-Transport-Security "max-age=63072000; includeSubDomains";
        add_header X-Content-Type-Options nosniff;
        ssl_stapling on; # Requires nginx >= 1.3.7
        ssl_stapling_verify on; # Requires nginx => 1.3.7
        resolver_timeout 5s;

        # Expose logs to "docker logs".
        # See https://github.com/nginxinc/docker-nginx/blob/master/Dockerfile#L12-L14
        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;

        #location ~ /(user-[a-zA-Z0-9]*)/static(.*) {
        #    alias /usr/local/lib/python3.4/dist-packages/notebook/static/$2;
        #}

        location / {
            proxy_pass http://localhost:8000;

            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

            proxy_set_header X-NginX-Proxy true;
        }

        location ~* /(user/[^/]*)/(api/kernels/[^/]+/channels|terminals/websocket)/? {
            proxy_pass http://localhost:8000;

            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

            proxy_set_header X-NginX-Proxy true;

            # WebSocket support
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_read_timeout 86400;

        }
    }

}

EOF
fi



