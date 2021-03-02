#! /bin/sh
# preload functions
source $(find ~ -name Linux-install-scripts 2>/dev/null)/functions.sh
[[ $FASE == "" ]] && FASE=firefox

# Installing package
echo "Installing Firefox"
install --dep $1 flatpak
flatpak install -y firefox
echo "FIREFOX DONE"
