#!/bin/sh
#	echo "wkStpRmtSqlBuGX-01.sh"; # for GX

# -- SQL Kn Host ENV --
export KnBasHP=$SrvKnz/$KnN  #@@ ?? What if SQL on baremetal, or in (Multi Kn) common location?? 

# -- Def --
export myDbN=NgxMainDfltHst__vvDB  # @@ $1

# -- GX Pln --
export SqlDmpGstBP=/srv/Out/dmp

# -- GX RT -- Respective HstPth's are: $KnBasHP/$myDmp__FQGPFN
export myDmpFQGPFN=$SqlDmpGstBP/${myDbN}.sql
export myDmpLogFQGPFN=$SqlDmpGstBP/${myDbN}.log
export myDmpStsFQGPFN=$SqlDmpGstBP/${myDbN}.sts
export myDmpTmpFQGPFN=$SqlDmpGstBP/${myDbN}.sql.tmp

# -- STS (Status)
export myDmpSts=0 # 0: in guest Q, 1: executing, 2: done
export myDmpExitCode='x' # x= Don't know, Only gets valid value when Sts=2 

### -- start actual @@@@@@@@@@@@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#	echo "Start - sqlDmpGX.sh"
sMyDmpStsEnv () {
cat >$myDmpStsFQGPFN <<EOF
export myDmpSts=$1
export myDmpExitCode=${2-x} 
EOF
}

# @@ Chk if DB exists
# @@ Chk if DB changed
# @@ use proper SQL Dmp usr (for this DB) to make dmp

sMyDmpStsEnv 1
mysqldump --add-drop-table $myDbN > $myDmpTmpFQGPFN 2> $myDmpLogFQGPFN; myDmpExitCode=$?
sMyDmpStsEnv 2 $myDmpExitCode

if [[ -z "$myDmpExitCode ]]; then mv $myDmpTmpFQGPFN $myDmpFQGPFN; fi
# @@ kick: Sql Dmp (result) ready (for next step in WkFlo) 
echo "WkPrxySQL    EC: $myDmpExitCode  pfn: $myDmpFQGPFN"
