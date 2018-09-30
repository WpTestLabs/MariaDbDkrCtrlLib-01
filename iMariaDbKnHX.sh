#!/bin/sh
	echo "Start: \$SrvLib/iMariaDbKnHX.sh - KnBasHP: $KnBasHP"; # called by __
mkdir -p $KnBasHP

mkGuestEnv () {
cat >$KnBasHP/guestEnv.sh <<'EOF'
# -- Guest FSH -----------------------------------
export SrvGP=/srv
export DbDataGP=$SrvGP/DataDir
export RunGP=$SrvGP/run
export RunWkFloGP=$RunGP/wkFlo

export MdbGrp=mysql       # ?? <<< @@@ can't pickup /root/.my.cnf !!!
export MdbUsr=mysql
#export MdbGrp=root
#export MdbUsr=root
EOF
}
if [[ ! -e $KnBasHP/guestEnv.sh ]]; then  mkGuestEnv; fi

. $KnBasHP/guestEnv.sh
# -- Host FSH ------------------------------------
export KnSrvHP=$KnBasHP$SrvGP
export MySqlRtPwHPFN=$KnSrvHP/.msRoot.pwa
mkdir -p $KnBasHP/{$DbDataGP,$RunWkFloGP};
  ln $Srv/run/wkFlo/hstWkFloRcv.fifo $KnBasHP/$RunWkFloGP
  echo "HX: via MariaDB hard link to fifo" > $KnBasHP/$RunWkFloGP 

if [[ ! -e $KnSrvHP/guestEnv.sh ]]; then 
    mv $KnBasHP/guestEnv.sh $KnSrvHP;   
	ln -srf $KnSrvHP/guestEnv.sh $KnBasHP/guestEnv.sh 
fi
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