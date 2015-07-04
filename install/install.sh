export VAGRANT_ROOT=/vagrant
export VAGRANT_CACHE=/vagrant/cache
export VAGRANT_INSTALL_ROOT=$VAGRANT_ROOT/install
export VAGRANT_INSTALL_CACHE=/home/vagrant/cache
export VAGRANT_HADOOP_DOWNLOAD_URL='http://ftp.nluug.nl/internet/apache/hadoop/common/hadoop-2.7.0/hadoop-2.7.0.tar.gz'

# Check for cache directory
if [ ! -d "$VAGRANT_INSTALL_CACHE" ]; then
	echo "Creating Cache DIR : $VAGRANT_INSTALL_CACHE"
    mkdir "$VAGRANT_INSTALL_CACHE"
    chmod 0777 "$VAGRANT_INSTALL_CACHE"
fi

if [ ! -d "$VAGRANT_CACHE" ]; then
    echo "Creating Cache DIR : $VAGRANT_CACHE"
    mkdir "$VAGRANT_CACHE"
    chmod 0777 "$VAGRANT_CACHE"
fi

# Change root password
echo "Setting new root password"
echo -e "root\nroot" | sudo passwd

# Hadoop Provisioning.
sh ${VAGRANT_INSTALL_ROOT}/scripts/hadoop.sh