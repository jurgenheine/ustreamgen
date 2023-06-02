#! /bin/bash
# store env as export in script file to export, filter LS_color env, it interfere with the export command
#printenv | compgen -v -X '*LS_COLORS*' | sed 's/^\(.*\)$/export \1/g' > /root/project_env.sh
#chmod +x /root/project_env.sh

#create log file
touch /logs/cron.log

# remove old jobs, needed when docker restarted, otherwise there multiple rules created
#crontab -r

#create cron rule(s)
if [ "$SINGLELIST" == "true" ]
then
    echo "cd /m3u2strm && python3 main.py $SINGLELISTURL 'all' $MOVIES $TVSHOWS $EVENTS /movies/ /tv/ /events/" > /root/parse_singlelist.sh
    chmod +x /root/parse_singlelist.sh
    /root/parse_singlelist.sh

    if [ -z "$CRON" ]
    then
        # CRON variable empty, use the hour minute
        (crontab -l ; echo "$CRONMINUTE $CRONHOUR * * * . /root/parse_singlelist.sh >> /logs/cron.log 2>&1") | crontab
    else
        # Use FULL CRON, so you can shedule like you want
        (crontab -l ; echo "$CRON . /root/parse_singlelist.sh >> /logs/cron.log 2>&1") | crontab
    fi
else
    if [ "$TVSHOWS" == "true" ]
    then 
        echo "cd /m3u2strm && python3 main.py $TVSHOWURL 'tvshows' $APOLLO /tv/" > /root/parse_tvlist.sh
        chmod +x /root/parse_tvlist.sh
        root/parse_tvlist.sh
        
        if [ -z "$TVCRON" ]
        then
            # CRON variable empty, use the hour minute
            (crontab -l ; echo "$TVCRONMINUTE $TVCRONHOUR * * * . /root/parse_tvlist.sh >> /logs/cron.log 2>&1") | crontab
        else
            # Use FULL CRON, so you can shedule like you want
            (crontab -l ; echo "$TVCRON . /root/parse_tvlist.sh >> /logs/cron.log 2>&1") | crontab
        fi
    fi
    if [ "$MOVIES" == "true" ]
    then
        echo "cd /m3u2strm && python3 main.py $MOVIEURL 'movies' $APOLLO /movies/" > /root/parse_movielist.sh
        chmod +x /root/parse_movielist.sh
        /root/parse_movielist.sh
        
        if [ -z "$MOVIECRON" ]
        then
            # CRON variable empty, use the hour minute
            (crontab -l ; echo "$MOVIECRONMINUTE $MOVIECRONHOUR * * * . /root/parse_movielist.sh >> /logs/cron.log 2>&1") | crontab
        else
            # Use FULL CRON, so you can shedule like you want
            (crontab -l ; echo "$MOVIECRON . /root/parse_movielist.sh >> /logs/cron.log 2>&1") | crontab
        fi
    fi
    if [ "$EVENTS" == "true" ]
    then
        echo "cd /m3u2strm && python3 main.py $EVENTURL 'events' $APOLLO /events/" > /root/parse_eventlist.sh
        chmod +x /root/parse_eventlist.sh
        /root/parse_eventlist.sh
        
        if [ -z "$EVENTCRON" ]
        then
            # CRON variable empty, use the hour minute
            (crontab -l ; echo "$EVENTCRONMINUTE $EVENTCRONHOUR * * * . /root/parse_eventlist.sh >> /logs/cron.log 2>&1") | crontab
        else
            # Use FULL CRON, so you can shedule like you want
            (crontab -l ; echo "$EVENTCRON . /root/parse_eventlist.sh >> /logs/cron.log 2>&1") | crontab
        fi
    fi
fi
cron && tail -f /logs/cron.log