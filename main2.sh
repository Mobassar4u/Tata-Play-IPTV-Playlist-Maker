#!/bin/bash -e
LOCALDIR=$(pwd)
RED='\033[0;31m'
NC='\033[0m'

info()
{
    printf "\n                                        -- Tata Play IPTV Playlist Maker --"
    printf "\n                                                 Author: Mobassar4u\n"
    printf "\n                                 -- GitHub Profile: https://github.com/Mobassar4u --"
    printf '\n'
    printf "\n This Script is make Daily-Workflow Repo for generating the Tata Play IPTV m3u Playlists Everyday. Keep the Playlist URL
 Constant, It's automatically refresh the Playlist Every 24 Hrs.Thanks to our Team for Hardworking on Playlist Generator
 
                                            *Enter only valid information* \n\n" 
    echo "-------------------------------------------------"
    tput sgr0;
}

take_input()
{
    curl -s "https://raw.githubusercontent.com/Mobassar4u/Tata-Play-IPTV-India/main/code_samples/constants.py" > constants.py &
    curl -s "https://raw.githubusercontent.com/Mobassar4u/Tata-Play-IPTV-India/main/code_samples/login.py" > login.py &
    echo "Please Enter the required details below to proceed further: "
    echo " "
    read -p " Enter your Tata Play IPTV Subscriber ID: " sub_id;
    read -p " Enter your Tata Play IPTV Registered Mobile Number: " tata_mobile;
    send_otp;
    read -p " Enter your GitHub Token: " git_token;
}

# validate_otp()
# {
# validate_otp_data=$(curl -s 'https://www.tataplay.com/inception-auth/v2/user/otp-login-validate' \
#   -H 'authority: www.tataplay.com' \
#   -H 'accept: application/json, text/plain, */*' \
#   -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.87 Safari/537.36' \
#   -H 'content-type: application/json' \
#   -H 'sec-gpc: 1' \
#   -H 'origin: https://www.tataplay.com' \
#   -H 'sec-fetch-site: same-origin' \
#   -H 'sec-fetch-mode: cors' \
#   -H 'sec-fetch-dest: empty' \
#   -H 'referer: https://www.tataplay.com/my-account/authenticate' \
#   -H 'accept-language: en-GB,en-US;q=0.9,en;q=0.8' \
#   --data-raw "{\"otp\":\"$tata_otp\",\"subscriberId\":\"$tata_mobile\"}" \
#   --compressed | source <(curl -s 'https://gist.githubusercontent.com/Mobassar4u/1b4f1bf163dd5a071e1c7c552ae21470/raw/bash-json-parser') > source)
# }

send_otp()
{
    send_otp_data=$(curl -s 'https://ts-api.videoready.tv/rest-api/pub/api/v2/generate/otp' \
    -H 'authority: ts-api.videoready.tv' \
    -H 'accept: */*' \
    -H 'accept-language: en-GB,en-US;q=0.9,en;q=0.8' \
    -H 'content-type: application/json' \
    -H 'device_details: {"pl":"web","os":"WINDOWS","lo":"en-us","app":"1.36.21","dn":"PC","bv":101,"bn":"CHROME","device_id":"nkdvk1941cbv2icfgjxjjos113d6euws","device_type":"WEB","device_platform":"PC","device_category":"open","manufacturer":"WINDOWS_CHROME_101","model":"PC","sname":""}' \
    -H 'locale: ENG' \
    -H 'origin: https://watch.tataplay.com' \
    -H 'platform: web' \
    -H 'referer: https://watch.tataplay.com/' \
    -H 'sec-fetch-dest: empty' \
    -H 'sec-fetch-mode: cors' \
    -H 'sec-fetch-site: cross-site' \
    -H 'sec-gpc: 1' \
    -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.41 Safari/537.36' \
    --data-raw "{\"sid\":\"$sub_id\",\"rmn\":\"$tata_mobile\"}" \
    --compressed);
    
    if [[ "$send_otp_data" == *"\"code\":1008"* ]]; then
    printf "\nPlease enter a valid Tata Play IPTV Subscriber ID or Registered Mobile Number\n"
    exit;
    fi
    echo "OTP Sent successfully"
    read -p " Enter the OTP Received: " tata_otp;
    login_otp=$(python3 login.py --otp "$tata_otp" --sid "$sub_id" --rmn "$tata_mobile")
    if [[ "$login_otp" == *'Please enter valid OTP.'* ]]; then
    echo "$login_otp"
    false;
    fi
}

take_vars()
{
    if [[ ! -f "$LOCALDIR/.usercreds2" ]]; then
    take_input;
    ask_playlist_type;
    main;
    else
    ask_direct_login;
    sleep 3;
    fi
}

extract_git_vars()
{
    git_id=$(curl -s -H "Authorization: token $git_token"     https://api.github.com/user | grep 'login' | sed 's/login//g' | tr -d '":, ')
    git_mail=$(curl -s -H "Authorization: token $git_token"     https://api.github.com/user/emails | grep 'email' | head -n1 | tr -d '", ' | sed 's/email://g')
}

initiate_setup()
{
    if [[ $OSTYPE == 'linux-gnu'* ]]; then
    echo "Please wait while the installation takes place..."
    printf "Please Enter your password to proceed with the setup: "
    sudo echo '' > /dev/null 2>&1
    sudo apt update
    sudo apt install python3.9 expect -y || { echo -e "${RED}Something went wrong, Try running the script again.${NC}"; exit 1; }
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3.9 get-pip.py
    pip3.9 install requests
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install gh
    echo "Installation done successfully!"
    
    elif [[ $OSTYPE == 'linux-android'* ]]; then
    if [[ $(echo "$TERMUX_VERSION" | cut -c 3-5) -ge "117" ]];then
    echo "Please wait while the installation takes place..."
    apt-get update &&      apt-get -o Dpkg::Options::="--force-confold" upgrade -q -y --force-yes &&     apt-get -o Dpkg::Options::="--force-confold" dist-upgrade -q -y --force-yes
    pkg install git gh ncurses-utils expect python gettext -y || { echo -e "${RED}Something went wrong, Try running the script again.${NC}"; exit 1; }
    pip install requests || { echo -e "${RED}Something went wrong, Try running the script again.${NC}"; exit 1; }
    echo "Installation done successfully!"
    else
    echo -e "Please use Latest Termux release, i.e, from FDroid (https://f-droid.org/en/packages/com.termux/)";
    exit 1;
    fi
    else
    echo -e "${RED}Platform not supported, Exiting...${NC}"; sleep 3; exit 1;
    fi
    
    touch .setupinitiated

}

save_creds()
{
    if [[ ! -f "$LOCALDIR/.usercreds2" ]]; then
    echo "Saving usercreds so that you don't have to login again..."
    printf "sub_id=\'$sub_id\'\ntata_mobile=\'$tata_mobile\'\ngit_token=\'$git_token\'\n" > $LOCALDIR/.usercreds2
    fi
}

ask_direct_login()
{
    read -p "File User-2 Data already exists, Would you like to take all the inputs from it? (y/n): " response;
    if [[ "$response" == 'y' ]]; then
    source $LOCALDIR/.usercreds2
    send_otp;
    ask_playlist_type;
    main;
    elif [[ "$response" == 'n' ]]; then
    rm .usercreds2;
    start && main;
    else
    echo "Invalid option chosen, Try again..." && ask_direct_login;
    fi
}

check_if_repo_exists()
{
    check_repo=$(curl -i -s -H "Authorization: token $git_token"     https://api.github.com/user/repos | grep 'Tata-Play-IPTV-Playlist-2-Daily-Generator') || true
    if [[ -n $check_repo ]]; then
    repo_exists='true'
    ask_user_to_select;
    else
    repo_exists='false'
    fi
}

ask_user_to_select()
{
    printf "\n Repo named 'Tata-Play-IPTV-Playlist-2-Daily-Generator' already exists, What would you like to perform? \n\n"
    echo "   1. Re-run the script & update my repo with same playlist."
    echo "   2. Maintain other playlist with another Tata Play IPTV Account"
    echo "   3. Generate new playlist with new link"
    printf '\n'
    while true; do
    read -p "Select from the options above: " selection
    case $selection in
    '1')echo "Option 1 chosen"; break;;
    '2')echo "Option 2 chosen"; break;;
    '3')echo "Option 3 chosen"; break;;
    *)echo "Invalid option chosen, Please try again...";;
    esac
    done
}

take_vars_from_existing_repo()
{
    if [[ $selection == '1' ]]; then
    dir="$(curl -s "https://$git_token@raw.githubusercontent.com/$git_id/Tata-Play-IPTV-Playlist-2-Daily-Generator/main/.github/workflows/Tata-Play-IPTV-Playlist-2-Daily-Workflow.yml" | perl -p -e 's/\r//g' | grep 'gist' | sed 's/.*\///g')"
    gist_url="https://$git_token@gist.github.com/$dir"
    fi
}

ask_playlist_type()
{
    printf "\nWhich type of playlist would you like to have? \n\n"
    echo "  1. Kodi & TiviMate Compatible"
    printf "  2. TiviMate & OTT Navigator Compatible\n\n"
    read -p "Select from the options above: " playlist_type;
    while true; do
    case $playlist_type in
    '1')echo "Selected Playlist Type: Kodi & TiviMate Compatible"; break;;
    '2')echo "Option 2 chosen"; break;;
    *)echo "Invalid option chosen, Please try again...";;
    esac
    done
}

start()
{
    if [[ $OSTYPE == 'linux-gnu'* ]]; then
    packages='curl gh expect python3 python3-pip'
    for package in $packages; do
    dpkg -s $package > /dev/null 2>&1 || initiate_setup;
    done
    clear
    tput setaf 41; curl -s 'https://gist.githubusercontent.com/Mobassar4u/c4672f8e826a591fddbd0acf722e5160/raw/Linuxpcimage' || { tput setaf 9; echo " " && echo "This script needs active Internet Connection, Please Check and try again."; exit 1; }
    info;
    python='python3.9'
    take_vars;
    
    
    elif [[ $OSTYPE == 'linux-android'* ]]; then
    packages='gh expect python ncurses-utils gettext'
    for package in $packages; do
    dpkg -s $package > /dev/null 2>&1 || initiate_setup;
    done
    clear
    tput setaf 41; curl -s 'https://gist.githubusercontent.com/Mobassar4u/d0396e83aa1a7819df83b248dcb2acf4/raw/Linuxmobileimage' || { tput setaf 9; echo " " && echo "This script needs active Internet Connection, Please Check and try again."; exit 1; }
    info;
    python='python3'
    take_vars;
    else
    echo -e "${RED}Platform not supported, Exiting...${NC}"; sleep 3; exit 1;
    fi
}

create_gist()
{
    if [[ $selection == "2" || $repo_exists == 'false' || $selection == '3' ]]; then
    echo "Initial Test" >> TataPlayPlaylist.m3u
    gh gist create TataPlayPlaylist.m3u | tee gist_link.txt >> /dev/null 2>&1
    sed -i "s/gist/$git_token@gist/g" gist_link.txt
    gist_url=$(cat gist_link.txt)
    dir="${gist_url##*/}"
    rm TataPlayPlaylist.m3u gist_link.txt
    gh repo create Tata-Play-IPTV-Playlist-2-Daily-Generator --private -y >> /dev/null 2>&1 || true
    fi
}

dynamic_push()
{
    git add .
    git commit --author="Mobassar@4u<mi4khdtvbox2020@gmail.com>" -m "Adapt Repo for auto-loop"
    if [[ "$selection" == "1" || "$selection" == '3' ]]; then
    git branch -M main
    git push -f --set-upstream origin main;
    elif [[ "$selection" == "2" ]]; then
    branch_name=$(echo "$dir" | cut -c 1-6)
    git branch -M $branch_name
    git push -f --set-upstream origin $branch_name
    elif [[ "$repo_exists" == 'false' ]]; then
    git branch -M main
    git push --set-upstream origin main
    fi
}

main()
{
    extract_git_vars;
    git config --global user.name "$git_id"
    git config --global user.email "$git_mail"
    check_if_repo_exists;
    git clone https://github.com/Mobassar4u/Tata-Play-IPTV-India >> /dev/null 2>&1 || { rm -rf Tata-Play-IPTV-India; git clone https://github.com/Mobassar4u/Tata-Play-IPTV-India; } 
    cd Tata-Play-IPTV-India/code_samples/
    mv $LOCALDIR/userDetails.json .    
    if [[ "$playlist_type" == '2' ]]; then
    echo "$wait Selected Playlist Type: TiviMate & OTT Navigator Compatible"
    git revert --no-commit 25976fd59ac0a7e937a04b76e54e5eee604423f4; fi
    cat $LOCALDIR/dependencies/post_script.exp > script.exp
    chmod 755 script.exp
    ./script.exp
    echo "$git_token" >> mytoken.txt
    gh auth login --with-token < mytoken.txt
    rm mytoken.txt script.exp
    cd ..
    create_gist;
    take_vars_from_existing_repo;
    mkdir -p $LOCALDIR/Tata-Play-IPTV-India/.github/workflows && cd $LOCALDIR/Tata-Play-IPTV-India/.github/workflows
    export dir=$dir
    export gist_url=$gist_url
    export git_id=$git_id
    export git_token=$git_token
    export git_mail=$git_mail
    cat $LOCALDIR/dependencies/Tata-Play-IPTV-Playlist-2-Daily-Workflow.yml | envsubst > Tata-Play-IPTV-Playlist-2-Daily-Workflow.yml
    cd ../..
    echo "code_samples/__pycache__" > .gitignore && echo "TataPlayPlaylist.m3u" >> .gitignore && echo "userSubscribedChannels.json" >> .gitignore
    git remote remove origin
    git remote add origin "https://$git_token@github.com/$git_id/Tata-Play-IPTV-Playlist-2-Daily-Generator.git"
    dynamic_push;
    git clone ${gist_url} >> /dev/null 2>&1
    cd ${dir} && rm TataPlayPlaylist.m3u && mv ../code_samples/TataPlayPlaylist.m3u .
    git add .
    git commit -m "Initial Playlist Upload"
    git push >> /dev/null 2>&1 || { tput setaf 9; printf 'Something went wrong!\n ERROR Code: 65x00a\n'; exit 1; }
    save_creds;
    tput setaf 51; echo "Successfully created your new private repo." && printf "Check your new private repo here: ${NC}https://github.com/$git_id/Tata-Play-IPTV-Playlist-2-Daily-Generator\n" && tput setaf 51; printf "Check Your Playlist URL here: ${NC}https://gist.githubusercontent.com/$git_id/$dir/raw/TataPlayPlaylist.m3u \n"
    if [[ "$selection" == '2' ]]; then tput setaf 51; echo -e "Check your other playlist branch here: ${NC}https://github.com/$git_id/Tata-Play-IPTV-Playlist-2-Daily-Generator/tree/$dir"; fi
    tput setaf 51; printf "You can directly paste this URL in TiviMate/OTT Navigator now, No need to remove hashcode\n"
    tput bold; printf "\n\nFor Privacy Reasons, Never Share your GitHub Tokens, Tata Play IPTV India Account Credentials and Playlist URL To Anyone. \n"
    tput setaf 51; printf "Using this script for Commercial uses is not permitted. \n\n"
    tput setaf 51; echo "Script by Mobassar4u, Please do star my repo if you've liked my work :) "
    tput setaf 51; echo "Credits: Mobassar@4u (https://github.com/Mobassar4u/Tata-Play-IPTV-India) & Our Team"
    tput setaf 51; echo "My Github Profile: https://github.com/Mobassar4u/"
    printf '\n\n'
    rm -rf $LOCALDIR/Tata-Play-IPTV-India;
    echo "Press Enter to exit."; read junk;
    tput setaf init;
    exit 1;
}
start;
