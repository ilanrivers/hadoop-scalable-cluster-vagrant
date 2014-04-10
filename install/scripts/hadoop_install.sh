echo "Installing HADOOP"
cd "$VAGRANT_CACHE"
tar -xzf "hadoop-2.3.0.tar.gz" --directory="$VAGRANT_INSTALL_CACHE"
cd "$VAGRANT_INSTALL_CACHE"
cp -r "hadoop-2.3.0" "/usr/local/hadoop"


