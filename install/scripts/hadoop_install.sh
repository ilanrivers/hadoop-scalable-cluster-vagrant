echo "Installing HADOOP"

cd "$VAGRANT_CACHE"
sudo tar -xzf "current-hadoop.tar.gz" --directory="$VAGRANT_INSTALL_CACHE"

cd "$VAGRANT_INSTALL_CACHE"
sudo cp -r hadoop* "/usr/local/hadoop"


