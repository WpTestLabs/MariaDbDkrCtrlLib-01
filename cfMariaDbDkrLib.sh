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

QFile () {	echo "  QFile() - PFN: $1 -- `basename $1`"
    local pfn=$1  baseN=`basename $1;`;  shift;	
    local qInHP=$KnBasHP/srv/bat/inQ
	if [[ -e $pfn ]]; then
		echo "  vvvv  Found file  vvvv";  cat $pfn;
            cp $pfn $qInHP/$baseN
	else
		echo "  *** QFile() - File Missing - $pfn ***"
	fi 
}

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
		docker exec  $CID $knSrvTmpGP/$baseN $@;

		rm $knSrvTmpHP/$baseN;			ls -al $knSrvTmpHP;
	else
		echo "  *** sh File Missing - $hpfn ***"
	fi 
}

xDbDmp () { echo "[Hst] cfMariaDbDkrLib.DbDmp - RunGP: $RunGP  (1)";
    On; echo "[Hst] cfMariaDbDkrLib.DbDmp - RunGP: $RunGP  (2)";
    . $KnBasHP/guestEnv.sh;  echo "[Hst] cfMariaDbDkrLib.DbDmp - RunGP: $RunGP (3)";
#    if [[ ! -e "$KnBasHP$KnWkFloFifoGPFN" ]]; then
#        mkfifo $KnBasHP$KnWkFloFifoGPFN
#    
#    fi

    echo "A: $@" 
    echo "$@" > $KnBasHP$KnWkFloFifoGPFN
    unset $@
    echo "Z: $@" 
    echo "End: DbDmp()"
}
msg () { On; 
    . $KnBasHP/guestEnv.sh;  echo "[Hst] cfMariaDbDkrLib.msg() - RunGP: $RunGP";
    echo "Msg>> $@" 
    echo "$@" > $KnBasHP$KnWkFloFifoGPFN
}
# sql WkFlo $WfToken cmdGX DbN ...

log () { echo "$@"; } # for ez upgrade

declare -A WfCmdMP
  WfCmdMP[DbDmp]=DbDmp

WkFlo () { On;  export WkFloTkn=$1; local cmdGP=$KnBasHP/lib/wkFlo  cmd0=$2  cmd; shift 2;
  
  mkdir -p $SrvWkFlo/{svrCB,tkn}  # @@@@@@@@ ==> ___??
  echo "log \"[WfRcv] Loaded token env: $WkFloTkn \"" > $SrvWkFlo/tkn/$WkFloTkn # @@@@@@ 
  

  cmd=${WfCmdMP[$cmd0]};  [[ -n "$cmd" ]] && $cmd "$@" && return;
  log "SqlCli.wkFlo() >> $cmd0 is NOT an Internal Command!"
  if [[ -e $cmdGP/$cmd0 ]]; then
    $cmdGP/$cmd0 "$@";  xc=$?; 
	log "SqlCli.wkFlo() >> $cmd0 - Exit Code: $xc"
  else 
    log "** SqlCli.wkFlo() >> $cmd0 is NOT an External Command! **"
  fi
}
DbDmp () {  log "SqlCli.DbDmp() >> Start: tkn: $WkFloTkn  args: $@"
  echo "Loading $KnBasHP/guestEnv.sh..." 
  . $KnBasHP/guestEnv.sh;    
  echo "sql.WkFlo.DbDmp() - SrvWkFlo: $SrvWkFlo  SqlSrvID: $SqlSrvID"
  mkdir -p $SrvWkFlo/svrCB/$SqlSrvID/WfDbDmpCB/{G,B,w8}
  ln -sf $SrvWkFlo/tkn/$WkFloTkn $SrvWkFlo/svrCB/$SqlSrvID/WfDbDmpCB/w8
  
  log "Msg 2 SQL >> WkFlo $WkFloTkn DbDmp $@"
  msg "WkFlo $WkFloTkn DbDmp $@"
  log "SqlCli.DbDmp() >> End - msg sent."
}  
 


gInQHP () { echo "$KnBasHP/srv/bat/inQ"; }

doCli $@
