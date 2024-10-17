#!/usr/bin/env python3
import sys
import os
import listhandler

directory =  os.path.abspath(os.path.dirname(__file__))
providerurl = sys.argv[1]
funct = sys.argv[2]
usegroup = sys.argv[3]

if funct == 'all':
    movies = sys.argv[4]
    tvshows = sys.argv[5]
    events = sys.argv[6]

    moviesDestination = None
    if movies == 'true':
        moviesDestination = sys.argv[7]

    tvshowsDestination = None
    if tvshows == 'true':
        tvshowsDestination = sys.argv[8]

    eventsDestination = None  
    if events == 'true':
        eventsDestination = sys.argv[9]

    listhandler.parseIPTVLists(funct, providerurl, directory, usegroup, moviesDestination, tvshowsDestination, eventsDestination)

else:
    apollo = sys.argv[4]
    path = sys.argv[5]

    if funct == 'movies' or apollo == 'false':
        listhandler.parseIPTVLists(funct, providerurl, directory, usegroup, path, None, None, None)
    elif funct == 'tvshows':
        listhandler.parseIPTVLists(funct, providerurl, directory, usegroup, None, path, None, 27)
    elif funct == 'events':
        listhandler.parseIPTVLists(funct, providerurl, directory, usegroup, None, None, path, 7)


