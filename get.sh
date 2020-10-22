#!/bin/bash
# based on https://gist.github.com/jmiserez/3bd58d8ee3c27f24dd6f
bing="www.bing.com"

# $xmlURL is needed to get the xml data from which
# the relative URL for the Bing pic of the day is extracted
#
# The mkt parameter determines which Bing market you would like to
# obtain your images from.
# Valid values are: en-US, zh-CN, ja-JP, en-AU, en-UK, de-DE, en-NZ, en-CA.
#
# The idx parameter determines where to start from. 0 is the current day,
# 1 the previous day, etc.
xmlURL="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1"

# The desired Bing picture resolution to download
# Valid options: "_1024x768" "_1280x720" "_1366x768" "_1920x1200"
desiredPicRes="_1920x1200"

# Extract the relative URL of the Bing pic of the day from
# the XML data retrieved from xmlURL, form the fully qualified
# URL for the pic of the day, and store it in $picURL

# Form the URL for the desired pic resolution
xmlContent=$(curl -s $xmlURL)

desiredPicURL=$bing$(echo $xmlContent | grep -oP "<urlBase>(.*)</urlBase>" | cut -d ">" -f 2 | cut -d "<" -f 1)$desiredPicRes$picExt

# Form the URL for the default pic resolution
defaultPicURL=$bing$(echo $xmlContent | grep -oP "<url>(.*)</url>" | cut -d ">" -f 2 | cut -d "<" -f 1)

# Attempt to download the desired image resolution. If it doesn't
# exist then download the default image resolution
if wget --quiet --spider "$desiredPicURL"
then
    # Download the Bing pic of the day at desired resolution
    curl $desiredPicURL > "./bing.jpg" 
else
    # Set picName to the default picName
    # Download the Bing pic of the day at default resolution
    curl $defaultPicURL > "./bing.jpg"
fi

# Exit the script
exit