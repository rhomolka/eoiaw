#!/bin/bash

MAINDIR=$HOME/.eoiaw
if [ ! -d $MAINDIR ]
then
    mkdir -p $MAINDIR $MAINDIR/rundirs/24hours.d $MAINDIR/var
    echo "Created Main dir $MAINDIR"
    exit
fi

LOCKDIR=$MAINDIR/var/lockdir
TOUCHFILE=$MAINDIR/var/runtime
# use directory to run only once instance
mkdir $LOCKDIR 2> /dev/null || exit
trap "touch $TOUCHFILE; rm -rf $LOCKDIR" EXIT TERM INT

for DIR in $MAINDIR/rundirs/*.d
do
    [ ! -d $DIR ] && continue
    TIMEOFFSET=${DIR##*/}
    TIMEOFFSET=${TIMEOFFSET%.d}
    [ -f $TOUCHFILE ] \
        && [ $(gdate --date="$TIMEOFFSET ago" '+%s') -lt $(gstat -c '%Y' $TOUCHFILE) ] \
        && continue

    for FILE in $DIR/*
    do
        [ ! -x $FILE ] && continue
        $FILE
    done
done
