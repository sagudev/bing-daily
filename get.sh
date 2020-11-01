#!/bin/bash
# based on https://gist.github.com/jmiserez/3bd58d8ee3c27f24dd6f

# xml data from which
# the relative URL for the Bing pic of the day is extracted
#
# The mkt parameter determines which Bing market you would like to
# obtain your images from.
# Valid values are: en-US, zh-CN, ja-JP, en-AU, en-UK, de-DE, en-NZ, en-CA.
#
# The idx parameter determines where to start from. 0 is the current day,
# 1 the previous day, etc.
if [ -z "$1" ]; then
    xml_url="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&cc=si"
    out="bing.jpg"
else
    xml_url="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&cc=$1"
    out="bing_$1.jpg"
fi


# Extract the relative URL of the Bing pic of the day from
# the XML data retrieved from xml_url, form the fully qualified
echo "XML: $xml_url"
xml_c=$(curl -s $xml_url)

# The desired Bing picture resolution to download
# Valid options: "_1024x768" "_1280x720" "_1366x768" "_1920x1200"
desired=www.bing.com$(echo $xml_c | grep -oP "<urlBase>(.*)</urlBase>" | cut -d ">" -f 2 | cut -d "<" -f 1)_UHD.jpg

# Form the URL for the default pic resolution
default=www.bing.com$(echo $xml_c | grep -oP "<url>(.*)</url>" | cut -d ">" -f 2 | cut -d "<" -f 1)

# Attempt to download the desired image resolution. If it doesn't
# exist then download the default image resolution
echo "Trying to get $desired"
if wget --quiet --spider "$desired"
then
    # Download the Bing pic of the day at desired resolution
    curl $desired > $out 
else
    # Set picName to the default picName
    # Download the Bing pic of the day at default resolution
    curl $default > $out
fi

# Exit the script
exit
