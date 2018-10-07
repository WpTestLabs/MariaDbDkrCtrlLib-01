#!/usr/bin/env bash
	msg "# [SQL] Start - $SrvGP/sqlTskRnrGX.sh"
set -e

while true; do   lst=`ls $BatGP/pending`
  if [[ -n "lst" ]]; then
    for f in $lst; do  msg "# [SQL] sqlTskRnr - Next file: $f"
		  mv $BatGP/pending/$f  $BatGP/cur
      sleep 3;
    done
  else  msg "# [SQL] sqlTskRnrGX.sh - Nothing in Q"
  fi
  sleep 15;
done

