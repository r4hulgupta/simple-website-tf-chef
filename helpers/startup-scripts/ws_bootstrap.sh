#!/bin/bash -xev

# Variables
SEED_PROJECT=""
CHEF_REPO_URL="https://source.developers.google.com/p/${SEED_PROJECT}/r/mychefrepo"
COOKBOOK_NAME='rg_ws_deploy'

# Do some chef pre-work
/bin/mkdir -p /etc/chef
/bin/mkdir -p /var/lib/chef
/bin/mkdir -p /var/log/chef

cd /etc/chef/

NODE_NAME=`hostname` 
# Create client.rb
/bin/echo "chef_license 'accept'" >> /etc/chef/client.rb
/bin/echo 'log_location     STDOUT' >> /etc/chef/client.rb
/bin/echo -e "node_name  \"$NODE_NAME\"" >> /etc/chef/client.rb

# get the cookbooks
sudo git clone $CHEF_REPO_URL

# cd into chef repo to run chef client
cd ${CHEF_REPO_URL##*/}

# Run Chef Client in local mode
sudo chef-client -z -o $COOKBOOK_NAME -c /etc/chef/client.rb
