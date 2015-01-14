# Helpful Shell Functions
#
# This file is part of the Ops-T Portal.
#
#   Copyright 2014 Operations Security Administration, Inc.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

# Uses LOCKFILE, returns LOCKTOUCHPID
cron_lock()
{
	LOCKFILE=$1

	# Avoid running more than one at a time
	if [ -x /usr/bin/lockfile-create ] ; then
		lockfile-create $LOCKFILE
		if [ $? -ne 0 ];
		then
		cat <<EOF

Unable to run crontab-minute.sh because lockfile $LOCKFILE
acquisition failed. This probably means that the previous instance
is still running. Please check and correct if necessary.

EOF
			exit 1
		fi

		# Keep lockfile fresh
		lockfile-touch $LOCKFILE &
		LOCKTOUCHPID="$!"
	fi
}

# Uses LOCKFILE and LOCKTOUCHPID
cron_unlock()
{
	# Clean up lockfile
	#
	if [ -x /usr/bin/lockfile-create ];
	then
		kill $LOCKTOUCHPID
		lockfile-remove $LOCKFILE
	fi
}

