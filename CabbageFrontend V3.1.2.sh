#!/bin/bash

#Script courtesy of FlamingCabbages, I didn't make YT-dlp, FFmpeg, or Deno though! Links and credit to them VVV
#FFmpeg : https://www.ffmpeg.org/download.html -- https://www.gyan.dev/ffmpeg/builds/
#yt-dlp : https://github.com/yt-dlp/yt-dlp
#Deno   : https://github.com/denoland/deno/ -- https://docs.deno.com/runtime/getting_started/installation/

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
dlplocation="$script_dir/.thirdpartysoftware/yt-dlp"
denolocation="$script_dir/.thirdpartysoftware/deno"
audiooutput="$script_dir/AudioOutput"
videooutput="$script_dir/VideoOutput"
settingsfile="$script_dir/settings.cfg"
videoformats=(mp4 mkv webm avi)
audioformats=(mp3 m4a opus wav flac)

#The Main Menu
mainmenu() {
    videomode="mp4"
    audiomode="mp3"
    videooutfolder="$videooutput"
    audiooutfolder="$audiooutput"
    if [ -f "$settingsfile" ]; then 
    {
        IFS= read -r _
        IFS= read -r videomode
        IFS= read -r _
        IFS= read -r audiomode
        IFS= read -r _
        IFS= read -r videooutfolder
        IFS= read -r _
        IFS= read -r audiooutfolder
    } < "$settingsfile"
    fi
    clear
    echo -e "Welcome! Please type a number.\n[1] Video Download\n[2] Audio Download\n[3] Update Program\n[4] Information Page\n[5] Settings\n[6] Exit"
    read -p "Type an option: " userinput
    
    if [ $userinput = 1 ]; then
        videomode
    elif [ $userinput = 2 ]; then
        audiomode
    elif [ $userinput = 3 ]; then
        updatemode
    elif [ $userinput = 4 ]; then
        information
    elif [ $userinput = 5 ]; then
        settingsmode
    elif [ $userinput = 6 ]; then
        echo "You have chosen to close the program"
        sleep 2        
        exit
    else
        echo "Invalid option!"
        sleep 1
        mainmenu
    fi
}

#Downloading Videos
videomode() {
    clear
    echo "You have chosen to download a video"
    read -p "Paste Link: " userlink
    python3 "$dlplocation" "$userlink" --js-runtimes "deno:$denolocation" -i -o "$videooutfolder/%(title)s.$videomode"
    mainmenu
}

# Downloading Audio
audiomode() {
    clear
    echo "You have chosen to download audio"
    read -p "Paste Link: " userlink
    python3 "$dlplocation" "$userlink" --extract-audio --audio-format $audiomode --js-runtimes "deno:$denolocation" -i -o "$audiooutfolder/%(title)s"
    mainmenu
}

#Updates Deno and yt-dlp
updatemode() {
    clear
    echo "You have chosen to update yt-dlp and deno"
    python3 "$dlplocation" --update
    "$denolocation" upgrade
    sleep 3
    mainmenu
}

#A Function that checks to see if user input is valid while changing the format that video or audio is outputting to
is_valid_format() {
    local input=$1
    shift
    local format

    for format in "$@"; do
        [[ $input == "$format" ]] && return 0
    done
    return 1
}

# The main settings menu
settingsmode() {
    videomode=""
    audiomode=""
    videooutfolder=""
    audiooutfolder=""
    if [ -f "$settingsfile" ]; then 
    {
        IFS= read -r _
        IFS= read -r videomode
        IFS= read -r _
        IFS= read -r audiomode
        IFS= read -r _
        IFS= read -r videooutfolder
        IFS= read -r _
        IFS= read -r audiooutfolder
    } < "$settingsfile"
    fi
    clear
    echo -e "- Settings Page -\n[0] Back\n[1] Video Format: $videomode\n[2] Audio Format: $audiomode\n[3] Video Output: $videooutfolder\n[4] Audio Output: $audiooutfolder"
    
    read -p "Type an option: " option
    
    if [ "$option" = "0" ]; then
        mainmenu
    elif [ "$option" = "1" ]; then
        while true; do
            read -r -p "Type New Video Format: " videomode
            if is_valid_format "$videomode" "${videoformats[@]}"; then
                break
            fi
            echo "Invalid video format. Try again."
        done
        editsetting
    elif [ "$option" = "2" ]; then
        while true; do
            read -r -p "Type New Audio Format: " audiomode
            if is_valid_format "$audiomode" "${audioformats[@]}"; then
                break
            fi
            echo "Invalid audio format. Try again."
        done
        editsetting
    elif [ "$option" = "3" ]; then
        read -r -p "Type New Video Output Path: " videooutfolder
        editsetting
    elif [ "$option" = "4" ]; then
        read -r -p "Type New Audio Output Path: " audiooutfolder
        editsetting
    else
        echo "Invalid option."
        settingsmode
    fi
}

# The little function that updates the settings file
editsetting() {
    local news="$1" #I'm not bothering to delete this unused variable
    {
        IFS= read -r line1
        IFS= read -r _
        IFS= read -r line3
        IFS= read -r _
        IFS= read -r line5
        IFS= read -r _
        IFS= read -r line7
        IFS= read -r _
    } < "$settingsfile"
    printf '%s\n' \
        "$line1" \
        "$videomode" \
        "$line3" \
        "$audiomode" \
        "$line5" \
        "$videooutfolder" \
        "$line7" \
        "$audiooutfolder" > "$settingsfile"
    echo "Settings Updated!"
    settingsmode
}

# The ever-so-useful information page that no one looks at
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
