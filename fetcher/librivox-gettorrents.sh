#!/bin/bash
# Set the current date
timestamp=$(date +"%F-T%H.%M.%S")

# Check if no numbers were provided.

if [ -z "$1" ] || [ -z "$2" ]
then
	echo "Please provide a starting and ending page in the RSS feed."
	echo "Exiting..."
	exit 1
fi

# Check if the provided values are actually numbers.
case $1 in
    '' | *[!0123456789]*)
        printf '%s\n' "$0: $var: invalid digit" >&2; exit 1;;
esac

case $2 in
    '' | *[!0123456789]*)
        printf '%s\n' "$0: $var: invalid digit" >&2; exit 1;;
esac


# Switch to the appropriate directory.
cd librivox
echo "Thanks for using Riff.CC Upload Toolkit!"
# Loop through as many pages as you would like.
for (( i = $1; i <= $2; ++i ));
do
	echo "Grabbing a list of torrent URLs."
        # Grab a list of torrent URLs from our source.
	# When necessary, use a local snapshot to speed up the debug loop.
	# We use -q to silence wget,
	# and we output to stdout before parsing and passing to various utilities to handle the actual downloading.
        torrent=$(wget -O- "https://archive.org/advancedsearch.php?q=collection%3A%22librivoxaudio%22&fl%5B%5D=downloads&sort%5B%5D=&sort%5B%5D=&sort%5B%5D=&rows=1000000000&callback=callback&save=yes&output=rss#raw" | awk -F'[<>]' '{ d[$2]=$3; if ($2=="/item" && index(d["description"],"BitTorrent") ) { print d["link"] } }' | parallel links -dump -html-numbered-links 1 | grep -o 'https://archive.org/.*torrent$' | sort -u | head -n $1 | parallel wget -c -x)
        #torrent=$(cat ~/upload-toolkit/fetcher/librivox.html | awk -F'[<>]' '{ d[$2]=$3; if ($2=="/item" && index(d["description"],"BitTorrent") ) { print d["link"] } }' | parallel links -dump -html-numbered-links 1 | grep -o 'https://archive.org/.*torrent$' | sort -u | head -n $1 | parallel wget -c -x)
done