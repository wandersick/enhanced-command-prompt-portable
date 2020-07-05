@echo off > "%temp%\dupeRemoval.tmp"
rem ************************
rem Name: Enhanced Command Prompt Portable (ECPP)
rem Version: 1.2
rem Scripts: *CommandPrompt.bat*, DirC.bat, ListC.bat
rem Creation Date: 27/7/2009
rem Last Modified: 21/9/2009,3/1/2010
rem Author: wandersick
rem Email: wandersick@gmail.com
rem Web: tech.wandersick.com
rem Supported OS: Windows 2000 or later
rem ************************
rem Description: See "commandprompt.bat /?"
rem ************************
rem Usage: Put in \CommandPromptPortable\Data\Batch.
rem ************************
rem Temp files: dupeRemoval.tmp, tempPath.tmp, originalPath.tmp
rem ************************


REM Check if user specified any switches, if so, display help message
REM The slash is for removing quotes around paramemters

if "%~1"=="/?" goto help
if /i "%~1"=="--help" goto help
if "%~1"=="" goto start

:help

ECHO  ________________________________________________________________
ECHO.
ECHO  Readme: 
ECHO.
ECHO  For use with Command Prompt Portable (i.e. CMD in a USB stick),
ECHO  with dirc.bat and listc.bat
ECHO.
ECHO  Run command line executables from any (sub)directories
ECHO  automatically.
ECHO.
ECHO  For example, I store my collection of commands in \Cmds, but
ECHO  some are very deep inside (\subfolder\subfolder, etc). To run
ECHO  a command I don't have to remember where it is, I simply enter 
ECHO  the command e.g. "dd" without going into any subfolder.
ECHO.
ECHO  It works by dynamically setting PATH to all (sub)directories
ECHO  where the script is run.
ECHO.
ECHO  Default supported exts: .exe .bat .cmd .vbs (modifiable -- see
ECHO  comments)
ECHO.
ECHO  Required folder structures: 
ECHO.
ECHO  "Command Prompt Portable"
ECHO       �x  
ECHO       �x  CommandPromptPortable.exe
ECHO       �x  
ECHO       �u�wData
ECHO       �x  �|�wBatch
ECHO       �x          commandprompt.bat
ECHO       �x          dirc.bat
ECHO       �x          listc.bat
ECHO       �u�wExe
ECHO       �x  �u�wMicrosoft (example)
ECHO       �x  �u�wUnxUtils (example)
ECHO       �x  �x  �u�w...  
ECHO       �x  �x  �|�w...  
ECHO       �x  �x      �|�w...
ECHO.
ECHO  'Command Prompt Portable' -- the base folder (can be anywhere)
ECHO  '\Data\Batch' -- where batches reside: commandprompt, dirc, listc
ECHO  '\Exe' -- where all user-specified command line executables are
ECHO.
ECHO  They are what PATH specifies as well. (Modify below for more
ECHo  locations of PATH -- see comments)
ECHO.
ECHO  Designed for use together with dirc.bat and listc.bat, which lists
ECHO  the available executables inside subfolders I can run, so that I
ECHO  don't have to remember what the executable name is.
ECHO.
ECHO  For example, with "[Microsoft] [UnxUtils] addswap.exe, ..."
ECHO  as the screen output, I can list the content in Microsoft and
ECHO  UnxUtils folders by entering "dirc microsoft UnxUtils". For more
ECHO  info, enter "listc /?" or "dirc /?"
ECHO.
ECHO  Features Summary:
ECHO.
ECHO  - PATH is automatically and dynamically updated on each run
ECHO    (to detect new executables)
ECHO  - Only folders with executables is appended to PATH to save space
ECHO    (optional)
ECHO  - Display a welcome message when Command Prompt Portable is run,
ECHO    where it also shows a list of command line executables placed
ECHO    inside "CommandPromptPortable\Exe\" in the USB drive. Root
ECHO    executables are listed as file1.exe, file2.bat, ... folders are
ECHO    listed as [Folder1], [Folder2]...
ECHO  - Grouping of different cmds using folders: e.g. [Linux] [Windows]
ECHO    (And because to display all executables inside subfolders would
ECHO    consume too much screen space. They are not expanded unless you:)
ECHO  - Work with DirC.bat and ListC.bat to list executables in specified
ECHO    [folder(s)] to easily know the name of the executables that can 
ECHO    be run, e.g. "listC linux windows" (or dirc) would show all 
ECHO    executables inside [linux] and [windows] folders
ECHO  - Doesn't depend on a static location. Command Prompt Portable can
ECHO    be placed anywhere.
ECHO.
ECHO  Updates:
ECHO.
ECHO  - Version 1.1 now uses another dupe removal algorithm which is
ECHO    much faster, so dupe removal is now on by default. (To disable,
ECHO    add 'REM' before line 203-219 and remove 'REM' before line 182)
ECHO  - Improved codes.
ECHO.
ECHO  ________________________________________________________________
ECHO.
ECHO  CommandPrompt.bat
ECHO.
ECHO  Usage:
ECHO.
ECHO   - There's no need to specify a switch using this script, just run.
ECHO.
goto end

:start

color 07
prompt $p$g
title Enhanced Command Prompt Portable

REM TIP: to reload, enter 'commandprompt'

REM check if script is first run or not
REM if script is run by again user entering "CommandPrompt", need to go up one folder
REM (due to "cd Exe" below) otherwise it won't run anymore

if defined runBit cd..
set runBit=1

REM backup original PATH, needed to restore it when user types
REM "CommandPrompt" to reload console; otherwise PATH would grow too big

REM if backup exists, restore it; otherwise, create new.

if exist "%temp%\originalpath.tmp" goto restore
echo %path% > "%temp%\originalPath.tmp"
goto setCritical

:restore

REM delims is asterisk to override default (space or tab) to include whole line

for /f "usebackq delims=*" %%i in ("%temp%\originalPath.tmp") do set PATH=%%i

:setCritical

REM set critical paths (can be modified to suit own use)

REM use %cd% instead of "%~d0\...\CommandPromptPortable" or "for %i in (C D E F...)"
REM in order to minimize complexity and maximize portability

REM the last has to be ended with \ because it will be removed down below.
SET PATH=%PATH%;%CD%\Exe;%CD%\Data\Batch\
cls
ver
echo.

REM show time without the last 3 chracters (.xx)

echo # The time now is: %date% %time:~0,-3%. Take your time!

REM would be more convenient to start here than root

cd Exe
echo.
REM echo # Default Cmds: Windows-native (ref: help), Welcome msg (commandprompt), etc.
REM echo.

REM enable delayed expansion in order to append to the same !variable! in a for loop

setlocal ENABLEDELAYEDEXPANSION
  set custom=# User Cmds: 
  
REM detecting and appending folders to command list shown on console

  for /d %%i in (*) do set custom=!custom![%%~nxi] 

REM ------ dupe removal ------
  
REM 1st version: FAST BUT NO DUPE REMOVAL. detecting and appending folders to PATH

for /d /r %%i in (*) do set path=!path!;%%i

REM export the appended PATH to a temp file to avoid PATH being reset after ENDLOCAL
REM also modify below the extensions shown in console. (By default: exe bat cmd vbs)

REM remove the \ and add ; at the end of PATH to accommodate if the last PATH has space

  echo %path%; > "%temp%\tempPath.tmp"
  for %%i in (*.exe *.bat *.cmd *.vbs) do set custom=!custom!%%~nxi, 
  set custom=%custom%

REM echo the command list without the last 2 characters (which is ',' and ' ' space)

  echo %custom:~0,-2%
endlocal

REM set the PATH from temp file after ENDLOCAL.

for /f "usebackq delims=*" %%k in ("%temp%\tempPath.tmp") do PATH=%%k
echo.
echo # To add executables, put in 'Exe'; to query contents, dirc /? or listc /?
echo.

:end