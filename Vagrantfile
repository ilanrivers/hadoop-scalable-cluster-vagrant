###############################################################################################
# Virtual Environment Configuration                                                           #
###############################################################################################

# The URL of the vagrant box
BOX_URL = "https://vagrantcloud.com/chef/centos-6.5/version/1/provider/virtualbox.box"

# Number of Data Nodes to create. 
# To run single-node mode set HADOOP_DATA_NODES to 0
HADOOP_DATA_NODES = 2

# Namenode will get IP address "X.X.X.50" if using the example below
# Datanodes will get IP addresses "X.X.X.51"..."X.X.X.52" and so on.
HADOOP_IP_BLOCK = "192.168.33.5"

# Host name of the NameNode
# If you change this name you also have to change it in the hadoop templates.
HADOOP_NAME_NODE_PREFIX = "HadoopNameNode"

# Hostname prefix for the DataNodes, a digit will be appended to the name for each data node
# Example hostnames: HadoopDataNode1, HadoopDataNode2 etc.
HADOOP_DATA_NODE_PREFIX = "HadoopDataNode"

###############################################################################################
# Vagrant configuration (Only change below this line if really necessary)                     #
###############################################################################################
Vagrant.configure("2") do |config|

    config.vm.box = "chef/centos-6.5"
    config.vm.box_url = BOX_URL
  
    config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "512"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
        vb.customize ["modifyvm", :id, "--nestedpaging", "on"]

        # needed when using the box and the openvpn at the same time
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
  
    @MASTER_HOSTNAME = "#{HADOOP_NAME_NODE_PREFIX}"
    @MASTER_IP_ADDRESS = "#{HADOOP_IP_BLOCK}0"
  
    config.vm.define "HadoopNameNode" do |hnn|

        hnn.vm.network :private_network, ip: @MASTER_IP_ADDRESS
        hnn.vm.hostname = @MASTER_HOSTNAME
        hnn.vm.synced_folder "~", "/user_home", :mount_options ["ro"]
		
		# DataNode specific provisioning
		hnn.vm.provision :shell,
			path: "install/scripts/hadoop_install_name_node.sh",
			binary: false,
			args: "#{HADOOP_DATA_NODE_PREFIX} #{HADOOP_DATA_NODES} #{HADOOP_IP_BLOCK}"
            
        hnn.vm.provision :shell,
            inline: "echo -e \"\n-------------- #{@MASTER_HOSTNAME} up and running @ #{@MASTER_IP_ADDRESS} --------------\n\""
    end
  
    (1..HADOOP_DATA_NODES).each do |i|
  
        config.vm.define "HadoopDataNode#{i}" do |hdn|
		
            @IP_ADDRESS = "#{HADOOP_IP_BLOCK}#{i}"
            @HOST_NAME = "#{HADOOP_DATA_NODE_PREFIX}#{i}"

            hdn.vm.network :private_network, ip: @IP_ADDRESS
            hdn.vm.hostname = @HOST_NAME
            
            hdn.vm.synced_folder "~", "/user_home", :mount_options ["ro"]
 
			# DataNode specific provisioning
            hdn.vm.provision :shell,
                path: "install/scripts/hadoop_install_data_node.sh",
                binary: true,
                args: "#{@MASTER_HOSTNAME} #{@MASTER_IP_ADDRESS}"
            
            hdn.vm.provision :shell,
                inline: "echo -e \"\n-------------- #{@HOST_NAME} up and running @ #{@IP_ADDRESS} --------------\n\""
            
        end
        
    end

	# Do global provisioning
    config.vm.provision :shell,
        path: "install/install.sh"
        
end

custom_vagrantfile = 'Vagrantfile.local'
load custom_vagrantfile if File.exist?(custom_vagrantfile)