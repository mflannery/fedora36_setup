# Fedora 36 Workstation base setup
How I set up a new Fedora 36 workstation

This is a simple bash script for setting up a new Fedora 36 Workstation. I use Fedora servers in my home lab for virtual machines and container but I also needed a GUI so I created one of my servers to be a Fedora 36 Workstation.  The setup.sh script is what I use to set up the workstation for my preferences and install the base applications I want installed.  

In this script I do the following:

* increase the number of parallel downloads for DNF so installs go faster.
* update the OS to the latest versions and packages.
* look for, download and then update the firmware to the latest versions if any firmware is available.
* add the rpm fusion free and non-free repositories
* upgrade the OS and group update core
* install and configure an NFS server
* install unzip, p7unzip, unrar, tmate (securely share terminal) and tree (list files in a tree structure)
* install some new fonts
* install the gnome-tweak-tool
* install gnome extensions into firefox
* install, log into and configure nordvpn <THIS WILL NEED TO BE ADJUSTED AS NEEDED>
* set up fedora to automatically apply updates
* install and start cockpit
* add the flathub repository to flatpak
* install a gnome extensions app
* install another gnome extensions app
* install a PDF reader
* install VLC
* commented out - install geary email client
* commented out - install thunderbird email client
* commented out - install betterbird email client
* start the podman service
* install synology drive client for sync'ing files to my synology 
* install signal
* install 1password

Some Gnome extensions I like include:
* Blur my Shell
* Clipboard Indicator
* Dash to Dock
* Just Perfection
* Netspeed Simplified
* Applications menu
* Background logo
* Places status indicator

From here I will install other packages based on my needs. 
  
# Fedora 36 headless VM server setup
How I create servers to run virtual machines
  
First install a Fedora server or Fedora minimal server.  Be sure to also install the optional headless management software packages (cockpit)

Next enable and start cockpit
  
```sudo systemctl enable --now cockpit.socket```
  
Generate ssh keys and copy them to any other servers in the cluster.
  
```ssh-keygen```
  
```ssh-copy-id <user>@vmserver.home.io```
  
Install packages for running virtual machines with the KVM hypervisor
  
```sudo dnf -y install bridge-utils libvirt virt-install qemu-kvm```

Edit /etc/sudoers and comment out %wheel and uncomment the #%wheel with NOPASSWD so you can do passwordless ssh
  
```sudo EDITOR=vi visudo```

Install some more hypervisor utilities
  
```sudo dnf install libvirt-devel virt-top libguestfs-tools guestfs-tools```

Enable and start libvirtd
  
```sudo systemctl enable --now libvirtd```

Start sshd 
  
```sudo systemctl enable --now sshd```

Do an upgrade to make sure you have all the latest packages
  
```sudo dnf upgrade -y```
  
Add cockpit and ssh to the firewall and make that change permanent
  
```sudo firewall-cmd --add-service=cockpit```
  
```sudo firewall-cmd --runtime-to-permanent```
  
Install some additional cockpit modules to add functionality to cockpit
  
```sudo dnf install cockpit-bridge cockpit-file-sharing cockpit-machines cockpit-navigator cockpit-networkmanager cockpit-ostree cockpit-packagekit cockpit-pcp cockpit-podman cockpit-selinux cockpit-storaged cockpit-system cockpit-ws -y```

Reboot the system

```sudo reboot```
  
Access cockpit by going to ```https://<server name or IP address>:9090```
  
If you have only one VM Server, you can manage the vms from cockpit.  If you want to manage the vms remotely with virt-manager, you will need to install virt-manager on a system that has a GUI (Linux Gnome or MacOS for example) and you will need to copy your ssh public key to the root user account on the vmserver.  Its easiest to do this in cockpit/accounts.  Once that is done, create your connection with virt-manager and you can access the console window from that app.
