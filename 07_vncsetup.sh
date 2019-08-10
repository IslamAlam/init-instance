#!/bin/bash

# This guide is taken from https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-vnc-on-ubuntu-18-04
apt update && apt upgrade -y

echo "Now install the Xfce desktop environment on your server"
apt install -y ubuntu-desktop xfce4 xfce4-goodies xfce4-* gnome-icon-theme tightvncserver novnc websockify python-numpy
# vnc4server

echo -n -e '\x8f\x03\x91\x42\xa8\x3b\xfc\x06' > $HOME/.vnc/passwd 

echo "To complete the VNC server's initial configuration after installation, use the vncserver command to set up a secure password and create the initial configuration files:"
vncserver

#
echo "Killing VNC"
vncserver -kill :*

echo "Before you modify the xstartup file, back up the original:"
mv $HOME/.vnc/xstartup $HOME/.vnc/xstartup.bak

echo "Now create a new xstartup file and open it in your text editor:"
cat > $HOME/.vnc/xstartup <<EOF
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources

xsetroot -solid grey
vncconfig -iconic &
vncconfig -nowin &

x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
x-session-manager &  xfdesktop & xfce4-panel &
xfce4-menu-plugin &
xfsettingsd &
xfconfd &
xfwm4 &

EOF

# cat > $HOME/.vnc/config <<EOF
# geometry=1920x1084
# depth=24
# EOF

# chown -R $USER ~/.Xauthority
chown -R ubuntu ~/.Xauthority
chown -R ubuntu ~/.vnc/xstartup

# For gnome 
# https://linode.com/docs/applications/remote-desktop/install-vnc-on-ubuntu-16-04/#connect-to-vnc-from-your-desktop

# sudo apt-get install ubuntu-desktop gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal

# sudo apt-get install --no-install-recommends ubuntu-desktop gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal

# #!/bin/sh
# 
# # Uncomment the following two lines for normal desktop:
# # unset SESSION_MANAGER
# # exec /etc/X11/xinit/xinitrc
# 
# [ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
# [ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
# xsetroot -solid grey
# vncconfig -iconic &
# x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
# x-window-manager &
# 
# gnome-panel &
# gnome-settings-daemon &
# metacity &
# nautilus &

# The first command in the file, xrdb $HOME/.Xresources, tells VNC's GUI framework to read the server user's .Xresources file. .Xresources is where a user can make changes to certain settings of the graphical desktop, like terminal colors, cursor themes, and font rendering. The second command tells the server to launch Xfce, which is where you will find all of the graphical software that you need to comfortably manage your server.
# To ensure that the VNC server will be able to use this new startup file properly, we'll need to make it executable.
echo "ensure that the VNC server will be able to use this new startup file properly, we'll need to make it executable."
chmod u+x $HOME/.vnc/xstartup

# Now, restart the VNC server.
echo "Now, restart the VNC server."
# vncserver

# You'll see output similar to this:

# Output
# New 'X' desktop is your_hostname:1

# Starting applications specified in $HOME/.vnc/xstartup
# Log file is $HOME/.vnc/your_hostname:1.log

echo "Running VNC as a System Service"

# cat > /etc/systemd/system/vncserver@.service <<EOF
# [Unit]
# Description=Start TightVNC server at startup
# After=syslog.target network.target
# 
# [Service]
# Type=simple
# User=ubuntu
# PAMName=login
# # Group=ubuntu
# # WorkingDirectory=/home/ubuntu
# 
# PIDFile=/home/%u/.vnc/%H%i.pid
# ExecStartPre=/bin/sh -c '/usr/bin/vncserver -kill :%i > /dev/null 2>&1 || :'
# ExecStart=/usr/bin/vncserver :%i -geometry 1920x1080 -alwaysshared -fg
# ExecStop=/usr/bin/vncserver -kill :%i
# 
# [Install]
# WantedBy=multi-user.target
# EOF


# Next, make the system aware of the new unit file.
# 
echo "Next, make the system aware of the new unit file."
# systemctl daemon-reload

echo "# Enable the unit file.
#"
# systemctl enable vncserver@1.service

# The 1 following the @ sign signifies which display number the service should appear over, in this case the default :1 as was discussed in Step 2..
# 
# Stop the current instance of the VNC server if it's still running.
# 
# vncserver -kill :1

echo "# Then start it as you would start any other systemd service."

# systemctl start vncserver@1

echo "# You can verify that it started with this command:
# "
# systemctl status vncserver@1

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

# My recipe for service obliteration (be careful with the rm statements!)
# 
# sudo systemctl stop vncserver@1
# sudo systemctl disable vncserver@1
# sudo rm /etc/systemd/system/vncserver@.service
# sudo rm /etc/systemd/system/vncserver@.service symlinks that might be related
# sudo systemctl daemon-reload
# sudo systemctl reset-failed



if [[ $(crontab -l | egrep -v "^(#|$)" | grep -q '/usr/bin/vncserver'; echo $?) == 1 ]]
then
    echo $(crontab -l ; echo '@reboot /usr/bin/vncserver -depth 32 -geometry 1920x1080') | crontab -
fi


cd /etc/ssl
openssl req -x509 -nodes -newkey rsa:2048 -keyout novnc.pem -out novnc.pem -days 365
chmod 644 novnc.pem

websockify -D --web=/usr/share/novnc/ --cert=/etc/ssl/novnc.pem 6080 localhost:5901

# Point your browser to https://(server’s hostname or IP address):6080/vnc.html and login with VNC password.

