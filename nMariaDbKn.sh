#!/bin/bash
#  $SrvBin/nMariaDbKn.sh
echo "--- Start: nMariaDbKn.sh - for \$Srv: $Srv" 
if [[ -z "$Srv" ]]; then  echo -e "\n** \$Srv is not defined! **\n"; exit; fi
export KnN=t10SqlKn   # @@@@>> $1  @@@@ check if KnN already in use !!!
export KnPkgN=mariadb
export DkrImgN=wptestlabs/mariadb
export KnKlsN=cfMariaDbDkrLib
export DkrRunDCmd=''
export KnGrpN=ZOLO
export DkrNet=--net=host
nMariaDbKnDef.sh  #@@@ $KnN  $DkrImgN
[[ -e $SrvEtcKnz/$KnPkgN ]] || ln -sf $KnN $SrvEtcKnz/$KnPkgN
