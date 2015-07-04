sudo rpm -i http://mirror.karneval.cz/pub/linux/fedora/epel/6/i386/epel-release-6-8.noarch.rpm
sudo yum -y install docker-io
sudo chkconfig docker on
sudo service docker start