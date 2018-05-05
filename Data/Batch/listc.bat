@echo off
rem ************************
rem Name: Enhanced Command Prompt Portable
rem Version: 1.1
rem Scripts: CommandPrompt.bat, DirC.bat, *ListC.bat*
rem Creation Date: 4/9/2009
rem Last Modified: 4/9/2009
rem Author: wanderSick@C7PE
rem Email: wander.sic.k@gmail.com
rem Web: wandersick.blogspot.com
rem Supported OS: Windows 2000 or later
rem ************************
rem Description: use with commandprompt.bat. see "listc /?"
rem ************************
rem Usage: see "listc /?"
rem ************************

SETLOCAL ENABLEDELAYEDEXPANSION

REM Check if user specified any switches, if not, display help message
REM The slash is for removing quotes around paramemters

if /i "%~1"=="/all" goto all
if /i "%~1"=="-all" goto all
if "%~1"=="/?" goto help
if /i "%~1"=="--help" goto help
if not "%~1"=="" goto start

:help

ECHO  ________________________________________________________________
echo.
echo  Readme:
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
goto end

:all

REM Return all .exe .bat .cmd .vbs files that resides in from current folder recursively

for /r ".\Cmds" %%i in (*.exe *.bat *.cmd *.vbs) do set list=!list!%%~nxi, 
goto output

:start

REM Check if folder exists (to prevent weird messages)

dir /ad %1 >nul 2>&1
if %errorlevel% NEQ 0 goto error

for /r ".\%~1" %%i in (*.exe *.bat *.cmd *.vbs) do set list=!list!%%~nxi, 

REM Check if user specified multple folders

if "%~2"=="" goto output
shift
goto start

:output

REM Output without the last 2 characters

echo %list:~0,-2%
goto end

:error

REM User specified a wrong folder

ECHO.
ECHO  ERROR: Folder not found. Please check spelling!
ECHO.
goto end

:end
ENDLOCAL