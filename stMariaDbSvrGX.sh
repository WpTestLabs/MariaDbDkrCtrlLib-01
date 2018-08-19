#!/usr/bin/env bash
#    $KnRootHP/srv/stMariaDbSvrGX.sh 
#    stMariaDbSvrGX.sh -- GX: at start of Docker run for the kan
set -e
. /srv/guestEnv.sh
#msg () { echo \$1;  echo \$1 > $MsgPipeGP; }
echo "Starting (in Kan) stMariaDbSrv.sh" 
echo ">>> \`date\` - Start: stMariaDbSrv.sh  In Guest Path: \`pwd\`"
ls -R /srv && pwd
install -o $LnxUsr -g $LnxGrp -d -m 755 /run/mysqld
ln -sf /run /var/run

if [ ! -d $DbDataGP/mysql ] ; then
	echo ">> No Database Found -- Preparing to init new DB <<"
	if [ -f $SrvGP/customInitDb.sh ] ; then
		. $SrvGP/customInitDb.sh     2>&1 | tee -a   $SrvGP/customInitDb.log
	else
		echo ">> No customInitDb.sh found, so using: standardInitDbGX.sh <<"
		. $SrvGP/standardInitDbGX.sh   2>&1 | tee -a $SrvGP/standardInitDb.log
	fi
else
	echo "Existing DB found, starting existing DB"
	# check if id chown needed @@@@@@@@@@@@@ (are files owned by wrong ID # ??)
fi
#msg ">> Starting MariaDB Service (this is final mesg) <<"
#  @@@ w/ "include in /etc/my.cnf,  --defaults-extra-file should not be needed!
# vvv defaults-extra has No Host Resolve !!
exec su-exec $LnxUsr mysqld --defaults-extra-file=$SrvGP/my.cnf
