#!/bin/bash

################################################################################
################################################################################
# Name - update-repos.sh
#
# Description - Update the local CentOS repos on this server and update the RPMs
#               installed on this server. 
#               
#               The repositories being mirror are as follows:
#                 * CentOS Base
#                 * CentOS Extras
#                 * CentOS Updates
#                 * EPEL
#
# Change Log
#--------------
# Date     By             Reason for Change
# -------- -------------- ------------------------------------------------------
# 20150120 Shawn Lenhardt Initial Release
#
################################################################################
################################################################################

##############
# VARIABLES
##############

# Location of the local CentOS Repos
export REPO_DIR="/srv/repos"

# Sub directory where the CentOS base repo is stored
export BASE_DIR="base"

# Group file definition for the base rpeo
export BASE_GROUP_FILE="/root/centos-base-groups.xml"

# Sub-directories of all the other repos being mirrored
export OTHER_DIRS=( "epel" "extras" "updates" )


#########
# MAIN
#########

# Jump to the directory where the local base repository is stored, sync the 
# repo, and re-create the repository, including the group definitions.

cd $REPO_DIR
reposync
cd base; createrepo -g $BASE_GROUP_FILE .; cd ..

# Jump to each directory where the local repositores are stored, sync the 
# repos, and re-create the repositories.

for x in "${OTHER_DIRS[@]}"
do
  cd $x;
  createrepo .
  cd ..
done

# Update the RPMs on the server

yum -y update


#########
# DONE
#########

