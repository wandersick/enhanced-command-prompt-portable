;Copyright (C) 2004-2009 John T. Haller of PortableApps.com
;Passed directory portaion (C) 2008 freemp

;Website: http://portableapps.com/

;This software is OSI Certified Open Source Software.
;OSI Certified is a certification mark of the Open Source Initiative.

;This program is free software; you can redistribute it and/or
;modify it under the terms of the GNU General Public License
;as published by the Free Software Foundation; either version 2
;of the License, or (at your option) any later version.

;This program is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.

;You should have received a copy of the GNU General Public License
;along with this program; if not, write to the Free Software
;Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

!define NAME "CommandPromptPortable"
!define PORTABLEAPPNAME "Command Prompt Portable"
!define APPNAME "Command Prompt Portable"
!define VER "2.1.0.0"
!define WEBSITE "PortableApps.com"
!define LAUNCHERLANGUAGE "english"

;=== Program Details
Name "${PORTABLEAPPNAME}"
OutFile "..\..\${NAME}.exe"
Caption "${PORTABLEAPPNAME} | PortableApps.com"
VIProductVersion "${VER}"
VIAddVersionKey ProductName "${PORTABLEAPPNAME}"
VIAddVersionKey Comments "Allows ${APPNAME} to be run from a removable drive.  For additional details, visit ${WEBSITE}"
VIAddVersionKey CompanyName "PortableApps.com"
VIAddVersionKey LegalCopyright "John T. Haller"
VIAddVersionKey FileDescription "${PORTABLEAPPNAME}"
VIAddVersionKey FileVersion "${VER}"
VIAddVersionKey ProductVersion "${VER}"
VIAddVersionKey InternalName "${PORTABLEAPPNAME}"
VIAddVersionKey LegalTrademarks "PortableApps.com is a registered trademark of Rare Ideas, LLC."
VIAddVersionKey OriginalFilename "${NAME}.exe"
;VIAddVersionKey PrivateBuild ""
;VIAddVersionKey SpecialBuild ""

;=== Runtime Switches
CRCCheck On
WindowIcon Off
SilentInstall Silent
AutoCloseWindow True
RequestExecutionLevel user
XPStyle On

; Best Compression
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On

;=== Include
;(NSIS)
!include FileFunc.nsh
!insertmacro GetRoot
!insertmacro GetParameters

;(Plugins)
!include Registry.nsh

;(Custom)
!include ReadINIStrWithDefault.nsh

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

;=== Languages
LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LAUNCHERLANGUAGE}.nlf"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh

;=== Variables
Var ComSpec
Var ExecString
Var MISSINGFILEORPATH
Var ENABLEAUTOCOMPLETE

Section "Main"
	${ReadINIStrWithDefault} $ENABLEAUTOCOMPLETE "$EXEDIR\${NAME}.ini" "${NAME}" "EnableAutoComplete" "false"

	;ComSpecCheck:
		;=== Be sure the ComSpec environment variable is set right
		ReadEnvStr $R0 "COMSPEC"
		StrLen $0 $R0
		IntCmp $0 1 CreateComSpec CreateComSpec CheckForData
		
	CreateComSpec:
		;=== We need to set the variable
		ReadEnvStr $R0 "SYSTEMROOT"
		IfFileExists "$R0\system32\cmd.exe" "" AltComSpecPath
		System::Call 'Kernel32::SetEnvironmentVariableA(t, t) i("COMSPEC", "$R0\system32\cmd.exe").r0'
		Goto CheckForData

	AltComSpecPath:
		IfFileExists "$R0\command.com" "" NoComSpec
		System::Call 'Kernel32::SetEnvironmentVariableA(t, t) i("COMSPEC", "$R0\command.com").r0'
		Goto CheckForData

	NoComSpec:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH "command.com/cmd.exe"
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort

	CheckForData:
		;=== Setup the options
		IfFileExists "$EXEDIR\Data\Batch\commandprompt.bat" SetupExecString
			CreateDirectory "$EXEDIR\Data\Batch"
			CopyFiles /SILENT "$EXEDIR\App\DefaultData\Batch\commandprompt.bat" "$EXEDIR\Data\Batch"
	
	SetupExecString:
		${GetRoot} $EXEDIR $0
		SetOutPath "$0\"
		ReadEnvStr $ComSpec "COMSPEC"
		StrCpy $ExecString `"$ComSpec" /d /k`
		IfFileExists "$EXEDIR\Data\Batch\commandprompt.bat" "" GetPassedParameters
			StrCpy $ExecString `$ExecString "$EXEDIR\Data\Batch\commandprompt.bat"`
			
	GetPassedParameters:
		;=== Get any passed parameters
		${GetParameters} $R0
		StrCmp "'$R0'" "''" PrepareLaunch ;if blank, launch now
			StrCpy $1 $R0 1
			StrCmp $1 `"` "" GetPassedParametersRoot
				StrCpy $R0 $R0 "" 1
				StrCpy $R0 $R0 -1
			
			GetPassedParametersRoot:
			${GetRoot} $R0 $R1
			StrLen $0 $R1
			IntCmp $0 2 0 +1 +1
				StrCpy $ExecString `$ExecString && $R1`
				StrCpy $R1 $R0 "" $0
				StrLen $0 $R1
				IntCmp $0 0 PrepareLaunch PrepareLaunch
					StrCpy $ExecString `$ExecString && cd $R1`

	PrepareLaunch:
		StrCmp $ENABLEAUTOCOMPLETE "true" LaunchAndWait LaunchAndExit

	LaunchAndWait:
		System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${NAME}") i .r1 ?e'
		Pop $0
		StrCmp $0 0 "" LaunchAndExit
		${registry::Read} "HKEY_CURRENT_USER\Software\Microsoft\Command Processor" "CompletionChar" $R0 $R2
		${registry::Write} "HKEY_CURRENT_USER\Software\Microsoft\Command Processor" "CompletionChar" "9" "REG_DWORD" $R2
		${registry::Write} "HKEY_CURRENT_USER\Software\Microsoft\Command Processor" "CompletionCharBackup" $R0 "REG_DWORD" $R2
		ExecWait $ExecString
		${registry::DeleteValue} "HKEY_CURRENT_USER\Software\Microsoft\Command Processor" "CompletionChar" $R2
		${registry::Read} "HKEY_CURRENT_USER\Software\Microsoft\Command Processor" "CompletionCharBackup" $R0 $R2
		StrCmp $R0 "" TheEnd
		${registry::DeleteValue} "HKEY_CURRENT_USER\Software\Microsoft\Command Processor" "CompletionCharBackup" $R2
		StrCmp $R0 "0" TheEnd
		${registry::Write} "HKEY_CURRENT_USER\Software\Microsoft\Command Processor" "CompletionChar" $R0 "REG_DWORD" $R2
		Goto TheEnd
	
	LaunchAndExit:
		Exec $ExecString
		Goto TheEnd
	
	TheEnd:
		${registry::Unload}
SectionEnd