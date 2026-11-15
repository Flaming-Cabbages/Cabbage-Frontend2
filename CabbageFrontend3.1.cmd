@echo OFF
::Script courtesy of FlamingCabbages, I didn't make YT-dlp, FFmpeg, or Deno though! Links and credit to them VVV
::FFmpeg : https://www.ffmpeg.org/download.html -- https://www.gyan.dev/ffmpeg/builds/
::yt-dlp : https://github.com/yt-dlp/yt-dlp
::Deno   : https://github.com/denoland/deno/ -- https://docs.deno.com/runtime/getting_started/installation/


:: Some supported formats for video
set "allowedformat[mp4]=true"
set "allowedformat[webm]=true"
set "allowedformat[avi]=true"
set "allowedformat[mkv]=true"
set "allowedformat[mov]=true"
:: Some supported formats for Audio
set "allowedformat1[mp3]=true"
set "allowedformat1[m4a]=true"
set "allowedformat1[wav]=true"
set "allowedformat1[ogg]=true"
set "allowedformat1[aac]=true"

:mainpart
cls
set dlppath="%~dp0\thirdpartysoftware\yt-dlp.exe"
set ffmpegpath="%~dp0\thirdpartysoftware\ffmpeg\bin\ffmpeg.exe"
set denopath="%~dp0\thirdpartysoftware\deno\deno.exe"
set settingsfile="%~dp0settings.cfg"

set vidoutpath=%~dp0VideoOutput
set audiooutpath=%~dp0AudioOutput
set videoformat="mp4"
set audioformat="mp3"
for /f "tokens=1* delims=:" %%a in ('findstr /n "^" "%~dp0settings.cfg"') do (
    if "%%a"=="2" set "videoformat=%%b"
    if "%%a"=="4" set "audioformat=%%b"
    if "%%a"=="6" set "vidoutpath=%%b"
    if "%%a"=="8" set "audiooutpath=%%b"
)

echo Choose an option (1: Video Download, 2: Audio Download, 3: Update, 4: Info, 5: Settings, 6: Exit)
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
goto settingsmode
) ELSE IF %option%==6 (
goto exitmode
) ELSE (
goto mainpart
)

:videomode
cls
echo You have chosen to download a video,
set /p "mylink=Paste a link: "
%dlppath% %mylink% --js-runtimes deno:%denopath% --ffmpeg-location %ffmpegpath% -i -o "%vidoutpath%\%%(title)s.%videoformat%"
goto mainpart

:audiomode
cls
echo You have chosen to download audio,
set /p "mylink2=Paste a link: "
%dlppath% %mylink2% --js-runtimes deno:%denopath% --extract-audio --audio-format %audioformat% --ffmpeg-location %ffmpegpath% -i -o "%audiooutpath%\%%(title)s"
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

:: Look I finally added a settings page
:settingsmode
set "videomode="
set "audiomode="
set "videooutfolder="
set "audiooutfolder="
set "newsetting="
set "linenum="
for /f "tokens=1* delims=:" %%a in ('findstr /n "^" "%~dp0settings.cfg"') do (
    if "%%a"=="2" set "videomode=%%b"
    if "%%a"=="4" set "audiomode=%%b"
    if "%%a"=="6" set "videooutfolder=%%b"
    if "%%a"=="8" set "audiooutfolder=%%b"
)
cls
echo - Settings Page -
echo [0] Back
echo [1] Video Format: %videomode%
echo [2] Audio Format: %audiomode%
echo [3] Video Output: %videooutfolder%
echo [4] Audio Output: %audiooutfolder%

set /p "option2=Type Option: "
if %option2%==1 (
set /p "newsetting=Type New Video Format: "
set "linenum=2"
goto editsetting
) ELSE IF %option2%==2 (
set /p "newsetting=Type New Audio Format: "
set "linenum=4"
goto editsetting
) ELSE IF %option2%==3 (
echo (As a hint, typing just a name will use the script's directory^)
set /p "newsetting=Type New Video Output Path: "
set "linenum=6"
goto editsetting
) ELSE IF %option2%==4 (
echo (As a hint, typing just a name will will use the script's directory^)
set /p "newsetting=Type New Audio Output Path: "
set "linenum=8"
goto editsetting
) ELSE IF %option2%==5 (
goto mainpart
)
goto mainpart

:editsetting
if %lineNum%==2 (
call:checkvideo "%newsetting%"
) else if %lineNum%==4 (
call:checkaudio "%newsetting%"
)
powershell -NoProfile -Command ^
    "$lines = Get-Content -Path '%settingsfile%';" ^
    "$lines[%lineNum% - 1] = '%newsetting%';" ^
    "$lines | Set-Content -Path '%settingsfile%'"
echo Setting Changed!
goto settingsmode

::Checks to see if the video format is allowed
:checkvideo
if not defined allowedformat[%~1] (
    echo %newsetting% is not a supported video format, please type a different one
    timeout /t 3
    goto settingsmode
)
goto:eof

::Checks to see if the audio format is allowed
:checkaudio
if not defined allowedformat1[%~1] (
    echo %newsetting% is not a supported audio format, please type a different one
    timeout /t 3
    goto settingsmode
)
goto:eof

::I think you can figure out what this part does
:exitmode
cls
echo You have chosen to exit the program
timeout 2
exit

mainpart
pause