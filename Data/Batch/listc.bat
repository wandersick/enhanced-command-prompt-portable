@echo off
:: ******************************************************
::                                                      
::   listc is now deprecated, please use 'dirc' instead 
::                                                       
:: ******************************************************
:: Name: ECPP (Enhanced Command Prompt Portable)
:: Version: 1.2
:: Scripts: CommandPrompt.bat, DirC.bat, Config_Menu.bat,
::          ListC.bat (Deprecated), Setup.bat, Update.bat
:: Creation Date: 4/9/2009
:: Last Modified: 2/11/2009
:: Author: wandersick
:: Email: wandersick@gmail.com
:: Web: wandersick.blogspot.com
:: Supported OS: Windows 2000 or later
:: ******************************************************
:: Description: use with commandprompt.bat. see "listc /?"
:: ******************************************************
:: Usage: see "listc /?"
:: ******************************************************

SETLOCAL ENABLEDELAYEDEXPANSION

if defined debug echo :: Debugging mode 1 is ON.
if defined debug2 echo on&set debug=1&echo :: Debugging mode 2 is ON.

:: this batch takes settings from from "_config.bat" if available
if not defined ECPP (
	set extentions=com exe bat cmd vbs vbe js jse wsf wsh msc
	@for %%i in (%extentions%) do call set ext1=%%ext1%%"*.%%i" 
)

:: defines extentions
:: FYI: sample outputs:
:: ext1: "*.com" "*.exe" "*.bat" "*.cmd" "*.vbs" "*.vbe" "*.js" "*.jse" "*.wsf" "*.wsh" "*.msc"
:: ext2" "h*.com" "h*.exe" "h*.bat" "h*.cmd" "h*.vbs" "h*.vbe" "h*.js" "h*.jse" "h*.wsf" "h*.wsh" "h*.msc"
:: ext3: "h\*.com" "h\*.exe" "h\*.bat" "h\*.cmd" "h\*.vbs" "h\*.vbe" "h\*.js" "h\*.jse" "h\*.wsf" "h\*.wsh" "h\*.msc"

:: Check if user specified any switches, if not, display help message
:: The slash is for removing quotes around paramemters

if /i "%~1"=="/all" goto all
if /i "%~1"=="-all" goto all
if "%~1"=="/?" goto help
if /i "%~1"=="--help" goto help
if not "%~1"=="" goto start

:help

ECHO  ________________________________________________________________
echo.
echo  ListC Readme:
echo.
echo     For use with commandprompt.bat
echo.
echo     List files from directories specified recursively.
ECHO     Files exts by default are: .exe .bat .cmd .vbs (set in script)
echo.
ECHO     For example, I store my collection of commands in
ECHO     \Cmds\subfolders. To see what command a subfolder called
ECHO     'microsoft' (and its subfolders) contain I simply enter
ECHO     "listc microsoft".
echo.
ECHO     Sample output: bootsect.exe, clip.exe, fciv.exe, xacls.vbs
ECHO.     
ECHO     Without this script, I would need to do this instead:                 
ECHO     dir /b /s Microsoft\*.vbs microsoft\*.bat microsoft\*.cmd
ECHO     microsoft\*.vbs
echo.
ECHO     I can specify multiple folders at the same time, e.g.
ECHO     "listc microsoft unxutils"
ECHO     Or simply list all executables by "listc /all"
echo.
ECHO     Designed for use with my Command Prompt Portable script,
ECHO     which is a batch file in "\CommandPromptPortable\Data\Batch 
ECHO     \commandprompt.bat" Command Prompt Portable runs each time,
ECHO     where PATH is dynamically updated with all subfolders that
ECHO     contain executables, from a base folder where the user runs the
ECHO     script, so that, for example, entering "dd" would run the dd.exe
ECHO     in "\Cmds\UnxUtils\usr\local\wbin" without going there.
echo.
ECHO     Together, they are useful for listing and running available
ECHO     command line executables stored in a USB flash drive.
echo.
echo     Also take a read: enter "notepad commandprompt.bat"
ECHO.
ECHO  Features:
ECHO.
ECHO     - Avoid remembering the names (and locations*) of executables
ECHO     - Lists exe bat cmd vbs (changeable) in specified (sub)folder(s)
ECHO       comma after comma
ECHO     - For use with commandprompt.bat to easily know the name of the
ECHO       executables that can be run
ECHO     - Accepts multiple inputs, accept /all switch
ECHO     - Work with *commandprompt.bat as a welcome message for Command
ECHO       Prompt Portable, to have PATH automatically and dynamically
ECHO       updated to easily locate all programs in a USB flash drive,
ECHO       to easily know the name of the executables that can be run 
ECHO.
ECHO  ________________________________________________________________
ECHO.
ECHO  ListC.bat
ECHO.
ECHO   - list command line executables (.exe .bat .cmd .vbs) from specified
ECHO     folders recursively
ECHO.
ECHO  Usage: listc [folder1, folder2...] [/all]
ECHO.
ECHO  Examples: [Microsoft] [Windows Support Tools] [WAIK] addswap.exe, ...
echo.
ECHO     1) List from 'Windows Support Tools' folder
ECHO        - listc "Windows Support Tools"
ECHO.
ECHO     2) List from 'Microsoft' and 'WAIK' folders
ECHO        - listc microsoft waik
ECHO.
ECHO     3) List from all locations (current and subfolders)
ECHO        - listc /all 
ECHO.
ECHO     Alternative display style: DirC.bat, see "dirc /?"
ECHO.
ECHO  ________________________________________________________________
ECHO.
ECHO         ListC is now deprecated, please use DirC instead  
ECHO  ________________________________________________________________
goto end

:all

:: Return all .exe .bat .cmd .vbs files that resides in from current folder recursively

for /r ".\Cmds" %%i in (*.exe *.bat *.cmd *.vbs) do set list=!list!%%~nxi, 
goto output

:start

:: this should be placed here, after :start!
for %%i in (%extentions%) do call set ext2=%%ext2%%"%~1*.%%i" 
for %%i in (%extentions%) do call set ext4=%%ext4%%"%~n1*.%%i" 

:: New: Changes to allow for using wildcard * as in "listc UnxUtils\w*" and "listc w*"

:: Detect if * exists
echo "%1" > "%temp%\listc_temp"
find "*" "%temp%\listc_temp" >nul 2>&1
if %errorlevel% EQU 0 goto wildcard

:: Check if folder exists (to prevent weird messages)
:: Because non-wildcard case must not be folder, hence for the more strict check. (%~1)
dir /ad "%~1" >nul 2>&1
if %errorlevel% NEQ 0 goto error

:: "%~dpn1" to cover the name (n) as well, although it is directory
for /r "%~dpn1" %%i in (%ext1%) do set list=!list!%%~nxi, 
goto skipWildcard

:wildcard

:: %~dp1 instead of %1 to allow existence check of parent folder to succeed.
:: Less strick check (Allow parent folder). Used with wildcard case only (%~dp1)

:: Check if *parent* folder exists (to prevent weird messages)
dir /ad "%~dp1" >nul 2>&1
if %errorlevel% NEQ 0 goto error

:: There is sth with ~n* that automatically expands to the nearest item there is (e.g. w* becomes WAIK),
:: in that case, "unxutils\w*" works but "listc w*" doesn't, hence the 2 for loops

:: Undefined variable works automatically as it adds up, it cannot echo 0 when it has nothing to add;
:: so the output can be still undefined sometimes... 0 *looks* better in that case... 
set counter=0
:: "set /a counter+=1" is the same as "set /a counter=!counter!+1"
for /r "%~dp1" %%i in (%ext4%) do (set list=!list!%%~nxi, &set /a counter+=1)
:: when counter is 0, i.e. it fails to list any file, try the alternative way where ~n* is removed to
:: avoid automatic expanding causing it to search for wrong things.
:: Practically, that means, when "listc w*" fails (due to becoming listc WAIK, for ex.), do this:
if "%counter%"=="0" for /r "%~dp1" %%i in (%ext2%) do (set list=!list!%%~nxi, )

:: in the above for loops it also made use of replaceable variables inside a list

:skipWildcard
:: Deleting temp file
del /q /f "%temp%\listc_temp"

:: Check if user specified multple folders

if "%~2"=="" goto output
shift
goto start

:output

:: Output without the last 2 characters

echo.
echo  # listc is now deprecated, please use 'dirc' instead
echo.
echo %list:~0,-2%
goto end

:error

:: User specified a wrong folder

ECHO.
ECHO  ERROR: Folder not found, Please check spelling^^^!
ECHO.
goto end

:end
endlocal