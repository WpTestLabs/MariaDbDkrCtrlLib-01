#!/usr/bin/env bash
	msg "# [SQL] Start - $SrvGP/sqlTskRnrGX.sh"
set -e

diagFileN () { msg "# [SQL] ----------------------------"
    msg "# [SQL] diagFileN() - Full Input File (FQPFN): $1"
    msg "# [SQL] diagFileN() - Filename without Path: " $(basename "$1")
    msg "# [SQL] diagFileN() - Filename without Extension: " ${1%.*}
    msg "# [SQL] diagFileN() - File Extension without Name: " ${1##*.}
}

rnFl () { msg "# [SQL] Start: $SrvGP/sqlTskRnrGX.rnFl() - $1"; 
	$1; xc=$?;
	msg "# [SQL] End: $SrvGP/sqlTskRnrGX.rnFl() - $1  xc: $xc";
}

while true; do   lst=`ls $BatGP/pending`
  if [[ -n "lst" ]]; then
    for f in $lst; do  msg "# [SQL] sqlTskRnr - Next file: $f"
		  mv $BatGP/pending/$f  $BatGP/cur
	diagFileN $f;  rnFl $BatGP/cur/$f

      sleep 3;
    done
  else  msg "# [SQL] sqlTskRnrGX.sh - Nothing in Q"
  fi
  sleep 15;
done

