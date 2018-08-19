#!/usr/bin/env bash
#    $SrvGP/standardInitDb.sh -- cmd run (in the container) iff start script see's no existing DB 
#set -e			Run in Guest, iff db data store file not found ie db !initialized
#msg () {  echo \$1;  echo \$1 > $MsgPipeGP; }
ping () { echo ">>>>>>>> mysql ping: \`mysqladmin -uroot ping\`"; }
pLkDnSQL () {
cat <<EOF
USE mysql;
UPDATE user set password=PASSWORD("\`cat /srv/.msRoot.pwa\`") where User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';
FLUSH PRIVILEGES;
EOF
}

#msg "[MariaDB] Starting: standardInitDb.sh - as: \`whoami\`  pwd: \$PWD"
cat >/root/.my.cnf <<<!include /srv/.myRtPW.cnf
		#gg cat /srv/.myRtPW.cnf
echo ">>>>>> my.cnf vvv"; cat $SrvGP/my.cnf

install -o $LnxUsr -g $LnxGrp -d -m 750 $DbDataGP
#ls / && 
#tt mysql --version && echo
		#??? vvvv mysql_install_db  --user=mysql --defaults-extra-file=$SrvGP/my.cnf
mysql_install_db  --defaults-extra-file=$SrvGP/my.cnf  --user=$LnxUsr 
#chown mysql:mysql /var/lib/mysql/ -R
#chown $LnxUsr:$LnxGrp /var/lib/mysql/ -R

		# with 5.7.6 following replaces mysql_install_db -- BUT not on MariaDB
		#mysqld --initialize-insecure --user mysql  --init-file=iSql.sql

mysqld_safe --defaults-extra-file=$SrvGP/my.cnf --skip-grant-tables --skip-networking &
#msg ">>>>>>>>>>>>  After starting: mysqld_safe"
sleep 5
echo ">>>>>>>> mysql ping vvvvvvvvv";  mysqladmin -uroot ping  
ping						# #xx pLkDnSQL
pLkDnSQL | mysql -u root

#msg ">>>>>>>>>>>>>>> Back from DB Lock Down"
#cat $SrvGP/tWpDb01.sql | mysql -u root -p\`@@catMsRtPW\`
#xx mysql -u root <<<SELECT * FROM mysql.user;  @@@@ failed: Unexpected redirect !!!
echo 'SELECT * FROM mysql.user;' | mysql -u root
#msg ">>>>>>>>>>>>>>>  After mysql safe";  msg "\`mysqladmin -uroot  ping\`"
#msg "####################################################################################"
#mysqld -v --help && mysqladmin -uroot  variables
mysqladmin -uroot   status  shutdown   
#msg ">>>>>>>>>>>>>>>>  StandardInitDB.sh -- Exited mysqladmin, after giving shutdown cmd"
#xx sleep 20;  ps -ef > $MsgPipeGP; 
