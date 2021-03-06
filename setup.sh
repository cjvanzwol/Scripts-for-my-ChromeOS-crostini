#! /bin/sh
#################################################
# This script should be run after fresh install #
#################################################
# variables & functions
source $( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )/functions.sh

##########################
# Start installing stuff #
##########################
title "Starting base setup"

if [ -f $PREFIX_/.base_done ]; then
    echo "Base-install has already been run. (remove .base_done to rerun)"
else
    FASE="base"
    if [[ $OS != "NAS" ]]; then
        # For Debian(-like) systems
        subtitle "Change password for $USER"
        sudo passwd $USER

        if [[ $OS == "ChromeOS" ]]; then
            subtitle "Upgrade container"
            sudo bash /opt/google/cros-containers/bin/upgrade_container
        else
            subsubtitle "Updating system"
            sudo apt-get update -q
            sudo apt-get upgrade -qq
            sudo apt-get dist-upgrade -y
        fi
        #sudo apt autoremove --purge -qq
        
        subtitle "Writing list of base-packages to ~/.base-packages"
        sudo apt list --installed > ~/.base-packages
        
        subtitle "Adding rules to apt.conf.d for minimal installation packages"
        cpfile 99_norecommends /etc/apt/apt.conf.d
        
        subtitle "Installing base-packages"
        #sudo apt --fix-broken install -y
        sudo apt-get install -qq nano #git
        
        if [[ $OS == "ChromeOS" ]]; then
            sudo apt-get -qq install mesa-utils

            install --dep gh
            # setting up git
            #ghcli=/home/linuxbrew/.linuxbrew/bin/gh
            #read -p "Enter Github username: " ghu
            [[ -z $(git config --get user.email) ]] && read -p "Enter e-mail adres for git [you@example.com]: " gite && git config --global user.email "$gite"
            [[ -z $(git config --get user.name) ]] && read -p "Enter name for git [John Doe]: " gitn && git config --global user.name "$gitn"
            #cloneRepo $ghu

        elif [[ $OS == "OSMC" ]]; then
            echo "No specific additional packages specified for $OS packages"
        fi
    elif $OS == "NAS"; then
        # For Synology DSM
        echo "no initial setup defined for $OS: nothing to do"
    fi

    # flagging base is done with empty file
    touch $PREFIX_/.base_done
    echo "--- Base setup DONE ---"
fi

###########
# PACKGES #
###########
title "Choose additional packages to install"

case $OS in
  ChromeOS)
    install gimp inkscape jupyterlab vscode firefox google-chrome docker adb fastboot
    ;;
  OSMC)
    install pi-hole gmediarender
    ;;
  synology_monaco_ds216play | nas)
    install sickbeard couchpotato headphones
    ;;
  *)
    install nfs-client smb-server
    ;;
esac

title "Setup and installs are DONE. Exitting now."
exit 0