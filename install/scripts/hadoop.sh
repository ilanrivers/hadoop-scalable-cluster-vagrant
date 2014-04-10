

# Check if we have already downloaded the tar.
if [ ! -d "/usr/local/hadoop" ]; then
	
	if [ -f "$VAGRANT_CACHE/hadoop-2.3.0.tar.gz" ]; then
		sh ${VAGRANT_INSTALL_ROOT}/scripts/hadoop_install.sh
	else
		echo "Downloading HADOOP"
        cd "$VAGRANT_CACHE"
		wget "$VAGRANT_HADOOP_DOWNLOAD_URL"
		sh ${VAGRANT_INSTALL_ROOT}/scripts/hadoop_install.sh
	fi
	
fi

# Install JAVA
yum -y install \
 java-1.7.0-openjdk.x86_64

# Install environment  
echo "Copying Bashrc..."
sudo cp ${VAGRANT_INSTALL_ROOT}/templates/.bashrc ~

# Create public/private key for root user
SSH_DIR="/root/.ssh"
if [ ! -f "$SSH_DIR/authorized_keys" ]; then

sudo rm -rf "$SSH_DIR"
# 3 empty lines because ssh-keygen ask 3 questions and we want to use the defaults
echo -e "\n\n\n" | ssh-keygen

# Add public key so we do not need to authenticate to login to localhost
sudo cat "$SSH_DIR/id_rsa.pub" > "$SSH_DIR/authorized_keys"

# We do not want to be prompted to verify the host
sudo echo "StrictHostKeyChecking no" >> "$SSH_DIR/config"
sudo echo "IdentityFile ~/.ssh/id_rsa" >> "$SSH_DIR/config"
fi