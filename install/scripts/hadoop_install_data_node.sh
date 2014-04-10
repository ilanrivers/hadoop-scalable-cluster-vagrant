VAGRANT_INSTALL_ROOT="/vagrant/install/"
NAMENODE_HOSTNAME=$1
NAMENODE_IP=$2
HOST_FILE="/etc/hosts"
CORE_SITE_FILE="/usr/local/hadoop/etc/hadoop/core-site.xml"
SSH_DIR="/root/.ssh"

echo "Configuring DataNode to use $NAMENODE_HOSTNAME [$NAMENODE_IP]..."

# Check if entry already is in file.
if ! grep -q "HadoopNameNode" "$HOST_FILE"; then
    echo "Updating $HOST_FILE..."
    echo "$NAMENODE_IP  $NAMENODE_HOSTNAME" >> $HOST_FILE
fi

# Copy core-site.xml template
if ! grep -q "fs.default.name" "$CORE_SITE_FILE"; then
    echo "Updating $CORE_SITE_FILE..."
    sudo cp -f "${VAGRANT_INSTALL_ROOT}/templates/hadoop/datanode-core-site.xml" "$CORE_SITE_FILE"
fi

# Copy NameNode public key to DataNode authorized_keys file
echo "Adding NameNode public key to DataNode authorized_keys file"
cat ${VAGRANT_INSTALL_ROOT}/templates/ssh/*.pub >> "$SSH_DIR/authorized_keys"


