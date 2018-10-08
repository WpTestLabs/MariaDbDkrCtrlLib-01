#!/usr/bin/env bash
#	echo "Start - $SrvGP/sqlHeartBeatGX.sh"
set -e
# msg () { echo "$@" >> /srv/run/wkFlo/hstWkFloRcv.fifo; }
  msg "TL [SQL] Start: sqlHeartBeatGX.sh"
  msg  "# [SQL] Start: sqlHeartBeatGX.sh - SrvGP: $SrvGP"

export SleepCnt=10
. $SrvGP/guestEnv.sh
msg  "# [SQL] sqlHeartBeatGX.sh - After: . $SrvGP/guestEnv.sh"

cd $SrvGP
  
chkKids () { msg "# [SQL] Start: sqlHeartBeatGX.chkKids()";
   #xx ps -ppid $$ -o pid,comm,state --no-headers | \ Alpine BusyBox: Missing options 
   	ps -o ppid= -o pid= -o stat= -o args= | \
	while read ln; do msg "# [sql] chkKids() - ps:  $ln"; done
}
msg  "# [SQL] sqlHeartBeatGX.sh - After: chkKids()"

stTstRnr () {  ./sqlTskRnrGX.sh; }

chkQ () { local lst=`ls $BatGP/inQ`
    if [[ -n "$lst" ]]; then 
	    msg "# [SQL] chkQ() - Found: $lst"
	if [[ -z "`ls $BatGP/pending`" ]]; then
			msg "# [SQL] Moving Q'd files to pending"
            mv $BatGP/inQ/* $BatGP/pending/
		stTskRnr
        else  msg "# [SQL] Already have pending files to clear first." 
        fi	
    fi
}
msg  "# [SQL] sqlHeartBeatGX.sh - After: chkQ()"
sqlPing () { local s=`mysqladmin ping` r=$? ; echo "$r  $s"; }
msg  "# [SQL] sqlHeartBeatGX.sh - After: sqlPing()"

onBeat () {   msg "SqlHB `sqlPing`";
    chkKids;  chkQ;
}
msg  "# [SQL] sqlHeartBeatGX.sh - After: onBeat()"

heartBeat () {	while true; do onBeat; sleep $SleepCnt; done; }

msg "# [SQL]  sqlHeartBeat.sh - Calling: heartBeat()"
heartBeat
