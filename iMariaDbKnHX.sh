#!/bin/sh
    TL "Start: \$SrvLib/iMariaDbKnHX.sh - KnBasHP: $KnBasHP"; # called by __
#   iMariaDbKnHX is called by SQL.Run() - always re-init KnRun, but rest only if not already???
$SrvReq/WkFloRcv
#qq [[ -e $KnBasHP/guestEnv.sh ]] && exit; # Exit early if Kn already initialized
mkdir -p $KnBasHP

mkGuestEnv () {
cat >$KnBasHP/guestEnv.sh <<'EOF'
# -- Guest FSH -----------------------------------
export SrvGP=/srv
export DbDataGP=$SrvGP/DataDir
export RunGP=$SrvGP/run
export RunWkFloGP=$RunGP/wkFlo
export BatGP=$SrvGP/bat

export KnWkFloFifoGPFN=$RunWkFloGP/WkFlo2Kn.fifo
export KnWkFloLogGPFN=$RunWkFloGP/WkFlo2KnLog.txt

export MdbGrp=mysql
export MdbUsr=mysql
# -- Host ---
export KnBasHP=$KnBasHP
EOF
}
# ?? With early exit at top, then always run mkGuestEnv here!! ? @@@
if [[ ! -e $KnBasHP/guestEnv.sh ]]; then  mkGuestEnv; fi

. $KnBasHP/guestEnv.sh
# -- Host FSH ------------------------------------
export KnSrvHP=$KnBasHP$SrvGP
export MySqlRtPwHPFN=$KnSrvHP/.msRoot.pwa

[[ -e "$KnBasHP$RunGP" ]] && rm -fr $KnBasHP$RunGP;   
mkdir -p $KnBasHP/{$DbDataGP,$RunWkFloGP};
[[ -e "$KnSrvHP/guestEnv.sh" ]] && exit; # EARLY Exit -- Below only for FIRST Run();

ln $Srv/run/wkFlo/hstWkFloRcv.fifo $KnBasHP/$RunWkFloGP/hstWkFloRcv.fifo
  echo "HX: via MariaDB hard link to fifo" > $KnBasHP/$RunWkFloGP/hstWkFloRcv.fifo

mkfifo $KnBasHP$KnWkFloFifoGPFN

mkdir -p $KnBasHP/$BatGP/{inQ,pending,cur,outQ} #@@@@

# vvvv ???
#if [[ ! -e $KnSrvHP/guestEnv.sh ]]; then 
    mv $KnBasHP/guestEnv.sh $KnSrvHP;   
	ln -srf $KnSrvHP/guestEnv.sh $KnBasHP/guestEnv.sh 
#fi
mkMsRtPW () { 	echo "mkMsRtPW - usr: `whoami`    pwd: `pwd`    target dir: $KnSrvHP"
	pwgen -s1 32 >$MySqlRtPwHPFN; 
	chown root:root $MySqlRtPwHPFN && chmod 400 $MySqlRtPwHPFN
cat >$KnSrvHP/.myRtPW.cnf  <<EOF
[client]
password=`cat $MySqlRtPwHPFN`
EOF
	chown $MdbUsr:$MdbGrp $KnSrvHP/.myRtPW.cnf && chmod 400 $KnSrvHP/.myRtPW.cnf
} #----
if [[ ! -e $MySqlRtPwHPFN ]]; then  	mkMsRtPW; 	fi
cat >$KnSrvHP/my.cnf   <<EOF
[mysqld]
datadir=$DbDataGP

skip-host-cache
skip-name-resolve
EOF
chown $MdbUsr:$MdbGrp $KnSrvHP/my.cnf && chmod 440 $KnSrvHP/my.cnf # ==> GX!!!

cp -p $SrvLib/MariaDB/GX/*  $KnSrvHP
sync;	chmod o+x $KnBasHP/*.sh;	chmod o+x $KnSrvHP/*.sh 
