#!/bin/bash
#

# Enable passwordless sudo
sudo bash -c 'cat << EOF > /etc/sudoers.d/wheel
# %wheel	ALL=(ALL)	ALL
%wheel	ALL=(ALL)	NOPASSWD: ALL
EOF'

# Increase the number of parallel downloads in dnf
sudo bash -c "echo 'max_parallel_downloads=10' >> /etc/dnf/dnf.conf"

# Update and then upgrade the OS
sudo dnf update -y
sudo dnf upgrade -y

# Update firmware if available (my servers do not have firmware to update)
sudo fwupdmgr refresh --force
sudo fwupdmgr get-updates 
if [ $? -eq 0 ]
then
  sudo fwupdmgr update
fi

# Add RPM Fusion repos
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Update system again
sudo dnf upgrade --refresh -y
sudo dnf groupupdate core -y

# Install NFS
sudo dnf install -y nfs-utils bind
sudo sed -i "s/#Domain = local.domain.edu/Domain = $(hostname | cut -f2-3 -d.)/" /etc/idmapd.conf
sudo bash -c "echo '/home/nfsshare 192.168.2.0/24(rw,no_root_squash)' >> /etc/exports"
sudo mkdir /home/nfsshare
sudo firewall-cmd --add-service=nfs
sudo firewall-cmd --runtime-to-permanent
sudo systemctl enable --now rpcbind nfs-server

# Install some packages
sudo dnf install -y unzip p7zip p7zip-plugins unrar tmate tree 

# Install some additional fonts
sudo dnf install -y 'google-roboto*' 'mozilla-fira*' fira-code-fonts

# Install Gnome Tweaks
sudo dnf install -y gnome-tweak-tool

# Enable Gnome Extensions
sudo dnf install -y chrome-gnome-shell

# Install nordvpn
sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)
read -p 'Nord Username: ' norduser
read -sp 'Nord Password: ' nordpass
sudo nordvpn login --username $norduser --password $nordpass
sudo nordvpn whitelist add subnet 192.168.2.0/24
sudo usermod -aG nordvpn $USER

# Automatically upgrade Fedora
sudo dnf install -y dnf-automatic
sudo sed -i "s/# system_name =/system_name = $(hostname)/" /etc/dnf/automatic.conf
sudo sed -i 's/# emit_via =/emit_via = motd/' /etc/dnf/automatic.conf
systemctl enable --now dnf-automatic.timer

# Install Cockpit
sudo dnf install -y cockpit cockpit-bridge cockpit-file-sharing cockpit-machines cockpit-navigator cockpit-networkmanager cockpit-ostree cockpit-packagekit cockpit-pcp cockpit-selinux cockpit-podman cockpit-storaged cockpit-system cockpit-ws
sudo firewall-cmd --add-service=cockpit
sudo firewall-cmd --runtime-to-permanent
sudo systemctl enable --now cockpit.socket

# Install Remmina
sudo dnf install -y remmina remmina-gnome-session remmina-plugins-kwallet remmina-plugins-spice remmina-plugins-www remmina-plugins-x2go

# Enable flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Gnome Extension Manager
flatpak install -y --noninteractive flathub com.mattjakeman.ExtensionManager

# Install a PDF reader
flatpak install -y --noninteractive flathub org.cubocore.CorePDF

# Install VLC
flatpak install -y --noninteractive flathub org.videolan.VLC

# Install geary - email client
#flatpak install -y --noninteractive flathub org.gnome.Geary

# Install thunderbird - email client
#flatpak install -y --noninteractive flathub org.mozilla.Thunderbird

# Install Betterbird - email client
#flatpak install -y --noninteractive flathub eu.betterbird.Betterbird

# Start podman service
sudo systemctl enable podman.service podman.socket

#Install Synology Drive Client
flatpak install -y --noninteractive flathub com.synology.SynologyDrive

# Install Signal
flatpak install -y --noninteractive flathub org.signal.Signal

# Install 1Password
sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
sudo dnf install 1password

# Remove Rhythmbox
sudo dnf remove rhythmbox

# Remove LibreOffice
sudo dnf remove libreoffice*

# Install OnlyOffice
sudo dnf install https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors.x86_64.rpm

echo "Install the following Gnome extensions using the Extensions Manager or Extensions app"
echo "  Blur my Shell"
echo "  Clipboard Indicator"
echo "  Dash to Dock"
echo "  Just Perfection"
echo "  Netspeed Simplified"
echo "  Applications Menu"
echo "  Background Logo"
echo "  Places Status Indicator"


