#!/bin/bash

MAINDIR=$HOME/.eoiaw
if [ ! -d $MAINDIR ]
then
    mkdir -p $MAINDIR/{rundirs/24hours.d,var/touchfiles} || exit 1
    echo "Created Main dir $MAINDIR"
    exit
fi

VARDIR=$MAINDIR/var
mkdir -p $VARDIR/touchfiles

LOCKDIR=$MAINDIR/var/lockdir
# use directory to run only once instance
mkdir $LOCKDIR 2> /dev/null || exit
trap "rm -rf $LOCKDIR" EXIT TERM INT

UNAME_S=$(uname -s)
case "$UNAME_S" in
Darwin)
    # homebrew
    # brew install coreutils
    GNUDATE=gdate
    GNUSTAT=gstat
    ;;
Linux)
    # normal coreutils
    GNUDATE=date
    GNUSTAT=stat
    ;;
*)
    echo "Unsupported OS type $UNAME_S" >&2
    exit 1
esac

for DIR in $MAINDIR/rundirs/*.d
do
    [ ! -d $DIR ] && continue
    TIMEOFFSET=${DIR##*/}
    TIMEOFFSET=${TIMEOFFSET%.d}
    TOUCHFILE=$MAINDIR/var/touchfiles/$TIMEOFFSET

    [ -f $TOUCHFILE ] \
        && [ $($GNUDATE --date="$TIMEOFFSET ago" '+%s') -lt $($GNUSTAT -c '%Y' $TOUCHFILE) ] \
        && continue

    for FILE in $DIR/*
    do
        [ ! -x $FILE ] && continue
        $FILE
    done
    touch $TOUCHFILE
done
