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
    printf "#! /bin/bash\ncd /m3u2strm && python3 main.py $SINGLELISTURL \"all\" $MOVIES $TVSHOWS $EVENTS /movies/ /tv/ /events/" > /root/parse_singlelist.sh
    chmod +x /root/parse_singlelist.sh
    source /root/parse_singlelist.sh

    if [ -z "$CRON" ]
    then
        # CRON variable empty, use the hour minute
        (crontab -l ; echo "$CRONMINUTE $CRONHOUR * * * root /bin/bash /root/parse_singlelist.sh >> /logs/cron.log 2>&1") | crontab
    else
        # Use FULL CRON, so you can shedule like you want
        (crontab -l ; echo "$CRON root /bin/bash /root/parse_singlelist.sh >> /logs/cron.log 2>&1") | crontab
    fi
else
    if [ "$TVSHOWS" == "true" ]
    then 
        printf "#! /bin/bash\ncd /m3u2strm && python3 main.py $TVSHOWURL tvshows $APOLLO /tv/" > /root/parse_tvlist.sh
        chmod +x /root/parse_tvlist.sh
        source root/parse_tvlist.sh
        
        if [ -z "$TVCRON" ]
        then
            # CRON variable empty, use the hour minute
            (crontab -l ; echo "$TVCRONMINUTE $TVCRONHOUR * * * root /bin/bash /root/parse_tvlist.sh >> /logs/cron.log 2>&1") | crontab
        else
            # Use FULL CRON, so you can shedule like you want
            (crontab -l ; echo "$TVCRON root /bin/bash /root/parse_tvlist.sh >> /logs/cron.log 2>&1") | crontab
        fi
    fi
    if [ "$MOVIES" == "true" ]
    then
        printf "#! /bin/bash\ncd /m3u2strm && python3 main.py $MOVIEURL 'movies' $APOLLO /movies/" > /root/parse_movielist.sh
        chmod +x /root/parse_movielist.sh
        source /root/parse_movielist.sh
        
        if [ -z "$MOVIECRON" ]
        then
            # CRON variable empty, use the hour minute
            (crontab -l ; echo "$MOVIECRONMINUTE $MOVIECRONHOUR * * * root /bin/bash /root/parse_movielist.sh >> /logs/cron.log 2>&1") | crontab
        else
            # Use FULL CRON, so you can shedule like you want
            (crontab -l ; echo "$MOVIECRON root /bin/bash /root/parse_movielist.sh >> /logs/cron.log 2>&1") | crontab
        fi
    fi
    if [ "$EVENTS" == "true" ]
    then
        printf "#! /bin/bash\ncd /m3u2strm && python3 main.py $EVENTURL 'events' $APOLLO /events/" > /root/parse_eventlist.sh
        chmod +x /root/parse_eventlist.sh
        source /root/parse_eventlist.sh
        
        if [ -z "$EVENTCRON" ]
        then
            # CRON variable empty, use the hour minute
            (crontab -l ; echo "$EVENTCRONMINUTE $EVENTCRONHOUR * * * root /bin/bash /root/parse_eventlist.sh >> /logs/cron.log 2>&1") | crontab
        else
            # Use FULL CRON, so you can shedule like you want
            (crontab -l ; echo "$EVENTCRON root /bin/bash /root/parse_eventlist.sh >> /logs/cron.log 2>&1") | crontab
        fi
    fi
fi
cron && tail -f /logs/cron.log