#!/bin/bash
# Warning: vscode inserts control m's.  Make sure to run dos2unix on this file before commiting.
#
# Copyright (c) 2020 Actian Corporation
#
# ema_check_vector plugin

while getopts s: opt
  do
  case "$opt" in
      "s")   II_SYSTEM=$OPTARG; shift; shift ;;
      *)     echo "Illegal option $opt" ; exit 3;;
  esac
done

II_SYSTEM=${II_SYSTEM:-$(realpath $(dirname $0)/../../..)}

# ema_check_vector plugin

PORT=43034
PLUGINS=$II_SYSTEM/ingres/iiema/plugins
EMADATA=$II_SYSTEM/ingres/iiema/data

# verify Vector daemon is running

DAEMON=`/usr/sbin/ss -lnt |grep ":$PORT"`
STATUS=$?
if [ $STATUS -ne 0 ]
then
    java -jar $PLUGINS/vectorEMA.jar --config=$EMADATA/vectorh.conf >>$EMADATA/vectorEMA.log 2>&1 &
    for i in {1..10}
    do
        sleep 3
        DAEMON=`/usr/sbin/ss -lnt |grep ":$PORT"`
        STATUS=$?
        if [ $STATUS -eq 0 ]
        then
            break
        fi
    done
fi

RESULT=`echo "$@" | ncat localhost $PORT 2>&1`
if [ "$?" != 0 ]
then
    echo "Unable to contact Vector monitoring daemon: $RESULT"
    exit 3
fi

# result string format is <status>|<message>

echo "${RESULT:2}"
exit ${RESULT:0:1}
