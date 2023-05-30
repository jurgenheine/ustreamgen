#! /bin/bash
# store env as export in script file to export, filter LS_color env, it interfere with the export command
#printenv | compgen -v -X '*LS_COLORS*' | sed 's/^\(.*\)$/export \1/g' > /root/project_env.sh
#chmod +x /root/project_env.sh

#create log file
touch /logs/cron.log

#create cron rule(s)
if [ "$SINGLELIST" == "true" ]
then
    cmd="cd /m3u2strm && python3 main.py $SINGLELISTURL all $MOVIES $TVSHOWS $EVENTS /movies/ /tv/ /events/"
    eval " $cmd"
    croncmd = "root $cmd >> /logs/cron.log 2>&1"
    if [ -z "$CRON" ]
    then
        # CRON variable empty, use the hour minute
        cronjob="$CRONMINUTE $CRONHOUR * * * $croncmd"
    else
        # Use FULL CRON, so you can shedule like you want
        cronjob="$CRON $croncmd"
    fi
    ( crontab -l | grep -v -F "$croncmd" || : ; echo "$cronjob" ) | crontab -
else
    if [ "$TVSHOWS" == "true" ]
    then 
        tvcmd="cd /m3u2strm && python3 main.py $TVSHOWURL tvshows $APOLLO /tv/"
        eval " $tvcmd"
        crontvcmd = "root $tvcmd >> /logs/cron.log 2>&1"
        if [ -z "$TVCRON" ]
        then
            # CRON variable empty, use the hour minute
            crontvjob="$TVCRONMINUTE $TVCRONHOUR * * * $crontvcmd"
        else
            # Use FULL CRON, so you can shedule like you want
            crontvjob="$TVCRON $crontvcmd"
        fi
        ( crontab -l | grep -v -F "$crontvcmd" || : ; echo "$crontvjob" ) | crontab -
    fi
    if [ "$MOVIES" == "true" ]
    then
        
        moviecmd="cd /m3u2strm && python3 main.py $MOVIEURL movies $APOLLO /movies/"
        eval " $moviecmd"
        cronmoviecmd="root $moviecmd >> /logs/cron.log 2>&1"
        if [ -z "$MOVIECRON" ]
        then
            # CRON variable empty, use the hour minute
            cronmoviejob="$MOVIECRONMINUTE $MOVIECRONHOUR * * * $cronmoviecmd"
        else
            # Use FULL CRON, so you can shedule like you want
            cronmoviejob="$MOVIECRON $cronmoviecmd"
        fi
        ( crontab -l | grep -v -F "$cronmoviecmd" || : ; echo "$cronmoviejob" ) | crontab -
    fi
    if [ "$EVENTS" == "true" ]
    then
       
        eventcmd=" cd /m3u2strm && python3 main.py $EVENTURL events $APOLLO /events/"
        eval " $eventcmd"
        croneventcmd="root $eventcmd >> /logs/cron.log 2>&1"
        if [ -z "$EVENTCRON" ]
        then
            # CRON variable empty, use the hour minute
            croneventsjob="$EVENTCRONMINUTE $EVENTCRONHOUR * * * $croneventcmd"
        else
            # Use FULL CRON, so you can shedule like you want
            croneventsjob="$EVENTCRON $croneventcmd"
        fi
        ( crontab -l | grep -v -F "$croneventcmd" || : ; echo "$croneventsjob" ) | crontab -
    fi
fi