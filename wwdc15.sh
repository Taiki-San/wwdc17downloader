#!/bin/bash

#Setup the environnement
mkdir wwdc15
cd wwdc15
mkdir tmp_download
cd tmp_download

#Extract IDs
wget https://developer.apple.com/videos/wwdc/2015/
cat index.html | grep "\t<a href=\"?id=" | sed -e 's/<a href=//' -e 's#/a>##' -e 's/>//' -e 's/</"/' > ../download_data

#Download dedicated webpages
rm index.html
cat ../download_data | awk '{ split($0, a, "\""); system( "wget -c \"https://developer.apple.com/videos/wwdc/2015/"a[2]"\" -O \"" a[3] "\"")}'

#Final download
for file in *
do
var=$(cat "$file" | grep "_hd_" | awk '{ split($0, a, "dl=1"); split(a[2], b, "href=\""); $1=b[2]; print substr($1, 0, length($1)-1)}')
wget -c "$var" -O "../$file.mp4"
done

#cleanup
cd ..
rm -rf tmp_download
rm download_data