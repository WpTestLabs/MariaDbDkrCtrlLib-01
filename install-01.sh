#!/bin/sh
#   echo "https://github.com/WpTestLabs/MariaDbDkrCtrlLib-01/install-01.sh"

install -pm 640 -o root -g root -t $SrvLib cfMariaDbDkrLib.sh  iMariaDbKnHX.sh 
install -pm 740 -o root -g root -t $SrvBin nMariaDbKn.sh nMariaDbKnDef.sh
pth=$SrvLib/MariaDB/GX/;    mkdir -p $pth && \
  install -pm 640 -o root -g root -t $pth stMariaDbSvrGX.sh standardInitDbGX.sh wkStpRmtSqlBuGX-01.sh
ln -srf $SrvBin/cfKnCli.sh $SrvBin/sql
ln -srf $SrvBin/cfKnCli.sh $SrvBin/mdb
