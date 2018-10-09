#!/usr/bin/env bash
	msg "# [SQL] Start - $SrvGP/sqlTskRnrGX.sh"
set -e
export myCur=cur$$

diagFileN () { msg "# [SQL] ----------------------------"
    msg "# [SQL] diagFileN() - Full Input File (FQPFN): $1"
    msg "# [SQL] diagFileN() - Filename without Path: " $(basename "$1")
    msg "# [SQL] diagFileN() - Filename without Extension: " ${1%.*}
    msg "# [SQL] diagFileN() - File Extension without Name: " ${1##*.}
}

# Noop () { :; }
RunFileExitStatus () { msg "# [SQL] sqlTskRnrGX.RunFileExitStatus() - xc: $xc"; }

export RunFileExitGood=RunFileExitStatus
export RunFileExitBad=RunFileExitStatus

rnFl () { msg "# [SQL] Start: $SrvGP/sqlTskRnrGX.rnFl() - $1"; 
	local xc=99 fx=${1##*.};
	msg "# [SQL] sqlTskRnrGX.rnFl() - File Ext: $fx";
	case $fx in
	    sh)   $1; xc=$?;
	          msg "# [SQL] sqlTskRnrGX.rnFl() - End .sh $1  xc: $xc";;
	    sql)  msg "# [SQL] sqlTskRnrGX.rnFl() - Still NO Handler for SQL files!";;
	    *)    msg "# [SQL] sqlTskRnrGX.rnFl() - ** NO Handler for $fx files! **";;
	esac
	msg "# [SQL] sqlTskRnrGX.rnFl() - case/handler Exit code: $xc"
        [[ $xc = "0" ]] && $RunFileExitGood || $RunFileExitBad;
	msg "# [SQL] End: sqlTskRnrGX.rnFl()"
#qq hangs??	return 22; #  $xc;
}

while true; do   lst=`ls $BatGP/pending`
  if [[ -n "lst" ]]; then
    for f in $lst; do  msg "# [SQL] sqlTskRnr.loop - Next file: $f"; # diagFileN $f;
    	mkdir -p $BatGP/$myCur;   mv $BatGP/pending/$f  $BatGP/$myCur
	
	rnFl $BatGP/$myCur/$f > $BatGP/$myCur/tskRnr-${f}.log;  xc=$? 
	msg "# [SQL] sqlTskRnr.loop - Exit Code for file: $f";
        [[ $xc = "0" ]] && $RunFileExitGood || $RunFileExitBad;

        sleep 1;
    done
  else  msg "# [SQL] sqlTskRnrGX.sh - Nothing in Q"
  fi
  sleep 15;
done

