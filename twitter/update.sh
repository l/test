#!/bin/bash

check_file()
{
	VAR=$1;
	if [ ! -r "${VAR}" ]; then
		echo "${VAR} is not readable file"
		exit 1
	fi

	if [ ! -s "${VAR}" ]; then
		echo "${VAR} is 0 byte file"
		exit 1
	fi
}

check_flg()
{
	FLG=$1;
	NAME=$2;
	if [ ! "$FLG" = "TRUE" ]; then
		echo "missing -${NAME} option"
		exit 1
	fi
}

check_var()
{
	VAR=$1;
	NAME=$2;
	if [ ! "${VAR}" ]; then
		echo "${NAME} is NULL"
		exit 1
	fi

	if [ ! -n "${VAR}" ]; then
		echo "${NAME} is 0 bytes"
		exit 1
	fi
}

CMDNAME=`basename $0`
while getopts s:a: OPT
do
	case $OPT in
	"a" ) FLG_A="TRUE" ; ACCOUNT="$OPTARG" ;;
	"s" ) FLG_S="TRUE" ; STATUS="$OPTARG" ;;
	* ) echo "Usage: $CMDNAME [-a ACCOUNTFILE] [-a STATUSFILE]" 1>&2
	exit 1 ;;
	esac
done

check_flg $FLG_A 'a'
check_file ${ACCOUNT}
check_flg $FLG_S 's'
check_file ${STATUS}

. ${ACCOUNT}
UPDATE_API=http://twitter.com/statuses/update.json
CURL="curl -sSv "

check_var ${UPDATE_API} 'UPDATE_API'
check_var ${CURL} 'CURL'
check_var ${USER} 'USER'
check_var ${PASS} 'PASS'
echo ${UPDATE_API}
echo ${CURL}
echo ${USER}
echo ${PASS}

TMPFILE=`mktemp -q /tmp/$0.XXXXXX`
if [ $? -ne 0 ]; then
	echo "$0: Can't create temp file, exiting..."
	exit 1
fi
nkf --utf8 ${STATUS} >> ${TMPFILE}

${CURL}\
	-u ${USER}:${PASS}\
	--data-urlencode status@${TMPFILE}\
	${UPDATE_API}

rm ${TMPFILE}

exit
