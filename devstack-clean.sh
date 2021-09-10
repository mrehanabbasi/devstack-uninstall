#!/bin/bash
# Pls note if you have added new services, please include them here, I gave example for core services to uninstall
# Make sure that you are logged in as root or any other user with sudo privileges
# root directory at $DEST
# Assuming that openstack git repository was cloned in /opt/stack
# Change the Path as appropriate, recommend don't change from /opt/stack
# Destination path for installation ``DEST`
DEST=/opt/stack
# Clean up Devstack services
echo "Stopping Devstack services..."
$DEST/devstack/clean.sh
# Unstack Devstack
echo "Unstacking..."
$DEST/devstack/unstack.sh
# Source stackrc
source $DEST/devstack/stackrc
# Defining directories
NOVA_DIR=$DEST/nova
HORIZON_DIR=$DEST/horizon
GLANCE_DIR=$DEST/glance
KEYSTONE_DIR=$DEST/keystone
NOVACLIENT_DIR=$DEST/python-novaclient
KEYSTONECLIENT_DIR=$DEST/python-keystoneclient
NOVNC_DIR=$DEST/noVNC
SWIFT_DIR=$DEST/swift
QUANTUM_DIR=$DEST/quantum
QUANTUM_CLIENT_DIR=$DEST/python-quantumclient
MELANGE_DIR=$DEST/melange
MELANGECLIENT_DIR=$DEST/python-melangeclient
TEMPEST_DIR=$DEST/tempest
PLACEMENT_DIR=$DEST/placement
#
# Cleanup installation trees
#
echo "Removing directories..."
sudo rm -rf $NOVA_DIR $HORIZON_DIR $GLANCE_DIR $KEYSTONE_DIR $NOVACLIENT_DIR $KEYSTONECLIENT_DIR $NOVNC_DIR $SWIFT_DIR $QUANTUM_DIR $QUANTUM_CLIENT_DIR $MELANGE_DIR $MELANGECLIENT_DIR $TEMPEST_DIR $PLACEMENT_DIR
sudo rm -rf $DEST/nova-volumes-backing-file
# Cleanup MySQL data
#
echo "Removing MySQL..."
sudo apt -y remove mysql-server
sudo rm -rf /var/lib/mysql
#
# Cleanup RabbitMQ data
#
echo "Cleaning up RabbitMQ data..."
sudo apt -y remove rabbitmq-server
sudo rm -rf /var/lib/rabbitmq
#
# Cleanup config dirs
#
echo "Deleting config directories..."
sudo rm -rf /etc/swift /etc/nova /etc/glance /etc/keystone
sudo rm /etc/sudoers.d/50_stack_sh
sudo rm /etc/sudoers.d/nova-rootwrap
sudo rm /etc/rsyslog.d/90-stack-m.conf
#
# Kill off any stray swift instances
echo "Killing all stray swift instances (if any)..."
killall -TERM /usr/bin/python
killall -TERM stunnel
# Remove any mounts
IMAGE_MNT=$(egrep -q swift.img /proc/mounts)
# Cleanup installation trees
echo "Cleaning up installation trees..."
sudo rm -rf $NOVA_DIR $HORIZON_DIR $GLANCE_DIR $KEYSTONE_DIR $NOVACLIENT_DIR $KEYSTONECLIENT_DIR $NOVNC_DIR $SWIFT_DIR $QUANTUM_DIR $QUANTUM_CLIENT_DIR $MELANGE_DIR $MELANGECLIENT_DIR $TEMPEST_DIR $PLACEMENT_DIR
sudo rm -rf $DEST/nova-volumes-backing-file
# Remove miscellenous items
echo "Removing miscellenous items..."
sudo apt purge -y --auto-remove
# Kill tasks by 'stack' user
echo "Killing all tasks by user stack..."
sudo killall -u stack
# Delete stack user
echo " Deleting user stack..."
sudo deluser -f --remove-home stack
# Cleaning up /opt/stack if it remains
echo "Removing /opt/stack directory..."
sudo rm -rf /opt/stack
