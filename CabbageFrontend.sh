#!/bin/bash
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dlplocation="$script_dir/.thirdpartysoftware/yt-dlp"
denolocation="$script_dir/.thirdpartysoftware/deno"
audiooutput="$script_dir/MusicOutput"
videooutput="$script_dir/VideoOutput"
videomode() {
    clear
    echo "You have chosen to download a video"
    read -p "Paste Link: " userlink
    python3 "$dlplocation" "$userlink" --js-runtimes "deno:$denolocation" -i -o "$videooutput/%(title)s"
    mainmenu
}
mp4videomode() {
    clear
    echo "You have chosen to download a MP4 video"
    read -p "Paste Link: " userlink
    python3 "$dlplocation" "$userlink" --js-runtimes "deno:$denolocation" -i -o "$videooutput/%(title)s" --recode-video mp4
    mainmenu
}
audiomode() {
    clear
    echo "You have chosen to download audio"
    read -p "Paste Link: " userlink
    python3 "$dlplocation" "$userlink" --extract-audio --audio-format mp3 --js-runtimes "deno:$denolocation" -i -o "$audiooutput/%(title)s"
    mainmenu
}
updatemode() {
    clear
    echo "You have chosen to update yt-dlp and deno"
    python3 $dlplocation --update
    $denolocation upgrade
    sleep 3
    mainmenu
}
mainmenu() {
    clear
    echo -e "Welcome! Please type a number.\n[1] Video Download\n[2] MP4 Video Download (Slower)\n[3] Audio Download\n[4] Update Program\n[5] Information Page\n[6] Exit"
    read -p "Type an option: " userinput
    
    if [ $userinput -eq 1 ]; then
        videomode
    elif [ $userinput -eq 2 ]; then
        mp4videomode
    elif [ $userinput -eq 3 ]; then
        audiomode
    elif [ $userinput -eq 4 ]; then
        updatemode
    elif [ $userinput -eq 5 ]; then
        information
    elif [ $userinput -eq 6 ]; then
        echo "You have chosen to close the program"
        sleep 2        
        exit   
    fi
}
information() {
    clear
    echo "------ Information Page ------"
    echo -e "\n\n-- Downloading capabilities --\nYou can put any Youtube video link or playlist link and it will download,\nplease note that the video or playlist must be publicly accessible, either\nset to Public or Unlisted. Private videos and playlists cannot be downloaded"
    echo -e "\n -- Updating --\nIf you select the update option the script will automatically update YT-dlp and\nDeno, this will take a second and let you know when it finishes"
    echo -e "\n-- Troubleshooting --\nIf the script is not working try using the update option and then try again\nIf nothing at all is downloading and it is erroring out a lot make sure you have Deno installed"
    echo -e "\n-- General Information --\nLinks to all of the programs used by this script can be found in the 'readme' file\n\n"
    read -p "Press Enter to continue..."
    mainmenu
}
mainmenu
