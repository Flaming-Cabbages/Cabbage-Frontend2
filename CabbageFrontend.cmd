@echo OFF
::Script courtesy of FlamingCabbages, I didn't make YT-dlp, FFmpeg, or Deno though! Links and credit to them VVV
::FFmpeg : https://www.ffmpeg.org/download.html -- https://www.gyan.dev/ffmpeg/builds/
::yt-dlp : https://github.com/yt-dlp/yt-dlp
::Deno   : https://github.com/denoland/deno/ -- https://docs.deno.com/runtime/getting_started/installation/

:mainpart
cls
set dlppath="%~dp0\thirdpartysoftware\yt-dlp.exe"
set ffmpegpath="%~dp0\thirdpartysoftware\ffmpeg\bin\ffmpeg.exe"
set vidoutpath=%~dp0VideoOutput
set audiooutpath=%~dp0MusicOutput
set denopath="%~dp0\thirdpartysoftware\deno\deno.exe"
echo Choose an option (1: Video Download, 2: Audio Download, 3: Update, 4: Info, 5: Exit)
set /p "option=Type Option: "
echo %option%
if %option%==1 (
goto videomode
) ELSE IF %option%==2 (
goto audiomode
) ELSE IF %option%==3 (
goto updatemode
) ELSE IF %option%==4 (
goto infomode
) ELSE IF %option%==5 (
goto exitmode
) ELSE (
goto mainpart
)

:videomode
cls
echo You have chosen to download a video,
set /p "mylink=type here: "
%dlppath% %mylink% --js-runtimes deno:%denopath% --ffmpeg-location %ffmpegpath% -i -o "%vidoutpath%\%%(title)s.mp4"
goto mainpart

:audiomode
cls
echo You have chosen to download audio,
set /p "mylink2=Paste a link: "
%dlppath% %mylink2% --js-runtimes deno:%denopath% --extract-audio --audio-format mp3 --ffmpeg-location %ffmpegpath% -i -o "%audiooutpath%\%%(title)s"
goto mainpart

:updatemode
cls
echo You have chosen to update YT-dlp
%dlppath% --update
%denopath% upgrade
pause
goto mainpart

:infomode
cls
echo - Information Page -
echo ~~ Downloading capabilities : You can put any Youtube video link or playlist link and it will download,
echo please note that the video or playlist must be publicly accessible, either set to Public or Unlisted. 
echo Private videos and playlists cannot be downloaded
echo ~~ Updating : If you select the update option the script will automatically update YT-dlp and Deno,
echo this will take a second and let you know when it's done
echo ~~ If the script isn't working try using the update option and then try again
echo ~~ Links to all of the programs used by this script can be found in the top of the script if you edit it
echo ~~ If nothing at all is downloading and it's erroring out a lot make sure you have Deno installed,
echo the link is in the Readme file
pause
goto mainpart

:exitmode
cls
echo You have chosen to exit the program
timeout 2
exit

mainpart
pause