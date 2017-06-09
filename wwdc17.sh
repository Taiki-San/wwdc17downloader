#!/bin/bash

#Setup the environnement
mkdir wwdc17
cd wwdc17
mkdir tmp_download
cd tmp_download

#Extract IDs
echo "Downloading the index"
wget -q https://developer.apple.com/videos/wwdc2017/ -O index.html
cat index.html | grep videos/play/wwdc2017 | sed -e 's/[[:blank:]]*//' | sort | uniq | sed -e 's/.*wwdc2017\///' -e 's/\/\"\>//' > ../downloadData

rm index.html

#Iterate through the talk IDs
while read -r line
do
	#Download the page with the real download URL and the talk name
	wget -q "https://developer.apple.com/videos/play/wwdc2017/$line/" -O webpage

	#We grab the title of the page then clean it up
	talkName=$(cat webpage | grep "<title" | sed -e "s/.*\<title\>//" -e "s/ \- WWDC 2017.*//")

	#We grep "_hd_" which bring up the download URL, then some cleanup
	#If we were to want SD video, all we would have to do is replace _hd_ by _sd_
	dlURL=$(cat webpage | grep _hd_ | sed -e "s/.*href\=//" -e "s/\>.*//" -e "s/\"//g")

	rm webpage

	#Is there a video URL?
	if [ -z "$dlURL" ] ; then
		echo "Video $line ($talkName) doesn't appear to be available for now"
		continue
	fi

	#Great, we download the file
	wget -c "$dlURL" -O "../$line - $talkName.mp4"

done < "../downloadData"

#cleanup
cd ..
rm -rf tmp_download
rm downloadData
