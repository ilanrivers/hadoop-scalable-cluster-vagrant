VAGRANT_INSTALL_ROOT="/vagrant/install/"
DATANODE_HOSTNAME_PREFIX=$1
DATANODE_COUNT=$2
IP_PREFIX=$3
NAMENODE_IP="$IP_PREFIX"
NAMENODE_IP+="0"
NAMENODE_HOSTNAME=`hostname`
HOST_FILE=/etc/hosts
HADOOP_DATANODE_FILE="$HADOOP_PREFIX/etc/hadoop/slaves"
CORE_SITE_FILE="$HADOOP_PREFIX/etc/hadoop/core-site.xml"
SSH_DIR="/root/.ssh"
SSH_COPY_ID_SCRIPT="/root/ssh-copy-id.sh"

echo "----- Configuring $NAMENODE_HOSTNAME[$NAMENODE_IP] -----"

# Clean up host file because vagrant ads entry for host which we do not want.
echo "127.0.0.1  localhost localhost.localdomain localhost4 localhost4.localdomain4\n
::1  localhost localhost.localdomain localhost6 localhost6.localdomain6\n" > $HOST_FILE
echo "$NAMENODE_IP $NAMENODE_HOSTNAME" >> $HOST_FILE

# Add public/private key specific for NameNode
sudo cp ${VAGRANT_INSTALL_ROOT}/templates/ssh/* "$SSH_DIR/"
chmod 600 "$SSH_DIR/id_rsa_hadoop"
chmod 644 "$SSH_DIR/id_rsa_hadoop.pub"

# Update config Identity
if ! grep -q "hadoop" "$SSH_DIR/config"; then
    echo "-- Adding Identity file for id_rsa_hadoop public key..."
    sudo echo "IdentityFile ~/.ssh/id_rsa_hadoop" >> "$SSH_DIR/config"
fi

# Remove script if exists
sudo rm -f "$SSH_COPY_ID_SCRIPT"
echo -e "# Run this script to copy the id_rsa public keys to the DataNodes." >> "$SSH_COPY_ID_SCRIPT"

# Reset hadoop slaves file, in case some data nodes were removed.
echo "-- Resetting file \"$HADOOP_DATANODE_FILE\""
echo "localhost" > $HADOOP_DATANODE_FILE

for (( i=1; i<=DATANODE_COUNT; i++ ))
do
    DATANODE="$DATANODE_HOSTNAME_PREFIX$i"
    DATANODE_IP="$IP_PREFIX$i"
    echo "-- Checking DataNode $DATANODE[$DATANODE_IP] --"
	
    # Check if NameNode can find DataNode
    if ! grep -q "$DATANODE" "$HOST_FILE"; then
        echo "-- Adding $DATANODE to NameNode $HOST_FILE..."
        echo "$DATANODE_IP $DATANODE $DATANODE" >> $HOST_FILE
    fi
	
    # Check if DataNode is registered as DataNode
    if ! grep -q "$DATANODE" "$HADOOP_DATANODE_FILE"; then
        echo "-- Adding $DATANODE as DataNode to $HADOOP_DATANODE_FILE..."
        echo "$DATANODE" >> $HADOOP_DATANODE_FILE
    fi
	
    # Add script to ssh-copy the Name Node's public key over to the Data Nodes.
    # This will copy the generated public key. This is only optional because the
    # public key from the template directory should already be authorized.
    SSH_COPY_COMMAND="ssh-copy-id -i /root/.ssh/id_rsa.pub root@$DATANODE"
    echo "$SSH_COPY_COMMAND" >> "$SSH_COPY_ID_SCRIPT"
    
done

# Copy core-site.xml template
if ! grep -q "fs.default.name" "$CORE_SITE_FILE"; then
    echo "-- Updating $CORE_SITE_FILE..."
    sudo cp -f "${VAGRANT_INSTALL_ROOT}/templates/hadoop/namenode-core-site.xml" "$CORE_SITE_FILE"
fi

# Create start script
echo "-- Creating Run-Once script..."
echo -e "hdfs namenode -format" >> "/root/hdfs-run-once.sh"
