#!/bin/bash -e
LOCALDIR=$(pwd)
RED='\033[0;31m'
NC='\033[0m'

if [[ $OSTYPE == 'linux-android'* && $(echo "$TERMUX_VERSION" | cut -c 3-5) -ge "117" ]]; then
    pkg install git
    git clone https://github.com/Mobassar4u/Tata-Play-IPTV-Playlist-Maker || { rm -rf Tata-Play-IPTV-Playlist-Maker; git clone https://github.com/Mobassar4u/Tata-Play-IPTV-Playlist-Maker; }
    cd Tata-Play-IPTV-Playlist-Maker;
    bash main2.sh

elif [[ $OSTYPE == 'linux-gnu'* ]]; then
      sudo apt-get install git
      git clone https://github.com/Mobassar4u/Tata-Play-IPTV-Playlist-Maker || { rm -rf Tata-Play-IPTV-Playlist-Maker; git clone https://github.com/Mobassar4u/Tata-Play-IPTV-Playlist-Maker; }
      cd Tata-Play-IPTV-Playlist-Maker;
      bash main2.sh
elif [[ $(echo "$TERMUX_VERSION" | cut -c 3-5) -le "117" ]]; then
    echo -e "Please use Latest Termux release, i.e, from FDroid (https://f-droid.org/en/packages/com.termux/)";
    exit 1;
else
    echo "Platform not supported"
    exit 1;
fi
