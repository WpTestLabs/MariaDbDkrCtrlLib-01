#!/bin/bash
echo "start: \$SrvLib/cfMariaDbDkrLib.sh"

.	$SrvLib/cfDkrCtrlLib.sh

databases () { docker exec -it $CID mysql -uroot -e 'SHOW DATABASES;'; }
databases-ss () { docker exec -it $CID mysql -uroot -ss -e 'SHOW DATABASES;'; }
engines () { docker exec -it $CID mysql -uroot -e 'SHOW ENGINES;'; }
plugins () { docker exec -it $CID mysql -uroot -e 'SHOW PLUGINS;'; }
users () { docker exec -it $CID mysql -uroot -e 'SELECT User,Host,Password FROM mysql.user;'; }

_ping () { docker exec -it $CID mysqladmin ping; }
Ping () {	echo "Kan: $FQKanRtN  -- CID: $CID  >>>>>  `_ping`"; }
ping () { Ping; }
print-defaults () { docker exec -it $CID mysql --print-defaults -uroot ; }
sqlStatus () { docker exec -it $CID mysqladmin status; }

Run () {
	echo ">>> sql Run() -- KnBasHP: $KnBasHP"
#tt	tree -ACa $KnBasHP
	. $SrvLib/iMariaDbKnHX.sh 
	_Run
}
Stop () { DkrStop; }

DoSqlFile () {	echo "  DoSqlFile() - PFN: $1 -- `basename $1`"
	local pfn=$1  baseN=`basename $1;`;  shift;	
	local qInHP=$KnBasHP/srv/Q/In;		mkdir -p $qInHP;
	if [[ -e $pfn ]]; then
		echo "  vvvv  Found file  vvvv";  cat $pfn;
		cp -p $pfn $qInHP;  						ls -al $qInHP;  cat $qInHP/$baseN
		docker exec  $CID mysql -uroot -e "source /srv/Q/In/$baseN;";

		rm $qInHP/$baseN;							ls -al $qInHP;
	else
		echo "  *** SQL File Missing - $pfn ***"
	fi 
}

DoShFile () {	echo "  DoShFile() - PFN: $1 -- `basename $1`"
	local hpfn=$1  baseN=`basename $1;`;  shift;
	local knSrvTmpGP=/srv/tmp
	local knSrvTmpHP=$KnBasHP/$knSrvTmpGP;		mkdir -p $knSrvTmpHP;
	if [[ -e $hpfn ]]; then
		echo "  vvvv  Found file  vvvv";  cat $hpfn;
		cp -p $hpfn $knSrvTmpHP;  		ls -al $knSrvTmpHP;  cat $knSrvTmpHP/$baseN
		docker exec  $CID $knSrvTmpGP/$baseN;";

		rm $knSrvTmpHP/$baseN;			ls -al $knSrvTmpHP;
	else
		echo "  *** sh File Missing - $hpfn ***"
	fi 
}

doCli $@
