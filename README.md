# Every Once In A While

Simple utility to run something every once in a while.

Useful for when I want to run things in the background, every... every once in a while.  Not have to remember to spawn them off.  And I'm not running cron or it's a laptop where it's not continually running

## Usage
1. Default base dir for scripts is `$HOME/.eoiaw/rundirs`


## Configure
1. Run `eoiaw.sh` script once, will create the directory structure
1. Create, if needed, the interval directory `$HOME/.eoiaw/rundirs/${INTERVAL}.d`
1. Drop script or symlink into `$HOME/.eoiaw/rundirs/${INTERVAL}.d`
1. Run `eoiaw.sh` from your shell start scripts.