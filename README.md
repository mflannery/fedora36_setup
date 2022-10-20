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
