#!/usr/bin/env bash
#	echo "Start - $SrvGP/sqlHeartBeatGX.sh"
set -e
# msg () { echo "$@" >> /srv/run/wkFlo/hstWkFloRcv.fifo; }
  msg "TL [SQL] Start: sqlHeartBeatGX.sh"
  msg  "# [SQL] Start: sqlHeartBeatGX.sh"

export SleepCnt=10
. $SrvGP/guestEnv.sh

cd $SrvGP
  
chkKids () { ps -ppid $$ -o pid,comm,state --no-headers | \
	while read ln; do msg "#[sql] chkKids() - $ln"; done
}
chkQ () { local lst=`ls $BatGP/inQ`
	if [[ -n "$lst" ]]; then 
	    msg "# [SQL] chkQ() - Found: $lst"
		if [[ -z "`ls $BatGP/pending`" ]]
			msg "# [SQL] Moving Q'd files to pending"
            mv $BatGP/inQ/* $BatGP/pending/
			./sqlTskRnrGX.sh
        else  msg "# [SQL] Already have pending files to clear first." 
        fi	
	fi
}
sqlPing () { local s=`mysqladmin ping` r=$? ; echo "$r  $s"; }

onBeat () {   msg "SqlHB `sqlPing`";
    chkKids;  chkQ;	
}
heartBeat () {	while true; do onBeat; sleep $SleepCnt; done; }

heartBeat
