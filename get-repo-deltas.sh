#!/bin/bash
################################################################################
################################################################################
# Name - get-repo-delta.sh 
#
# Description - Copy RPMs in each local repository that is X days old or 
#               newer to a staging area so that the group of packages can be 
#               exported for offline updating to other environments.
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

# Directory where the local repositories are stored on the server
export REPO_DIR="/srv/repos"

# Directory where the staging area where RPMs will be copied to.
export EXPORT_DIR="/tmp/repos"

# Sub-direcotry where the RPMs are in each repository in the mirror
export REPO_DIRS=( "base/Packages" "epel" "extras/Packages" "updates/Packages" )

# Sub-diretory where to copy the RPMs that will be exported per each repositoiry
export EXPORT_DIRS=( "base" "epel" "extras" "updates" )

# How old are the RPMs do you need to pull? command-line arguement X days 
# and newer
daysold=$1


#########
# MAIN
#########

numrepos=${#REPO_DIRS[@]}

# Iterate through each repository that if being mirrored...
for (( x=1; x<${numrepos}+1; x++ ));
do

  # Create the staging folder, if it doesn't exist and clear it out for each
  # repository that is being mirrored
  mkdir -p $EXPORT_DIR"/"${EXPORT_DIRS[$x-1]}
  cd $EXPORT_DIR"/"${EXPORT_DIRS[$x-1]}
  rm -rf *

  # Go to the local repository mirror, find all the RPMs that are X days and 
  # newer, and copy those RPMs to the staging area for the repository
  cd $REPO_DIR"/"${REPO_DIRS[$x-1]}
  find . -name "*.rpm" -type f -mtime -${daysold} -print | xargs -ifile cp file $EXPORT_DIR"/"${EXPORT_DIRS[$x-1]}
done


#########
# DONE
#########
