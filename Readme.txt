
  Enhanced Command Prompt Portable | v1.1 | 21/9/2009 
  (Scripts: CommandPrompt.bat, DirC.bat, ListC.bat)
  
  by wanderSick@C7PE
  Email: wander.sic.k@gmail.com | Web: wandersick.blogspot.com
      
  Supports Windows 2000 or later
  ________________________________________________________________
  
  Updates:

  - Since Version 1.1 dupe removal is on by default, as script now
    uses another dupe removal algorithm which is much faster. Now
    having a lot of useless folders won't fill up PATH too soon.
  - Improved codecs.
  ________________________________________________________________
  
  Words for Chinese users:
  
  如需要中文介面，請解壓 Data\Batch\chinese.zip 並取代現有檔案。
  (建議使用英文版，因為中文字在英文 Windows 下可能變成亂碼。)
  ________________________________________________________________

  Readme for CommandPrompt.bat: 

  For use with Command Prompt Portable (i.e. CMD in a USB stick),
  with dirc.bat and listc.bat

  Run command line executables from any (sub)directories
  automatically.

  For example, I store my collection of commands in \Cmds, but
  some are very deep inside (\subfolder\subfolder, etc). To run
  a command I don't have to remember where it is, I simply enter 
  the command e.g. "dd" without going into any subfolder.

  It works by dynamically setting PATH to all (sub)directories
  where the script is run.

  Default supported exts: .exe .bat .cmd .vbs (modifiable -- see
  comments)

  Required folder structures: 

  "Command Prompt Portable"
       │  
       │  CommandPromptPortable.exe
       │  
       ├─Data
       │  └─Batch
       │          commandprompt.bat
       │          dirc.bat
       │          listc.bat
       ├─Exe
       │  ├─Microsoft (example)
       │  ├─UnxUtils (example)
       │  │  ├─...  
       │  │  └─...  
       │  │      └─...

  'Command Prompt Portable' -- the base folder (can be anywhere)
  '\Data\Batch' -- where batches reside: commandprompt, dirc, listc
  '\Exe' -- where all user-specified command line executables are

  They are what PATH specifies as well. (Modify below for more
  locations of PATH -- see comments)

  Designed for use together with dirc.bat and listc.bat, which lists
  the available executables inside subfolders I can run, so that I
  don't have to remember what the executable name is.

  For example, with "[Microsoft] [UnxUtils] addswap.exe, ..."
  as the screen output, I can list the content in Microsoft and
  UnxUtils folders by entering "dirc microsoft UnxUtils". For more
  info, enter "listc /?" or "dirc /?"

  Features Summary:

  - PATH is automatically and dynamically updated on each run
    (to detect new executables)
  - Only folders with executables is appended to PATH to save space
    (optional)
  - Display a welcome message when Command Prompt Portable is run,
    where it also shows a list of command line executables placed
    inside "CommandPromptPortable\Exe\" in the USB drive. Root
    executables are listed as file1.exe, file2.bat, ... folders are
    listed as [Folder1], [Folder2]...
  - Grouping of different cmds using folders: e.g. [Linux] [Windows]
    (And because to display all executables inside subfolders would
    consume too much screen space. They are not expanded unless you:)
  - Work with DirC.bat and ListC.bat to list executables in specified
    [folder(s)] to easily know the name of the executables that can 
    be run, e.g. "listC linux windows" (or dirc) would show all 
    executables inside [linux] and [windows] folders
  - Doesn't depend on a static location. Command Prompt Portable can
    be placed anywhere.

  ________________________________________________________________

  Readme for DirC.bat and ListC.bat:

     For use with commandprompt.bat

     List files from directories specified recursively.
     Files exts by default are: .exe .bat .cmd .vbs (set in script)

     For example, I store my collection of commands in
     \Cmds\subfolders. To see what command a subfolder called
     'microsoft' (and its subfolders) contain I simply enter
     "dirc microsoft".
     
     Without this script, I would need to do this instead:                 
     dir /w /s Microsoft\*.vbs microsoft\*.bat microsoft\*.cmd
     microsoft\*.vbs

     I can specify multiple folders at the same time, e.g.
     "dirc microsoft unxutils"
     Or simply list all executables by "dirc /all"

     Designed for use with my Command Prompt Portable script,
     which is a batch file in "\CommandPromptPortable\Data\Batch 
     \commandprompt.bat" Command Prompt Portable runs each time,
     where PATH is dynamically updated with all subfolders that
     contain executables, from a base folder where the user runs the
     script, so that, for example, entering "dd" would run the dd.exe
     in "\Cmds\UnxUtils\usr\local\wbin" without going there.

     Together, they are useful for listing and running available
     command line executables stored in a USB flash drive.

     Also take a read: enter "notepad commandprompt.bat"

  Features:

     - Avoid remembering the names (and locations*) of executables
     - Lists exe bat cmd vbs (changeable) in specified (sub)folder(s)
       in Dir /w style 
     - Accepts multiple inputs, accept /all switch
     - Work with *commandprompt.bat as a welcome message for Command
       Prompt Portable, to have PATH automatically and dynamically
       updated to easily locate all programs in a USB flash drive,
       to easily know the name of the executables that can be run 

  ________________________________________________________________
  
    CommandPrompt.bat

  Usage:

   - There's no need to specify a switch using this script, just run.

  ________________________________________________________________

  DirC.bat

   - list command line executables (.exe .bat .cmd .vbs) from specified
     folders recursively in "DIR /W" style

  Usage: dirc [folder1, folder2...] [/all]

  Examples: [Microsoft] [Windows Support Tools] [WAIK] addswap.exe, ...

     1) List from 'Windows Support Tools' folder
        - dirc "Windows Support Tools"

     2) List from 'Microsoft' and 'WAIK' folders
        - dirc microsoft waik

     3) List from all locations (current and subfolders)
        - dirc /all 

     Alternative display style: listc.bat, see "listc /?"

  ________________________________________________________________

  ListC.bat

   - list command line executables (.exe .bat .cmd .vbs) from specified
     folders recursively

  Usage: listc [folder1, folder2...] [/all]

  Examples: [Microsoft] [Windows Support Tools] [WAIK] addswap.exe, ...

     1) List from 'Windows Support Tools' folder
        - listc "Windows Support Tools"

     2) List from 'Microsoft' and 'WAIK' folders
        - listc microsoft waik

     3) List from all locations (current and subfolders)
        - listc /all 

     Alternative display style: DirC.bat, see "dirc /?"

  ________________________________________________________________
  
  If you have any comments, please email to wander.sic.k@gmail.com, or reply
  wandersick.blogspot.com/2009/09/my-customized-command-prompt-portable.html
  