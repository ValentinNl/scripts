#!/bin/sh

# GID management
# ==============
# Change the gid of a group without affecting files ownership

#
# 3 parameters are required : the new GID, the group which must be edited, and the root directory (ex: / or /home/my_user)
#

USAGE()
{
echo "usage : ${0} {new_gid} {group_name} {root_directory}"
exit 1
}

#
# change the group id. the first parameter is the new GID, the second is the group name
# change gid of files : search all files with the old gid and replace with the new one
#

CH_GID()
{
groupmod -g ${new_gid} ${group_name} || FAILURE
for i in `find ${root_dir} -group ${MY_GID}`; do chgrp ${new_gid} $i; done || FAILURE
}

#
# Get GID with group name
#

GET_GID()
{
MY_GID=`getent group ${1} | awk -F':'  '{print $3}'` || FAILURE
}

FAILURE()
{
echo "Failed"
exit 1
}

SUCCESS()
{
echo "Modifications succeed"
return 0
}

#
# RUN SCRIPT
#

[ "${#}" -ne 3 ] && USAGE

# Define
new_gid=${1}
group_name=${2}
root_dir=${3}

GET_GID ${group_name}

# Ask verification
read -p "You will replace ${group_name} gid (current gid : ${MY_GID}) by ${new_gid}. This will not affect files ownership (y/n)" action

[ "${action}" == "n" ] && FAILURE
[ "${action}" == "y" ] && CH_GID && SUCCESS
