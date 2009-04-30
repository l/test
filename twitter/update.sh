#!/bin/bash
ACCOUNT="/home/de/.twitter/account.sh"
STATUS=`mktemp -q /tmp/$0.XXXXXX`
if [ $? -ne 0 ]; then
	echo "$0: Can't create temp file, exiting..."
	exit 1
fi

vi ${STATUS}

. ./update.sh -a ${ACCOUNT} -s ${STATUS}

rm ${STATUS}
