@echo off
:: *********************************************************
:: Name: ECPP (Enhanced Command Prompt Portable)
:: Version: 1.2
:: Scripts: CommandPrompt.bat, DirC.bat, Config_Menu.bat,
::          ListC.bat (Deprecated), ECPP.bat, Update.bat...
:: Creation Date: 4/9/2009
:: Last Modified: 25/12/2009
:: Author: wandersick
:: Email: wandersick@gmail.com
:: Web: tech.wandersick.com
:: Supported OS: Windows 2000 or later
:: *********************************************************
:: Description: use with commandprompt.bat. see "dirc /?"
:: *********************************************************
:: Usage: see "dirc /?"
:: *********************************************************
:: Related: macro.ini, quotes_en|chs|cht.txt,
::          _config.bat, _choiceMulti.bat, _choiceYN.bat,
::          _elevate.vbs, ecpp_shortcut.vbs, ecpp_noReg.vbs,
::          ecpp_uninstall.bat, ecpp_uninstall.vbs
:: *********************************************************

SETLOCAL

if defined debug echo :: Debugging mode 1 is ON.
if defined debug2 echo on&set debug=1&echo :: Debugging mode 2 is ON.

:: this batch takes settings from from "_config.bat" if available
if not defined ECPP (
	set extentions=com exe bat cmd vbs vbe js jse wsf wsh msc
	set dircStyle=/w /s /l
	@for %%i in (%extentions%) do call set ext1=%%ext1%%"*.%%i" 
)

:: defines extentions
:: FYI: sample outputs:
:: ext1: "*.com" "*.exe" "*.bat" "*.cmd" "*.vbs" "*.vbe" "*.js" "*.jse" "*.wsf" "*.wsh" "*.msc"
:: ext2" "h*.com" "h*.exe" "h*.bat" "h*.cmd" "h*.vbs" "h*.vbe" "h*.js" "h*.jse" "h*.wsf" "h*.wsh" "h*.msc"
:: ext3: "h\*.com" "h\*.exe" "h\*.bat" "h\*.cmd" "h\*.vbs" "h\*.vbe" "h\*.js" "h\*.jse" "h\*.wsf" "h\*.wsh" "h\*.msc"

set ext1=&set ext2=&set ext3=
for %%i in (%extentions%) do call set ext1=%%ext1%%"*.%%i" 

:: Check if user specified any switches, if not, display help message
:: The slash is for removing quotes around paramemters

if /i "%~1"=="/all" goto all
if /i "%~1"=="-all" goto all
if "%~1"=="/?" goto help
if /i "%~1"=="--help" goto help
:: pause after help for -h
if /i "%~1"=="-h" goto help
if not "%~1"=="" goto start

:help

ECHO     ________________________________________________________________
echo.
ECHO                DirC for Enhanced Command Prompt Portable
ECHO     ________________________________________________________________
echo.
ECHO     Only remember the name of command partly? Use DirC to searches
ECHO     using wildcard.
ECHO.
ECHO     Don't even remember its name but know which folder its in? Use
ECHO     DirC to query Executables available in that folder
ECHO.
ECHO     With DirC, you don't need to remember where you'd put the exe or
ECHO     what its full name is. How so? ECPP provides the capability to
ECHO     use a command in any sub-sub-folders right from startup without
ECHO     changing into the directories.
ECHO.
ECHO     Together, DirC and ECPP make a good combination.
echo.
ECHO     Syntax: Dirc [directory1, directory2 ^| file wildcard][/all]
echo.
ECHO     Example 1: dirc UnxUtils
ECHO                - Returns any executables in "UnxUtils" folder
echo.
ECHO             2: dirc de*
ECHO                - Returns any executables named de*
echo.
ECHO             3: dirc "Windows Tools\de*"
ECHO                - Returns any executables named de* in "Windows Tools"
echo.
ECHO             4: dirc "Microsoft" "Linux"
ECHO                - Returns any executables "Microsoft" and "Linux"
echo.
ECHO             5: dirc * ^(or /all^)
ECHO                - Returns all executables
echo.
ECHO     # Accepts multiple folders as inputs; accepts wildcards
echo.
ECHO     # Executable extensions can be defined in Advanced Configuration.
ECHO       By default, these are considered as executables:
echo.
ECHO       com exe bat cmd vbs vbe js jse wsf wsh msc
echo.
ECHO     # Dirc makes use of DIR command. You can control the style of 
ECHO       output in just the same way as DIR. Modify it in the Advanced
ECHO       Configuration file. By default: 
echo.
ECHO       /w /s /l ^(Wide list, include Sub-folders, Use Lower case^)
echo.
ECHO     # The main reason for Dirc is you don't have to achieve the not-
ECHO       quite-the-same-effect using a long long command with DIR.
echo.
ECHO     # DirC is in some way similiar to the "where" command available
ECHO       since Windows 2003, except that "where searches everything in
ECHO       PATH, while DirC only searches folders inside "Exe" folder;
ECHO       except that "where" doesn't accept directories, while DirC
ECHO       eats everything.
echo.
ECHO     # ListC was an alternative to DirC but is now deprecated.
echo.
ECHO     ________________________________________________________________
echo.
if /i "%~1"=="-h" pause >nul 2>&1
goto :EOF

:all

:: Return all .exe .bat .cmd .vbs files that resides in from current folder recursively

:: ex: dir /w /s *.exe *.bat *.cmd *.vbs
dir %dircStyle% %ext1%
goto end

:start

:: this should be placed here, after :start!
for %%i in (%extentions%) do call set ext2=%%ext2%%"%~1*.%%i" 
for %%i in (%extentions%) do call set ext3=%%ext3%%"%~1\*.%%i" 

:: Check if folder exists (to prevent weird messages)

:: New: 2 changes to allow for using wildcard * as in "dirc UnxUtils\p*" and "dirc p*"
:: Change 1: %~dp1 instead of %1 to allow existence check of parent folder to succeed
dir /ad "%~dp1" >nul 2>&1
if %errorlevel% NEQ 0 goto error

:: Change 2: Not using wildcard causes failure with the next changed line ("%~1*.exe") causes failure,
:: unless manually add a slash at the end (dirc UnxUtils\). To avoid the trouble, check if there's any
:: error, if there is, revert to the old line. ("%~1\*.exe")

:: FYI: ext3 - dir. ext2 - file.
:: NEW CHANGE: check if user is checking directory (ext3) instead of file (ext2).
:: folder now prioritized over file

:: if the batch detects user 's search term is a folder that exists, output the content inside the folder
dir %dircStyle% %ext3% >nul 2>&1
if %errorlevel% EQU 0 (dir %dircStyle% %ext3%) else (dir %dircStyle% %ext2%)

:: the below is the old one, which returned wsccportable.exe instead of the folder.
:: if user needs to search for folder instead of files, user need to add a alash: dirc wscc\
:: so folder now prioritized over file, since this batch is meant for ease of use with folders by tabbing
:: ex: dir %dircStyle% %ext2% >nul 2>&1
:: ex: if %errorlevel% EQU 0 (dir %dircStyle% %ext2%) else (dir %dircStyle% %ext3%)

:: *** although this batch automatically adapts to file/folder, user should enter asterisk at all time when searching for files
:: if user want to search for file instead of folder, user should add a asterisk: dirc addsw*

:: this one-for-both solution was considered before but cancalled since there're dupes:
:: not implemented: dir %dircStyle% %ext2% %ext3% 2>nul

:: Check if user specified multple folders

if "%~2"=="" goto end
shift
goto start

:error

:: User specified a wrong folder

ECHO.
ECHO  ERROR: Folder not found. Please check spelling!
ECHO.
goto end

:end
endlocal