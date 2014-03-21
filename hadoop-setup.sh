# Author : Luc Demierre

cd ~
sudo apt-get update

# Download java jdk
sudo apt-get install openjdk-7-jdk
cd /usr/lib/jvm
sudo ln -s java-7-openjdk-amd64 jdk

# Uncommment to install ssh
sudo apt-get install openssh-server

# Add hadoop user
sudo addgroup hadoop
sudo adduser --ingroup hadoop hduser
sudo adduser hduser sudo

# Generate keys
sudo -u hduser ssh-keygen -t rsa -P
sudo sh -c 'cat /home/hduser/.ssh/id_rsa.pub >> /home/hduser/.ssh/authorized_keys'
ssh localhost

# Download Hadoop and set permissons
cd ~
if [ ! -f hadoop-2.3.0.tar.gz ]; then
    wget http://archive.apache.org/dist/hadoop/core/hadoop-2.3.0/hadoop-2.3.0.tar.gz
fi
sudo tar vxzf hadoop-2.3.0.tar.gz -C /usr/local
cd /usr/local
sudo mv hadoop-2.3.0 hadoop
sudo chown -R hduser:hadoop hadoop

# Hadoop variables
sudo sh -c 'touch /home/hduser/.bashrc'
sudo sh -c 'echo export JAVA_HOME=/usr/lib/jvm/jdk >> /home/hduser/.bashrc'
sudo sh -c 'echo export HADOOP_INSTALL=/usr/local/hadoop >> /home/hduser/.bashrc'
sudo sh -c 'echo export HADOOP_PREFIX=/usr/local/hadoop >> /home/hduser/.bashrc'
sudo sh -c 'echo export PATH=\$PATH:\$HADOOP_INSTALL/bin >> /home/hduser/.bashrc'
sudo sh -c 'echo export PATH=\$PATH:\$HADOOP_INSTALL/sbin >> /home/hduser/.bashrc'
sudo sh -c 'echo export HADOOP_MAPRED_HOME=\$HADOOP_INSTALL >> /home/hduser/.bashrc'
sudo sh -c 'echo export HADOOP_COMMON_HOME=\$HADOOP_INSTALL >> /home/hduser/.bashrc'
sudo sh -c 'echo export HADOOP_HDFS_HOME=\$HADOOP_INSTALL >> /home/hduser/.bashrc'
sudo sh -c 'echo export YARN_HOME=\$HADOOP_INSTALL >> /home/hduser/.bashrc'
sudo sh -c 'echo export HADOOP_YARN_HOME=\$HADOOP_INSTALL >> /home/hduser/.bashrc'
sudo sh -c 'echo export HADOOP_COMMON_LIB_NATIVE_DIR=\$\{HADOOP_INSTALL\}/lib/native >> /home/hduser/.bashrc'
sudo sh -c 'echo export HADOOP_OPTS=\"-Djava.library.path=\$HADOOP_INSTALL/lib\" >> /home/hduser/.bashrc'
sudo sh -c 'echo export HADOOP_CONF_DIR=$HADOOP_INSTALL/etc/hadoop'

# Modify JAVA_HOME
cd /usr/local/hadoop/etc/hadoop
sudo -u hduser sed -i.bak s=\${JAVA_HOME}=/usr/lib/jvm/jdk/=g hadoop-env.sh
pwd

# Check that Hadoop is installed
/usr/local/hadoop/bin/hadoop version