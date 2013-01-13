#!/bin/sh
 
##
## usage web_server.sh {start|stop|debug}
##
 
##   PA   = path to the web server
##   PORT  = port to run as
 
PA=$HOME/stat/stat/sbin
ERL=erl
HOSTNAME=`hostname`

case $1 in

  start)
    $ERL -pa $PWD/ebin $PWD/deps/*/ebin -sname stat1@$HOSTNAME -boot start_sasl -heart -detached -s stat start
    echo  "Starting Webserver"
    ;;
 
  debug)
    $ERL -sname stat001 -pa $PA -s stat start 
    ;;
 
  stop)
    $ERL -pa $PWD/ebin $PWD/deps/*/ebin -sname stat001_stopper -s stat_web stop stat1@$HOSTNAME
    echo "Stopping webserver"
    ;;
 
  *)
    echo "Usage: $0 {start|stop|debug}"
    exit 1
esac
 
exit 0
