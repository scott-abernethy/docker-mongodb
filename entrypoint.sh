#!/bin/bash
set -e

# Add command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- mongod "$@"
fi

# Drop root privileges if we are running the service
if [ "$1" = 'mongod' ]; then
	chown -R mongodb /data/db

	numa='numactl --interleave=all'
	if $numa true &> /dev/null; then
		set -- $numa "$@"
	fi

	exec gosu mongodb "$@"
fi

# Assume user wanting to run own process e.g. `bash` to explore this image.
exec "$@"
