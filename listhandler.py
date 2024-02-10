import shutil
import os
import filecmp
import tools
import streamClasses
import wget

def parseIPTVLists( type, url, localdir, usegroup, moviesDestination=None, tvShowsDestination=None, eventsDestination=None, endrange=None):
    if usegroup is not None and usegroup.lower() == 'true':
        downloadAndParseLists(type, url,True, endrange)
    else:
        downloadAndParseLists(type, url,False, endrange)

    if moviesDestination is not None:
        moveToDestination(localdir,'movies',moviesDestination)

    if tvShowsDestination is not None:
        moveToDestination(localdir,'tvshows',tvShowsDestination)

    if eventsDestination is not None:
        moveToDestination(localdir,'events',eventsDestination)

    #clean up fir single list, but 1 skipped destionation, for multiple skipped it's better to use multiple lists
    if moviesDestination  is None and tvShowsDestination is not None and eventsDestination is not None:
        cleanTempDirectory(localdir, 'movies')
    if moviesDestination  is not None and tvShowsDestination is None and eventsDestination is not None:
        cleanTempDirectory(localdir, 'tvshows')
    if moviesDestination  is not None and tvShowsDestination is not None and eventsDestination is None:
        cleanTempDirectory(localdir, 'events')

    print('done')

def downloadAndParseLists(type, url, usegroup, endrange):
    if endrange is None:
        downloadAndParseList(url, type, usegroup)
    else:
        for i in range(1, endrange):
            downloadAndParseList(url  + str(i), type + '-' + str(i), usegroup)

def downloadAndParseList( url, filename, usegroup):
        print('...Starting Download...')
        print(wget.download(url, ('m3u/' + filename + '.m3u')))
        streamClasses.rawStreamList('m3u/' + filename + '.m3u', usegroup)
        os.remove('m3u/' + filename + '.m3u')

def moveToDestination(localdir, localfolder, destination):
    print('comparing destination ',destination)
    c = filecmp.dircmp(localdir + '/' + localfolder, destination)
    tools.compare_and_update(c)
    cleanTempDirectory(localdir, localfolder)

def cleanTempDirectory(localdir,localfolder):
    print('cleaning up events temp space')       
    shutil.rmtree(localdir + '/' + localfolder + '/')
