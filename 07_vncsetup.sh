#!/bin/bash

# This guide is taken from https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-vnc-on-ubuntu-18-04
apt update && apt upgrade -y

echo "Now install the Xfce desktop environment on your server"
apt install -y xfce4 xfce4-* gnome-icon-theme vnc4server tightvncserver novnc websockify python-numpy

echo "To complete the VNC server's initial configuration after installation, use the vncserver command to set up a secure password and create the initial configuration files:"
vncserver

#
echo "Killing VNC"
vncserver -kill :1

echo "Before you modify the xstartup file, back up the original:"
mv $HOME/.vnc/xstartup $HOME/.vnc/xstartup.bak

echo "Now create a new xstartup file and open it in your text editor:"
cat > $HOME/.vnc/xstartup <<EOF
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF


# The first command in the file, xrdb $HOME/.Xresources, tells VNC's GUI framework to read the server user's .Xresources file. .Xresources is where a user can make changes to certain settings of the graphical desktop, like terminal colors, cursor themes, and font rendering. The second command tells the server to launch Xfce, which is where you will find all of the graphical software that you need to comfortably manage your server.
# To ensure that the VNC server will be able to use this new startup file properly, we'll need to make it executable.
ehco "ensure that the VNC server will be able to use this new startup file properly, we'll need to make it executable."
chmod +x $HOME/.vnc/xstartup

# Now, restart the VNC server.
echo "Now, restart the VNC server."
vncserver

# You'll see output similar to this:

# Output
# New 'X' desktop is your_hostname:1

# Starting applications specified in $HOME/.vnc/xstartup
# Log file is $HOME/.vnc/your_hostname:1.log

echo "Running VNC as a System Service"

cat > /etc/systemd/system/vncserver@.service <<EOF
[Unit]
Description=Start TightVNC server at startup
After=syslog.target network.target

[Service]
Type=simple
User=ubuntu
PAMName=login
# Group=ubuntu
# WorkingDirectory=/home/ubuntu

PIDFile=/home/%u/.vnc/%H%i.pid
ExecStartPre=/bin/sh -c '/usr/bin/vncserver -kill :%i > /dev/null 2>&1 || :'
ExecStart=/usr/bin/vncserver :%i -depth 24 -geometry 1920x1080 -alwaysshared -fg
ExecStop=/usr/bin/vncserver -kill :%i

[Install]
WantedBy=multi-user.target
EOF


# Next, make the system aware of the new unit file.
# 
echo "Next, make the system aware of the new unit file."
systemctl daemon-reload

echo "# Enable the unit file.
#"
systemctl enable vncserver@1.service

# The 1 following the @ sign signifies which display number the service should appear over, in this case the default :1 as was discussed in Step 2..
# 
# Stop the current instance of the VNC server if it's still running.
# 
vncserver -kill :1

echo "# Then start it as you would start any other systemd service."

systemctl start vncserver@1

echo "# You can verify that it started with this command:
# "
systemctl status vncserver@1

echo "# If it started correctly, the output should look like this:
# 
# Output
# ● vncserver@1.service - Start TightVNC server at startup
#    Loaded: loaded (/etc/systemd/system/vncserver@.service; indirect; vendor preset: enabled)
#    Active: active (running) since Mon 2018-07-09 18:13:53 UTC; 2min 14s ago
#   Process: 22322 ExecStart=/usr/bin/vncserver -depth 24 -geometry 1280x800 :1 (code=exited, status=0/SUCCESS)
#   Process: 22316 ExecStartPre=/usr/bin/vncserver -kill :1 > /dev/null 2>&1 (code=exited, status=0/SUCCESS)
#  Main PID: 22330 (Xtightvnc)
# 
# ...
# 
# Your VNC server will now be available when you reboot the machine."

# Start your SSH tunnel again:

# ssh -L 5901:127.0.0.1:5901 -C -N -l ubuntu your_server_ip

# g@at2H1q
