; <COMPILER: v1.1.08.01>
#SingleInstance Force
#Persistent
#NoEnv
#NoTrayIcon
Setkeydelay,-1
SetControlDelay,-1
Detecthiddenwindows,on
Coordmode,Menu,Window
Version := "0.52"
KeyTemp :=
Repeat :=
VimAction :=
KeyCount := 0
Global Vim := true
Global InsertMode := False
Global VimRN
Global VimRN_Count
Global VimRN_ID
Global VimRN_History := Object()
Global VimRN_Temp
Global VimRN_Vis := False
Global VimRN_IsReplace := False
Global VimRN_IsMultiReplace := False
Global VimRN_IsFind := False
GroupKey_Arr := object()
MapKey_Arr := object()
ExecFile_Arr := object()
SendText_Arr := object()
Command_Arr := object()
CmdHistory_Arr := object()
Mark_Arr := object()
HideControl_Arr := object()
ActionInfo_Arr := object()
HelpInfo_Arr := object()
GroupInfo_Arr := object()
ReName_Arr := Object()
STabs := Object()
HideControl_Arr["Toggle"] := False
TcExe := FindPath("exe")
TcIni := FindPath("ini")
Splitpath,TcExe,,TcDir
If RegExMatch(TcExe,"i)totalcmd64\.exe")
{
Global TCListBox := "LCLListBox"
Global TCEdit := "Edit2"
GLobal TCPanel1 := "Window1"
Global TCPanel2 := "Window11"
}
Else
{
Global TCListBox := "TMyListBox"
Global TCEdit := "Edit1"
Global TCPanel1 := "TPanel1"
Global TCPanel2 := "TMyPanel8"
}
RegRead,ViATcIni,HKEY_CURRENT_USER,Software\VIATC,ViATcINI
If Not FileExist(ViATcINI)
ViatcIni := TcDir . "\viatc.ini"
GoSub,<ConfigVar>
Menu,VimRN_Set,Add,默认Vim模式`tAlt+V,VimRN_SelMode
Menu,VimRN_Set,Add,默认选择后缀`tAlt+E,VimRN_SelExt
Menu,VimRN_MENU,Add,选项(&G),:VimRN_Set
Menu,VimRN_MENU,Add,帮助(&H),VimRN_Help
Menu,Tray,NoStandard
Menu,Tray,Add,运行TC(&T),<ToggleTC>
Menu,Tray,Add,禁用(&E),<EnableVIM>
Menu,Tray,Add,重启(&R),<ReLoadVIATC>
Menu,Tray,Add
Menu,Tray,Add,选项(&O),<Setting>
Menu,Tray,Add,帮助(&H),<Help>
Menu,Tray,Add
Menu,Tray,Add,退出(&X),<QuitVIATC>
Menu,Tray,Tip,Vim Mode At TotalCommander
Menu,Tray,Default,运行TC(&T)
If TrayIcon
Menu,Tray,Icon
SetHelpInfo()
SetVimAction()
SetActionInfo()
SetDefaultKey()
ReadKeyFromIni()
EmptyMem()
return
<ConfigVar>:
Vim := GetConfig("Configuration","Vim")
Toggle := TransHotkey(GetConfig("Configuration","Toggle"),"ALL")
GlobalTogg := GetConfig("Configuration","GlobalTogg")
If GlobalTogg
{
Hotkey,%Toggle%,<ToggleTC>,On,UseErrorLevel
Toggle := GetConfig("Configuration","Toggle")
}
Else
{
HotKey,Ifwinactive,AHK_CLASS TTOTAL_CMD
Hotkey,%Toggle%,<ToggleTC>,On,UseErrorLevel
Toggle := GetConfig("Configuration","Toggle")
}
Susp := TransHotkey(GetConfig("Configuration","Suspend"),"ALL")
GlobalSusp := GetConfig("Configuration","GlobalSusp")
If GlobalSusp
{
HotKey,Ifwinactive
Hotkey,%Susp%,<EnableVim>,On,UseErrorLevel
Susp := GetConfig("Configuration","Suspend")
}
Else
{
HotKey,Ifwinactive,AHK_CLASS TTOTAL_CMD
Hotkey,%Susp%,<EnableVim>,On,UseErrorLevel
Susp := GetConfig("Configuration","Suspend")
}
TrayIcon := GetConfig("Configuration","TrayIcon")
Service := GetConfig("Configuration","Service")
If Not Service
{
IfWinExist,AHK_CLASS TTOTAL_CMD
Winactivate,AHK_CLASS TTOTAL_CMD
Else
{
Run,%TcExe%,,UseErrorLevel
If ErrorLevel = ERROR
TcExe := FindPath("exe")
}
WinWait,AHK_CLASS TTOTAL_CMD
Settimer,<CheckTCExist>,100
}
StartUp := GetConfig("Configuration","Startup")
If StartUp
{
RegRead,IsStartup,HKEY_CURRENT_USER,SOFTWARE\Microsoft\Windows\CurrentVersion\Run,ViATc
If Not RegExMatch(IsStartup,A_ScriptFullPath)
{
RegWrite,REG_SZ,HKEY_CURRENT_USEr,SOFTWARE\Microsoft\Windows\CurrentVersion\Run,ViATc,%A_ScriptFullPath%
If ErrorLevel
Msgbox,16,ViATc,设置开机启动失败,3
}
}
Else
Regdelete,HKEY_CURRENT_USER,SOFTWARE\Microsoft\Windows\CurrentVersion\Run,ViATc
GroupWarn := GetConfig("Configuration","GroupWarn")
GlobalSusp := GetConfig("Configuration","GlobalSusp")
TransParent := GetConfig("Configuration","TransParent")
TranspHelp := GetConfig("Configuration","TranspHelp")
MaxCount := GetConfig("Configuration","MaxCount")
TranspVar := GetConfig("Configuration","TranspVar")
DefaultSE := GetConfig("SearchEngine","Default")
SearchEng := GetConfig("SearchEngine",DefaultSE)
LnkToDesktop := GetConfig("Other","LnkToDesktop")
Return
<32768>:
Get32768()
RETURN
Get32768()
{
Global InsertMode
WinGet,MenuID,ID,AHK_CLASS #32768
IF MenuID
InsertMode := True
ELSE
{
InsertMode := False
SetTimer,<32768>,OFF
}
}
<GroupKey>:
GroupKey(A_ThisHotkey)
Return
<CheckTCExist>:
IfWinNotExist,AHK_CLASS TTOTAL_CMD
ExitApp
Return
<RemoveToolTip>:
SetTimer,<RemoveToolTip>, Off
ToolTip
return
<RemoveToolTipEx>:
Ifwinnotactive,AHK_CLASS TTOTAL_CMD
{
SetTimer,<RemoveToolTipEx>, Off
ToolTip
}
If A_ThisHotkey = Esc
{
SetTimer,<RemoveToolTipEx>, Off
Tooltip
}
return
<Exec>:
If SendPos(0)
ExecFile()
return
<Text>:
If SendPos(0)
SendText()
return
<None>:
SendPos(-1)
return
<MsgVar>:
Msgbox % "Text=" SendText_Arr["Hotkeys"] "`n" "Exec=" ExecFile_Arr["HotKeys"] "`n" "MapKeys=" MapKey_Arr["HotKeys"] "`nGroupkey=" GroupKey_Arr["Hotkeys"]
Return
<GroupWarnAction>:
Msg := GroupInfo_arr[A_ThisHotkey]
StringSplit,Len,Msg,`n
ControlGetPos,xn,yn,,hn,%TCEdit%,AHK_CLASS TTOTAL_CMD
yn := yn - hn  - ( Len0 - 1 ) * 17
Tooltip,%Msg%,%xn%,%yn%
SetTimer,<RemoveTooltipEx>,50
settimer,<GroupWarnAction>,off
return
<Esc>:
Send,{Esc}
Vim := True
KeyCount := 0
KeyTemp :=
InsertMode := False
Tooltip
ControlSetText,%TCEdit%,,AHK_CLASS TTOTAL_CMD
Settimer,<RemoveTooltipEx>,off
EmptyMem()
WinClose,ViATc_TabList
Gui,Destroy
Return
<ToggleTC>:
Ifwinexist,AHK_CLASS TTOTAL_CMD
{
WinGet,AC,MinMax,AHK_CLASS TTOTAL_CMD
If Ac = -1
Winactivate,AHK_ClASS TTOTAL_CMD
Else
Ifwinnotactive,AHK_CLASS TTOTAL_CMD
Winactivate,AHK_CLASS TTOTAL_CMD
Else
Winminimize,AHK_CLASS TTOTAL_CMD
}
Else
{
Run,%TcExe%,,UseErrorLevel
If ErrorLevel = ERROR
TcExe := FindPath("exe")
Loop,6
{
WinWait,AHK_CLASS TTOTAL_CMD,,0
If ErrorLevel
Run,%TcExe%,,UseErrorLevel
Else
Break
}
Winactivate,AHK_CLASS TTOTAL_CMD
If TransParent
WinSet,Transparent,220,ahk_class TTOTAL_CMD
}
EmptyMem()
Return
<EnableVIM>:
Suspend
If Not IsSuspended
{
Menu,Tray,Rename,禁用(&E),启用(&E)
TrayTip,,禁用VIM,10,17
If A_IsCompiled
Menu,Tray,icon,%A_ScriptFullPath%,5,1
Else
Menu,Tray,icon,%A_AHKPath%,5,1
Settimer,<GetKey>,100
IsSuspended := 1
}
Else
{
Menu,Tray,Rename,启用(&E),禁用(&E)
TrayTip,,启用VIM,10,17
If A_IsCompiled
Menu,Tray,icon,%A_ScriptFullPath%,1,1
Else
Menu,Tray,icon,%A_AHKPath%,1,1
Settimer,<GetKey>,off
IsSuspended := 0
Suspend,off
}
Return
<GetKey>:
IfWinActive AHK_CLASS TTOTAL_CMD
Suspend,on
Else
Suspend,off
Return
<ReLoadVIATC>:
ReloadVIATC()
Return
ReloadVIATC()
{
ToggleMenu(1)
If HideControl_arr["Toggle"]
HideControl()
Reload
}
<Enter>:
Enter()
Return
<Hint>:
If SendPos(0)
Vim := !Vim
Return
<Setting>:
If SendPos(0)
Setting()
Return
<Help>:
If SendPos(0)
Help()
Return
<QuitViatc>:
If SendPos(0)
ExitApp
Return
<Num0>:
SendNum("0")
Return
<Num1>:
SendNum("1")
Return
<Num2>:
SendNum("2")
Return
<Num3>:
SendNum("3")
Return
<Num4>:
SendNum("4")
Return
<Num5>:
SendNum("5")
Return
<Num6>:
SendNum("6")
Return
<Num7>:
SendNum("7")
Return
<Num8>:
SendNum("8")
Return
<Num9>:
SendNum("9")
Return
<Down>:
SendKey("{down}")
Return
<Up>:
SendKey("{up}")
Return
<Left>:
SendKey("{Left}")
Return
<Right>:
SendKey("{Right}")
Return
<ForceDel>:
SendKey("+{Delete}")
Return
<UpSelect>:
SendKey("+{Up}")
Return
<DownSelect>:
SendKey("+{down}")
Return
<PageUp>:
SendKey("{PgUp}")
Return
<PageDown>:
SendKey("{PgDn}")
Return
<Home>:
If SendPos(0)
GG()
Return
GG()
{
ControlGetFocus,ctrl,AHK_CLASS TTOTAL_CMD
PostMessage, 0x19E, 0, 1, %CTRL%, AHK_CLASS TTOTAL_CMD
}
<End>:
If SendPos(0)
G()
Return
G()
{
ControlGetFocus,ctrl,AHK_CLASS TTOTAL_CMD
ControlGet,text,List,,%ctrl%,AHK_CLASS TTOTAL_CMD
Stringsplit,T,Text,`n
Last := T0 - 1
PostMessage, 0x19E,  %Last% , 1 , %CTRL%, AHK_CLASS TTOTAL_CMD
}
<Mark>:
If SendPos(4003)
{
ControlGet,EditId,Hwnd,,AHK_CLASS TTOTAL_CMD
ControlSetText,%TCEdit%,m,AHK_CLASS TTOTAL_CMD
Postmessage,0xB1,2,2,%TCEdit%,AHK_CLASS TTOTAL_CMD
SetTimer,<MarkTimer>,100
}
Return
<MarkTimer>:
MarkTimer()
Return
MarkTimer()
{
Global Mark_Arr,VIATCINI
ControlGetFocus,ThisControl,AHK_CLASS TTOTAL_CMD
ControlGetText,OutVar,%TCEdit%,AHK_CLASS TTOTAL_CMD
Match_TCEdit := "i)^" . TCEdit . "$"
If Not RegExMatch(ThisControl,Match_TCEdit) OR Not RegExMatch(Outvar,"i)^m.?")
{
Settimer,<MarkTimer>,Off
Return
}
If RegExMatch(OutVar,"i)^m.$")
{
SetTimer,<MarkTimer>,off
ControlSetText,%TCEdit%,,AHK_CLASS TTOTAL_CMD
ControlSend,%TCEdit%,{Esc},AHK_CLASS TTOTAL_CMD
ClipSaved := ClipboardAll
Clipboard :=
Postmessage 1075, 2029, 0, , ahk_class TTOTAL_CMD
ClipWait
Path := Clipboard
Clipboard := ClipSaved
If StrLen(Path) > 80
{
SplitPath,Path,,PathDir
Path1 := SubStr(Path,1,15)
Path2 := SubStr(Path,RegExMatch(Path,"\\[^\\]*$")-Strlen(Path))
Path := Path1 . "..." . SubStr(Path2,1,65) "..."
}
M := SubStr(OutVar,2,1)
mPath := "&" . m . ">>" . Path
If RegExMatch(Mark_Arr["ms"],m)
{
DelM := Mark_Arr[m]
Menu,MarkMenu,Delete,%DelM%
Menu,MarkMenu,Add,%mPath%,<AddMark>
Mark_Arr["ms"] := Mark_Arr["ms"] . m
Mark_Arr[m] := mPath
}
Else
{
Menu,MarkMenu,Add,%mPath%,<AddMark>
Mark_Arr["ms"] := Mark_Arr["ms"] . m
Mark_Arr[m] := mPath
}
}
}
<AddMark>:
AddMark()
Return
AddMark()
{
ThisMenuItem := SubStr(A_ThisMenuItem,5,StrLen(A_ThisMenuItem))
If RegExMatch(ThisMenuItem,"i)\\\\桌面$")
{
Postmessage 1075, 2121, 0, , ahk_class TTOTAL_CMD
Return
}
If RegExMatch(ThisMenuItem,"i)\\\\计算机$")
{
Postmessage 1075, 2122, 0, , ahk_class TTOTAL_CMD
Return
}
If RegExMatch(ThisMenuItem,"i)\\\\所有控制面板项$")
{
Postmessage 1075, 2123, 0, , ahk_class TTOTAL_CMD
Return
}
If RegExMatch(ThisMenuItem,"i)\\\\Fonts$")
{
Postmessage 1075, 2124, 0, , ahk_class TTOTAL_CMD
Return
}
If RegExMatch(ThisMenuItem,"i)\\\\网络$")
{
Postmessage 1075, 2125, 0, , ahk_class TTOTAL_CMD
Return
}
If RegExMatch(ThisMenuItem,"i)\\\\打印机$")
{
Postmessage 1075, 2126, 0, , ahk_class TTOTAL_CMD
Return
}
If RegExMatch(ThisMenuItem,"i)\\\\回收站$")
{
Postmessage 1075, 2127, 0, , ahk_class TTOTAL_CMD
Return
}
ControlSetText, %TCEdit%, cd %ThisMenuItem%, ahk_class TTOTAL_CMD
ControlSend, %TCEdit%, {Enter}, ahk_class TTOTAL_CMD
Return
}
<ListMark>:
If SendPos(0)
ListMark()
Return
ListMark()
{
Global Mark_Arr,VIATCINI
If Not Mark_Arr["ms"]
Return
ControlGetFocus,TLB,ahk_class TTOTAL_CMD
ControlGetPos,xn,yn,,,%TLB%,ahk_class TTOTAL_CMD
Menu,MarkMenu,Show,%xn%,%yn%
}
<azHistory>:
If SendPos(572)
azhistory()
Return
azhistory()
{
Sleep, 100
if WinExist("ahk_class #32768")
{
SendMessage,0x01E1
hmenu := ErrorLevel
if hmenu!=0
{
If Not RegExMatch(GetMenuString(Hmenu,1),".*[\\|/]$")
Return
Menu,sh,add
Menu,sh,deleteall
a :=
itemCount := DllCall("GetMenuItemCount", "Uint", hMenu, "Uint")
Loop %itemCount%
{
a := chr(A_Index+64) . ">>" .  GetMenuString(Hmenu,A_Index-1)
Menu,SH,add,%a%,azSelect
}
Send {Esc}
ControlGetFocus,TLB,ahk_class TTOTAL_CMD
ControlGetPos,xn,yn,,,%TLB%,ahk_class TTOTAL_CMD
Menu,SH,show,%xn%,%yn%
Return
}
}
}
GetMenuString(hMenu, nPos)
{
VarSetCapacity(lpString, 256)
length := DllCall("GetMenuString"
, "UInt", hMenu
, "UInt", nPos
, "Str", lpString
, "Int", 255
, "UInt", 0x0400)
return lpString
}
azSelect:
azSelect()
Return
azSelect()
{
nPos := A_ThisMenuItem
nPos := Asc(Substr(nPos,1,1)) - 64
Winactivate,ahk_class TTOTAL_CMD
Postmessage,1075,572,0,,ahk_class TTOTAL_CMD
Sleep,100
if WinExist("ahk_class #32768")
{
Loop %nPos%
SendInput {Down}
Send {enter}
}
}
<Internetsearch>:
If SendPos(0)
Internetsearch()
Return
Internetsearch()
{
Global SearchEng
If CheckMode()
{
ClipSaved := ClipboardAll
Clipboard =
PostMessage 1075, 2017, 0, , ahk_class TTOTAL_CMD
ClipWait
rFileName := clipboard
clipboard := ClipSaved
StringRight,lastchar,rFileName,1
If(lastchar = "\" )
Stringleft,rFileName,rFileName,Strlen(rFileName)-1
rFileName := RegExReplace(SearchEng,"{%1}",rFileName)
Run %rFileName%
}
Return
}
<GoDesktop>:
If SendPos(0)
{
ControlSetText,%TCEdit%,CD %A_Desktop%,AHK_CLASS TTOTAL_CMD
ControlSend,%TCEdit%,{Enter},AHK_CLASS TTOTAL_CMD
}
Return
<GotoParentEx>:
If CheckMode()
IsRootDir()
SendPos(2002,True)
Return
IsRootDir()
{
ClipSaved := ClipboardAll
clipboard :=
PostMessage,1075,2029,0,,AHK_CLASS TTOTAL_CMD
ClipWait,1
Path := Clipboard
Clipboard := ClipSaved
If RegExMatch(Path,"^.:\\$")
{
PostMessage,1075,2122,0,,AHK_CLASS TTOTAL_CMD
Path := "i)" . RegExReplace(Path,"\\","")
ControlGetFocus,focus_control,AHK_CLASS TTOTAL_CMD
ControlGet,outvar,list,,%focus_control%,AHK_CLASS TTOTAL_CMD
Loop,Parse,Outvar,`n
{
If Not A_LoopField
Break
If RegExMatch(A_LoopField,Path)
{
Focus := A_Index - 1
Break
}
}
PostMessage, 0x19E, %Focus%, 1, %focus_control%, AHK_CLASS TTOTAL_CMD
}
}
<SingleRepeat>:
If SendPos(-1)
SingleRepeat()
Return
<TCLite>:
If SendPos(0)
{
ToggleMenu()
HideControl()
GoSub,<VisDirTabs>
Send,{Esc}
}
Return
<TCFullScreen>:
If SendPos(0)
{
ToggleMenu()
HideControl()
GoSub,<VisDirTabs>
If HideControl_arr["Max"]
{
PostMessage 1075, 2016, 0, , ahk_class TTOTAL_CMD
HideControl_arr["Max"] := 0
Return
}
WinGet,AC,MinMax,AHK_CLASS TTOTAL_CMD
If AC = 1
{
PostMessage 1075, 2016, 0, , ahk_class TTOTAL_CMD
PostMessage 1075, 2015, 0, , ahk_class TTOTAL_CMD
HideControl_arr["Max"] := 0
}
If AC = 0
{
PostMessage 1075, 2015, 0, , ahk_class TTOTAL_CMD
HideControl_arr["Max"] := 1
}
}
Return
<CreateNewFile>:
If SendPos(0)
CreateNewFile()
Return
<Editviatcini>:
If SendPos(0)
Editviatcini()
Return
<GOLastTab>:
if SendPos(0)
{
PostMessage 1075, 5001, 0, , ahk_class TTOTAL_CMD
PostMessage 1075, 3006, 0, , ahk_class TTOTAL_CMD
}
Return
<DeleteLHistory>:
If SendPos(0)
DeleteHistory(1)
Return
<DeleteRHistory>:
If SendPos(0)
DeleteHistory(0)
Return
DeleteHistory(A)
{
Global TCEXE,TCINI
If A
{
H := "LeftHistory"
DelMsg := "删除左侧文件夹历史记录?"
}
Else
{
H := "RightHistory"
DelMsg := "删除右侧文件夹历史记录?"
}
Msgbox,4,ViATC,%DelMsg%
Ifmsgbox YES
{
Winkill,AHK_CLASS TTOTAL_CMD
n := 0
Loop
{
IniRead,TempField,%TCINI%,%H%,%n%
If TempField = ERROR
Break
IniDelete,%TCINI%,%H%,%n%
n++
}
Run,%TCEXE%,,UseErrorLevel
If ErrorLevel = ERROR
TCEXE := findpath(1)
WinWait,AHK_CLASS TTOTAL_CMD,3
Winactivate,AHK_CLASS TTOTAL_CMD
}
Else
Winactivate,AHK_CLASS TTOTAL_CMD
}
<DelCmdHistory>:
If SendPos(0)
DeleteCmd()
Return
DeleteCMD()
{
Global TCEXE,TCINI,CmdHistory
CmdHistory := Object()
Msgbox,4,ViATc,删除命令行历史?
Ifmsgbox YES
{
Winkill ahk_class TTOTAL_CMD
n := 0
TempField :=
Loop
{
IniRead,TempField,%TCINI%,Command line history,%n%
If TempField = ERROR
Break
IniDelete,%TCINI%,Command line history,%n%
n++
}
Run,%TCEXE%,,UseErrorLevel
If ErrorLevel = ERROR
TCEXE := findpath(1)
WinWait,AHK_CLASS TTOTAL_CMD,3
Winactivate,AHK_CLASS TTOTAL_CMD
}
Else
Winactivate ahk_class TTOTAL_CMD
}
<ListMapKey>:
If SendPos(0)
ListMapKey()
Return
ListMapKey()
{
Global MapKey_Arr,ActionInfo_Arr,ExecFile_Arr,SendText_Arr
Map := MapKey_Arr["Hotkeys"]
Stringsplit,ListMap,Map,%A_Space%
Loop,% ListMap0
{
If ListMap%A_Index%
{
Action := MapKey_Arr[ListMap%A_Index%]
If Action = <Exec>
{
EX := SubStr(ListMap%A_Index%,1,1) . TransHotkey(SubStr(ListMap%A_Index%,2))
Action := "(" . ExecFile_Arr[EX] . ")"
}
If Action = <Text>
{
TX := SubStr(ListMap%A_Index%,1,1) . TransHotkey(SubStr(ListMap%A_Index%,2))
Action := "{" . SendText_Arr[TX] . "}"
}
LM .= SubStr(ListMap%A_Index%,1,1) . "  " . SubStr(ListMap%A_Index%,2) . "  " . Action  . "`n"
}
}
ControlGetPos,xn,yn,,hn,%TCEdit%,AHK_CLASS TTOTAL_CMD
yn := yn - hn - ( ListMap0 * 8 ) - 2
Tooltip,%LM%,%xn%,%yn%
Settimer,<RemoveToolTipEx>,100
}
<FocusCmdLineEx>:
If SendPos(4003)
{
ControlSetText,%TCEdit%,:,AHK_CLASS TTOTAL_CMD
Send,{end}
}
Return
<WinMaxLeft>:
If SendPos(0)
WinMaxLeft()
Return
WinMaxLeft()
{
ControlGetPos,x,y,w,h,%TCPanel2%,ahk_class TTOTAL_CMD
ControlGetPos,tm1x,tm1y,tm1W,tm1H,%TCPanel1%,ahk_class TTOTAL_CMD
If (tm1w < tm1h)
{
ControlMove,%TCPanel1%,x+w,,,,ahk_class TTOTAL_CMD
}
else
ControlMove,%TCPanel1%,0,y+h,,,ahk_class TTOTAL_CMD
ControlClick, %TCPanel1%,ahk_class TTOTAL_CMD
WinActivate ahk_class TTOTAL_CMD
}
<WinMaxRight>:
If SendPos(0)
{
ControlMove,%TCPanel1%,0,0,,,ahk_class TTOTAL_CMD
ControlClick,%TCPanel1%,ahk_class TTOTAL_CMD
WinActivate ahk_class TTOTAL_CMD
}
Return
<AlwayOnTop>:
If SendPos(0)
AlwayOnTop()
Return
AlwayOnTop()
{
WinGet,ExStyle,ExStyle,ahk_class TTOTAL_CMD
If (ExStyle & 0x8)
WinSet,AlwaysOnTop,off,ahk_class TTOTAL_CMD
else
WinSet,AlwaysOnTop,on,ahk_class TTOTAL_CMD
}
<TransParent>:
If SendPos(0)
TransParent()
Return
TransParent()
{
Global VIATCINI,Transparent,TranspVar
IniRead,Transparent,%VIATCINI%,Configuration,Transparent
If Transparent
{
WinSet,Transparent,255,ahk_class TTOTAL_CMD
IniWrite,0,%VIATCINI%,Configuration,Transparent
Transparent := 0
}
Else
{
WinSet,Transparent,%TranspVar%,ahk_class TTOTAL_CMD
IniWrite,1,%VIATCINI%,Configuration,Transparent
Transparent := 1
}
}
<ReLoadTC>:
If SendPos(0)
{
ToggleMenu(1)
If HideControl_arr["Toggle"]
HideControl()
WinKill,AHK_CLASS TTOTAL_CMD
Loop,100
{
IfWinNotExist,AHK_CLASS TTOTAL_CMD
Break
}
GoSub,<ToggleTC>
}
Return
<QuitTc>:
WinClose,AHK_CLASS TTOTAL_CMD
return
<Half>:
If SendPos(0)
Half()
Return
Half()
{
winget,tid,id,ahk_class TTOTAL_CMD
controlgetfocus,ctrl,ahk_id %tid%
controlget,cid,hwnd,,%ctrl%,ahk_id %tid%
controlgetpos,x1,y1,w1,h1,THeaderClick2,ahk_id %tid%
controlgetpos,x,y,w,h,%ctrl%,ahk_id %tid%
SendMessage,0x01A1,1,0,,ahk_id %cid%
Hight := ErrorLevel
SendMessage,0x018E,0,0,,ahk_id %cid%
Top := ErrorLevel
HalfLine := Ceil( ((h-h1)/Hight)/2 ) + Top
PostMessage, 0x19E, %HalfLine%, 1, , AHK_id %cid%
}
<azTab>:
If SendPos(0)
azTab()
Return
azTab()
{
Global TabsBreak,TcExe
If RegExMatch(TcExe,"i)totalcmd64\.exe")
Return
TCid := WinExist("AHK_CLASS TTOTAL_CMD")
WinClose,ViATc_TabList
ControlGetPos,xe,ye,we,he,Edit1,AHK_CLASS TTOTAL_CMD
Gui,New
Gui,+HwndTabsHwnd -Caption  +Owner%TCid%
Gui,Add,ListBox,x2 y2 w%we% gSetTab
Index := 1
for i,tab in ControlGetTabs("TMyTabControl1","AHK_CLASS TTOTAL_CMD")
{
vTab := Chr(Index+64) . ":" . Tab
STabs[vTab] := "L" . A_index
If A_Index = 1
{
ControlGet,TMyT2,hwnd,,TMyTabControl2,AHK_CLASS TTOTAL_CMD
If TMyT2
GuiControl,,ListBox1,=====左边===================
Else
{
ControlGetPos,x1,y1,,,TPanel1,AHK_CLASS TTOTAL_CMD
ControlGetPos,x2,y2,,,TMyTabControl1,AHK_CLASS TTOTAL_CMD
If ( x2 < x1 ) OR ( y2 < y1 )
GuiControl,,ListBox1,=====左边===================
Else
GuiControl,,ListBox1,=====右边===================
}
}
GuiControl,,ListBox1,%vTab%
Index++
}
TabsBreak := Index
for i,tab in ControlGetTabs("TMyTabControl2","AHK_CLASS TTOTAL_CMD")
{
vTab := Chr(Index+64) . ":" . Tab
STabs[vTab] := "R" . A_index
If A_index = 1
{
GuiControl,,ListBox1,=====右边===================
}
GuiControl,,ListBox1,%vTab%
Index++
}
h := (Index+1)*13
GuiControl,Move,ListBox1,h%h%
WinGetPos,wx,wy,ww,wh,AHK_CLASS TTOTAL_CMD
x := xe + wx - 1
w := we +  4
h := h + 4
y := ye - h + wy
GUiControl,Focus,ListBox2
Gui,Show,h%h% w%w% x%x% y%y%,ViATc_TabList
Postmessage,0xB1,7,7,%TCEdit%,AHK_CLASS TTOTAL_CMD
}
SetTab:
ControlGet,var,Choice,,Listbox1
Pos := SubStr(var,1,1)
If Not RegExMatch(Pos,"=")
{
Pos := Asc(Pos) - 65
TabsBreak--
If ( Pos < TabsBreak )
{
PostMessage,0x1330,%Pos%,0,TMyTabControl1,AHK_CLASS TTOTAL_CMD
If Not LeftRight()
PostMessage,1075,4001,0,,AHK_CLASS TTOTAL_CMD
}
TabsBreak--
If ( Pos > TabsBreak )
{
Pos := Pos - TabsBreak - 1
PostMessage,0x1330,%Pos%,0,TMyTabControl2,AHK_CLASS TTOTAL_CMD
If Not LeftRight()
PostMessage,1075,4002,0,,AHK_CLASS TTOTAL_CMD
}
WinClose,AHK_ID %TabsHwnd%
Return
}
return
LeftRight()
{
ControlGetPos,x1,y1,,,TPanel1,AHK_CLASS TTOTAL_CMD
ControlGetFocus,TLB,AHK_CLASS TTOTAL_CMD
ControlGetPos,x2,y2,,,%TLB%,AHK_CLASS TTOTAL_CMD
If ( x2 < x1 ) OR ( y2 < y1 )
Return True
Else
Return False
}
ControlGetTabs(Control, WinTitle="", WinText="")
{
static TCM_GETITEMCOUNT := 0x1304
, TCM_GETITEM := A_IsUnicode ? 0x133C : 0x1305
, TCIF_TEXT := 1
, TCITEM_SIZE := 16 + A_PtrSize*3
, MAX_TEXT_LENGTH := 260
, MAX_TEXT_SIZE := MAX_TEXT_LENGTH * (A_IsUnicode ? 2 : 1)
static PROCESS_VM_OPERATION := 0x8
, PROCESS_VM_READ := 0x10
, PROCESS_VM_WRITE := 0x20
, READ_WRITE_ACCESS := PROCESS_VM_READ |PROCESS_VM_WRITE |PROCESS_VM_OPERATION
, MEM_COMMIT := 0x1000
, MEM_RELEASE := 0x8000
, PAGE_READWRITE := 4
if Control is not integer
{
ControlGet Control, Hwnd,, %Control%, %WinTitle%, %WinText%
if ErrorLevel
return
}
WinGet pid, PID, ahk_id %Control%
hproc := DllCall("OpenProcess", "uint", READ_WRITE_ACCESS
, "int", false, "uint", pid, "ptr")
if !hproc
return
remote_item := DllCall("VirtualAllocEx", "ptr", hproc, "ptr", 0
, "uptr", TCITEM_SIZE + MAX_TEXT_SIZE
, "uint", MEM_COMMIT, "uint", PAGE_READWRITE, "ptr")
remote_text := remote_item + TCITEM_SIZE
VarSetCapacity(local_item, TCITEM_SIZE, 0)
NumPut(TCIF_TEXT,       local_item, 0, "uint")
NumPut(remote_text,     local_item, 8 + A_PtrSize)
NumPut(MAX_TEXT_LENGTH, local_item, 8 + A_PtrSize*2, "int")
VarSetCapacity(local_text, MAX_TEXT_SIZE)
DllCall("WriteProcessMemory", "ptr", hproc, "ptr", remote_item
, "ptr", &local_item, "uptr", TCITEM_SIZE, "ptr", 0)
tabs := []
SendMessage TCM_GETITEMCOUNT,,,, ahk_id %Control%
Loop % (ErrorLevel != "FAIL") ? ErrorLevel : 0
{
SendMessage TCM_GETITEM, A_Index-1, remote_item,, ahk_id %Control%
if (ErrorLevel = 1)
DllCall("ReadProcessMemory", "ptr", hproc, "ptr", remote_text
, "ptr", &local_text, "uptr", MAX_TEXT_SIZE, "ptr", 0)
else
local_text := ""
tabs[A_Index] := local_text
}
DllCall("VirtualFreeEx", "ptr", hproc, "ptr", remote_item
, "uptr", 0, "uint", MEM_RELEASE)
DllCall("CloseHandle", "ptr", hproc)
return tabs
}
<VimRN>:
If SendPos(0)
VimRNCreateGui()
Return
VimRNCreateGui()
{
Static WM_CHAR := 0x102
Global GetName
WinClose,AHK_ID %VimRN_ID%
PostMessage 1075, 1007, 0, , ahk_class TTOTAL_CMD
Loop,8
{
ControlGetFocus,ThisCtrl,AHK_CLASS TTOTAL_CMD
If ThisCtrl = TInEdit1
{
ControlGetText,GetName,TInEdit1,AHK_CLASS TTOTAL_CMD
Break
}
Sleep,50
}
If Not GetName
Return
StringRight,GetDir,GetName,1
If GetDir = \
{
StringLeft,GetName,GetName,Strlen(GetName)-1
GetDir := True
}
Else
GetDir := False
WinGet,TCID,ID,AHK_CLASS TTOTAL_CMD
Gui,New
Gui,+HwndVimRN_ID
Gui,+Owner%TCID%
Gui,Menu,VimRN_MENU
Gui,Add,Edit,r6 w300 -WantReturn gVimRN_Edit,%GetName%
Gui,Add,StatusBar
Gui,Add,Button,Default Hidden gVimRN_Enter
Gui,Show,h125,ViATc 重命名
PostMessage,0x00C5,256,,Edit1,AHK_ID %VimRN_ID%
VimRN := GetConfig("VimReName","Mode")
If VimRN
{
Menu,VimRN_Set,Check,默认Vim模式`tAlt+V
Status := " 模式: Vim                                    "
}
Else
Status := " 模式: Normal                                 "
ControlSetText,msctls_statusbar321,%status%,AHK_ID %VimRN_ID%
If GetConfig("VimReName","SelectExt")
{
SplitPath,GetName,,,Ext
Menu,VimRN_Set,Check,默认Vim模式`tAlt+V
Menu,VimRN_Set,Check,默认选择后缀`tAlt+E
}
If Ext And ( Not GetDir )
{
StartPos := 0
EndPos := StrLen(GetName) - strlen(Ext) - 1
VimRN_SetPos(StartPos,EndPos)
}
VimRN_History["s"] := 0
VimRN_History[0] := StartPos . "," . EndPos . "," . GetName
VimRN_History["String"] := GetName
OnMessage(WM_CHAR,"GetFindText")
}
GetFindText(byRef w, byRef l)
{
If VimRN_IsFind
{
ThisChar := Chr(w)
ControlGetText,Text,Edit1,AHK_ID %VimRN_ID%
GetPos := VimRN_GetPos()
StartPos := GetPos[2] + 1
Pos := RegExMatch(Text,RegExReplace(ThisChar,"\+|\?|\.|\*|\{|\}|\(|\)|\||\^|\$|\[|\]|\\","\$0"),"",StartPos)
VimRN_SetPos(Pos-1,Pos)
VimRN_IsFind := False
VimRN := True
Return 0
}
}
VimRN_Num:
VimRN_SendNum()
Return
VimRN_Down:
Key := VimRN_Vis ? "+{Down}" : "{Down}"
VimRN_SendKey(key)
Return
VimRN_Up:
Key := VimRN_Vis ? "+{Up}" : "{Up}"
VimRN_SendKey(key)
Return
VimRN_Left:
Key := VimRN_Vis ? "+{Left}" : "{Left}"
VimRN_SendKey(key)
Return
VimRN_Right:
Key := VimRN_Vis ? "+{Right}" : "{Right}"
VimRN_SendKey(key)
Return
VimRN_SDown:
VimRN_SendKey("+{Down}")
Return
VimRN_SLeft:
VimRN_SendKey("+{Left}")
Return
VimRN_SUp:
VimRN_SendKey("+{Up}")
Return
VimRN_SRight:
VimRN_SendKey("+{Right}")
Return
VimRN_Find:
If VimRN_SendKey("")
{
VimRN := False
VimRN_IsFind := True
}
Return
VimRN_SelectThis:
If VimRN_SendKey("")
{
Pos := VimRN_GetPos()
Pos := Pos[2]
VimRN_SetPos(Pos,Pos)
}
return
VimRN_Selectall:
If VimRN_SendKey("")
{
ControlGetText,Text,Edit1,AHK_ID %VimRN_ID%
Pos := Strlen(Text)
VimRN_SetPos(0,Pos)
}
Return
VimRN_SelectFileName:
If VimRN_SendKey("")
{
ControlGetText,Text,Edit1,AHK_ID %VimRN_ID%
splitpath,Text,,,,FileName
Pos := Strlen(FileName)
VimRN_SetPos(0,Pos)
}
Return
VimRN_SelectExt:
If VimRN_SendKey("")
{
ControlGetText,Text,Edit1,AHK_ID %VimRN_ID%
splitpath,Text,,,FileExt,FileName
Pos1 := Strlen(FileName)
Pos2 := Strlen(FileExt)
VimRN_SetPos(Pos1+1,Pos1+Pos2+1)
}
Return
VimRN_Home:
If VimRN_SendKey("")
VimRN_SetPos(0,0)
Return
VimRN_End:
If VimRN_SendKey("")
{
ControlGetText,Text,Edit1,AHK_ID %VimRN_ID%
Pos := Strlen(Text)
VimRN_SetPos(Pos,Pos)
}
Return
VimRN_Copy:
If VimRN_SendKey("")
{
Pos := VimRN_GetPos()
ControlGetText,Text,Edit1,AHK_ID %VimRN_ID%
VimRN_Temp := SubStr(Text,Pos[1]+1,Pos[2]-Pos[1])
}
Return
VimRN_Backspace:
If VimRN_SendKey("")
{
VimRN_Cut(-1)
Send {Backspace}
}
Return
VimRN_Delete:
If VimRN_SendKey("")
{
VimRN_Cut(0)
Send {Delete}
}
Return
VimRN_Paste:
If VimRN_SendKey("")
VimRN_Paste()
Return
VimRN_Trade:
If VimRN_SendKey("")
{
Pos := VimRN_GetPos()
ControlGetText,Text,Edit1,AHK_ID %VimRN_ID%
If Pos[1] > 0
{
TextA := SubStr(Text,Pos[1],1)
TextB := SubStr(Text,Pos[1]+1,1)
SetText := SubStr(Text,1,Pos[1]-1) . TextB . TextA . SubStr(Text,Pos[1]+2)
ControlSetText,Edit1,%SetText%,AHK_ID %VimRN_ID%
VimRN_SetPos(Pos[1],Pos[2])
VimRN_Edit()
}
}
Return
VimRN_Replace:
If VimRN_SendKey("")
{
VimRN_IsReplace := True
Pos := VimRN_GetPos()
If Pos[1] = Pos[2]
{
VimRN_SetPos(Pos[1],Pos[1]+1)
VimRN := False
}
}
Return
VimRN_MultiReplace:
If VimRN_SendKey("")
{
VimRN_IsMultiReplace := True
Pos := VimRN_GetPos()
If Pos[1] = Pos[2]
{
VimRN_SetPos(Pos[1],Pos[1]+1)
VimRN := False
}
}
Return
VimRN_visual:
If VimRN_SendKey("")
{
VimRN_Vis := !VimRN_Vis
If VimRN_Vis
{
Status := " 模式: Visual                                 "
ControlSetText,msctls_statusbar321,%status%,AHK_ID %VimRN_ID%
}
Else
{
Status := " 模式: Vim                                    "
ControlSetText,msctls_statusbar321,%status%,AHK_ID %VimRN_ID%
}
}
Return
VimRN_Insert:
If VimRN_SendKey("")
{
VimRN := False
Status := " 模式: Normal                                 "
ControlSetText,msctls_statusbar321,%status%,AHK_ID %VimRN_ID%
}
Return
VimRN_Esc:
VimRN := True
VimRN_IsReplace := False
VimRN_IsMultiReplace := False
VimRN_Count := 0
Status := " 模式: Vim                                    "
Tooltip
Settimer,<RemoveHelpTip>,off
ControlSetText,msctls_statusbar321,%status%,AHK_ID %VimRN_ID%
Return
VimRN_Quit:
If VimRN_SendKey("")
WinClose,AHK_ID %VimRN_ID%
Return
VimRN_Undo:
If VimRN_SendKey("")
VimRN_Undo()
Return
VimRN_Enter:
GuiControlGet,NewName,,Edit1
Gui,Destroy
Postmessage,1075,1007,0,,AHK_CLASS TTOTAL_CMD
Loop,40
{
ControlGetFocus,This,AHK_CLASS TTOTAL_CMD
If This = TInEdit1
{
ControlGetText,ConfirName,TInEdit1,AHK_CLASS TTOTAL_CMD
ControlSetText,TInEdit1,%NewName%,AHK_CLASS TTOTAL_CMD
Break
}
Sleep,50
}
If Diff(ConfirName,GetName)
ControlSend,TInEdit1,{enter},AHK_CLASS TTOTAL_CMD
Else
Return
Return
VimRN_Edit:
VimRN_Edit()
Return
VimRN_SelMode:
SetConfig("VimReName","Mode",!GetConfig("VimReName","Mode"))
If GetConfig("VimReName","Mode")
Menu,VimRN_Set,Check,默认Vim模式`tAlt+V
Else
Menu,VimRN_Set,UnCheck,默认Vim模式`tAlt+V
Return
VimRN_SelExt:
SetConfig("VimReName","SelectExt",!GetConfig("VimReName","SelectExt"))
If GetConfig("VimReName","SelectExt")
Menu,VimRN_Set,Check,默认选择后缀`tAlt+E
Else
Menu,VimRN_Set,UnCheck,默认选择后缀`tAlt+E
Return
VimRN_Help:
VimRN_Help()
Return
VimRN_Help()
{
test =
(
h : 向左移动N个字符
j : 向下移动N个字符
k : 向上移动N个字符
l : 向右移动N个字符
w : 选择文件名
e : 选择扩展名
u : 撤销
x : 向后删除
d : 向前删除
y : 复制字符
p : 粘贴字符
t : 对换光标处的两个字符
r : 只替换光标处的字符
R : 替换光标之后的所有字符，直遇到Esc
a : 全选
g : 光标位于第一个字符
b : 光标位于最后一个字符
s : 光标位于选中字符的最后一个字符处
f : 查找字符，例如f后按a，就是查找a
q : 退出重命名
i : 编辑模式
v : 选择模式
Esc : 正常模式
Enter : 保存重命名
)
WinGetPos,,,w,h,AHK_ID %VimRN_ID%
tooltip,%test%,0,%h%
Settimer,<RemoveHelpTip>,50
Return
}
<RemoveHelpTip>:
Ifwinnotactive,AHK_ID %VimRN_ID%
{
SetTimer,<RemoveHelpTip>, Off
ToolTip
}
return
VimRN_SendKey(ThisKey)
{
If VimRN
{
VimRN_Count := VimRN_Count ? VimRN_Count : 1
Loop % VimRN_Count
{
Send %ThisKey%
}
VimRN_Count := 0
ControlGetText,status,msctls_statusbar321,AHK_ID %VimRN_ID%
status := SubStr(status,1,Strlen(status)-3) . "   "
ControlSetText,msctls_statusbar321,%status%,AHK_ID %VimRN_ID%
Return True
}
Else
{
Send %A_ThisHotkey%
Return False
}
}
VimRN_SendNum()
{
If A_ThisHotkey is integer
ThisNum := A_ThisHotkey
Else
Return
If VimRN
{
If VimRN_Count
VimRN_Count := ThisNum + (VimRN_Count * 10 )
Else
VimRN_Count := ThisNum + 0
if VimRN_Count > 256
VimRN_Count := 256
ControlGetText,status,msctls_statusbar321,AHK_ID %VimRN_ID%
StringRight,isNumber,status,3
If RegExMatch(isNumber,"\s\s\s")
Status := RegExReplace(Status,"\s\s\s$") . VimRN_Count . "  "
If RegExMatch(isNumber,"\d\s\s")
Status := RegExReplace(Status,"\d\s\s$") . VimRN_Count  . " "
If RegExMatch(isNumber,"\d\d\s")
Status := RegExReplace(Status,"\d\d\s$") . VimRN_Count
If RegExMatch(isNumber,"\d\d\d")
Status := RegExReplace(Status,"\d\d\d$") . VimRN_Count
ControlSetText,msctls_statusbar321,%status%,AHK_ID %VimRN_ID%
Return True
}
Else
{
Send %A_ThisHotkey%
Return False
}
}
VimRN_Undo()
{
DontSetText := False
Serial := VimRN_History["s"]
If  Serial > 0
Serial--
Else
DontSetText := True
Change := VimRN_History[Serial]
Stringsplit,Pos,Change,`,
If Not DontSetText
ControlSetText,Edit1,%Pos3%,AHK_ID %VimRN_ID%
VimRN_SetPos(Pos1,Pos2)
VimRN_History["s"] := Serial
VimRN_History["String"] := Pos3
}
VimRN_Edit()
{
Match := "^" . RegExReplace(VimRN_History["String"],"\+|\?|\.|\*|\{|\}|\(|\)|\||\^|\$|\[|\]|\\","\$0") . "$"
ControlGetText,Change,Edit1,AHK_ID %VimRN_ID%
if Not RegExMatch(Change,Match)
{
Serial := VimRN_History["s"]
Serial++
pos := VimRN_GetPos()
StartPos := pos[1]
EndtPos  := pos[2]
VimRN_History[Serial] :=  StartPos . "," . EndPos . "," .  Change
VimRN_History["s"] := Serial
VimRN_History["String"] := change
If VimRN_IsReplace
{
VimRN_IsReplace := !VimRN_IsReplace
VimRN := True
}
If VimRN_IsMultiReplace
{
Pos := VimRN_GetPos()
If Pos[1] = Pos[2]
{
VimRN_SetPos(Pos[1],Pos[1]+1)
}
}
}
}
VimRN_Cut(Length)
{
Pos := VimRN_GetPos()
ControlGetText,Text,Edit1,AHK_ID %VimRN_ID%
If Pos[1] = Pos[2]
{
Pos1 := Pos[1] + 1 + Length
Len  := 1
}
Else
{
Pos1 := Pos[1] + 1
Len := Pos[2] - Pos[1]
}
VimRN_Temp := SubStr(Text,Pos1,Len)
}
VimRN_Paste(Direction="")
{
Pos := VimRN_GetPos()
ControlGetText,Text,Edit1,AHK_ID %VimRN_ID%
SetText := SubStr(Text,1,Pos[1]) . VimRN_Temp . SubStr(Text,Pos[1]+1)
Pos1 := Pos[1] + Strlen(VimRN_Temp)
ControlSetText,Edit1,%SetText%,AHK_ID %VimRN_ID%
VimRN_SetPos(Pos1,Pos1)
VimRN_Edit()
}
VimRN_GetPos()
{
Pos := []
ControlGet,Edit_ID,hwnd,,Edit1,AHK_ID %VimRN_ID%
Varsetcapacity(StartPos,2)
Varsetcapacity(EndPos,2)
Sendmessage,0x00B0,&StartPos,&EndPos,,AHK_ID %Edit_ID%
Pos[1] := NumGet(StartPos)
Pos[2] := NumGet(EndPos)
Return Pos
}
VimRN_SetPos(Pos1,Pos2)
{
PostMessage,0x00B1,%Pos1%,%Pos2%,Edit1,AHK_ID %VimRN_ID%
}
SetDefaultKey()
{
Hotkey,Ifwinactive,ahk_class TQUICKSEARCH
Hotkey,+j,<Down>
Hotkey,+k,<Up>
Hotkey,Ifwinactive,AHK_CLASS TTOTAL_CMD
HotKey,1,<Num1>,on,UseErrorLevel
HotKey,2,<Num2>,on,UseErrorLevel
HotKey,3,<Num3>,on,UseErrorLevel
HotKey,4,<Num4>,on,UseErrorLevel
HotKey,5,<Num5>,on,UseErrorLevel
HotKey,6,<Num6>,on,UseErrorLevel
HotKey,7,<Num7>,on,UseErrorLevel
HotKey,8,<Num8>,on,UseErrorLevel
HotKey,9,<Num9>,on,UseErrorLevel
HotKey,0,<Num0>,on,UseErrorLevel
HotKey,j,<Down>,on,UseErrorLevel
HotKey,k,<up>,on,UseErrorLevel
HotKey,h,<left>,on,UseErrorLevel
HotKey,l,<right>,on,UseErrorLevel
HotKey,+k,<UpSelect>,on,UseErrorLevel
HotKey,+j,<DownSelect>,on,UseErrorLevel
HotKey,+h,<GotoPreviousDir>,on,UseErrorLevel
HotKey,+l,<GotoNextDir>,on,UseErrorLevel
HotKey,d,<DirectoryHotlist>,on,UseErrorLevel
HotKey,+d,<GoDesktop>,on,UseErrorLevel
Hotkey,.,<SingleRepeat>,On,UseErrorLevel
HotKey,e,<ContextMenu>,on,UseErrorLevel
HotKey,+e,<ExecuteDOS>,on,UseErrorLevel
HotKey,u,<GotoParentEx>,on,UseErrorLevel
HotKey,+u,<GotoRoot>,on,UseErrorLevel
Hotkey,i,<CreateNewFile>,on,UseErrorLevel
Hotkey,x,<Delete>,On,UseErrorLevel
Hotkey,+x,<ForceDel>,On,UseErrorLevel
HotKey,o,<LeftOpenDrives>,on,UseErrorLevel
HotKey,+o,<RightOpenDrive>,on,UseErrorLevel
HotKey,q,<SrcQuickview>,on,UseErrorLevel
HotKey,p,<PackFiles>,on,UseErrorLevel
HotKey,+p,<UnpackFiles>,on,UseErrorLevel
HotKey,t,<OpenNewTab>,on,UseErrorLevel
HotKey,+t,<OpenNewTabBg>,on,UseErrorLevel
Hotkey,r,<VimRN>,on,UseErrorLevel
Hotkey,+r,<MultiRenameFiles>,on,UseErrorLevel
Hotkey,f,<PageDown>,On,UseErrorLevel
Hotkey,+f,<Hint>,On,UseErrorLevel
Hotkey,b,<PageUp>,On,UseErrorLevel
Hotkey,+b,<azTab>,On,UseErrorLevel
Hotkey,y,<CopyNamesToClip>,On,UseErrorLevel
Hotkey,+y,<CopyFullNamesToClip>,On,UseErrorLevel
Hotkey,/,<ShowQuickSearch>,On,UseErrorLevel
Hotkey,+/,<SearchFor>,On,UseErrorLevel
Hotkey,`;,<FocusCmdLine>,On,UseErrorLevel
Hotkey,:,<FocusCmdLineEx>,On,UseErrorLevel
Hotkey,[,<SelectCurrentName>,On,UseErrorLevel
Hotkey,+[,<UnselectCurrentName>,On,UseErrorLevel
Hotkey,],<SelectCurrentExtension>,On,UseErrorLevel
Hotkey,+],<UnselectCurrentExtension>,On,UseErrorLevel
Hotkey,\,<ExchangeSelection>,On,UseErrorLevel
Hotkey,+\,<ClearAll>,On,UseErrorLevel
Hotkey,=,<MatchSrc>,On,UseErrorLevel
Hotkey,-,<SwitchSeparateTree>,On,UseErrorLevelHotkey,\,<ExchangeSelection>,On,UseErrorLevel
Hotkey,v,<SrcCustomViewMenu>,On,UseErrorLevel
HotKey,a,<SetAttrib>,on,UseErrorLevel
Hotkey,m,<Mark>,On,UseErrorLevel
Hotkey,+m,<Half>,On,UseErrorLevel
Hotkey,',<ListMark>,On,UseErrorLevel
HotKey,+q,<Internetsearch>,on,UseErrorLevel
Hotkey,+g,<End>,On,UseErrorLevel
Hotkey,w,<EditComment>,On,UseErrorLevel
Hotkey,n,<azhistory>,On,UseErrorLevel
Hotkey,+n,<DirectoryHistory>,On,UseErrorLevel
Hotkey,`,,<None>,On,UseErrorLevel
Hotkey,$Enter,<Enter>,On,UseErrorLevel
Hotkey,Esc,<Esc>,On,UseErrorLevel
HotKey,+a,<None>,on,UseErrorLevel
Hotkey,+.,<None>,On,UseErrorLevel
Hotkey,+w,<None>,On,UseErrorLevel
Hotkey,+s,<None>,On,UseErrorLevel
Hotkey,+',<None>,On,UseErrorLevel
GroupKeyAdd("zz","<50Percent>")
GroupKeyAdd("zi","<WinMaxLeft>")
GroupKeyAdd("zo","<WinMaxRight>")
GroupKeyAdd("zt","<AlwayOnTop>")
GroupKeyAdd("zn","<Minimize>")
GroupKeyAdd("zm","<Maximize>")
GroupKeyAdd("zr","<Restore>")
GroupKeyAdd("zv","<VerticalPanels>")
GroupKeyAdd("zs","<TransParent>")
GroupKeyAdd("zf","<TCFullScreen>")
GroupKeyAdd("zl","<TCLite>")
GroupKeyAdd("zq","<QuitTC>")
GroupKeyAdd("za","<ReLoadTC>")
GroupKeyAdd("sn","<SrcByName>")
GroupKeyAdd("se","<SrcByExt>")
GroupKeyAdd("ss","<SrcBySize>")
GroupKeyAdd("sd","<SrcByDateTime>")
GroupKeyAdd("sr","<SrcNegOrder>")
GroupKeyAdd("s1","<SrcSortByCol1>")
GroupKeyAdd("s2","<SrcSortByCol2>")
GroupKeyAdd("s3","<SrcSortByCol3>")
GroupKeyAdd("s4","<SrcSortByCol4>")
GroupKeyAdd("s5","<SrcSortByCol5>")
GroupKeyAdd("s6","<SrcSortByCol6>")
GroupKeyAdd("s7","<SrcSortByCol7>")
GroupKeyAdd("s8","<SrcSortByCol8>")
GroupKeyAdd("s9","<SrcSortByCol9>")
GroupKeyAdd("gn","<SwitchToNextTab>")
GroupKeyAdd("gp","<SwitchToPreviousTab>")
GroupKeyAdd("ga","<CloseAllTabs>")
GroupKeyAdd("gc","<CloseCurrentTab>")
GroupKeyAdd("gt","<OpenDirInNewTab>")
GroupKeyAdd("gb","<OpenDirInNewTabOther>")
GroupKeyAdd("ge","<Exchange>")
GroupKeyAdd("gw","<ExchangeWithTabs>")
GroupKeyAdd("g1","<SrcActivateTab1>")
GroupKeyAdd("g2","<SrcActivateTab2>")
GroupKeyAdd("g3","<SrcActivateTab3>")
GroupKeyAdd("g4","<SrcActivateTab4>")
GroupKeyAdd("g5","<SrcActivateTab5>")
GroupKeyAdd("g6","<SrcActivateTab6>")
GroupKeyAdd("g7","<SrcActivateTab7>")
GroupKeyAdd("g8","<SrcActivateTab8>")
GroupKeyAdd("g9","<SrcActivateTab9>")
GroupKeyAdd("g0","<GoLastTab>")
GroupKeyAdd("gg","<Home>")
GroupKeyAdd("<Shift>vb","<VisButtonbar>")
GroupKeyAdd("<Shift>vd","<VisDriveButtons>")
GroupKeyAdd("<Shift>vo","<VisTwoDriveButtons>")
GroupKeyAdd("<Shift>vr","<VisDriveCombo>")
GroupKeyAdd("<Shift>vc","<VisCurDir>")
GroupKeyAdd("<Shift>vt","<VisTabHeader>")
GroupKeyAdd("<Shift>vs","<VisStatusbar>")
GroupKeyAdd("<Shift>vn","<VisCmdLine>")
GroupKeyAdd("<Shift>vf","<VisKeyButtons>")
GroupKeyAdd("<Shift>vw","<VisDirTabs>")
GroupKeyAdd("<Shift>ve","<CommandBrowser>")
GroupKeyAdd("cl","<DeleteLHistory>")
GroupKeyAdd("cr","<DeleteRHistory>")
GroupKeyAdd("cc","<DelCmdHistory>")
Hotkey,IfWinActive,ViATc 重命名
Hotkey,j,VimRN_Down,on,UseErrorLevel
Hotkey,k,VimRN_Up,on,UseErrorLevel
Hotkey,h,VimRN_Left,on,UseErrorLevel
Hotkey,l,VimRN_Right,on,UseErrorLevel
Hotkey,+j,VimRN_SDown,on,UseErrorLevel
Hotkey,+k,VimRN_SUp,on,UseErrorLevel
Hotkey,+h,VimRN_SLeft,on,UseErrorLevel
Hotkey,+l,VimRN_SRight,on,UseErrorLevel
Hotkey,y,VimRN_Copy,on,UseErrorLevel
Hotkey,d,VimRN_Backspace,on,UseErrorLevel
Hotkey,x,VimRN_Delete,on,UseErrorLevel
Hotkey,i,VimRN_Insert,on,UseErrorLevel
Hotkey,r,VimRN_Replace,on,UseErrorLevel
Hotkey,t,VimRN_Trade,on,UseErrorLevel
Hotkey,f,VimRN_Find,on,UseErrorLevel
Hotkey,+r,VimRN_MultiReplace,on,UseErrorLevel
Hotkey,a,VimRN_Selectall,on,UseErrorLevel
Hotkey,s,VimRN_SelectThis,on,UseErrorLevel
Hotkey,w,VimRN_Selectfilename,on,UseErrorLevel
Hotkey,e,VimRN_Selectext,on,UseErrorLevel
Hotkey,g,VimRN_Home,on,UseErrorLevel
Hotkey,b,VimRN_End,on,UseErrorLevel
Hotkey,q,VimRN_Quit,on,UseErrorLevel
Hotkey,u,VimRN_Undo,on,UseErrorLevel
Hotkey,v,VimRN_Visual,on,UseErrorLevel
Hotkey,p,VimRN_Paste,on,UseErrorLevel
Hotkey,Esc,VimRN_Esc,on,UseErrorLevel
Hotkey,1,VimRN_Num,on,UseErrorLevel
Hotkey,2,VimRN_Num,on,UseErrorLevel
Hotkey,3,VimRN_Num,on,UseErrorLevel
Hotkey,4,VimRN_Num,on,UseErrorLevel
Hotkey,5,VimRN_Num,on,UseErrorLevel
Hotkey,6,VimRN_Num,on,UseErrorLevel
Hotkey,7,VimRN_Num,on,UseErrorLevel
Hotkey,8,VimRN_Num,on,UseErrorLevel
Hotkey,9,VimRN_Num,on,UseErrorLevel
Hotkey,0,VimRN_Num,on,UseErrorLevel
}
SendKey(HotKey)
{
Global KeyCount,KeyTemp,Repeat,MaxCount
If CheckMode()
{
If KeyTemp
{
GroupKey(A_ThisHotkey)
Return
}
If KeyCount
{
ControlSetText,%TCEdit%,,AHK_CLASS TTOTAL_CMD
If KeyCount > %MaxCount%
keyCount := MaxCount
Repeat := KeyCount . ">>" . hotkey
Loop,%KeyCount%
Send %hotkey%
KeyCount := 0
}
Else
{
Send %hotkey%
Repeat := 1 . ">>" . hotkey
}
}
Else
{
hotkey := TransSendKey(A_ThisHotkey)
Send %hotkey%
}
}
SendNum(HotKey)
{
Global KeyCount,KeyTemp,GetNum
If CheckMode()
{
If KeyTemp
{
GroupKey(A_ThisHotkey)
Return
}
If KeyCount
KeyCount := Hotkey + (KeyCount * 10 )
Else
KeyCount := HotKey + 0
ControlSetText,%TCEdit%,%KeyCount%,AHK_CLASS TTOTAL_CMD
}
Else
{
hotkey := TransSendKey(A_ThisHotkey)
Send %hotkey%
}
}
SendPos(Num,IsCount=False)
{
Global KeyCount,KeyTemp,Repeat
If IsCount
Count := KeyCount ? KeyCount : 1
Else
Count := 1
KeyCount := 0
If CheckMode()
{
If KeyTemp
{
GroupKey(A_ThisHotkey)
Return False
}
ControlSetText,%TCEdit%,,AHK_CLASS TTOTAL_CMD
If Num < 0
Return True
If Num
{
Repeat := Count . "@" . Num
Loop,%Count%
PostMessage 1075, %Num%, 0, , AHK_CLASS TTOTAL_CMD
}
Return True
}
Else
{
hotkey := TransSendKey(A_ThisHotkey)
Send %hotkey%
Return False
}
}
ExecFile()
{
Global ExecFile_Arr,KeyTemp,GoExec,Repeat
IfWinActive,AHK_CLASS TTOTAL_CMD
{
Key := "H" . A_ThisHotkey
If Not ExecFile_Arr[Key]
Key := "S" . A_ThisHotkey
}
Else
Key := "S" . A_ThisHotkey
If GoExec
File := ExecFile_Arr[GoExec]
Else
File := ExecFile_Arr[Key]
Run,%File%,,UseErrorLevel,ExecID
If ErrorLevel = ERROR
{
Msgbox 运行%File%失败
Return
}
WinWait,AHK_PID %ExecID%,,3
WinActivate,AHK_PID %ExecID%
Repeat := "(" . File . ")"
GoExec :=
}
SendText()
{
Global SendText_Arr,KeyTemp,Repeat,GoText
IfWinActive,AHK_CLASS TTOTAL_CMD
{
Key := "H" . A_ThisHotkey
If Not SendText_Arr[Key]
Key := "S" . A_ThisHotkey
}
Else
Key := "S" . A_ThisHotkey
If GoText
Text := SendText_Arr[GoText]
Else
Text := SendText_Arr[Key]
IfWinActive,AHK_CLASS TTOTAL_CMD
{
ControlGetFocus,ThisControl,AHK_CLASS TTOTAL_CMD
If RegExMatch(Text,"^[#!\^\+]\{.*}.*")
ControlSend,%ThisControl%,%Text%,AHK_CLASS TTOTAL_CMD
Else
{
ControlSetText,%TCEdit%,%Text%,AHK_CLASS TTOTAL_CMD
Postmessage,1075,4003,0,,AHK_CLASS TTOTAL_CMD
PosEnd := Strlen(Text)
PostMessage,0x00B1,%PosEnd%,%PosEnd%,%TCEdit%,AHK_CLASS TTOTAL_CMD
}
}
Else
Send,%Text%
Repeat := "{" . Text . "}"
GoText :=
}
Groupkey(Hotkey)
{
Global GroupKey_Arr,KeyTemp,KeyCount,GroupInfo_arr,GroupWarn,Repeat,SendText_Arr,ExecFile_Arr,GoExec,GoText
If GroupWarn And ( Not KeyTemp ) And CheckMode() And GroupInfo_Arr[A_ThisHotkey]
Settimer,<GroupWarnAction>,50
If checkMode()
{
KeyCount := 0
KeyTemp .= A_ThisHotkey
AllGK := Groupkey_Arr["Hotkeys"]
MatchString := "[^&]\s" . RegExReplace(KeyTemp,"\+|\?|\.|\*|\{|\}|\(|\)|\||\^|\$|\[|\]|\\","\$0")
If RegExMatch(AllGK,MatchString)
{
MatchString .= "\s"
If RegExMatch(AllGk,MatchString)
{
Settimer,<RemoveToolTipEx>,off
Tooltip
ControlSetText,%TCEdit%,,AHK_CLASS TTOTAL_CMD
Action := GroupKey_Arr[KeyTemp]
If RegExMatch(Action,"<Text>")
GoText := "G" . KeyTemp
If RegExMatch(Action,"<Exec>")
GoExec := "G" . KeyTemp
KeyTemp :=
If IsLabel(Action)
{
GoSub,%Action%
Repeat := Action
}
Else
Msgbox % KeyTemp "动作" Action "出错"
}
Else
ControlSetText,%TCEdit%,%KeyTemp%,AHK_CLASS TTOTAL_CMD
}
Else
{
ControlSetText,%TCEdit%,,AHK_CLASS TTOTAL_CMD
KeyTemp :=
Tooltip
}
}
Else
{
Key := TransSendKey(A_ThisHotkey)
Send,%key%
}
}
GroupKeyAdd(Key,Action,IsGlobal=False)
{
Global GroupKey_Arr,GroupInfo_Arr,ActionInfo_Arr,ExecFile_Arr,SendText_Arr
Key_T := TransHotkey(key,"ALL")
Info := Key . " >>" . ActionInfo_Arr[Action]
If Action = <Text>
{
Key_N := "G" . Key_T
Info := Key . " >>发送文字 " . SendText_Arr[Key_N]
}
If Action = <Exec>
{
Key_N := "G" . Key_T
Info := key . " >>运行 " . ExecFile_Arr[Key_N]
}
GroupKey_Arr["Hotkeys"] .= A_Space . A_Space . Key_T . A_Space . A_Space
GroupKey_Arr[Key_T] := Action
Key_T := TransHotkey(key,"First")
GroupInfo_Arr[Key_T] .= Info . "`n"
If IsGlobal
Hotkey,Ifwinactive
Else
Hotkey,Ifwinactive,AHK_CLASS TTOTAL_CMD
Hotkey,%Key_T%,<GroupKey>,On,UseErrorLevel
}
GroupkeyDelete(Key,IsGlobal=False)
{
Global GroupKey_Arr
Key_T := "\s" . TransHotkey(Key,"ALL") . "\s"
GroupKey_Arr["Hotkeys"] := RegExReplace(Groupkey_Arr["Hotkeys"],Key_T)
Key_T := "\s" . TransHotkey(Key,"First")
If RegExMatch(GroupKey_Arr["Hotkeys"],Key_T)
Return
If IsGlobal
Hotkey,Ifwinactive
Else
Hotkey,Ifwinactive,AHK_CLASS TTOTAL_CMD
Key_T := TransHotkey(Key,"First")
Hotkey,%Key_T%,Off
}
SingleRepeat()
{
Global Repeat
If RegExMatch(Repeat,">>")
{
KeyCount := SubStr(Repeat,1,(RegExMatch(Repeat,">>") - 1))
Loop,%KeyCount%
SendKey(SubStr(Repeat,(RegExMatch(Repeat,">>")+2,StrLen(Repeat))))
Return
}
If RegExMatch(Repeat,"^<.*>$")
{
If IsLabel(Repeat) AND Not RegExMatch(Repeat,"i)<SingleRepeat>")
GoSub,%Repeat%
Return
}
If RegExMatch(Repeat,"[0-9]*@[0-9]*")
{
Stringsplit,Num,Repeat,@
Loop % Num1
Postmessage 1075, %Num2%, 0, , ahk_class TTOTAL_CMD
}
If RegExMatch(Repeat,"^\(.*\)$")
{
File := SubStr(Repeat,2,StrLen(File)-1)
If FileExist(File)
{
Run,%File%,,UseErrorLevel,ExecID
WinWait,AHK_PID %ExecID%,,3
WinActivate,AHK_PID %ExecID%
}
}
If RegExMatch(Repeat,"^\{.*\}$")
{
Text := SubStr(Repeat,2,StrLen(Text)-1)
Send,%Text%
}
}
CheckMode()
{
IfWinNotActive,AHK_CLASS TTOTAL_CMD
Return True
WinGet,MenuID,ID,AHK_CLASS #32768
IF MenuID
Return False
ControlGetFocus,ListBox,ahk_class TTOTAL_CMD
Ifinstring,ListBox,%TCListBox%
If Vim
Return true
Else
Return False
Else
Return False
}
TransHotkey(Hotkey,pos="ALL")
{
If Pos = ALL
{
Loop
{
If RegExMatch(Hotkey,"^<[^<>]+><[^<>]+>.*$")
{
Hotkey1 := SubStr(Hotkey,2,RegExMatch(Hotkey,"><.*")-2)
If RegExMatch(Hotkey1,"i)(l|r)?(ctrl|control|shift|win|alt)")
{
HK := SubStr(Hotkey,RegExMatch(Hotkey,"><.*")+2,Strlen(Hotkey)-RegExMatch(Hotkey,"><.*")-1)
Hotkey2 := SubStr(HK,1,RegExMatch(HK,">")-1)
Hotkey3 := SubStr(HK,RegExMatch(HK,">")+1)
NewHotkey := Hotkey1 . " & " . Hotkey2 . Hotkey3
}
Else
NewHotkey := Hotkey1  . HK := SubStr(Hotkey,RegExMatch(Hotkey,"><.*")+1,Strlen(Hotkey)-RegExMatch(Hotkey,"><.*"))
Break
}
If RegExMatch(Hotkey,"^<[^<>]+>.+$")
{
Hotkey1 := SubStr(Hotkey,2,RegExMatch(Hotkey,">.+")-2)
If RegExMatch(Hotkey1,"i)(l|r)?(ctrl|control|shift|win|alt)")
{
Hotkey2 := SubStr(Hotkey,RegExMatch(Hotkey,">.+")+1)
NewHotkey := Hotkey1 . " & " . Hotkey2
}
Else
{
Hotkey2 := SubStr(Hotkey,RegExMatch(Hotkey,">.+")+1)
NewHotkey := Hotkey1 . Hotkey2
}
Break
}
If RegExMatch(Hotkey,"^<[^<>]+>$")
{
NewHotkey := SubStr(Hotkey,2,Strlen(Hotkey)-2)
Break
}
NewHotkey := Hotkey
Break
}
}
Else
{
Loop
{
If RegExMatch(Hotkey,"^<[^<>]+><[^<>]+>.*")
{
Hotkey1 := SubStr(Hotkey,2,RegExMatch(Hotkey,"><")-2)
If RegExMatch(Hotkey1,"i)(l|r)?(ctrl|control|shift|win|alt)")
{
HK := SubStr(Hotkey,RegExMatch(Hotkey,"><")+2,Strlen(Hotkey)-RegExMatch(Hotkey,"><")-1)
Hotkey2 := SubStr(HK,1,RegExMatch(HK,">")-1)
NewHotkey := Hotkey1 . " & " . Hotkey2
}
Else
NewHotkey := Hotkey1
Break
}
If RegExMatch(Hotkey,"^<[^<>]+>.+")
{
Hotkey1 := SubStr(Hotkey,2,RegExMatch(Hotkey,">")-2)
If RegExMatch(Hotkey1,"i)(l|r)?(ctrl|control|shift|win|alt)")
{
NewHotkey := Hotkey1 . " & " . SubStr(Hotkey,RegExMatch(Hotkey,">")+1,1)
}
Else
NewHotkey := Hotkey1
Break
}
If RegExMatch(Hotkey,"i)^<(l|r)?(ctrl|control|shift|win|alt)>$")
{
NewHotkey := SubStr(Hotkey,2,Strlen(Hotkey)-2)
Break
}
If RegExMatch(Hotkey,"^<[^<>]+>$")
{
NewHotkey := SubStr(Hotkey,2,Strlen(Hotkey)-2)
Break
}
If RegExMatch(Hotkey,"^.*")
NewHotkey := Substr(hotkey,1,1)
Break
}
}
Return NewHotkey
}
CheckScope(key)
{
If RegExMatch(Key,"^<[^<>]+>$|^<[^<>]+><[^<>]+>$|^.$")
Scope := "H"
Else
Scope := "G"
If RegExMatch(Key,"i)^<(shift|lshift|rshift|ctrl|lctrl|rctrl|control|lcontrol|rcontrol|lwin|rwin|alt|lalt|ralt)>.$")
Scope := "H"
return Scope
}
TransSendKey(hotkey)
{
Loop
{
If RegExMatch(Hotkey,"i)^Esc$")
{
Hotkey := "{Esc}"
Break
}
If StrLen(hotkey) > 1 AND Not RegExMatch(Hotkey,"^\+.$")
{
Hotkey := "{" . hotkey . "}"
If RegExMatch(hotkey,"i)(shift|lshift|rshift)(\s\&\s)?.+$")
Hotkey := "+" . RegExReplace(hotkey,"i)(shift|lshift|rshift)(\s\&\s)?")
If RegExMatch(hotkey,"i)(ctrl|lctrl|rctrl|control|lcontrol|rcontrol)(\s\&\s)?.+$")
Hotkey := "^" . RegExReplace(hotkey,"i)(ctrl|lctrl|rctrl|control|lcontrol|rcontrol)(\s\&\s)?")
If RegExMatch(hotkey,"i)(lwin|rwin)(\s\&\s)?.+$")
Hotkey := "#" . RegExReplace(hotkey,"i)(lwin|rwin)(\s\&\s)?")
If RegExMatch(hotkey,"i)(alt|lalt|ralt)(\s\&\s)?.+$")
Hotkey := "!" . RegExReplace(hotkey,"i)(alt|lalt|ralt)(\s\&\s)?")
}
If RegExMatch(Hotkey,"^\+.$")
{
Hotkey := SubStr(Hotkey,1,1) . "{" . SubStr(Hotkey,2) . "}"
}
GetKeyState,Var,CapsLock,T
If Var = D
{
If RegExMatch(Hotkey,"^\+\{[a-z]\}$")
{
Hotkey := SubStr(Hotkey,2)
Break
}
If RegExMatch(Hotkey,"^[a-z]$")
{
Hotkey := "+{" . Hotkey . "}"
Break
}
If RegExMatch(Hotkey,"^\{[a-z]\}$")
{
Hotkey := "+" . Hotkey
Break
}
}
Break
}
Return hotkey
}
FindPath(File)
{
If RegExMatch(File,"exe")
{
GetPath := A_WorkingDir . "\totalcmd.exe"
GetPath64 := A_WorkingDir . "\totalcmd64.exe"
Reg := "InstallDir"
FileSF_Option := 3
FileSF_FileName:=
FileSF_Prompt := "TOTALCMD.EXE"
FileSF_Filter := "*.EXE"
FileSF_Error := "打开TOTALCMD.EXE失败"
}
If RegExMatch(File,"ini")
{
GetPath := A_workingDir . "\wincmd.ini"
Reg := "IniFileName"
FileSF_Option := 3
FileSF_FileName:=
FileSF_Prompt := "选择配置文件"
FileSF_Filter := "*.INI"
FileSF_Error := "打开TC配置文件失败"
}
RegRead,GetPath,HKEY_CURRENT_USER,Software\VIATC,%Reg%
If FileExist(GetPath)
{
FilegetAttrib,Attrib,%GetPath%
IfNotInString, Attrib, D
{
Return GetPath
}
}
If FileExist(GetPath64)
{
Regwrite,REG_SZ,HKEY_CURRENT_USER,Software\VIATC,%Reg%,%GetPath64%
Return GetPath64
}
If FileExist(GetPath)
{
Regwrite,REG_SZ,HKEY_CURRENT_USER,Software\VIATC,%Reg%,%GetPath%
Return GetPath
}
FileSelectFile,GetPath,%FileSF_Option%,%FileSF_FileName%,%FileSF_Prompt%,%FileSF_Filter%
If ErrorLevel
{
Msgbox %FileSF_Error%
Return
}
Else
Regwrite,REG_SZ,HKEY_CURRENT_USER,Software\VIATC,%Reg%,%GetPath%
Return GetPath
}
ReadKeyFromIni()
{
Global ViatcIni,ExecFile_Arr,SendText_Arr,MapKey_Arr,MapKey_Arr
Loop,Read,%ViatcIni%
{
If RegExMatch(SubStr(RegExReplace(A_LoopReadLine,"\s"),1,1),";")
Continue
If RegExMatch(A_LoopReadLine,"i)\[.*\]")
IsReadKey := False
If RegExMatch(A_LoopReadLine,"i)\[Hotkey\]")
{
IsReadKey := True
IsHotkey := True
IsGlobalHotkey := False
IsGroupkey := False
Continue
}
If RegExMatch(A_LoopReadLine,"i)\[GlobalHotkey\]")
{
IsReadKey := True
IsGlobalHotkey := True
IsHotkey := False
IsGroupkey := False
Continue
}
If RegExMatch(A_LoopReadLine,"i)\[GroupKey\]")
{
IsReadKey := True
IsGroupkey := True
IsHotkey := False
IsGlobalHotkey := False
Continue
}
If IsReadkey
{
StringPos := RegExMatch(A_LoopReadLine,"=[<|\(|\{].*[>|\)\}]$",Action)
If StringPos
{
Key := SubStr(A_LoopReadLine,1,StringPos-1)
Action := SubStr(Action,2)
}
If IsGlobalHotkey
MapKeyAdd(Key,Action,"S")
If IsHotkey
MapKeyAdd(Key,Action,"H")
If IsGroupkey
MapKeyAdd(Key,Action,"G")
}
}
}
MapKeyAdd(Key,Action,Scope)
{
Global MapKey_Arr,ExecFile_Arr,SendText_Arr
If RegExMatch(CheckScope(key),"G")
Scope := "G"
If Not RegExMatch(Action,"^[<|\(|\{].*[>|\)\}]$")
Return False
If Not IsLabel(Action) AND RegExMatch(Action,"^<.*>$")
{
return False
}
If RegExMatch(Action,"^\(.*\)$")
{
Key_T := Scope . TransHotkey(Key)
ExecFile_Arr["HotKeys"] .= A_Space . Key_T . A_Space
ExecFile_Arr[Key_T] := Substr(Action,2,Strlen(Action)-2)
Action := "<Exec>"
}
If RegExMatch(Action,"^\{.*\}$")
{
Key_T := Scope . TransHotkey(Key)
SendText_Arr["HotKeys"] .= A_Space . Key_T . A_Space
SendText_Arr[Key_T] := Substr(Action,2,Strlen(Action)-2)
Action := "<Text>"
}
If Scope = S
{
HotKey,IfWinActive
Key_T := TransHotkey(Key)
Hotkey,%Key_T%,%Action%,On,UseErrorLevel
}
If Scope = H
{
Hotkey,IfWinActive,AHK_CLASS TTOTAL_CMD
Key_T := TransHotkey(Key)
Hotkey,%Key_T%,%Action%,On,UseErrorLevel
}
If Scope = G
GroupKeyAdd(Key,Action)
Key_T := "i)\s" . Scope . RegExReplace(Key,"\+|\?|\.|\*|\{|\}|\(|\)|\||\^|\$|\[|\]|\\","\$0") . "\s"
If RegExMatch(MapKey_Arr["Hotkeys"],Key_T)
Return true
Else
{
Key := Scope . Key
MapKey_Arr["Hotkeys"] .= A_space . Key . A_Space
}
MapKey_Arr[Key] := Action
Return true
}
MapKeyDelete(Key,Scope)
{
Global MapKey_Arr
If Scope = S
{
Key_T := TransHotkey(Key)
Hotkey,IfWinActive
Hotkey,%Key_T%,Off
}
If Scope = H
{
Key_T := TransHotkey(Key)
Hotkey,IfWinActive,AHK_CLASS TTOTAL_CMD
Hotkey,%Key_T%,Off
}
If Scope = G
GroupkeyDelete(Key)
DelKey := "\s" . Scope . RegExReplace(Key,"\+|\?|\.|\*|\{|\}|\(|\)|\||\^|\$|\[|\]|\\","\$0") . "\s"
Mapkey_Arr["Hotkeys"] := RegExReplace(MapKey_Arr["Hotkeys"],DelKey)
}
GetConfig(Section,Key)
{
Global ViatcIni
IniRead,Getvar,%ViatcIni%,%Section%,%Key%
If RegExMatch(Getvar,"^ERROR$")
GetVar := CreateConfig(Section,key)
Return GetVar
}
SetConfig(Section,Key,Var)
{
Global ViatcIni
IniWrite,%Var%,%ViatcIni%,%Section%,%Key%
}
CreateConfig(Section,Key)
{
Global ViatcIni
If Section = Configuration
If Key = TrayIcon
SetVar := 1
If Key = Vim
SetVar := 1
If Key = Toggle
SetVar := "<lwin>w"
If Key = GlobalTogg
SetVar := 1
If Key = Suspend
SetVar := "<alt>``"
If Key = GlobalSusp
SetVar := 0
If Key = Startup
SetVar := 0
If Key = Service
SetVar := 1
If Key = GroupWarn
SetVar := 1
If Key = TranspHelp
SetVar := 0
If Key = TransParent
SetVar := 0
If Key = TranspVar
SetVar := 220
If Key = MaxCount
SetVar := 99
If Section = SearchEngine
If Key = Default
SetVar := 1
If Key = 1
SetVar := "http://www.google.com.hk/search?q={%1}"
If Key = 2
SetVar := "http://www.baidu.com/s?wd={%1}"
If Section = VimReName
If Key = Mode
SetVar := 1
If Key = SelectExt
SetVar := 1
If Section = Other
If Key = LnkToDesktop
SetVar := 1
IniRead,GetVar,%ViatcIni%,%Section%,%Key%
If Getvar = ERROR
Iniwrite,%SetVar%,%ViatcIni%,%Section%,%Key%
Return SetVar
}
ToggleMenu(a=0)
{
Global TCMenuHandle
WinGet,hwin,Id,AHK_CLASS TTOTAL_CMD
If hwin
MenuHandle := DllCall("GetMenu", "uint", hWin)
If MenuHandle
{
DllCall("SetMenu", "uint", hWin, "uint", 0)
TCmenuHandle := MenuHandle
}
Else
DllCall("SetMenu", "uint", hWin, "uint", TCmenuHandle )
if a
{
WinSet,Style,+0xC10000,AHK_CLASS TTOTAL_CMD
DllCall("SetMenu", "uint", hWin, "uint", TCmenuHandle )
}
}
HideControl()
{
Global HideControl_arr,TcIni,TCmenuHandle
if HideControl_arr["Toggle"]
{
HideControl_arr["Toggle"] := False
if HideControl_arr["KeyButtons"]
PostMessage 1075, 2911 , 0, , AHK_CLASS TTOTAL_CMD
if HideControl_arr["drivebar1"]
PostMessage 1075, 2902 , 0, , AHK_CLASS TTOTAL_CMD
if HideControl_arr["DriveBar2"]
PostMessage 1075,  2903, 0, , AHK_CLASS TTOTAL_CMD
if HideControl_arr["DriveBarFlat"]
PostMessage 1075,  2904, 0, , AHK_CLASS TTOTAL_CMD
if HideControl_arr["InterfaceFlat"]
PostMessage 1075,  2905, 0, , AHK_CLASS TTOTAL_CMD
if HideControl_arr["DriveCombo"]
PostMessage 1075, 2906 , 0, , AHK_CLASS TTOTAL_CMD
if HideControl_arr["DirectoryTabs"]
PostMessage 1075,  2916, 0, , AHK_CLASS TTOTAL_CMD
if HideControl_arr["XPthemeBg"]
PostMessage 1075, 2923 , 0, , AHK_CLASS TTOTAL_CMD
if HideControl_arr["CurDir"]
PostMessage 1075, 2907 , 0, , AHK_CLASS TTOTAL_CMD
if HideControl_arr["TabHeader"]
PostMessage 1075, 2908 , 0, , AHK_CLASS TTOTAL_CMD
if HideControl_arr["StatusBar"]
PostMessage 1075,  2909, 0, , AHK_CLASS TTOTAL_CMD
if HideControl_arr["CmdLine"]
PostMessage 1075, 2910 , 0, , AHK_CLASS TTOTAL_CMD
if HideControl_arr["HistoryHotlistButtons"]
PostMessage 1075, 2919 , 0, , AHK_CLASS TTOTAL_CMD
if HideControl_arr["BreadCrumbBar"]
PostMessage 1075,  2926, 0, , AHK_CLASS TTOTAL_CMD
if HideControl_arr["ButtonBar"]
PostMessage 1075,2901  , 0, , AHK_CLASS TTOTAL_CMD
WinSet,Style,+0xC10000,AHK_CLASS TTOTAL_CMD
winActivate,AHK_CLASS TTOTAL_CMD
Settimer,FS,off
WinGet,hwin,Id,AHK_CLASS TTOTAL_CMD
If hwin
DllCall("SetMenu", "uint", hWin, "uint", TCmenuHandle )
}
Else
{
HideControl_arr["Toggle"] := True
IniRead,v_KeyButtons,%TCINI%,LayOut,KeyButtons
HideControl_arr["KeyButtons"] := v_KeyButtons
If v_KeyButtons
PostMessage 1075, 2911 , 0, , AHK_CLASS TTOTAL_CMD
IniRead,v_drivebar1,%TcIni%,layout,drivebar1
HideControl_arr["drivebar1"] := v_drivebar1
If v_DriveBar1
PostMessage 1075, 2902 , 0, , AHK_CLASS TTOTAL_CMD
IniRead,v_DriveBar2,%TcIni%,Layout,DriveBar2
HideControl_arr["DriveBar2"] := v_DriveBar2
If v_DriveBar2
PostMessage 1075,  2903, 0, , AHK_CLASS TTOTAL_CMD
IniRead,v_DriveBarFlat,%TcIni%,Layout,DriveBarFlat
HideControl_arr["DriveBarFlat"] := v_DriveBarFlat
If v_DriveBarFlat
PostMessage 1075,  2904, 0, , AHK_CLASS TTOTAL_CMD
IniRead,v_InterfaceFlat,%TcIni%,Layout,InterfaceFlat
HideControl_arr["InterfaceFlat"] := v_InterfaceFlat
If v_InterfaceFlat
PostMessage 1075,  2905, 0, , AHK_CLASS TTOTAL_CMD
IniRead,v_DriveCombo,%TcIni%,Layout,DriveCombo
HideControl_arr["DriveCombo"] := v_DriveCombo
If v_DriveCombo
PostMessage 1075, 2906 , 0, , AHK_CLASS TTOTAL_CMD
IniRead,v_DirectoryTabs,%TcIni%,Layout,DirectoryTabs
HideControl_arr["DirectoryTabs"] := v_DirectoryTabs
If v_DirectoryTabs
PostMessage 1075,  2916, 0, , AHK_CLASS TTOTAL_CMD
IniRead,v_XPthemeBg,%TcIni%,Layout,XPthemeBg
HideControl_arr["XPthemeBg"] := v_XPthemeBg
If v_XPthemeBg
PostMessage 1075, 2923 , 0, , AHK_CLASS TTOTAL_CMD
IniRead,v_CurDir,%TcIni%,Layout,CurDir
HideControl_arr["CurDir"] := v_CurDir
If v_CurDir
PostMessage 1075, 2907 , 0, , AHK_CLASS TTOTAL_CMD
IniRead,v_TabHeader,%TcIni%,Layout,TabHeader
HideControl_arr["TabHeader"] := v_TabHeader
If v_TabHeader
PostMessage 1075, 2908 , 0, , AHK_CLASS TTOTAL_CMD
IniRead,v_StatusBar,%TcIni%,Layout,StatusBar
HideControl_arr["StatusBar"] := v_StatusBar
If v_StatusBar
PostMessage 1075,  2909, 0, , AHK_CLASS TTOTAL_CMD
IniRead,v_CmdLine,%TcIni%,Layout,CmdLine
HideControl_arr["CmdLine"] := v_CmdLine
If v_CmdLine
PostMessage 1075, 2910 , 0, , AHK_CLASS TTOTAL_CMD
IniRead,v_HistoryHotlistButtons,%TcIni%,Layout,HistoryHotlistButtons
HideControl_arr["HistoryHotlistButtons"] := v_HistoryHotlistButtons
If v_HistoryHotlistButtons
PostMessage 1075, 2919 , 0, , AHK_CLASS TTOTAL_CMD
IniRead,v_BreadCrumbBar,%TcIni%,Layout,BreadCrumbBar
HideControl_arr["BreadCrumbBar"] := v_BreadCrumbBar
If v_BreadCrumbBar
PostMessage 1075,  2926, 0, , AHK_CLASS TTOTAL_CMD
IniRead,v_ButtonBar	,%TcIni%,Layout,ButtonBar
HideControl_arr["ButtonBar"] := v_ButtonBar
If v_ButtonBar
PostMessage 1075,2901  , 0, , AHK_CLASS TTOTAL_CMD
WinSet,Style,-0xC00000,AHK_CLASS TTOTAL_CMD
winActivate,AHK_CLASS TTOTAL_CMD
}
}
FS:
FS()
Return
FS()
{
WinGet,hwin,Id,AHK_CLASS TTOTAL_CMD
If hwin
MenuHandle := DllCall("GetMenu", "uint", hWin)
Else
Settimer,FS,off
If MenuHandle
DllCall("SetMenu", "uint", hWin, "uint", 0)
}
Enter()
{
Global MapKey_Arr,ActionInfo_Arr,ExecFile_Arr,SendText_Arr,TabsBreak
ControlGetFocus,ThisControl,AHK_CLASS TTOTAL_CMD
Match_TCEdit := "^" . TCEdit . "$"
If RegExMatch(ThisControl,Match_TCEdit)
{
ControlGetText,CMD,%TCEdit%,AHK_CLASS TTOTAL_CMD
If RegExMatch(CMD,"^:.*")
{
ControlGetPos,xn,yn,,hn,%TCEdit%,AHK_CLASS TTOTAL_CMD
ControlSetText,%TCEdit%,,AHK_CLASS TTOTAL_CMD
CMD := SubStr(CMD,2)
If RegExMatch(CMD,"i)^se?t?t?i?n?g?\s*$")
{
Setting()
Return
}
If RegExMatch(CMD,"i)^he?l?p?\s*")
{
Help()
Return
}
If RegExMatch(CMD,"i)^re?l?o?a?d?\s*$")
{
ReloadVIATC()
Return
}
If RegExMatch(CMD,"i)^ma?p?\s*$")
{
Map := MapKey_Arr["Hotkeys"]
Stringsplit,ListMap,Map,%A_Space%
Loop,% ListMap0
{
If ListMap%A_Index%
{
Action := MapKey_Arr[ListMap%A_Index%]
If Action = <Exec>
{
EX := SubStr(ListMap%A_Index%,1,1) . TransHotkey(SubStr(ListMap%A_Index%,2))
Action := "(" . ExecFile_Arr[EX] . ")"
}
If Action = <Text>
{
TX := SubStr(ListMap%A_Index%,1,1) . TransHotkey(SubStr(ListMap%A_Index%,2))
Action := "{" . SendText_Arr[TX] . "}"
}
LM .= SubStr(ListMap%A_Index%,1,1) . "  " . SubStr(ListMap%A_Index%,2) . "  " . Action  . "`n"
}
}
yn := yn - hn - ( ListMap0 * 8 )
Tooltip,%LM%,%xn%,%yn%
Settimer,<RemoveToolTipEx>,100
Return
}
If RegExMatch(CMD,"i)^ma?p?\s*[^\s]*")
{
CMD1 := RegExReplace(CMD,"i)^ma?p?\s*")
Key := SubStr(CMD1,1,RegExMatch(CMD1,"\s")-1)
Action := SubStr(CMD1,RegExMatch(CMD1,"\s[^\s]")+1)
yn := yn -  hn - 9
If RegExMatch(CheckScope(key),"G")
If Not MapKeyAdd(Key,Action,"G")
Tooltip,映射失败`,动作%Action%有误,%xn%,%yn%
Else
Tooltip,映射成功,%xn%,%yn%
Else
If Not MapKeyAdd(Key,Action,"H")
Tooltip,映射失败,%xn%,%yn%
Else
Tooltip,映射成功,%xn%,%yn%
Sleep,2000
Tooltip
Return
}
If RegExMatch(CMD,"i)^sma?p?\s*[^\s]*")
{
CMD1 := RegExReplace(CMD,"i)^sma?p?\s*")
Key := SubStr(CMD1,1,RegExMatch(CMD1,"\s")-1)
Action := SubStr(CMD1,RegExMatch(CMD1,"\s[^\s]")+1)
yn := yn -  hn - 9
If RegExMatch(Key,"^[^<][^>]+$|^<[^<>]*>[^<>][^<>]+$|^<[^<>]+><[^<>]+>.+$")
Tooltip,映射失败`,全局热键不支持组合键,%xn%,%yn%
Else
If Not MapKeyAdd(Key,Action,"S")
Tooltip,映射失败,%xn%,%yn%
Else
Tooltip,映射成功,%xn%,%yn%
Sleep,2000
Tooltip
Return
}
If RegExMatch(CMD,"i)^qu?i?t?")
{
GoSub,<QuitTC>
Return
}
If RegExMatch(CMD,"i)^e.*")
{
Editviatcini()
Return
}
yn := yn -  hn - 9
Tooltip,无效的命令行,%xn%,%yn%
Sleep,2000
Tooltip
}
Else
ControlSend,%TCEdit%,{Enter},AHK_CLASS TTOTAL_CMD
}
Else
ControlSend,%ThisControl%,{Enter},AHK_CLASS TTOTAL_CMD
}
CreateNewFile()
{
Global ViatcIni
If CheckMode()
{
Menu,CreateNewFile,Add
Menu,CreateNewFile,DeleteAll
Index := 0
Loop,23
{
IniRead,file,%ViatcIni%,ShellNew,%A_Index%
If file <> ERROR
{
Splitpath,file,,,ext
ext := "." . ext
Icon_file :=
Icon_idx :=
RegRead,filetype,HKEY_CLASSES_ROOT,%ext%
If Not filetype
{
Loop,HKEY_CLASSES_ROOT,%ext%,2
If RegExMatch(A_LoopRegName,".*\.")
filetype := A_LoopRegName
}
RegRead,iconfile,HKEY_CLASSES_ROOT,%filetype%\DefaultIcon
Loop,% StrLen(iconfile)
{
If RegExMatch(SubStr(iconfile,Strlen(iconfile)-A_index+1,1),",")
{
icon_file := SubStr(iconfile,1,Strlen(iconfile)-A_index)
icon_idx := Substr(iconfile,Strlen(iconfile)-A_index+2,A_index)
Break
}
}
file := "&" . chr(64+A_Index) . ">>" . Substr(file,2,RegExMatch(file,"\)")-2)
Menu,CreateNewFile,Add,%file%,CreateFile
Menu,CreateNewFile,Icon,%file%,%icon_file%,%icon_idx%
Index++
File :=
}
}
If Index > 1
Menu,CreateNewFile,Add
Menu,CreateNewFile,Add,文件夹(&W),MkDir
Menu,CreateNewFile,Icon,文件夹(&W),%A_WinDir%\system32\Shell32.dll,-4
Menu,CreateNewFile,Add,空白文件(&V),CreateFile
Menu,CreateNewFile,Icon,空白文件(&V),%A_WinDir%\system32\Shell32.dll,-152
Menu,CreateNewFile,Add,快捷方式(&Y),Shortcut
Menu,CreateNewFile,Icon,快捷方式(&Y),%A_WinDir%\system32\Shell32.dll,-30
Menu,CreateNewFile,Add
Menu,CreateNewFile,Add,添加到新模版(&X),template
Menu,CreateNewFile,Icon,添加到新模版(&X),%A_WinDir%\system32\Shell32.dll,-155
Menu,CreateNewFile,Add,配置(&Z),M_EVI
Menu,CreateNewFile,Icon,配置(&Z),%A_WinDir%\system32\Shell32.dll,-151
ControlGetFocus,TLB,ahk_class TTOTAL_CMD
ControlGetPos,xn,yn,,,%TLB%,ahk_class TTOTAL_CMD
Menu,CreateNewFile,show,%xn%,%yn%
}
}
MkDir:
PostMessage 1075, 907, 0, , ahk_class TTOTAL_CMD
Return
Shortcut:
PostMessage 1075, 1004, 0, , ahk_class TTOTAL_CMD
If LnkToDesktop
Settimer,SetLnkToDestop,50
Return
SetLnkToDestop:
Loop,4
{
If WinExist("AHK_CLASS TInpComboDlg")
{
ControlGetText,Path,TAltEdit1,AHK_CLASS TInpComboDlg
Splitpath,Path,FileName
NewFileName := A_Desktop . "\" . FileName
ControlSetText,TAltEdit1,%NewFileName%,AHK_CLASS TInpComboDlg
Break
}
Sleep,500
}
Settimer,SetLnkToDestop,off
return
template:
template()
Return
template()
{
Global CNF
ClipSaved := ClipboardAll
Clipboard :=
SendMessage 1075, 2018, 0, , ahk_class TTOTAL_CMD
ClipWait,2
If Clipboard
temp_File := Clipboard
Else
Return
Clipboard := ClipSaved
Filegetattrib,Attributes,%Temp_file%
IfInString, Attributes, D
{
Msgbox ,,添加新模板,请选择文件
Return
}
Splitpath,temp_file,,,Ext
WinGet,hwndtc,id,AHK_CLASS TTOTAL_CMD
Gui,new,+Theme +Owner%hwndtc% +HwndCNF
Gui,Add,Text,x10 y10,模板名
Gui,Add,Edit,x50 y8 w205,%ext%
Gui,Add,Text,x10 y42,模板源
Gui,Add,Edit,x50 y40 w205 h20 +ReadOnly,%temp_File%
Gui,Add,button,x140 y68 default gTemp_save,确定(&O)
Gui,Add,button,x200 y68 g<Cancel>,取消(&C)
Gui,Show,,新建模板
Controlsend,edit1,{ctrl a},ahk_id %CNF%
Controlsend,edit2,{end},ahk_id %CNF%
}
Temp_save:
temp_save()
Return
Temp_save()
{
Global CNF,TCDir,ViatcIni
ControlGettext,tempName,edit1,ahk_id %cnf%
ControlGettext,tempPath,edit2,ahk_id %cnf%
ShellNew := TCDir . "\ShellNew"
If Not InStr(Fileexist(ShellNew),"D")
FileCreateDir,%ShellNew%
Filecopy,%tempPath%,%TCDir%\ShellNew,1
Splitpath,tempPath,FileName
New := 1
Loop,23
{
IniRead,file,%ViatcIni%,ShellNew,%A_Index%
If file = ERROR
Break
New++
}
IniWrite,(%tempName%)\%FileName%,%ViatcIni%,ShellNew,%New%
Gui,Destroy
EmptyMem()
}
CreateFile:
CreateFile(SubStr(A_ThisMenuItem,5,Strlen(A_ThisMenuItem)))
Return
CreateFile(item)
{
Global ViatcIni,TCDir,CNF_New
ClipSaved := ClipboardAll
Clipboard :=
SendMessage 1075, 2029, 0, , ahk_class TTOTAL_CMD
ClipWait,2
If Clipboard
NewPath := Clipboard
Else
Return
Clipboard := ClipSaved
If RegExMatch(NewPath,"^\\\\计算机$")
Return
If RegExMatch(NewPath,"i)\\\\所有控制面板项$")
Return
If RegExMatch(NewPath,"i)\\\\Fonts$")
Return
If RegExMatch(NewPath,"i)\\\\网络$")
Return
If RegExMatch(NewPath,"i)\\\\打印机$")
Return
If RegExMatch(NewPath,"i)\\\\回收站$")
Return
Loop,23
{
IniRead,file,%ViatcIni%,ShellNew,%A_Index%
Match := Substr(file,2,RegExMatch(file,"\)")-2)
if RegExMatch(Match,item) Or RegExMatch(Item,"\(&V\)$")
{
If RegExMatch(Item,"\(&V\)$")
{
File := A_Temp . "\viatcTemp"
If Fileexist(file)
Filedelete,%File%
FileAppend,,%File%,UTF-8
}
Else
file := TCDir . "\ShellNew" . Substr(file,RegExMatch(file,"\)")+1,Strlen(file))
If Fileexist(file)
{
Splitpath,file,filename,,fileext
WinGet,hwndtc,id,AHK_CLASS TTOTAL_CMD
Gui,new,+Theme +Owner%hwndtc% +HwndCNF_New
Gui,Add,Text,hidden ,%file%
Gui,Add,Edit,x10 y10 w340 h22 -Multi,%filename%
Gui,Add,button,x200 y40 w70 gTemp_create Default,确定(&O)
Gui,Add,button,x280 y40 w70 g<Cancel>,取消(&C)
Gui,Show,w360 h70,新建文件
Controlsend,edit1,{ctrl a},ahk_id %CNF_New%
If Fileext
Loop,% strlen(fileext)+1
Controlsend,edit1,+{left},ahk_id %CNF_New%
}
Else
{
Msgbox 模板源已被移动或删除
IniDelete,%ViatcIni%,ShellNew,%A_Index%
}
Break
}
}
}
Temp_Create:
Temp_Create()
Return
Temp_Create()
{
Global CNF_New
ControlGetText,FilePath,Static1,AHK_ID %CNF_New%
ControlGetText,NewFile,Edit1,AHK_ID %CNF_New%
ClipSaved := ClipboardAll
Clipboard :=
SendMessage 1075, 2029, 0, , ahk_class TTOTAL_CMD
ClipWait,2
If Clipboard
NewPath := Clipboard
Else
Return
If RegExmatch(NewPath,"^\\\\桌面$")
NewPath := A_Desktop
NewFile := NewPath . "\" . NewFile
If Fileexist(NewPath)
{
Filecopy,%FilePath%,%NewFile%,1
If ErrorLevel
Msgbox 文件已存在
Gui,Destroy
EmptyMem()
}
Clipboard := ClipSaved
ControlGetFocus,focus_control,AHK_CLASS TTOTAL_CMD
MatchCtrl := "^" . TCListBox
If RegExMatch(focus_control,MatchCtrl)
{
Splitpath,NewFile,NewFileName,,NewFileExt
Matchstr := RegExReplace(newfileName,"\+|\?|\.|\*|\{|\}|\(|\)|\||\^|\$|\[|\]|\\","\$0")
Loop,100
{
ControlGet,outvar,list,,%focus_control%,AHK_CLASS TTOTAL_CMD
If RegExMatch(outvar,Matchstr)
{
Matchstr := "^" . Matchstr
Loop,Parse,Outvar,`n
{
If RegExMatch(A_LoopField,MatchStr)
{
Focus := A_Index - 1
Break
}
}
PostMessage, 0x19E, %Focus%, 1, %focus_control%, AHK_CLASS TTOTAL_CMD
Break
}
Sleep,50
}
}
If NewFileExt
Run,%newFile%,,UseErrorLevel
Else
Postmessage,1075,904,0,,AHK_CLASS TTOTAL_CMD
Return
}
M_EVI:
Editviatcini()
Return
Editviatcini()
{
Global viatcini
RegRead,path,HKEY_LOCAL_MACHINE,Software\vim\gvim,path
match = `"$0
INI := Regexreplace(viatcini,".*",match)
path := path . " "
If Fileexist(path)
editini := path . a_space . ini
Else
editini := "notepad.exe" . a_space . ini
Run,%editini%,,UseErrorLevel
Return
}
<Cancel>:
Gui,Cancel
Return
EmptyMem(PID="AHK Rocks")
{
pid:=(pid="AHK Rocks") ? DllCall("GetCurrentProcessId") : pid
h:=DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", pid)
DllCall("SetProcessWorkingSetSize", "UInt", h, "Int", -1, "Int", -1)
DllCall("CloseHandle", "Int", h)
}
Diff(String1,String2)
{
String2 := "^" . RegExReplace(String2,"\+|\?|\.|\*|\{|\}|\(|\)|\||\^|\$|\[|\]|\\","\$0") "$"
If RegExMatch(String1,String2)
Return True
Else
Return False
}
Setting()
{
Global StartUp,Service,TrayIcon,Vim,GlobalTogg,Toggle,GlobalSusp,Susp,GroupWarn,TranspHelp,TransParent,SearchEng,DefaultSE,ViATcIni,TCExe,TCINI,NeedReload
NeedReload := 1
Global ListView
Global MapKey_Arr,ActionInfo_Arr,ExecFile_Arr,SendText_Arr
Vim := GetConfig("Configuration","Vim")
Gui,Destroy
Gui,+Theme +hwndviatcsetting
Gui,Add,Button,x10 y335 w80 g<EditViATCIni>,配置文件(&E)
Gui,Add,Button,x140 y335 w80 center Default g<GuiEnter>,确定(&O)
Gui,Add,Button,x230 y335 w80 center g<GuiCancel>,取消(&C)
Gui,Add,Tab2,x10 y6 +theme h320 center choose2,常规(U)|快捷键(P)|&路径设置(&M)
Gui,Add,GroupBox,x16 y32 H170 w290,全局设置
Gui,Add,CheckBox,x25 y50 h20 checked%startup% vStartup,开机运行VIATC(&R)
Gui,Add,CheckBox,x180 y50 h20 checked%Service% vService,后台运行(&B)
Gui,Add,CheckBox,x25 y70 h20 checked%TrayIcon% vTrayIcon,系统托盘图标(&T)
Gui,Add,CheckBox,x180 y70 h20 checked%Vim% vVim,默认VIM模式(&V)
Gui,Add,Text,x25 y100 h20,激活/最小化TC(&F)
Gui,Add,Edit,x24 y120 h20 w140 vToggle ,%Toggle%
Gui,Add,CheckBox,x180 y120 h20 checked%GlobalTogg% vGlobalTogg ,全局(&G)
Gui,Add,Text,x25 y150 h20,启用/禁用VIM热键(&A)
Gui,Add,Edit,x25 y170 h20 w140 vSusp ,%Susp%
Gui,Add,CheckBox,x180 y170 h20 checked%GlobalSusp% vGlobalSusp,全局(&L)
Gui,Add,GroupBox,x16 y210 H110 w290,其它设置
Gui,Add,Text,x25 y228 h20,搜索选中的文件名或文件夹(&Q)
D := 1
Loop,15
{
IniRead,SE,%ViATcINI%,SearchEngine,%A_Index%
If SE = ERROR
IniDelete,%ViATcINI%,SearchEngine,%A_Index%
Else
{
IniDelete,%ViATcINI%,SearchEngine,%A_Index%
If A_Index = %DefaultSE%
{
DefaultSE := D
IniWrite,%D%,%ViATcIni%,SearchEngine,Default
}
IniWrite,%SE%,%ViATcIni%,SearchEngine,%D%
SE_Arr .= SE . "|"
D++
}
}
D--
If DefaultSE > %D%
{
DefaultSE := D
IniWrite,%D%,%ViATcIni%,SearchEngine,Default
}
Gui,Add,ComboBox,x25 y246 h20 w226 choose%DefaultSE% AltSubmit vDefaultSE R5 hwndaa g<SetDefaultSE>,%SE_Arr%
Gui,Add,Button,x256 y246 h20 w22 g<AddSearchEng>,+
Gui,Add,Button,x280 y246 h20 w22 g<DelSearchEng>,-
Gui,Add,CheckBox,x25 y270 h20 checked%GroupWarn% vGroupWarn,组合键提示信息(&I)
Gui,Add,CheckBox,x25 y295 h20 checked%transpHelp% vTranspHelp ,帮助界面透明(&I)
Gui,Add,Button,x170 y280 h30 w120 Center g<Help>,打开VIATC帮助(&H)
Gui,Tab,2
Gui,Add,ListView,x16 y32 h170 w290 count20 sortdesc  -Multi vListView g<ListViewDK>,*|快捷键|动作|说明
Lv_modifycol(2,100)
Lv_modifycol(3,100)
Lv_modifycol(4,300)
lv := MapKey_Arr["Hotkeys"]
Stringsplit,Index,lv,%A_Space%
Index := Index0 - 1
Loop,%Index%
{
If Index%A_Index%
{
Scope := SubStr(Index%A_Index%,1,1)
Key := SubStr(Index%A_Index%,2)
Action := MapKey_Arr[Index%A_Index%]
Info := ActionInfo_Arr[Action]
If Action = <Exec>
{
Action := "运行"
Key_T := Scope . TransHotkey(Key)
Info := ExecFile_Arr[key_T]
}
If Action = <Text>
{
Action := "发送文本"
Key_T := Scope . TransHotkey(Key)
Info := SendText_Arr[key_T]
}
LV_Add(vis,Scope,Key,Action,Info)
}
}
Gui,Add,GroupBox,x16 y210 h110 w290
Gui,Add,Text,x22 y223 h20,快捷键(&K)
Gui,Add,Edit,x78 y220 h20 w100 g<CheckGorH>
Gui,Add,CheckBox,x183 y221 h20 ,全局(&G)
Gui,Add,Button,x250 y220 w50 g<TestTH>,分析
Gui,Add,text,x28 y249 h20,动作(&W)
Gui,Add,Edit,x78 y246 h20 w220
Gui,Add,Button,x21 y270 h20 w80 g<VimCMD> ,VIM命令(&V)
Gui,Add,Button,x110 y270 h20 w80 g<TCCMD> ,TC命令(&T)
Gui,Add,Button,x21 y294 h20 w80 g<RunFile> ,运行(&R)
Gui,Add,Button,x110 y294 h20 w80 g<SendString> ,字符串(&S)
Gui,Add,Button,x196 y274 h40 w50 g<CheckKey> ,保存(&L)
Gui,Add,Button,x250 y274 h40 w50 g<DeleItem> ,删除(&A)
Gui,Tab,3
Gui,Add,Text,x18 y35 h16 center,TC执行程序位置:
Gui,Add,Edit,x18 y55 h20 +ReadOnly w250,%TCEXE%
Gui,Add,Button,x275 y53 w30 g<GuiTCEXE>,...
Gui,Add,Text,x18 y80 h16 center,TC配置文件位置:
Gui,Add,Edit,x18 y100 h20 +ReadOnly w250,%TCINI%
Gui,Add,Button,x275 y98 w30 g<GuiTCINI> ,...
Gui,Add,Text,x18 y125 h16 center,ViATc配置文件位置:
Gui,Add,Edit,x18 y145 h20 +ReadOnly w250,%ViATcIni%
Gui,Add,Button,x275 y143 w30 g<GuiViATcINI> ,...
Gui,Tab
Gui,Add,Button,x280 y5 w30 h20 center hidden g<ChangeTab>,&U
Gui,Add,Button,x280 y5 w30 h20 center hidden g<ChangeTab>,&P
Gui,Add,Button,x280 y5 w30 h20 center hidden g<ChangeTab>,&M
GUi,Show,h370 w320,VIATC设置
}
GuiContextMenu:
If A_GuiControl <> ListView
Return
EventInfo := A_EventInfo
Menu,RightClick,Add
Menu,RightClick,DeleteAll
Menu,RightClick,Add,编辑(&E),<EditItem>
Menu,RightClick,Add,删除(&D),<DeleItem>
Menu,RightClick,Show
Return
GuiEscape:
Tooltip
Gui,Destroy
If NeedReload
GoSub,<ReloadVIATC>
Else
EmptyMem()
Return
<AddSearchEng>:
AddSearchEng()
Return
AddSearchEng()
{
Global ViATcSetting,ViATcIni
ControlgetText,SE,Edit3,AHK_ID %VIATCSetting%
Controlget,SEList,list,,combobox1,AHK_ID %VIATCSetting%
Stringsplit,List,SEList,`n
List0++
GuiControl,,combobox1,%SE%
IniWrite,%SE%,%VIATCINI%,SearchEngine,%List0%
}
<DelSearchEng>:
DelSearchEng()
Return
DelSearchEng()
{
Global ViATcSetting,ViATcIni,DefaultSE
Controlget,SEList,list,,combobox1,AHK_ID %VIATCSetting%
IniDelete,%ViATcIni%,SearchEngine,%DefaultSE%
Stringsplit,List,SEList,`n
Loop,%List0%
{
If A_Index = %DefaultSE%
Continue
NewSEList .= "|" . List%A_Index%
}
DefaultSE--
GuiControl,,combobox1,%NewSEList%
IniWrite,%DefaultSE%,%VIATCINI%,SearchEngine,Default
}
<SetDefaultSE>:
SetDefaultSE()
Return
SetDefaultSE()
{
Global ViATcSetting,DefaultSE,ViATcIni,SearchEng
GuiControlget,SE,,combobox1,AHK_ID %VIATCSetting%
If RegExMatch(SE,"^\d+$")
{
DefaultSE := SE
IniRead,SearchEng,%VIATCINI%,SearchEngine,%DefaultSE%
IniWrite,%SE%,%VIATCINI%,SearchEngine,Default
}
}
<GuiEnter>:
Gui,Submit
IniWrite,%TrayIcon%,%ViATcIni%,Configuration,TrayIcon
IniWrite,%Vim%,%ViATcIni%,Configuration,Vim
IniWrite,%Toggle%,%ViATcIni%,Configuration,Toggle
IniWrite,%Susp%,%ViATcIni%,Configuration,Suspend
IniWrite,%GlobalTogg%,%ViATcIni%,Configuration,GlobalTogg
IniWrite,%GlobalSusp%,%ViATcIni%,Configuration,GlobalSusp
IniWrite,%StartUp%,%ViATcIni%,Configuration,StartUp
IniWrite,%Service%,%ViATcIni%,Configuration,Service
IniWrite,%GroupWarn%,%ViATcIni%,Configuration,GroupWarn
IniWrite,%TranspHelp%,%ViATcIni%,Configuration,TranspHelp
If NeedReload
GoSub,<ReloadVIATC>
Else
GoSub,<ConfigVar>
Return
<GuiCancel>:
Gui,Destroy
EmptyMem()
Return
<ListViewDK>:
If RegExMatch(A_GuiEvent,"DoubleClick")
{
EventInfo := A_EventInfo
EditItem()
}
Tooltip
Return
<EditItem>:
EditItem()
Return
EditItem()
{
Global EventInfo,VIATCSetting
If EventInfo
{
LV_GetText(Scope,EventInfo,1)
LV_GetText(Key,EventInfo,2)
LV_GetText(Action,EventInfo,3)
LV_GetText(Info,EventInfo,4)
If RegExMatch(Scope,"S")
GuiControl,,Button18,1
If RegExMatch(Scope,"[G|H]")
GuiControl,,Button18,0
If Key
GuiControl,,Edit4,%Key%
If Action = 运行
Action := "(" . Info . ")"
If Action = 发送文本
Action := "{" . Info . "}"
If Action
GuiControl,,Edit5,%Action%
}
}
<DeleItem>:
DeleItem()
Return
DeleItem()
{
Global EventInfo,ViATcIni,MapKey_Arr,VIATCSetting
ControlGet,Line,List,Count Focused,SysListView321,AHK_ID %VIATCSetting%
EventInfo := Line
If EventInfo
{
LV_GetText(Get,EventInfo,1)
LV_GetText(GetText,EventInfo,2)
Lv_Delete(EventInfo)
Key := A_Space . Get . GetText . A_Space
RegExReplace(MapKey_Arr["Hotkeys"],Key)
MapKeyDelete(GetText,Get)
If Get = H
IniDelete,%ViATcIni%,Hotkey,%GetText%
If Get = S
IniDelete,%ViATcIni%,GlobalHotkey,%GetText%
If Get = G
IniDelete,%ViATcIni%,GroupKey,%GetText%
}
}
<VIMCMD>:
VimCMD()
Return
VimCMD()
{
Global VimAction,ActionInfo_Arr
Stringsplit,kk,VimAction,%A_Space%
Gui,New
Gui,+HwndVIMCMDHwnd
Gui,Add,ListView,w400 h400 -Multi g<GetVIMCMD>,序号|动作|说明
Lv_delete()
Lv_modifycol(1,40)
Lv_modifycol(2,110)
Lv_modifycol(3,420)
Loop,%kk0%
{
key := kk%A_Index%
Info := ActionInfo_Arr[key]
LV_ADD(vis,A_Index-1,key,info)
}
kk := kk%0% - 1
lv_delete(1)
Gui, Add, Button, x280 y420 w60 h24 Default g<VIMCMDB1>, &OK
Gui, Add, Button, x350 y420 w60 h24 g<Cancel>, &Cancel
Gui,Show,,VIATC默认动作
}
<VIMCMDB1>:
ControlGet,EventInfo,List, Count Focused,SysListView321,ahk_id %VIMCMDHwnd%
lv_gettext(actiontxt,EventInfo,2)
ControlSetText,edit5,%actiontxt%,AHK_ID %VIATCSetting%
Gui,Destroy
EmptyMem()
Winactivate,AHK_ID %VIATCSetting%
Return
<GetVIMCMD>:
lv_gettext(actiontxt,A_EventInfo,2)
ControlSetText,edit5,%actiontxt%,AHK_ID %VIATCSetting%
Gui,Destroy
EmptyMem()
Winactivate,AHK_ID %VIATCSetting%
Return
<TCCMD>:
tccmd()
Return
tccmd()
{
Global VIATCSetting,TCEXE
Ifwinexist,AHK_CLASS TTOTAL_CMD
Winactivate,AHK_CLASS TTOTAL_CMD
Else
{
Run,%TCEXE%
WinWait,AHK_CLASS TTOTAL_CMD,1
Winactivate,AHK_CLASS TTOTAL_CMD
}
Cli := ClipboardAll
Clipboard :=
Postmessage 1075, 2924, 0, , ahk_class TTOTAL_CMD
Clipwait,0.5
Loop
{
If Clipboard
Break
Else
Ifwinexist,ahk_class TCmdSelForm
Clipwait,0.5
Else
Break
}
If Clipboard
{
actiontxt := Clipboard
actiontxt := Regexreplace(actiontxt,"^cm_","<") . ">"
}
Else
actiontxt :=
Clipboard := cli
If actiontxt
GuiControl,text,edit5,%actiontxt%
Winactivate,AHK_ID %VIATCSetting%
}
<RunFile>:
SelectFile()
Return
SelectFile()
{
Global VIATCSetting
Fileselectfile,outvar,,,VIATC运行
If outvar
outvar := "(" . outvar . ")"
Winactivate,AHK_ID %VIATCSetting%
GuiControl,text,edit5,%outvar%
}
<SendString>:
GetSendString()
Return
GetSendString()
{
Global VIATCSetting,VIATCSettingString
Gui,New
Gui,+Owner%VIATCSetting%
Gui,Add,Edit,w500 h20
Gui,Add,Button,x390 y30 h20 g<GetSendStringEnter> Default,确定(&O)
Gui,Add,Button,x457 y30 h20 g<GetSendStringCancel>,取消(&C)
Gui,Show,,VIATC字符串
}
<GetSendStringEnter>:
GuiControlGet,txt4,,Edit1
if txt4
txt4 := "{" . txt4 . "}"
ControlSetText,edit5,%txt4%,AHK_ID %VIATCSetting%
GUi,Destroy
EmptyMem()
Return
<GetSendStringCancel>:
GUi,Destroy
EmptyMem()
Winactivate,AHK_ID %VIATCSetting%
Return
<GuiTCEXE>:
GuiTCEXE()
return
GuiTCExe()
{
Global TCEXE,VIATCSetting
Fileselectfile,TCEXE,3,TOTALCMD.EXE,选择TOTALCMD.EXE,*.exe
If ErrorLevel
Return
Regwrite,REG_SZ,HKEY_CURRENT_USER,Software\VIATC,InstallDir,%TCEXE%
GuiControl,text,Edit6,%TCEXE%
}
<GuiTCIni>:
GuiTCIni()
return
GuiTCIni()
{
Global TCINI,VIATCSetting
Fileselectfile,TCINI,3,,选择配置文件，默认为WINCMD.INI,*.ini
If ErrorLevel
Return
Regwrite,REG_SZ,HKEY_CURRENT_USER,Software\VIATC,IniFileName,%TCINI%
GuiControl,text,Edit7,%TCINI%
}
<GuiViATcIni>:
GuiViATcIni()
return
GuiViATcIni()
{
Global ViATcIni,VIATCSetting
Splitpath,ViATcINI,,ViATcINIDir
Fileselectfolder,NewDir,,3,ViATc.ini 另存为
If ErrorLevel
Return
If Not Fileexist(NewDir)
FileCreateDir,%NewDir%
FileMove,%ViATcINI%,%NewDir%\viatc.ini
ViATcINI := NewDir . "\ViATc.ini"
Regwrite,REG_SZ,HKEY_CURRENT_USER,Software\VIATC,ViATcINI,%ViATcINI%
GuiControl,text,Edit8,%ViATcINI%
GoSub,<ReloadVIATC>
}
<CheckGorH>:
CheckGorH()
Tooltip
Return
CheckGorH()
{
Global ViATcSetting
GuiControlGet,Key,,Edit4,AHK_CLASS %ViATcSetting%
If Key
If RegExMatch(CheckScope(key),"G")
GuiControl,Disable,Button18
Else
GuiControl,Enable,Button18
Else
GuiControl,Enable,Button18
}
<CheckKey>:
CheckKey()
Return
CheckKey()
{
Global VIATCSetting,ViATcIni,MapKey_Arr,ExecFile_Arr,SendText_Arr,ActionInfo_Arr,NeedReload
GuiControlGet,Scope,,Button18,AHK_CLASS %ViATcSetting%
GuiControlGet,Key,,Edit4,AHK_CLASS %ViATcSetting%
GuiControlGet,Action,,Edit5,AHK_CLASS %ViATcSetting%
If Scope
Scope := "S"
Else
Scope := "H"
If RegExMatch(CheckScope(key),"G")
{
Scope := "G"
GuiControl,,Button18,0
}
If Action And Key
{
NeedReload := 1
If RegExMatch(Scope,"i)S")
{
If MapKeyAdd(Key,Action,Scope)
Iniwrite,%Action%,%ViatcIni%,GlobalHotkey,%Key%
Else
{
GuiControlGet,VarPos,Pos,Edit4
Tooltip,映射失败,%VarPosX%,%VarPosY%
Sleep,2000
Tooltip
Return
}
}
If RegExMatch(Scope,"i)H")
{
If MapKeyAdd(Key,Action,Scope)
Iniwrite,%Action%,%ViatcIni%,Hotkey,%Key%
Else
{
GuiControlGet,VarPos,Pos,Edit4
Tooltip,映射失败,%VarPosX%,%VarPosY%
Sleep,2000
Tooltip
Return
}
}
If RegExMatch(Scope,"i)G")
{
If MapKeyAdd(Key,Action,Scope)
Iniwrite,%Action%,%ViatcIni%,GroupKey,%Key%
Else
{
GuiControlGet,VarPos,Pos,Edit4
Tooltip,映射失败,%VarPosX%,%VarPosY%
Sleep,2000
Tooltip
Return
}
}
Loop,% LV_GetCount()
{
LV_GetText(GetScope,A_Index,1)
LV_GetText(GetKey,A_Index,2)
LV_GetText(GetAction,A_Index,3)
Scope_M := "i)" . Scope
Key_M := "i)" . RegExReplace(Key,"\+|\?|\.|\*|\{|\}|\(|\)|\||\^|\$|\[|\]|\\","\$0")
Action_M := "i)" . RegExReplace(Action,"\+|\?|\.|\*|\{|\}|\(|\)|\||\^|\$|\[|\]|\\","\$0")
If RegExMatch(GetScope,Scope_M) AND RegExMatch(GetKey,Key_M) AND RegExMatch(GetAction,Action_M)
Return
If RegExMatch(GetScope,Scope_M) AND RegExMatch(GetKey,Key_M) AND Not RegExMatch(GetAction,Action_M)
{
Info := ActionInfo_Arr[Action]
If RegExMatch(Action,"^\(.*\)$")
{
Action := "运行"
Key_T := Scope . TransHotkey(Key)
Info := ExecFile_Arr[key_T]
}
If RegExMatch(Action,"^\{.*\}$")
{
Action := "发送文本"
Key_T := Scope . TransHotkey(Key)
Info := SendText_Arr[key_T]
}
Lv_Modify(A_Index,vis,Scope,Key,Action,Info)
Return
}
}
Info := ActionInfo_Arr[Action]
If RegExMatch(Action,"^\(.*\)$")
{
Action := "运行"
Key_T := Scope . TransHotkey(Key)
Info := ExecFile_Arr[key_T]
}
If RegExMatch(Action,"^\{.*\}$")
{
Action := "发送文本"
Key_T := Scope . TransHotkey(Key)
Info := SendText_Arr[key_T]
}
LV_Add(vis,Scope,Key,Action,Info)
}
Else
{
GuiControlGet,VarPos,Pos,Edit4
Tooltip,快捷键或动作为空,%VarPosX%,%VarPosY%
Sleep,2000
Tooltip
}
}
<ChangeTab>:
ChangeTab()
Return
ChangeTab()
{
If RegExMatch(A_GuiControl,"U")
GuiControl,choose,SysTabControl321,1
If RegExMatch(A_GuiControl,"P")
GuiControl,choose,SysTabControl321,2
If RegExMatch(A_GuiControl,"M")
GuiControl,choose,SysTabControl321,3
}
<TestTH>:
TH()
Return
TH()
{
GuiControlGet,Scope,,Button18,AHK_CLASS %ViATcSetting%
GuiControlGet,Key,,Edit4,AHK_CLASS %ViATcSetting%
if key
{
If Scope
KeyType := "全局键"
Else
KeyType := "快捷键"
If RegExMatch(CheckScope(key),"G")
KeyType := "组合键"
Msg :=  KeyType . "`n"
Key1 := TransHotkey(Key,"First")
Msg .= "第1个键:" . Key1 . "`n"
Key2 := TransHotkey(Key,"ALL")
KeyT := SubStr(Key2,Strlen(key1)+1)
Stringsplit,T,KeyT
N := 2
Loop,%T0%
{
Msg .= "第" . N . "个键:" . T%A_index% . "`n"
N++
}
GuiControlGet,VarPos,Pos,Edit4
VarPosY := VarPosY - VarPosH - ( T0 * 17)
Tooltip,%Msg%,%VarPosX%,%VarPosY%
Settimer,<RemoveTTEx>,5000
}
else
{
Msg := "请在快捷键栏输入需要分析的快捷键"
GuiControlGet,VarPos,Pos,Edit4
VarPosY := VarPosY - VarPosH + 17
Tooltip,%Msg%,%VarPosX%,%VarPosY%
Settimer,<RemoveTTEx>,1500
}
}
return
<RemoveTTEx>:
SetTimer,<RemoveTTEx>, Off
ToolTip
return
<RemoveTT>:
Ifwinnotactive,AHK_ID %ViATcSetting%
{
SetTimer,<RemoveTT>, Off
ToolTip
}
return
Help()
{
Global TranspHelp,HelpInfo_Arr
Gui,New
Gui,+HwndVIATCHELP
Gui,Font,s8,Arial Bold
Gui,Add,Text,x12 y10 w30 h18 center Border g<ShowHelp>,Esc
Gui,Add,Text,x52 y10 w26 h18 center Border g<ShowHelp>,F1
Gui,Add,Text,x80 y10 w26 h18 center Border g<ShowHelp>,F2
Gui,Add,Text,x108 y10 w26 h18 center Border g<ShowHelp>,F3
Gui,Add,Text,x136 y10 w26 h18 center Border g<ShowHelp>,F4
Gui,Add,Text,x164 y10 w26 h18 center Border g<ShowHelp>,F5
Gui,Add,Text,x192 y10 w26 h18 center Border g<ShowHelp>,F6
Gui,Add,Text,x220 y10 w26 h18 center Border g<ShowHelp>,F7
Gui,Add,Text,x248 y10 w26 h18 center Border g<ShowHelp>,F8
Gui,Add,Text,x276 y10 w26 h18 center Border g<ShowHelp>,F9
Gui,Add,Text,x304 y10 w26 h18 center Border g<ShowHelp>,F10
Gui,Add,Text,x332 y10 w26 h18 center Border g<ShowHelp>,F11
Gui,Add,Text,x360 y10 w26 h18 center Border g<ShowHelp>,F12
Gui,Add,Text,x12 y35 w22 h18 center Border g<ShowHelp>,``~
Gui,Add,Text,x36 y35 w22 h18 center Border g<ShowHelp>,1!
Gui,Add,Text,x60 y35 w22 h18 center Border g<ShowHelp>,2@
Gui,Add,Text,x84 y35 w22 h18 center Border g<ShowHelp>,3#
Gui,Add,Text,x108 y35 w22 h18 center Border g<ShowHelp>,4$
Gui,Add,Text,x132 y35 w22 h18 center Border g<ShowHelp>,5`%
Gui,Add,Text,x156 y35 w22 h18 center Border g<ShowHelp>,6^
Gui,Add,Text,x180 y35 w22 h18 center Border g<ShowHelp>,7&
Gui,Add,Text,x204 y35 w22 h18 center Border g<ShowHelp>,8*
Gui,Add,Text,x228 y35 w22 h18 center Border g<ShowHelp>,9(
Gui,Add,Text,x252 y35 w22 h18 center Border g<ShowHelp>,0)
Gui,Add,Text,x276 y35 w22 h18 center Border g<ShowHelp>,-_
Gui,Add,Text,x300 y35 w22 h18 center Border g<ShowHelp>,=+
Gui,Add,Text,x324 y35 w62 h18 center Border g<ShowHelp>,Backspace
Gui,Add,Text,x12 y55 w40 h18 center Border g<ShowHelp>,Tab
Gui,Add,Text,x54 y55 w22 h18 center Border g<ShowHelp>,Q
Gui,Add,Text,x78 y55 w22 h18 center Border g<ShowHelp>,W
Gui,Add,Text,x102 y55 w22 h18 center Border g<ShowHelp>,E
Gui,Add,Text,x126 y55 w22 h18 center Border g<ShowHelp>,R
Gui,Add,Text,x150 y55 w22 h18 center Border g<ShowHelp>,T
Gui,Add,Text,x174 y55 w22 h18 center Border g<ShowHelp>,Y
Gui,Add,Text,x198 y55 w22 h18 center Border g<ShowHelp>,U
Gui,Add,Text,x222 y55 w22 h18 center Border g<ShowHelp>,I
Gui,Add,Text,x246 y55 w22 h18 center Border g<ShowHelp>,O
Gui,Add,Text,x270 y55 w22 h18 center Border g<ShowHelp>,P
Gui,Add,Text,x294 y55 w22 h18 center Border g<ShowHelp>,[{
Gui,Add,Text,x318 y55 w22 h18 center Border g<ShowHelp>,]}
Gui,Add,Text,x342 y55 w44 h18 center Border g<ShowHelp>,\|
Gui,Add,Text,x12 y75 w60 h18 center Border g<ShowHelp>,CapsLock
Gui,Add,Text,x74 y75 w22 h18 center Border g<ShowHelp>,A
Gui,Add,Text,x98 y75 w22 h18 center Border g<ShowHelp>,S
Gui,Add,Text,x122 y75 w22 h18 center Border g<ShowHelp>,D
Gui,Add,Text,x146 y75 w22 h18 center Border g<ShowHelp>,F
Gui,Add,Text,x170 y75 w22 h18 center Border g<ShowHelp>,G
Gui,Add,Text,x194 y75 w22 h18 center Border g<ShowHelp>,H
Gui,Add,Text,x218 y75 w22 h18 center Border g<ShowHelp>,J
Gui,Add,Text,x242 y75 w22 h18 center Border g<ShowHelp>,K
Gui,Add,Text,x266 y75 w22 h18 center Border g<ShowHelp>,L
Gui,Add,Text,x290 y75 w22 h18 center Border g<ShowHelp>,`;:
Gui,Add,Text,x314 y75 w22 h18 center Border g<ShowHelp>,'`"
Gui,Add,Text,x338 y75 w48 h18 center Border g<ShowHelp>,Enter
Gui,Add,Text,x12 y95 w70 h18 center Border g<ShowHelp>,LShift
Gui,Add,Text,x84 y95 w22 h18 center Border g<ShowHelp>,Z
Gui,Add,Text,x108 y95 w22 h18 center Border g<ShowHelp>,X
Gui,Add,Text,x132 y95 w22 h18 center Border g<ShowHelp>,C
Gui,Add,Text,x156 y95 w22 h18 center Border g<ShowHelp>,V
Gui,Add,Text,x180 y95 w22 h18 center Border g<ShowHelp>,B
Gui,Add,Text,x204 y95 w22 h18 center Border g<ShowHelp>,N
Gui,Add,Text,x228 y95 w22 h18 center Border g<ShowHelp>,M
Gui,Add,Text,x252 y95 w22 h18 center Border g<ShowHelp>,`,<
Gui,Add,Text,x276 y95 w22 h18 center Border g<ShowHelp>,.>
Gui,Add,Text,x300 y95 w22 h18 center Border g<ShowHelp>,/?
Gui,Add,Text,x324 y95 w62 h18 center Border g<ShowHelp>,RShift
Gui,Add,Text,x12 y115 w40 h18 center Border g<ShowHelp>,LCtrl
Gui,Add,Text,x54 y115 w40 h18 center Border g<ShowHelp>,LWin
Gui,Add,Text,x96 y115 w40 h18 center Border g<ShowHelp>,LAlt
Gui,Add,Text,x138 y115 w122 h18 center Border g<ShowHelp>,Space
Gui,Add,Text,x262 y115 w40 h18 center Border g<ShowHelp>,RAlt
Gui,Add,Text,x304 y115 w40 h18 center Border g<ShowHelp>,Apps
Gui,Add,Text,x346 y115 w40 h18 center Border g<ShowHelp>,RCtrl
Gui,Add,Groupbox,x12 y135 w374 h40
Gui,Add,Button,x20 y146 w58 gIntro,介绍(&I)
Gui,Add,Button,x80 y146 w58 gFunck,功能键(&K)
Gui,Add,Button,x140 y146 w58 gGroupk,组合键(&G)
Gui,Add,Button,x200 y146 w58 gCmdl,命令行(&C)
Gui,Add,Button,x260 y146 w58 gAction,动作(&J)
Gui,Add,Button,x320 y146 w58 gAbout,关于(&A)
Intro := HelpInfo_Arr["Intro"]
Gui,Add,Edit,x12 y180 w374 h200 +ReadOnly,%Intro%
Gui,Show,w400 h400,VIATC 帮助
If TranspHelp
WinSet,Transparent,220,ahk_id %VIATCHELP%
Return
}
Intro:
var := HelpInfo_Arr["Intro"]
GuiControl,Text,Edit1,%var%
Return
funck:
var := HelpInfo_Arr["funck"]
GuiControl,Text,Edit1,%var%
Return
Groupk:
var := HelpInfo_Arr["Groupk"]
GuiControl,Text,Edit1,%var%
Return
cmdl:
var := HelpInfo_Arr["cmdl"]
GuiControl,Text,Edit1,%var%
Return
action:
var := HelpInfo_Arr["action"]
GuiControl,Text,Edit1,%var%
Return
about:
var := HelpInfo_Arr["about"]
GuiControl,Text,Edit1,%var%
Return
<ShowHelp>:
ShowHelp(A_GuiControl)
Return
ShowHelp(control)
{
Global HelpInfo_Arr
Var := HelpInfo_Arr[Control]
GuiControl,Text,Edit1,%var%
}
SetHelpInfo()
{
Global HelpInfo_arr
HelpInfo_arr["Esc"] :="Esc >>复位所有状态"
HelpInfo_arr["F1"] :="F1 >>无映射`n打开TC帮助"
HelpInfo_arr["F2"] :="F2 >>无映射`n刷新来源窗口"
HelpInfo_arr["F3"] :="F3 >>无映射`n查看文件"
HelpInfo_arr["F4"] :="F4 >>无映射`n编辑文件"
HelpInfo_arr["F5"] :="F5 >>无映射`n复制文件"
HelpInfo_arr["F6"] :="F6 >>无映射`n重命名或移动文件"
HelpInfo_arr["F7"] :="F7 >>无映射`n新建文件夹"
HelpInfo_arr["F8"] :="F8 >>无映射`n删除文件（到回收站或直接删除－由配置决定）"
HelpInfo_arr["F9"] :="F9 >>无映射`n激活源窗口的菜单 (左或右)"
HelpInfo_arr["F10"] :="F10 >>无映射`n激活左侧菜单或退出菜单"
HelpInfo_arr["F11"] :="F11 >>无映射"
HelpInfo_arr["F12"] :="F12 >>无映射"
HelpInfo_arr["``~"] :="`` >>无映射`n~ >>无映射"
HelpInfo_arr["1!"] :="1 >>数字1，用于计数`n! >>无映射"
HelpInfo_arr["2@"] :="2 >>数字2，用于计数`n@ >>无映射"
HelpInfo_arr["3#"] :="3 >>数字3，用于计数`n# >>无映射"
HelpInfo_arr["4$"] :="4 >>数字4，用于计数`n$ >>无映射"
HelpInfo_arr["5%"] :="5 >>数字5，用于计数`n% >>无映射"
HelpInfo_arr["6^"] :="6 >>数字6，用于计数`n^ >>无映射"
HelpInfo_arr["7&"] :="7 >>数字7，用于计数`n& >>无映射"
HelpInfo_arr["8*"] :="8 >>数字8，用于计数`n* >>无映射"
HelpInfo_arr["9("] :="9 >>数字9，用于计数`n( >>无映射"
HelpInfo_arr["0)"] :="0 >>数字0，用于计数`n) >>无映射"
HelpInfo_arr["-_"] :="- >>切换独立文件夹树面板状态`n_ >>无映射"
HelpInfo_arr["=+"] :="= >>目标 = 来源`n+ >>无映射"
HelpInfo_arr["Backspace"] :="Backspace >>无映射`n返回上一层文件夹或者在编辑状态下删除文字"
HelpInfo_arr["Tab"] :="Tab >>无映射`n切换窗口"
HelpInfo_arr["Q"] :="q >>快速查看功能`nQ >>使用默认浏览器搜索当前文件名/文件夹名"
HelpInfo_arr["W"] :="w >>编辑文件备注`nW >>无映射"
HelpInfo_arr["E"] :="e >>显示右键快捷菜单`nE >>在当前目录运行CMD.EXE"
HelpInfo_arr["R"] :="r >>重命名文件`nR >>批量重命名文件"
HelpInfo_arr["T"] :="t >>新建标签`nT >>在后台新建标签"
HelpInfo_arr["Y"] :="y >>复制文件名`nY >>复制文件名及完整路径"
HelpInfo_arr["U"] :="u >>返回一层目录`nU >>返回根目录"
HelpInfo_arr["I"] :="i >>插入新的文件夹`nI >>无映射"
HelpInfo_arr["O"] :="o >>打开左侧驱动器列表`nO >>打开右侧驱动器列表"
HelpInfo_arr["P"] :="p >>压缩文件/文件夹`nP >>解压缩"
HelpInfo_arr["[{"] :="[ >>选择文件名相同的文件`n{ >>不选择文件名相同的文件"
HelpInfo_arr["]}"] :="] >>选择扩展名相同的文件`n} >>不选择扩展名相同的文件"
HelpInfo_arr["\|"] :="\ >>反选所有文件及文件夹 `n| >>取消所有选择"
HelpInfo_arr["CapsLock"] :="CapsLock 无映射"
HelpInfo_arr["A"] :="a >>更改属性`n A >>无映射"
HelpInfo_arr["S"] :="s >>排序类热键`nS >>无映射`nsn >>来源窗口: 按文件名排序`nse >>来源窗口: 按扩展名排序`nss >>来源窗口: 按大小排序`nst >>来源窗口: 按日期时间排序`nsr >>来源窗口: 反向排序`ns1 >>来源窗口: 按第 1 列排序`ns2 >>来源窗口: 按第2 列排序`ns3 >>来源窗口: 按第 3 列排序`ns4 >>来源窗口: 按第 4 列排序`ns5 >>来源窗口: 按第 5 列排序`ns6 >>来源窗口: 按第 6 列排序`ns7 >>来源窗口: 按第 7 列排序`ns8 >>来源窗口: 按第 8 列排序`ns9 >>来源窗口: 按第 9 列排序 >>"
HelpInfo_arr["D"] :="d >>常用文件夹`nD >>打开桌面文件夹"
HelpInfo_arr["F"] :="f >>向下翻页，相当于PageDown`nF >>切换到TC默认快速搜索模式"
HelpInfo_arr["G"] :="g >>标签类组合键`nG >>焦点移动到文件列表未尾`ngg >>转到文件列表首行`ngn >>下一个标签(Ctrl+Tab)`ngp >>上一个标签(Ctrl+Shift+Tab)`nga >>关闭所有标签`ngc >>关闭当前标签`ngt >>新建标签(并打开光标处的文件夹)`ngb >>新建标签(在另一窗口打开文件夹)`nge >>交换左右窗口`ngw >>交换左右窗口及其标签`ngg >>转到文件列表首行`ng1 >>来源窗口: 激活标签 1`ng2 >>来源窗口: 激活标签 2`ng3 >>来源窗口: 激活标签 3`ng4 >>来源窗口: 激活标签 4`ng5 >>来源窗口: 激活标签 5`ng6 >>来源窗口: 激活标签 6`ng7 >>来源窗口: 激活标签 7`ng8 >>来源窗口: 激活标签 8`ng9 >>来源窗口: 激活标签 9`ng0 >>转到最后一个标签"
HelpInfo_arr["H"] :="h >>向左移动Num次`nH >>后退"
HelpInfo_arr["J"] :="j >>向下移动Num次`nJ >>向下选择Num个文件（夹）"
HelpInfo_arr["K"] :="k >>向上移动Num次`nK >>向上选择Num个文件（夹）"
HelpInfo_arr["L"] :="l >>向右移动Num次`nL >>前进"
HelpInfo_arr["`;:"] :="; >>焦点位于命令行`n: >>进行VIATC命令行模式(带:)"
HelpInfo_arr["'"""] :="' >>显示所有标记（标记由m键的标记功能产生）与VIM相似`n"" >>无映射"
HelpInfo_arr["Enter"] :="Enter >>回车"
HelpInfo_arr["LShift"] :="Lshift >>左shift键，也可以由Shift代替"
HelpInfo_arr["Z"] :="z >>工具类组合键`nZ >>无映射`nzz >>窗口分隔栏位于 50%`nzx >>窗口分隔栏位于 100%`nzi >>最大化左面板`nzo >>最大化右面板`nzt >>TC窗口保持最前`nzn >>最小化 Total Commander`nzm >>最大化 Total Commander`nzr >>恢复正常大小`nzv >>纵向/横向排列`nzs >>TC透明`nzf >>最简TC`nzq >>退出TC`nza >>重启TC"
HelpInfo_arr["X"] :="x >>删除文件(夹)`nX >>强制删除文件(夹)"
HelpInfo_arr["C"] :="c >>清除类组合键`nC >>无映射`ncl >>删除左侧文件夹历史`ncr >>删除右侧文件夹历史`ncc >>删除命令行历史"
HelpInfo_arr["V"] :="v >>显示视图菜单(带a-z导航)`nV >>显示类组合键<Shift>vb >>显示/隐藏: 工具栏`n<Shift>vd >>显示/隐藏: 驱动器按钮`n<Shift>vo >>显示/隐藏: 两个驱动器按钮栏`n<Shift>vr >>显示/隐藏: 驱动器列表`n<Shift>vc >>显示/隐藏: 当前文件夹`n<Shift>vt >>显示/隐藏: 排序制表符`n<Shift>vs >>显示/隐藏: 状态栏`n<Shift>vn >>显示/隐藏: 命令行`n<Shift>vf >>显示/隐藏: 功能键按钮`n<Shift>vw >>显示/隐藏: 文件夹标签`n<Shift>ve >>浏览内部命令"
HelpInfo_arr["B"] :="b >>向上翻页，相当于PageUp`nB >>打开标签浏览窗口"
HelpInfo_arr["N"] :="n >>显示文件夹历史(带a-z导航)`nN >>无映射"
HelpInfo_arr["M"] :="m >>标记功能，标记当前文件夹`nM >>移动到列表中间`n标记功能，类似于VIM中的m键。当按下m后，命令行会提示m，进入标记状态，再输入任意字符，可保存当前文件夹路径到标记。例如在正常状态下输入ma后，再按下'调出所有标记，此时按再a，可以转到相应标记的文件夹"
HelpInfo_arr[",<"] :=", >>显示命令历史(带a-z导航)`n< >>无映射"
HelpInfo_arr[".>"] :=". >>重复上一次动作`n> >>无映射`n重复上一次的动作，例如当你输入10j向下移动10行，又想再向下移动10行，无需再按10j只需要按一下.即可。按下gn移动到下一个标签，再次移动的话，也只需要按下."
HelpInfo_arr["/?"] :="/ >>使用快速搜索`n? >>使用搜索文件功能(完全)"
HelpInfo_arr["RShift"] :="Rshift >>右shift键，也可以由Shift代替"
HelpInfo_arr["LCtrl"] :="Lctrl >>左ctrl键，也可以由control或ctrl代替"
HelpInfo_arr["LWin"] :="LWin >>Win键 由于ahk的限制，win键必须由lwin来代替"
HelpInfo_arr["LAlt"] :="LAlt >>左Alt键，也可以由alt代替"
HelpInfo_arr["Space"] :="Space >>空格，无映射"
HelpInfo_arr["RAlt"] :="RAlt >>右Alt键，也可以由alt代替"
HelpInfo_arr["Apps"] :="Apps >>打开上下文菜单（右键菜单）"
HelpInfo_arr["RCtrl"] :="Rctrl >>右ctrl键，也可以由control或ctrl代替"
HelpInfo_arr["Intro"] :="   将Vim快捷键体系与TC结合，让TC操作“快捷”起来。最多两次按键可以完成大部分用鼠标需要完成的任务`n     如果你曾经使用过Vim，又正在使用TC，那么你会喜欢ViATc`n     如果你在使用TC，但又觉得鼠标的点击不足以更快速地操作，那么你会想用ViATc`n     把复杂的操作，用两只手在键盘上敲击出来。是编写ViATc的初衷。`nViATc做到了:`n     让TC带有Vim的模式，h,j,k,l移动和更多；按下：到命令行模式`n      不需要使用时，Alt+~(可修改）禁用所有VIATC按键功能，或者干脆退出ViATc，对TC完全无影响。 `n     任意一个快捷键都不与TC自带的快捷键冲突，绿色。`n     常驻为任务栏图标，双击任务栏图标，或者Win+E调用TC`n     多次移动、组合键、透明TC、顶置TC、还有更多……`n`n等待您的建议，一起让ViATc变得更加好用。"
HelpInfo_arr["Funck"] :="功能键>>单次按键即可实现操作`n      功能键按文字类型分，可分为数字Num0-Num9，字符a-z各种字符等。默认情况下，输入数字时不会引起任务操作，只会记录数字的大小，然后通过按下允许多次操作的键来实现重复操作，例如按下10j，实现的是向下移动10行,按下10K，则是向上选择10行，由于文件管理器的特殊，所以只有在列表中移动(hjkl/JK)才可以使用多次操作。`n重要！  在VIATC中表达功能键（单次按键）可以带control,alt,win,shift四种修饰符和字符组成，但是每个字符都只能跟一个修饰符`n<LWin>e (有效，必须使用LWin而不是Win)`n<ctrl><F12> (有效，此时第二个<>中的字符会被解释成普通字符)`n<ctrl><shift>a (无效，超过单个修饰符的要求)`n      关于每个按键能实现什么功能，请点击上面的键盘，获得每个按键的详细信息。"
HelpInfo_arr["GroupK"] :="组合键>>按两次或两次以上实现操作`n    与VIM相似，组合键可以非常灵活地映射某个功能，同时不局限于键盘的26个字母，与功能键不同，组合键可以由多个字符组成。但是有一点要注意，组合键的第一个按键只能带最多一个的修饰符(ctrl/lwin/shift/alt)，后面所有的按键都不可以带修饰符`n例如:`n<ctrl>ab (有效，按下ctrl+a后，再按b来实现某个功能)`n<ctrl>a<ctrl>b (无效，第一个按键可以最多一个的修饰符，第二个按键不能带)`nVIATC默认带了五组组合键，详细点击上面的键盘z,c,v,g,s"
HelpInfo_arr["cmdl"] :="命令行>>`nVIATC的命令行支持缩写:h :s :r :m :sm :e，分别是`n:help 显示帮助信息`n:Setting VIATC设置界面`n:reload 重新运行VIATC`n:map 显示或者映射热键`n如果在命令行中输入:map 会显示所有自定义热键。`n如果输入的是:map key action，其中key代表要映射的热键，可以是组合键，也可以是功能键。action代表的是要执行的动作。这个功能适合的情景是临时需要某个功能的映射，同时关闭VIATC后不会保存。如果要进行永久映射，则可以打开VIATC设置界面进行映射，或者直接编辑位于TC根目录下的配置文件VIATC.ini。`n:smap 与map一样，不过映射的是全局热键，而且不支持映射组合键`n:edit 直接编辑ViATc.ini文件"
HelpInfo_arr["action"] :="动作>>`n在VIATC中，所有的操作都可以理解为一个动作(action)，所有的动作可以在设置界面的热键映射界面里找到。动作分为四类：`n1、VIATC自带动作，由VIATC提供的一些TC增强功能，让你更加方便地操作TC。`n2、TC内部动作，也就是TC默认以cm_开头的内部命令，如cm_SrcComments等。`n3、运行某个程序或打开某个文件，这个比较方便常常需要结合TC运行的程序或需要编辑的文件，当然，TC内部也有类似的功能，等这个功能用多后，自然知道哪个比较好用:)。`n4、发送字符串，如果要经常在TC里输入某个文字，可以用组合键映射到发送字符串的动作，方便啊！！`n上述四种动作中，1和2必须是以<和>开头结尾的,3则是以(和)开头结尾的，4则是以{和}开头结尾的。`n举例`n:map <shift>a <TransParent> (映射shift a键为让TC透明的动作)`n:map ggg (E:\google\chrome.exe) (映射ggg组合键为运行chrome.exe程序`n:map abcd {cd E:\ {enter}} (映射abcd组合键为发送cd E:\ {enter}到TC的命令行中，其中{enter}还是被VIATC解释成按下回车键"
HelpInfo_arr["About"] :="有什么问题请联系我(linxinhong.sky@gmail.com)"
}
SetGroupInfo()
{
Global GroupInfo_arr
GroupInfo_arr["s"] :="sn >>来源窗口: 按文件名排序`nse >>来源窗口: 按扩展名排序`nss >>来源窗口: 按大小排序`nsd >>来源窗口: 按日期时间排序`nsr >>来源窗口: 反向排序`ns1 >>来源窗口: 按第 1 列排序`ns2 >>来源窗口: 按第2 列排序`ns3 >>来源窗口: 按第 3 列排序`ns4 >>来源窗口: 按第 4 列排序`ns5 >>来源窗口: 按第 5 列排序`ns6 >>来源窗口: 按第 6 列排序`ns7 >>来源窗口: 按第 7 列排序`ns8 >>来源窗口: 按第 8 列排序`ns9 >>来源窗口: 按第 9 列排序"
GroupInfo_arr["z"] :="zz >>窗口分隔栏位于 50%`nzx >>窗口分隔栏位于 100%(TC 8.0+)`nzi >>最大化左面板`nzo >>最大化右面板`nzt >>TC窗口保持最前`nzn >>最小化 Total Commander`nzm >>最大化 Total Commander`nzr >>恢复正常大小`nzv >>纵向/横向排列`nzs >>TC透明`nzf >>全屏TC`nzl >>最简TC`nzq >>退出TC`nza >>重启TC"
GroupInfo_arr["g"] :="gn >>下一个标签(Ctrl+Tab)`ngp >>上一个标签(Ctrl+Shift+Tab)`nga >>关闭所有标签`ngc >>关闭当前标签`ngt >>新建标签(并打开光标处的文件夹)`ngb >>新建标签(在另一窗口打开文件夹)`nge >>交换左右窗口`ngw >>交换左右窗口及其标签`ngg >>焦点转到文件列表首行`ng1 >>来源窗口: 激活标签 1`ng2 >>来源窗口: 激活标签 2`ng3 >>来源窗口: 激活标签 3`ng4 >>来源窗口: 激活标签 4`ng5 >>来源窗口: 激活标签 5`ng6 >>来源窗口: 激活标签 6`ng7 >>来源窗口: 激活标签 7`ng8 >>来源窗口: 激活标签 8`ng9 >>来源窗口: 激活标签 9`ng0 >>转到最后一个标签"
GroupInfo_arr["Shift & v"] :="<Shift>vb >>显示/隐藏: 工具栏`n<Shift>vd >>显示/隐藏: 驱动器按钮`n<Shift>vo >>显示/隐藏: 两个驱动器按钮栏`n<Shift>vr >>显示/隐藏: 驱动器列表`n<Shift>vc >>显示/隐藏: 当前文件夹`n<Shift>vt >>显示/隐藏: 排序制表符`n<Shift>vs >>显示/隐藏: 状态栏`n<Shift>vn >>显示/隐藏: 命令行`n<Shift>vf >>显示/隐藏: 功能键按钮`n<Shift>vw >>显示/隐藏: 文件夹标签`n<Shift>ve >>浏览内部命令"
GroupInfo_arr["c"] :="cl >>删除左侧文件夹历史`ncr >>删除右侧文件夹历史`ncc >>删除命令行历史"
}
SetVimAction()
{
Global VimAction
VimAction := " <help> <Setting> <ToggleTC> <EnableVIM> <QuitTC> <ReloadTC> <QuitVIATC> <ReloadVIATC> <Enter> <singleRepeat> <Esc> <Num0> <Num1> <Num2> <Num3> <Num4> <Num5> <Num6> <Num7> <Num8> <Num9> <Down> <up> <Left> <Right> <DownSelect> <PageUp> <PageDown> <Home> <Half> <End> <UpSelect> <ForceDel> <Mark> <ListMark> <Internetsearch> <azHistory> <ListMapKey> <WinMaxLeft> <WinMaxRight> <AlwayOnTop> <GoLastTab> <TransParent> <DeleteLHistory> <DeleteRHistory> <DelCmdHistory> <CreateNewFile> <TCLite> <TCFullScreen> <EditViATCIni> <azTab>"
}
SetActionInfo()
{
Global ActionInfo_arr
ActionInfo_Arr["<azTab>"] := "使用a-z来浏览标签(x64不可用)"
ActionInfo_Arr["<ReLoadVIATC>"] :="重启VIATC"
ActionInfo_Arr["<ReLoadTC>"] :="重启TC"
ActionInfo_Arr["<QuitTC>"] :="退出TC"
ActionInfo_Arr["<QuitViATc>"] :="退出ViATc"
ActionInfo_Arr["<None>"] :="无效果"
ActionInfo_Arr["<Setting>"] :="配置界面"
ActionInfo_Arr["<FocusCmdLine:>"] := "命令行模式 焦点置于命令行，并以:开头"
ActionInfo_Arr["<CreateNewFile>"] := "文件模板功能，创建新文件或新目录"
ActionInfo_Arr["<TCLite>"] := "最简TC"
ActionInfo_Arr["<ExReName>"] := "增强重命名，不选择扩展名"
ActionInfo_Arr["<Help>"] := "VIATC帮助"
ActionInfo_Arr["<Setting>"] := "VIATC设置"
ActionInfo_Arr["<ToggleTC>"] :="打开TC"
ActionInfo_Arr["<EnableVIM>"] :="启用/禁用VIM模式"
ActionInfo_Arr["<Enter>"] :="回车"
ActionInfo_Arr["<SingleRepeat>"] :="重复上次的动作"
ActionInfo_Arr["<Esc>"] :="复位并发送ESC"
ActionInfo_Arr["<EditViATCIni>"] :="直接编辑ViATc配置文件"
ActionInfo_Arr["<Num0>"] :="数字0"
ActionInfo_Arr["<Num1>"] :="数字1"
ActionInfo_Arr["<Num2>"] :="数字2"
ActionInfo_Arr["<Num3>"] :="数字3"
ActionInfo_Arr["<Num4>"] :="数字4"
ActionInfo_Arr["<Num5>"] :="数字5"
ActionInfo_Arr["<Num6>"] :="数字6"
ActionInfo_Arr["<Num7>"] :="数字7"
ActionInfo_Arr["<Num8>"] :="数字8"
ActionInfo_Arr["<Num9>"] :="数字9"
ActionInfo_Arr["<Down>"] :="下方向"
ActionInfo_Arr["<up>"] :="上方向"
ActionInfo_Arr["<Left>"] :="左方向"
ActionInfo_Arr["<Right>"] :="右方向"
ActionInfo_Arr["<DownSelect>"] :="向下选择"
ActionInfo_Arr["<UpSelect>"] :="向上选择"
ActionInfo_Arr["<Home>"] :="转到首行，相当于Home键"
ActionInfo_Arr["<Half>"] :="转到列表中间"
ActionInfo_Arr["<End>"] :="转到未行，相当于End键"
ActionInfo_Arr["<PageUp>"] :="向上翻页"
ActionInfo_Arr["<PageDown>"] :="向下翻页"
ActionInfo_Arr["<ForceDel>"] :="强制删除"
ActionInfo_Arr["<Mark>"] :="标记功能，标记当前文件夹，使用'可以打开相应的标记"
ActionInfo_Arr["<ListMark>"] :="显示所有标记（标记由m键的标记功能产生）与VIM相似"
ActionInfo_Arr["<Internetsearch>"] :="使用默认浏览器搜索当前文件"
ActionInfo_Arr["<azHistory>"] :="在文件夹历史加上前缀，方便用a-z导航"
ActionInfo_Arr["<azCmdHistory>"] :="查看命令历史记录"
ActionInfo_Arr["<ListMapKey>"] :="显示自定义映射键"
ActionInfo_Arr["<WinMaxLeft>"] :="最大化左面板"
ActionInfo_Arr["<WinMaxRight>"] :="最大化右面板"
ActionInfo_Arr["<AlwayOnTop>"] :="TC窗口保持最前"
ActionInfo_Arr["<TransParent>"] :="TC透明"
ActionInfo_Arr["<DeleteLHistory>"] :="删除左侧文件夹历史"
ActionInfo_Arr["<DeleteRHistory>"] :="删除右侧文件夹历史"
ActionInfo_Arr["<DelCmdHistory>"] :="删除命令行历史"
ActionInfo_Arr["<GoLastTab>"] :="转到最后一个标签"
ActionInfo_Arr["<TCLite>"] :="最简化TC"
ActionInfo_Arr["<TCFullScreen>"] :="TC全屏"
ActionInfo_Arr["<SrcComments>"] :="来源窗口: 显示文件备注"
ActionInfo_Arr["<SrcShort>"] :="来源窗口: 列表"
ActionInfo_Arr["<SrcLong>"] :="来源窗口: 详细信息"
ActionInfo_Arr["<SrcTree>"] :="来源窗口: 文件夹树"
ActionInfo_Arr["<SrcQuickview>"] :="来源窗口: 快速查看"
ActionInfo_Arr["<VerticalPanels>"] :="纵向/横向排列"
ActionInfo_Arr["<SrcQuickInternalOnly>"] :="来源窗口: 快速查看(不用插件)"
ActionInfo_Arr["<SrcHideQuickview>"] :="来源窗口: 关闭快速查看窗口"
ActionInfo_Arr["<SrcExecs>"] :="来源窗口: 可执行文件"
ActionInfo_Arr["<SrcAllFiles>"] :="来源窗口: 所有文件"
ActionInfo_Arr["<SrcUserSpec>"] :="来源窗口: 上次选中的文件"
ActionInfo_Arr["<SrcUserDef>"] :="来源窗口: 自定义类型"
ActionInfo_Arr["<SrcByName>"] :="来源窗口: 按文件名排序"
ActionInfo_Arr["<SrcByExt>"] :="来源窗口: 按扩展名排序"
ActionInfo_Arr["<SrcBySize>"] :="来源窗口: 按大小排序"
ActionInfo_Arr["<SrcByDateTime>"] :="来源窗口: 按日期时间排序"
ActionInfo_Arr["<SrcUnsorted>"] :="来源窗口: 不排序"
ActionInfo_Arr["<SrcNegOrder>"] :="来源窗口: 反向排序"
ActionInfo_Arr["<SrcOpenDrives>"] :="来源窗口: 打开驱动器列表"
ActionInfo_Arr["<SrcThumbs>"] :="来源窗口: 缩略图"
ActionInfo_Arr["<SrcCustomViewMenu>"] :="来源窗口: 自定义视图菜单"
ActionInfo_Arr["<SrcPathFocus>"] :="来源窗口: 焦点置于路径上"
ActionInfo_Arr["<LeftComments>"] :="左窗口: 显示文件备注"
ActionInfo_Arr["<LeftShort>"] :="左窗口: 列表"
ActionInfo_Arr["<LeftLong>"] :="左窗口: 详细信息"
ActionInfo_Arr["<LeftTree>"] :="左窗口: 文件夹树"
ActionInfo_Arr["<LeftQuickview>"] :="左窗口: 快速查看"
ActionInfo_Arr["<LeftQuickInternalOnly>"] :="左窗口: 快速查看(不用插件)"
ActionInfo_Arr["<LeftHideQuickview>"] :="左窗口: 关闭快速查看窗口"
ActionInfo_Arr["<LeftExecs>"] :="左窗口: 可执行文件"
ActionInfo_Arr["<LeftAllFiles>"] :="	左窗口: 所有文件"
ActionInfo_Arr["<LeftUserSpec>"] :="左窗口: 上次选中的文件"
ActionInfo_Arr["<LeftUserDef>"] :="左窗口: 自定义类型"
ActionInfo_Arr["<LeftByName>"] :="左窗口: 按文件名排序"
ActionInfo_Arr["<LeftByExt>"] :="左窗口: 按扩展名排序"
ActionInfo_Arr["<LeftBySize>"] :="左窗口: 按大小排序"
ActionInfo_Arr["<LeftByDateTime>"] :="左窗口: 按日期时间排序"
ActionInfo_Arr["<LeftUnsorted>"] :="左窗口: 不排序"
ActionInfo_Arr["<LeftNegOrder>"] :="左窗口: 反向排序"
ActionInfo_Arr["<LeftOpenDrives>"] :="左窗口: 打开驱动器列表"
ActionInfo_Arr["<LeftPathFocus>"] :="左窗口: 焦点置于路径上"
ActionInfo_Arr["<LeftDirBranch>"] :="左窗口: 展开所有文件夹"
ActionInfo_Arr["<LeftDirBranchSel>"] :="左窗口: 只展开选中的文件夹"
ActionInfo_Arr["<LeftThumbs>"] :="窗口: 缩略图"
ActionInfo_Arr["<LeftCustomViewMenu>"] :="窗口: 自定义视图菜单"
ActionInfo_Arr["<RightComments>"] :="右窗口: 显示文件备注"
ActionInfo_Arr["<RightShort>"] :="右窗口: 列表"
ActionInfo_Arr["<RightLong>"] :="详细信息"
ActionInfo_Arr["<RightTre>"] :="右窗口: 文件夹树"
ActionInfo_Arr["<RightQuickvie>"] :="右窗口: 快速查看"
ActionInfo_Arr["<RightQuickInternalOnl>"] :="右窗口: 快速查看(不用插件)"
ActionInfo_Arr["<RightHideQuickvie>"] :="右窗口: 关闭快速查看窗口"
ActionInfo_Arr["<RightExec>"] :="右窗口: 可执行文件"
ActionInfo_Arr["<RightAllFile>"] :="右窗口: 所有文件"
ActionInfo_Arr["<RightUserSpe>"] :="右窗口: 上次选中的文件"
ActionInfo_Arr["<RightUserDe>"] :="右窗口: 自定义类型"
ActionInfo_Arr["<RightByNam>"] :="右窗口: 按文件名排序"
ActionInfo_Arr["<RightByEx>"] :="右窗口: 按扩展名排序"
ActionInfo_Arr["<RightBySiz>"] :="右窗口: 按大小排序"
ActionInfo_Arr["<RightByDateTim>"] :="右窗口: 按日期时间排序"
ActionInfo_Arr["<RightUnsorte>"] :="右窗口: 不排序"
ActionInfo_Arr["<RightNegOrde>"] :="右窗口: 反向排序"
ActionInfo_Arr["<RightOpenDrive>"] :="右窗口: 打开驱动器列表"
ActionInfo_Arr["<RightPathFocu>"] :="右窗口: 焦点置于路径上"
ActionInfo_Arr["<RightDirBranch>"] :="右窗口: 展开所有文件夹"
ActionInfo_Arr["<RightDirBranchSel>"] :="右窗口: 只展开选中的文件夹"
ActionInfo_Arr["<RightThumb>"] :="右窗口: 缩略图"
ActionInfo_Arr["<RightCustomViewMen>"] :="右窗口: 自定义视图菜单"
ActionInfo_Arr["<List>"] :="查看(用查看程序)"
ActionInfo_Arr["<ListInternalOnly>"] :="查看(用查看程序, 但不用插件/多媒体)"
ActionInfo_Arr["<Edit>"] :="编辑"
ActionInfo_Arr["<Copy>"] :="复制"
ActionInfo_Arr["<CopySamepanel>"] :="复制到当前窗口"
ActionInfo_Arr["<CopyOtherpanel>"] :="复制到另一窗口"
ActionInfo_Arr["<RenMov>"] :="重命名/移动"
ActionInfo_Arr["<MkDir>"] :="新建文件夹"
ActionInfo_Arr["<Delete>"] :="删除"
ActionInfo_Arr["<TestArchive>"] :="测试压缩包"
ActionInfo_Arr["<PackFiles>"] :="压缩文件"
ActionInfo_Arr["<UnpackFiles>"] :="解压文件"
ActionInfo_Arr["<RenameOnly>"] :="重命名(Shift+F6)"
ActionInfo_Arr["<RenameSingleFile>"] :="重命名当前文件"
ActionInfo_Arr["<MoveOnly>"] :="移动(F6)"
ActionInfo_Arr["<Properties>"] :="显示属性"
ActionInfo_Arr["<CreateShortcut>"] :="创建快捷方式"
ActionInfo_Arr["<Return>"] :="模仿按 ENTER 键"
ActionInfo_Arr["<OpenAsUser>"] :="以其他用户身份运行光标处的程序"
ActionInfo_Arr["<Split>"] :="分割文件"
ActionInfo_Arr["<Combine>"] :="合并文件"
ActionInfo_Arr["<Encode>"] :="编码文件(MIME/UUE/XXE 格式)"
ActionInfo_Arr["<Decode>"] :="解码文件(MIME/UUE/XXE/BinHex 格式)"
ActionInfo_Arr["<CRCcreate>"] :="创建校验文件"
ActionInfo_Arr["<CRCcheck>"] :="验证校验和"
ActionInfo_Arr["<SetAttrib>"] :="更改属性"
ActionInfo_Arr["<Config>"] :="配置: 布局"
ActionInfo_Arr["<DisplayConfig>"] :="配置: 显示"
ActionInfo_Arr["<IconConfig>"] :="配置: 图标"
ActionInfo_Arr["<FontConfig>"] :="配置: 字体"
ActionInfo_Arr["<ColorConfig>"] :="配置: 颜色"
ActionInfo_Arr["<ConfTabChange>"] :="配置: 制表符"
ActionInfo_Arr["<DirTabsConfig>"] :="配置: 文件夹标签"
ActionInfo_Arr["<CustomColumnConfig>"] :="配置: 自定义列"
ActionInfo_Arr["<CustomColumnDlg>"] :="更改当前自定义列"
ActionInfo_Arr["<LanguageConfig>"] :="配置: 语言"
ActionInfo_Arr["<Config2>"] :="配置: 操作方式"
ActionInfo_Arr["<EditConfig>"] :="配置: 编辑/查看"
ActionInfo_Arr["<CopyConfig>"] :="配置: 复制/删除"
ActionInfo_Arr["<RefreshConfig>"] :="配置: 刷新"
ActionInfo_Arr["<QuickSearchConfig>"] :="配置: 快速搜索"
ActionInfo_Arr["<FtpConfig>"] :="配置: FTP"
ActionInfo_Arr["<PluginsConfig>"] :="配置: 插件"
ActionInfo_Arr["<ThumbnailsConfig>"] :="配置: 缩略图"
ActionInfo_Arr["<LogConfig>"] :="配置: 日志文件"
ActionInfo_Arr["<IgnoreConfig>"] :="配置: 隐藏文件"
ActionInfo_Arr["<PackerConfig>"] :="配置: 压缩程序"
ActionInfo_Arr["<ZipPackerConfig>"] :="配置: ZIP 压缩程序"
ActionInfo_Arr["<Confirmation>"] :="配置: 其他/确认"
ActionInfo_Arr["<ConfigSavePos>"] :="保存位置"
ActionInfo_Arr["<ButtonConfig>"] :="更改工具栏"
ActionInfo_Arr["<ConfigSaveSettings>"] :="保存设置"
ActionInfo_Arr["<ConfigChangeIniFiles>"] :="直接修改配置文件"
ActionInfo_Arr["<ConfigSaveDirHistory>"] :="保存文件夹历史记录"
ActionInfo_Arr["<ChangeStartMenu>"] :="更改开始菜单"
ActionInfo_Arr["<NetConnect>"] :="映射网络驱动器"
ActionInfo_Arr["<NetDisconnect>"] :="断开网络驱动器"
ActionInfo_Arr["<NetShareDir>"] :="共享当前文件夹"
ActionInfo_Arr["<NetUnshareDir>"] :="取消文件夹共享"
ActionInfo_Arr["<AdministerServer>"] :="显示系统共享文件夹"
ActionInfo_Arr["<ShowFileUser>"] :="显示本地文件的远程用户"
ActionInfo_Arr["<GetFileSpace>"] :="计算占用空间"
ActionInfo_Arr["<VolumeId>"] :="设置卷标"
ActionInfo_Arr["<VersionInfo>"] :="版本信息"
ActionInfo_Arr["<ExecuteDOS>"] :="打开命令提示符窗口"
ActionInfo_Arr["<CompareDirs>"] :="比较文件夹"
ActionInfo_Arr["<CompareDirsWithSubdirs>"] :="比较文件夹(同时标出另一窗口没有的子文件夹)"
ActionInfo_Arr["<ContextMenu>"] :="显示快捷菜单"
ActionInfo_Arr["<ContextMenuInternal>"] :="显示快捷菜单(内部关联)"
ActionInfo_Arr["<ContextMenuInternalCursor>"] :="显示光标处文件的内部关联快捷菜单"
ActionInfo_Arr["<ShowRemoteMenu>"] :="媒体中心遥控器播放/暂停键快捷菜单"
ActionInfo_Arr["<SyncChangeDir>"] :="两边窗口同步更改文件夹"
ActionInfo_Arr["<EditComment>"] :="编辑文件备注"
ActionInfo_Arr["<FocusLeft>"] :="焦点置于左窗口"
ActionInfo_Arr["<FocusRight>"] :="焦点置于右窗口"
ActionInfo_Arr["<FocusCmdLine>"] :="焦点置于命令行"
ActionInfo_Arr["<FocusButtonBar>"] :="焦点置于工具栏"
ActionInfo_Arr["<CountDirContent>"] :="计算所有文件夹占用的空间"
ActionInfo_Arr["<UnloadPlugins>"] :="卸载所有插件"
ActionInfo_Arr["<DirMatch>"] :="标出新文件, 隐藏相同者"
ActionInfo_Arr["<Exchange>"] :="交换左右窗口"
ActionInfo_Arr["<MatchSrc>"] :="目标 = 来源"
ActionInfo_Arr["<ReloadSelThumbs>"] :="刷新选中文件的缩略图"
ActionInfo_Arr["<DirectCableConnect>"] :="直接电缆连接"
ActionInfo_Arr["<NTinstallDriver>"] :="加载 NT 并口驱动程序"
ActionInfo_Arr["<NTremoveDriver>"] :="卸载 NT 并口驱动程序"
ActionInfo_Arr["<PrintDir>"] :="打印文件列表"
ActionInfo_Arr["<PrintDirSub>"] :="打印文件列表(含子文件夹)"
ActionInfo_Arr["<PrintFile>"] :="打印文件内容"
ActionInfo_Arr["<SpreadSelection>"] :="选择一组文件"
ActionInfo_Arr["<SelectBoth>"] :="选择一组: 文件和文件夹"
ActionInfo_Arr["<SelectFiles>"] :="选择一组: 仅文件"
ActionInfo_Arr["<SelectFolders>"] :="选择一组: 仅文件夹"
ActionInfo_Arr["<ShrinkSelection>"] :="不选一组文件"
ActionInfo_Arr["<ClearFiles>"] :="不选一组: 仅文件"
ActionInfo_Arr["<ClearFolders>"] :="不选一组: 仅文件夹"
ActionInfo_Arr["<ClearSelCfg>"] :="不选一组: 文件和/或文件夹(视配置而定)"
ActionInfo_Arr["<SelectAll>"] :="全部选择: 文件和/或文件夹(视配置而定)"
ActionInfo_Arr["<SelectAllBoth>"] :="全部选择: 文件和文件夹"
ActionInfo_Arr["<SelectAllFiles>"] :="全部选择: 仅文件"
ActionInfo_Arr["<SelectAllFolders>"] :="全部选择: 仅文件夹"
ActionInfo_Arr["<ClearAll>"] :="全部取消: 文件和文件夹"
ActionInfo_Arr["<ClearAllFiles>"] :="全部取消: 仅文件"
ActionInfo_Arr["<ClearAllFolders>"] :="全部取消: 仅文件夹"
ActionInfo_Arr["<ClearAllCfg>"] :="全部取消: 文件和/或文件夹(视配置而定)"
ActionInfo_Arr["<ExchangeSelection>"] :="反向选择"
ActionInfo_Arr["<ExchangeSelBoth>"] :="反向选择: 文件和文件夹"
ActionInfo_Arr["<ExchangeSelFiles>"] :="反向选择: 仅文件"
ActionInfo_Arr["<ExchangeSelFolders>"] :="反向选择: 仅文件夹"
ActionInfo_Arr["<SelectCurrentExtension>"] :="选择扩展名相同的文件"
ActionInfo_Arr["<UnselectCurrentExtension>"] :="不选扩展名相同的文件"
ActionInfo_Arr["<SelectCurrentName>"] :="选择文件名相同的文件"
ActionInfo_Arr["<UnselectCurrentName>"] :="不选文件名相同的文件"
ActionInfo_Arr["<SelectCurrentNameExt>"] :="选择文件名和扩展名相同的文件"
ActionInfo_Arr["<UnselectCurrentNameExt>"] :="不选文件名和扩展名相同的文件"
ActionInfo_Arr["<SelectCurrentPath>"] :="选择同一路径下的文件(展开文件夹+搜索文件)"
ActionInfo_Arr["<UnselectCurrentPath>"] :="不选同一路径下的文件(展开文件夹+搜索文件)"
ActionInfo_Arr["<RestoreSelection>"] :="恢复选择列表"
ActionInfo_Arr["<SaveSelection>"] :="保存选择列表"
ActionInfo_Arr["<SaveSelectionToFile>"] :="导出选择列表"
ActionInfo_Arr["<SaveSelectionToFileA>"] :="导出选择列表(ANSI)"
ActionInfo_Arr["<SaveSelectionToFileW>"] :="导出选择列表(Unicode)"
ActionInfo_Arr["<SaveDetailsToFile>"] :="导出详细信息"
ActionInfo_Arr["<SaveDetailsToFileA>"] :="导出详细信息(ANSI)"
ActionInfo_Arr["<SaveDetailsToFileW>"] :="导出详细信息(Unicode)"
ActionInfo_Arr["<LoadSelectionFromFile>"] :="导入选择列表(从文件)"
ActionInfo_Arr["<LoadSelectionFromClip>"] :="导入选择列表(从剪贴板)"
ActionInfo_Arr["<EditPermissionInfo>"] :="设置权限(NTFS)"
ActionInfo_Arr["<EditAuditInfo>"] :="审核文件(NTFS)"
ActionInfo_Arr["<EditOwnerInfo>"] :="获取所有权(NTFS)"
ActionInfo_Arr["<CutToClipboard>"] :="剪切选中的文件到剪贴板"
ActionInfo_Arr["<CopyToClipboard>"] :="复制选中的文件到剪贴板"
ActionInfo_Arr["<PasteFromClipboard>"] :="从剪贴板粘贴到当前文件夹"
ActionInfo_Arr["<CopyNamesToClip>"] :="复制文件名"
ActionInfo_Arr["<CopyFullNamesToClip>"] :="复制文件名及完整路径"
ActionInfo_Arr["<CopyNetNamesToClip>"] :="复制文件名及网络路径"
ActionInfo_Arr["<CopySrcPathToClip>"] :="复制来源路径"
ActionInfo_Arr["<CopyTrgPathToClip>"] :="复制目标路径"
ActionInfo_Arr["<CopyFileDetailsToClip>"] :="复制文件详细信息"
ActionInfo_Arr["<CopyFpFileDetailsToClip>"] :="复制文件详细信息及完整路径"
ActionInfo_Arr["<CopyNetFileDetailsToClip>"] :="复制文件详细信息及网络路径"
ActionInfo_Arr["<FtpConnect>"] :="FTP 连接"
ActionInfo_Arr["<FtpNew>"] :="新建 FTP 连接"
ActionInfo_Arr["<FtpDisconnect>"] :="断开 FTP 连接"
ActionInfo_Arr["<FtpHiddenFiles>"] :="显示隐藏文件"
ActionInfo_Arr["<FtpAbort>"] :="中止当前 FTP 命令"
ActionInfo_Arr["<FtpResumeDownload>"] :="续传"
ActionInfo_Arr["<FtpSelectTransferMode>"] :="选择传输模式"
ActionInfo_Arr["<FtpAddToList>"] :="添加到下载列表"
ActionInfo_Arr["<FtpDownloadList>"] :="按列表下载"
ActionInfo_Arr["<GotoPreviousDir>"] :="后退"
ActionInfo_Arr["<GotoNextDir>"] :="前进"
ActionInfo_Arr["<DirectoryHistory>"] :="文件夹历史记录"
ActionInfo_Arr["<GotoPreviousLocalDir>"] :="后退(非 FTP)"
ActionInfo_Arr["<GotoNextLocalDir>"] :="前进(非 FTP)"
ActionInfo_Arr["<DirectoryHotlist>"] :="常用文件夹"
ActionInfo_Arr["<GoToRoot>"] :="转到根文件夹"
ActionInfo_Arr["<GoToParent>"] :="转到上层文件夹"
ActionInfo_Arr["<GoToDir>"] :="打开光标处的文件夹或压缩包"
ActionInfo_Arr["<OpenDesktop>"] :="桌面"
ActionInfo_Arr["<OpenDrives>"] :="我的电脑"
ActionInfo_Arr["<OpenControls>"] :="控制面板"
ActionInfo_Arr["<OpenFonts>"] :="字体"
ActionInfo_Arr["<OpenNetwork>"] :="网上邻居"
ActionInfo_Arr["<OpenPrinters>"] :="打印机"
ActionInfo_Arr["<OpenRecycled>"] :="回收站"
ActionInfo_Arr["<CDtree>"] :="更改文件夹"
ActionInfo_Arr["<TransferLeft>"] :="在左窗口打开光标处的文件夹或压缩包"
ActionInfo_Arr["<TransferRight>"] :="在右窗口打开光标处的文件夹或压缩包"
ActionInfo_Arr["<EditPath>"] :="编辑来源窗口的路径"
ActionInfo_Arr["<GoToFirstFile>"] :="光标移到列表中的第一个文件"
ActionInfo_Arr["<GotoNextDrive>"] :="转到下一个驱动器"
ActionInfo_Arr["<GotoPreviousDrive>"] :="转到上一个驱动器"
ActionInfo_Arr["<GotoNextSelected>"] :="转到下一个选中的文件"
ActionInfo_Arr["<GotoPrevSelected>"] :="转到上一个选中的文件"
ActionInfo_Arr["<GotoDriveA>"] :="转到驱动器 A"
ActionInfo_Arr["<GotoDriveC>"] :="转到驱动器 C"
ActionInfo_Arr["<GotoDriveD>"] :="转到驱动器 D"
ActionInfo_Arr["<GotoDriveE>"] :="转到驱动器 E"
ActionInfo_Arr["<GotoDriveF>"] :="可自定义其他驱动器"
ActionInfo_Arr["<GotoDriveZ>"] :="最多 26 个"
ActionInfo_Arr["<HelpIndex>"] :="帮助索引"
ActionInfo_Arr["<Keyboard>"] :="快捷键列表"
ActionInfo_Arr["<Register>"] :="注册信息"
ActionInfo_Arr["<VisitHomepage>"] :="访问 Totalcmd 网站"
ActionInfo_Arr["<About>"] :="关于 Total Commander"
ActionInfo_Arr["<Exit>"] :="退出 Total Commander"
ActionInfo_Arr["<Minimize>"] :="最小化 Total Commander"
ActionInfo_Arr["<Maximize>"] :="最大化 Total Commander"
ActionInfo_Arr["<Restore>"] :="恢复正常大小"
ActionInfo_Arr["<ClearCmdLine>"] :="清除命令行"
ActionInfo_Arr["<NextCommand>"] :="下一条命令"
ActionInfo_Arr["<PrevCommand>"] :="上一条命令"
ActionInfo_Arr["<AddPathToCmdline>"] :="将路径复制到命令行"
ActionInfo_Arr["<MultiRenameFiles>"] :="批量重命名"
ActionInfo_Arr["<SysInfo>"] :="系统信息"
ActionInfo_Arr["<OpenTransferManager>"] :="后台传输管理器"
ActionInfo_Arr["<SearchFor>"] :="搜索文件"
ActionInfo_Arr["<FileSync>"] :="同步文件夹"
ActionInfo_Arr["<Associate>"] :="文件关联"
ActionInfo_Arr["<InternalAssociate>"] :="定义内部关联"
ActionInfo_Arr["<CompareFilesByContent>"] :="比较文件内容"
ActionInfo_Arr["<IntCompareFilesByContent>"] :="使用内部比较程序"
ActionInfo_Arr["<CommandBrowser>"] :="浏览内部命令"
ActionInfo_Arr["<VisButtonbar>"] :="显示/隐藏: 工具栏"
ActionInfo_Arr["<VisDriveButtons>"] :="显示/隐藏: 驱动器按钮"
ActionInfo_Arr["<VisTwoDriveButtons>"] :="显示/隐藏: 两个驱动器按钮栏"
ActionInfo_Arr["<VisFlatDriveButtons>"] :="切换: 平坦/立体驱动器按钮"
ActionInfo_Arr["<VisFlatInterface>"] :="切换: 平坦/立体用户界面"
ActionInfo_Arr["<VisDriveCombo>"] :="显示/隐藏: 驱动器列表"
ActionInfo_Arr["<VisCurDir>"] :="显示/隐藏: 当前文件夹"
ActionInfo_Arr["<VisBreadCrumbs>"] :="显示/隐藏: 路径导航栏"
ActionInfo_Arr["<VisTabHeader>"] :="显示/隐藏: 排序制表符"
ActionInfo_Arr["<VisStatusbar>"] :="显示/隐藏: 状态栏"
ActionInfo_Arr["<VisCmdLine>"] :="显示/隐藏: 命令行"
ActionInfo_Arr["<VisKeyButtons>"] :="显示/隐藏: 功能键按钮"
ActionInfo_Arr["<ShowHint>"] :="显示文件提示"
ActionInfo_Arr["<ShowQuickSearch>"] :="显示快速搜索窗口"
ActionInfo_Arr["<SwitchLongNames>"] :="开启/关闭: 长文件名显示"
ActionInfo_Arr["<RereadSource>"] :="刷新来源窗口"
ActionInfo_Arr["<ShowOnlySelected>"] :="仅显示选中的文件"
ActionInfo_Arr["<SwitchHidSys>"] :="开启/关闭: 隐藏或系统文件显示"
ActionInfo_Arr["<Switch83Names>"] :="开启/关闭: 8.3 式文件名小写显示"
ActionInfo_Arr["<SwitchDirSort>"] :="开启/关闭: 文件夹按名称排序"
ActionInfo_Arr["<DirBranch>"] :="展开所有文件夹"
ActionInfo_Arr["<DirBranchSel>"] :="只展开选中的文件夹"
ActionInfo_Arr["<50Percent>"] :="窗口分隔栏位于 50%"
ActionInfo_Arr["<100Percent>"] :="窗口分隔栏位于 100% TC 8.0+"
ActionInfo_Arr["<VisDirTabs>"] :="显示/隐藏: 文件夹标签"
ActionInfo_Arr["<VisXPThemeBackground>"] :="显示/隐藏: XP 主题背景"
ActionInfo_Arr["<SwitchOverlayIcons>"] :="开启/关闭: 叠置图标显示"
ActionInfo_Arr["<VisHistHotButtons>"] :="显示/隐藏: 文件夹历史记录和常用文件夹按钮"
ActionInfo_Arr["<SwitchWatchDirs>"] :="启用/禁用: 文件夹自动刷新"
ActionInfo_Arr["<SwitchIgnoreList>"] :="启用/禁用: 自定义隐藏文件"
ActionInfo_Arr["<SwitchX64Redirection>"] :="开启/关闭: 32 位 system32 目录重定向(64 位 Windows)"
ActionInfo_Arr["<SeparateTreeOff>"] :="关闭独立文件夹树面板"
ActionInfo_Arr["<SeparateTree1>"] :="一个独立文件夹树面板"
ActionInfo_Arr["<SeparateTree2>"] :="两个独立文件夹树面板"
ActionInfo_Arr["<SwitchSeparateTree>"] :="切换独立文件夹树面板状态"
ActionInfo_Arr["<ToggleSeparateTree1>"] :="开启/关闭: 一个独立文件夹树面板"
ActionInfo_Arr["<ToggleSeparateTree2>"] :="开启/关闭: 两个独立文件夹树面板"
ActionInfo_Arr["<UserMenu1>"] :="用户菜单 1"
ActionInfo_Arr["<UserMenu2>"] :="用户菜单 2"
ActionInfo_Arr["<UserMenu3>"] :="用户菜单 3"
ActionInfo_Arr["<UserMenu4>"] :="..."
ActionInfo_Arr["<UserMenu5>"] :="5"
ActionInfo_Arr["<UserMenu6>"] :="6"
ActionInfo_Arr["<UserMenu7>"] :="7"
ActionInfo_Arr["<UserMenu8>"] :="8"
ActionInfo_Arr["<UserMenu9>"] :="9"
ActionInfo_Arr["<UserMenu10>"] :="可定义其他用户菜单"
ActionInfo_Arr["<OpenNewTab>"] :="新建标签"
ActionInfo_Arr["<OpenNewTabBg>"] :="新建标签(在后台)"
ActionInfo_Arr["<OpenDirInNewTab>"] :="新建标签(并打开光标处的文件夹)"
ActionInfo_Arr["<OpenDirInNewTabOther>"] :="新建标签(在另一窗口打开文件夹)"
ActionInfo_Arr["<SwitchToNextTab>"] :="下一个标签(Ctrl+Tab)"
ActionInfo_Arr["<SwitchToPreviousTab>"] :="上一个标签(Ctrl+Shift+Tab)"
ActionInfo_Arr["<CloseCurrentTab>"] :="关闭当前标签"
ActionInfo_Arr["<CloseAllTabs>"] :="关闭所有标签"
ActionInfo_Arr["<DirTabsShowMenu>"] :="显示标签菜单"
ActionInfo_Arr["<ToggleLockCurrentTab>"] :="锁定/解锁当前标签"
ActionInfo_Arr["<ToggleLockDcaCurrentTab>"] :="锁定/解锁当前标签(可更改文件夹)"
ActionInfo_Arr["<ExchangeWithTabs>"] :="交换左右窗口及其标签"
ActionInfo_Arr["<GoToLockedDir>"] :="转到锁定标签的根文件夹"
ActionInfo_Arr["<SrcActivateTab1>"] :="来源窗口: 激活标签 1"
ActionInfo_Arr["<SrcActivateTab2>"] :="来源窗口: 激活标签 2"
ActionInfo_Arr["<SrcActivateTab3>"] :="..."
ActionInfo_Arr["<SrcActivateTab4>"] :="最多 99 个"
ActionInfo_Arr["<SrcActivateTab5>"] :="5"
ActionInfo_Arr["<SrcActivateTab6>"] :="6"
ActionInfo_Arr["<SrcActivateTab7>"] :="7"
ActionInfo_Arr["<SrcActivateTab8>"] :="8"
ActionInfo_Arr["<SrcActivateTab9>"] :="9"
ActionInfo_Arr["<SrcActivateTab10>"] :="0"
ActionInfo_Arr["<TrgActivateTab1>"] :="目标窗口: 激活标签 1"
ActionInfo_Arr["<TrgActivateTab2>"] :="目标窗口: 激活标签 2"
ActionInfo_Arr["<TrgActivateTab3>"] :="..."
ActionInfo_Arr["<TrgActivateTab4>"] :="最多 99 个"
ActionInfo_Arr["<TrgActivateTab5>"] :="5"
ActionInfo_Arr["<TrgActivateTab6>"] :="6"
ActionInfo_Arr["<TrgActivateTab7>"] :="7"
ActionInfo_Arr["<TrgActivateTab8>"] :="8"
ActionInfo_Arr["<TrgActivateTab9>"] :="9"
ActionInfo_Arr["<TrgActivateTab10>"] :="0"
ActionInfo_Arr["<LeftActivateTab1>"] :="左窗口: 激活标签 1"
ActionInfo_Arr["<LeftActivateTab2>"] :="左窗口: 激活标签 2"
ActionInfo_Arr["<LeftActivateTab3>"] :="..."
ActionInfo_Arr["<LeftActivateTab4>"] :="最多 99 个"
ActionInfo_Arr["<LeftActivateTab5>"] :="5"
ActionInfo_Arr["<LeftActivateTab6>"] :="6"
ActionInfo_Arr["<LeftActivateTab7>"] :="7"
ActionInfo_Arr["<LeftActivateTab8>"] :="8"
ActionInfo_Arr["<LeftActivateTab9>"] :="9"
ActionInfo_Arr["<LeftActivateTab10>"] :="0"
ActionInfo_Arr["<RightActivateTab1>"] :="右窗口: 激活标签 1"
ActionInfo_Arr["<RightActivateTab2>"] :="右窗口: 激活标签 2"
ActionInfo_Arr["<RightActivateTab3>"] :="..."
ActionInfo_Arr["<RightActivateTab4>"] :="最多 99 个"
ActionInfo_Arr["<RightActivateTab5>"] :="5"
ActionInfo_Arr["<RightActivateTab6>"] :="6"
ActionInfo_Arr["<RightActivateTab7>"] :="7"
ActionInfo_Arr["<RightActivateTab8>"] :="8"
ActionInfo_Arr["<RightActivateTab9>"] :="9"
ActionInfo_Arr["<RightActivateTab10>"] :="0"
ActionInfo_Arr["<SrcSortByCol1>"] :="来源窗口: 按第 1 列排序"
ActionInfo_Arr["<SrcSortByCol2>"] :="来源窗口: 按第 2 列排序"
ActionInfo_Arr["<SrcSortByCol3>"] :="..."
ActionInfo_Arr["<SrcSortByCol4>"] :="最多 99 列"
ActionInfo_Arr["<SrcSortByCol5>"] :="5"
ActionInfo_Arr["<SrcSortByCol6>"] :="6"
ActionInfo_Arr["<SrcSortByCol7>"] :="7"
ActionInfo_Arr["<SrcSortByCol8>"] :="8"
ActionInfo_Arr["<SrcSortByCol9>"] :="9"
ActionInfo_Arr["<SrcSortByCol10>"] :="0"
ActionInfo_Arr["<SrcSortByCol99>"] :="9"
ActionInfo_Arr["<TrgSortByCol1>"] :="目标窗口: 按第 1 列排序"
ActionInfo_Arr["<TrgSortByCol2>"] :="目标窗口: 按第 2 列排序"
ActionInfo_Arr["<TrgSortByCol3>"] :="..."
ActionInfo_Arr["<TrgSortByCol4>"] :="最多 99 列"
ActionInfo_Arr["<TrgSortByCol5>"] :="5"
ActionInfo_Arr["<TrgSortByCol6>"] :="6"
ActionInfo_Arr["<TrgSortByCol7>"] :="7"
ActionInfo_Arr["<TrgSortByCol8>"] :="8"
ActionInfo_Arr["<TrgSortByCol9>"] :="9"
ActionInfo_Arr["<TrgSortByCol10>"] :="0"
ActionInfo_Arr["<TrgSortByCol99>"] :="9"
ActionInfo_Arr["<LeftSortByCol1>"] :="左窗口: 按第 1 列排序"
ActionInfo_Arr["<LeftSortByCol2>"] :="左窗口: 按第 2 列排序"
ActionInfo_Arr["<LeftSortByCol3>"] :="..."
ActionInfo_Arr["<LeftSortByCol4>"] :="最多 99 列"
ActionInfo_Arr["<LeftSortByCol5>"] :="5"
ActionInfo_Arr["<LeftSortByCol6>"] :="6"
ActionInfo_Arr["<LeftSortByCol7>"] :="7"
ActionInfo_Arr["<LeftSortByCol8>"] :="8"
ActionInfo_Arr["<LeftSortByCol9>"] :="9"
ActionInfo_Arr["<LeftSortByCol10>"] :="0"
ActionInfo_Arr["<LeftSortByCol99>"] :="9"
ActionInfo_Arr["<RightSortByCol1>"] :="右窗口: 按第 1 列排序"
ActionInfo_Arr["<RightSortByCol2>"] :="右窗口: 按第 2 列排序"
ActionInfo_Arr["<RightSortByCol3>"] :="..."
ActionInfo_Arr["<RightSortByCol4>"] :="最多 99 列"
ActionInfo_Arr["<RightSortByCol5>"] :="5"
ActionInfo_Arr["<RightSortByCol6>"] :="6"
ActionInfo_Arr["<RightSortByCol7>"] :="7"
ActionInfo_Arr["<RightSortByCol8>"] :="8"
ActionInfo_Arr["<RightSortByCol9>"] :="9"
ActionInfo_Arr["<RightSortByCol10>"] :="0"
ActionInfo_Arr["<RightSortByCol99>"] :="9"
ActionInfo_Arr["<SrcCustomView1>"] :="来源窗口: 自定义列视图 1"
ActionInfo_Arr["<SrcCustomView2>"] :="来源窗口: 自定义列视图 2"
ActionInfo_Arr["<SrcCustomView3>"] :="..."
ActionInfo_Arr["<SrcCustomView4>"] :="最多 29 个"
ActionInfo_Arr["<SrcCustomView5>"] :="5"
ActionInfo_Arr["<SrcCustomView6>"] :="6"
ActionInfo_Arr["<SrcCustomView7>"] :="7"
ActionInfo_Arr["<SrcCustomView8>"] :="8"
ActionInfo_Arr["<SrcCustomView9>"] :="9"
ActionInfo_Arr["<LeftCustomView1>"] :="左窗口: 自定义列视图 1"
ActionInfo_Arr["<LeftCustomView2>"] :="左窗口: 自定义列视图 2"
ActionInfo_Arr["<LeftCustomView3>"] :="..."
ActionInfo_Arr["<LeftCustomView4>"] :="最多 29 个"
ActionInfo_Arr["<LeftCustomView5>"] :="5"
ActionInfo_Arr["<LeftCustomView6>"] :="6"
ActionInfo_Arr["<LeftCustomView7>"] :="7"
ActionInfo_Arr["<LeftCustomView8>"] :="8"
ActionInfo_Arr["<LeftCustomView9>"] :="9"
ActionInfo_Arr["<RightCustomView1>"] :="右窗口: 自定义列视图 1"
ActionInfo_Arr["<RightCustomView2>"] :="右窗口: 自定义列视图 2"
ActionInfo_Arr["<RightCustomView3>"] :="..."
ActionInfo_Arr["<RightCustomView4>"] :="最多 29 个"
ActionInfo_Arr["<RightCustomView5>"] :="5"
ActionInfo_Arr["<RightCustomView6>"] :="6"
ActionInfo_Arr["<RightCustomView7>"] :="7"
ActionInfo_Arr["<RightCustomView8>"] :="8"
ActionInfo_Arr["<RightCustomView9>"] :="9"
ActionInfo_Arr["<SrcNextCustomView>"] :="来源窗口: 下一个自定义视图"
ActionInfo_Arr["<SrcPrevCustomView>"] :="来源窗口: 上一个自定义视图"
ActionInfo_Arr["<TrgNextCustomView>"] :="目标窗口: 下一个自定义视图"
ActionInfo_Arr["<TrgPrevCustomView>"] :="目标窗口: 上一个自定义视图"
ActionInfo_Arr["<LeftNextCustomView>"] :="左窗口: 下一个自定义视图"
ActionInfo_Arr["<LeftPrevCustomView>"] :="左窗口: 上一个自定义视图"
ActionInfo_Arr["<RightNextCustomView>"] :="右窗口: 下一个自定义视图"
ActionInfo_Arr["<RightPrevCustomView>"] :="右窗口: 上一个自定义视图"
ActionInfo_Arr["<LoadAllOnDemandFields>"] :="所有文件都按需加载备注"
ActionInfo_Arr["<LoadSelOnDemandFields>"] :="仅选中的文件按需加载备注"
ActionInfo_Arr["<ContentStopLoadFields>"] :="停止后台加载备注"
}
<SrcComments>:
SendPos(300)
Return
<SrcShort>:
SendPos(301)
Return
<SrcLong>:
SendPos(302)
Return
<SrcTree>:
SendPos(303)
<SrcQuickview>:
SendPos(304)
Return
<VerticalPanels>:
SendPos(305)
Return
<SrcQuickInternalOnly>:
SendPos(306)
Return
<SrcHideQuickview>:
SendPos(307)
Return
<SrcExecs>:
SendPos(311)
Return
<SrcAllFiles>:
SendPos(312)
Return
<SrcUserSpec>:
SendPos(313)
Return
<SrcUserDef>:
SendPos(314)
Return
<SrcByName>:
SendPos(321)
Return
<SrcByExt>:
SendPos(322)
Return
<SrcBySize>:
SendPos(323)
Return
<SrcByDateTime>:
SendPos(324)
Return
<SrcUnsorted>:
SendPos(325)
Return
<SrcNegOrder>:
SendPos(330)
Return
<SrcOpenDrives>:
SendPos(331)
Return
<SrcThumbs>:
SendPos(269	)
Return
<SrcCustomViewMenu>:
SendPos(270)
Return
<SrcPathFocus>:
SendPos(332)
Return
Return
<LeftComments>:
SendPos(100)
Return
<LeftShort>:
SendPos(101)
Return
<LeftLong>:
SendPos(102)
Return
<LeftTree>:
SendPos(103)
Return
<LeftQuickview>:
SendPos(104)
Return
<LeftQuickInternalOnly>:
SendPos(106)
Return
<LeftHideQuickview>:
SendPos(107)
Return
<LeftExecs>:
SendPos(111)
Return
<LeftAllFiles>:
SendPos(112)
Return
<LeftUserSpec>:
SendPos(113)
Return
<LeftUserDef>:
SendPos(114)
Return
<LeftByName>:
SendPos(121)
Return
<LeftByExt>:
SendPos(122)
Return
<LeftBySize>:
SendPos(123)
Return
<LeftByDateTime>:
SendPos(124)
Return
<LeftUnsorted>:
SendPos(125)
Return
<LeftNegOrder>:
SendPos(130)
Return
<LeftOpenDrives>:
SendPos(131)
Return
<LeftPathFocus>:
SendPos(132)
Return
<LeftDirBranch>:
SendPos(203)
Return
<LeftDirBranchSel>:
SendPos(204)
Return
<LeftThumbs>:
SendPos(69)
Return
<LeftCustomViewMenu>:
SendPos(70)
Return
Return
<RightComments>:
SendPos(200)
Return
<RightShort>:
SendPos(201)
Return
<RightLong>:
SendPos(202)
Return
<RightTre>:
SendPos(203)
Return
<RightQuickvie>:
SendPos(204)
Return
<RightQuickInternalOnl>:
SendPos(206)
Return
<RightHideQuickvie>:
SendPos(207)
Return
<RightExec>:
SendPos(211)
Return
<RightAllFile>:
SendPos(212)
Return
<RightUserSpe>:
SendPos(213)
Return
<RightUserDe>:
SendPos(214)
Return
<RightByNam>:
SendPos(221)
Return
<RightByEx>:
SendPos(222)
Return
<RightBySiz>:
SendPos(223)
Return
<RightByDateTim>:
SendPos(224)
Return
<RightUnsorte>:
SendPos(225)
Return
<RightNegOrde>:
SendPos(230)
Return
<RightOpenDrive>:
SendPos(231)
Return
<RightPathFocu>:
SendPos(232)
Return
<RightDirBranch>:
SendPos(2035)
Return
<RightDirBranchSel>:
SendPos(2048)
Return
<RightThumb>:
SendPos(169)
Return
<RightCustomViewMen>:
SendPos(170)
Return
Return
<List>:
SendPos(903)
Return
<ListInternalOnly>:
SendPos(1006)
Return
<Edit>:
SendPos(904)
Return
<Copy>:
SendPos(905)
Return
<CopySamepanel>:
SendPos(3100)
Return
<CopyOtherpanel>:
SendPos(3101)
Return
<RenMov>:
SendPos(906)
Return
<MkDir>:
SendPos(907)
Return
<Delete>:
SendPos(908)
Return
<TestArchive>:
SendPos(518)
Return
<PackFiles>:
SendPos(508)
Return
<UnpackFiles>:
SendPos(509)
Return
<RenameOnly>:
SendPos(1002)
Return
<RenameSingleFile>:
SendPos(1007)
Return
<MoveOnly>:
SendPos(1005)
Return
<Properties>:
SendPos(1003)
Return
<CreateShortcut>:
SendPos(1004)
Return
<Return>:
SendPos(1001)
Return
<OpenAsUser>:
SendPos(2800)
Return
<Split>:
SendPos(560)
Return
<Combine>:
SendPos(561)
Return
<Encode>:
SendPos(562)
Return
<Decode>:
SendPos(563)
Return
<CRCcreate>:
SendPos(564)
Return
<CRCcheck>:
SendPos(565)
Return
<SetAttrib>:
SendPos(502)
Return
Return
<Config>:
SendPos(490)
Return
<DisplayConfig>:
SendPos(486)
Return
<IconConfig>:
SendPos(477)
Return
<FontConfig>:
SendPos(492)
Return
<ColorConfig>:
SendPos(494)
Return
<ConfTabChange>:
SendPos(497)
Return
<DirTabsConfig>:
SendPos(488)
Return
<CustomColumnConfig>:
SendPos(483)
Return
<CustomColumnDlg>:
SendPos(2920)
Return
<LanguageConfig>:
SendPos(499)
Return
<Config2>:
SendPos(516)
Return
<EditConfig>:
SendPos(496)
Return
<CopyConfig>:
SendPos(487)
Return
<RefreshConfig>:
SendPos(478)
Return
<QuickSearchConfig>:
SendPos(479)
Return
<FtpConfig>:
SendPos(489)
Return
<PluginsConfig>:
SendPos(484)
Return
<ThumbnailsConfig>:
SendPos(482)
Return
<LogConfig>:
SendPos(481)
Return
<IgnoreConfig>:
SendPos(480)
Return
<PackerConfig>:
SendPos(491)
Return
<ZipPackerConfig>:
SendPos(485)
Return
<Confirmation>:
SendPos(495)
Return
<ConfigSavePos>:
SendPos(493)
Return
<ButtonConfig>:
SendPos(498)
Return
<ConfigSaveSettings>:
SendPos(580)
Return
<ConfigChangeIniFiles>:
SendPos(581)
Return
<ConfigSaveDirHistory>:
SendPos(582)
Return
<ChangeStartMenu>:
SendPos(700)
Return
Return
<NetConnect>:
SendPos(512)
Return
<NetDisconnect>:
SendPos(513)
Return
<NetShareDir>:
SendPos(514)
Return
<NetUnshareDir>:
SendPos(515)
Return
<AdministerServer>:
SendPos(2204)
Return
<ShowFileUser>:
SendPos(2203)
Return
Return
<GetFileSpace>:
SendPos(503)
Return
<VolumeId>:
SendPos(505)
Return
<VersionInfo>:
SendPos(510)
Return
<ExecuteDOS>:
SendPos(511)
Return
<CompareDirs>:
SendPos(533)
Return
<CompareDirsWithSubdirs>:
SendPos(536)
Return
<ContextMenu>:
SendPos(2500)
Return
<ContextMenuInternal>:
SendPos(2927)
Return
<ContextMenuInternalCursor>:
SendPos(2928)
Return
<ShowRemoteMenu>:
SendPos(2930)
Return
<SyncChangeDir>:
SendPos(2600)
Return
<EditComment>:
SendPos(2700)
Return
<FocusLeft>:
SendPos(4001)
Return
<FocusRight>:
SendPos(4002)
Return
<FocusCmdLine>:
SendPos(4003)
Return
<FocusButtonBar>:
SendPos(4004)
Return
<CountDirContent>:
SendPos(2014)
Return
<UnloadPlugins>:
SendPos(2913)
Return
<DirMatch>:
SendPos(534)
Return
<Exchange>:
SendPos(531)
Return
<MatchSrc>:
SendPos(532)
Return
<ReloadSelThumbs>:
SendPos(2918)
Return
Return
<DirectCableConnect>:
SendPos(2300)
Return
<NTinstallDriver>:
SendPos(2301)
Return
<NTremoveDriver>:
SendPos(2302)
Return
Return
<PrintDir>:
SendPos(2027)
Return
<PrintDirSub>:
SendPos(2028)
Return
<PrintFile>:
SendPos(504)
Return
Return
<SpreadSelection>:
SendPos(521)
Return
<SelectBoth>:
SendPos(3311)
Return
<SelectFiles>:
SendPos(3312)
Return
<SelectFolders>:
SendPos(3313)
Return
<ShrinkSelection>:
SendPos(522)
Return
<ClearFiles>:
SendPos(3314)
Return
<ClearFolders>:
SendPos(3315)
Return
<ClearSelCfg>:
SendPos(3316)
Return
<SelectAll>:
SendPos(523)
Return
<SelectAllBoth>:
SendPos(3301)
Return
<SelectAllFiles>:
SendPos(3302)
Return
<SelectAllFolders>:
SendPos(3303)
Return
<ClearAll>:
SendPos(524)
Return
<ClearAllFiles>:
SendPos(3304)
Return
<ClearAllFolders>:
SendPos(3305)
Return
<ClearAllCfg>:
SendPos(3306)
Return
<ExchangeSelection>:
SendPos(525)
Return
<ExchangeSelBoth>:
SendPos(3321)
Return
<ExchangeSelFiles>:
SendPos(3322)
Return
<ExchangeSelFolders>:
SendPos(3323)
Return
<SelectCurrentExtension>:
SendPos(527)
Return
<UnselectCurrentExtension>:
SendPos(528)
Return
<SelectCurrentName>:
SendPos(541)
Return
<UnselectCurrentName>:
SendPos(542)
Return
<SelectCurrentNameExt>:
SendPos(543)
Return
<UnselectCurrentNameExt>:
SendPos(544)
Return
<SelectCurrentPath>:
SendPos(537)
Return
<UnselectCurrentPath>:
SendPos(538)
Return
<RestoreSelection>:
SendPos(529)
Return
<SaveSelection>:
SendPos(530)
Return
<SaveSelectionToFile>:
SendPos(2031)
Return
<SaveSelectionToFileA>:
SendPos(2041)
Return
<SaveSelectionToFileW>:
SendPos(2042)
Return
<SaveDetailsToFile>:
SendPos(2039)
Return
<SaveDetailsToFileA>:
SendPos(2043)
Return
<SaveDetailsToFileW>:
SendPos(2044)
Return
<LoadSelectionFromFile>:
SendPos(2032)
Return
<LoadSelectionFromClip>:
SendPos(2033)
Return
Return
<EditPermissionInfo>:
SendPos(2200)
Return
<EditAuditInfo>:
SendPos(2201)
Return
<EditOwnerInfo>:
SendPos(2202)
Return
Return
<CutToClipboard>:
SendPos(2007)
Return
<CopyToClipboard>:
SendPos(2008)
Return
<PasteFromClipboard>:
SendPos(2009)
Return
<CopyNamesToClip>:
SendPos(2017)
Return
<CopyFullNamesToClip>:
SendPos(2018)
Return
<CopyNetNamesToClip>:
SendPos(2021)
Return
<CopySrcPathToClip>:
SendPos(2029)
Return
<CopyTrgPathToClip>:
SendPos(2030)
Return
<CopyFileDetailsToClip>:
SendPos(2036)
Return
<CopyFpFileDetailsToClip>:
SendPos(2037)
Return
<CopyNetFileDetailsToClip>:
SendPos(2038)
Return
Return
<FtpConnect>:
SendPos(550)
Return
<FtpNew>:
SendPos(551)
Return
<FtpDisconnect>:
SendPos(552)
Return
<FtpHiddenFiles>:
SendPos(553)
Return
<FtpAbort>:
SendPos(554)
Return
<FtpResumeDownload>:
SendPos(555)
Return
<FtpSelectTransferMode>:
SendPos(556)
Return
<FtpAddToList>:
SendPos(557)
Return
<FtpDownloadList>:
SendPos(558)
Return
Return
<GotoPreviousDir>:
SendPos(570,True)
Return
<GotoNextDir>:
SendPos(571,True)
Return
<DirectoryHistory>:
SendPos(572)
Return
<GotoPreviousLocalDir>:
SendPos(573)
Return
<GotoNextLocalDir>:
SendPos(574)
Return
<DirectoryHotlist>:
SendPos(526)
Return
<GoToRoot>:
SendPos(2001)
Return
<GoToParent>:
SendPos(2002,True)
Return
<GoToDir>:
SendPos(2003)
Return
<OpenDesktop>:
SendPos(2121)
Return
<OpenDrives>:
SendPos(2122)
Return
<OpenControls>:
SendPos(2123)
Return
<OpenFonts>:
SendPos(2124)
Return
<OpenNetwork>:
SendPos(2125)
Return
<OpenPrinters>:
SendPos(2126)
Return
<OpenRecycled>:
SendPos(2127)
Return
<CDtree>:
SendPos(500)
Return
<TransferLeft>:
SendPos(2024)
Return
<TransferRight>:
SendPos(2025)
Return
<EditPath>:
SendPos(2912)
Return
<GoToFirstFile>:
SendPos(2050)
Return
<GotoNextDrive>:
SendPos(2051)
Return
<GotoPreviousDrive>:
SendPos(2052)
Return
<GotoNextSelected>:
SendPos(2053)
Return
<GotoPrevSelected>:
SendPos(2054)
Return
<GotoDriveA>:
SendPos(2061)
Return
<GotoDriveC>:
SendPos(2063)
Return
<GotoDriveD>:
SendPos(2064)
Return
<GotoDriveE>:
SendPos(2065)
Return
<GotoDriveF>:
SendPos(2066)
Return
<GotoDriveZ>:
SendPos(2086)
Return
Return
<HelpIndex>:
SendPos(610)
Return
<Keyboard>:
SendPos(620)
Return
<Register>:
SendPos(630)
Return
<VisitHomepage>:
SendPos(640)
Return
<About>:
SendPos(690)
Return
Return
<Exit>:
SendPos(24340)
Return
<Minimize>:
SendPos(2000)
Return
<Maximize>:
SendPos(2015)
Return
<Restore>:
SendPos(2016)
Return
Return
<ClearCmdLine>:
SendPos(2004)
Return
<NextCommand>:
SendPos(2005)
Return
<PrevCommand>:
SendPos(2006)
Return
<AddPathToCmdline>:
SendPos(2019)
Return
Return
<MultiRenameFiles>:
SendPos(2400)
Return
<SysInfo>:
SendPos(506)
Return
<OpenTransferManager>:
SendPos(559)
Return
<SearchFor>:
SendPos(501)
Return
<FileSync>:
SendPos(2020)
Return
<Associate>:
SendPos(507)
Return
<InternalAssociate>:
SendPos(519)
Return
<CompareFilesByContent>:
SendPos(2022)
Return
<IntCompareFilesByContent>:
SendPos(2040)
Return
<CommandBrowser>:
SendPos(2924)
Return
Return
<VisButtonbar>:
SendPos(2901)
Return
<VisDriveButtons>:
SendPos(2902)
Return
<VisTwoDriveButtons>:
SendPos(2903)
Return
<VisFlatDriveButtons>:
SendPos(2904)
Return
<VisFlatInterface>:
SendPos(2905)
Return
<VisDriveCombo>:
SendPos(2906)
Return
<VisCurDir>:
SendPos(2907)
Return
<VisBreadCrumbs>:
SendPos(2926)
Return
<VisTabHeader>:
SendPos(2908)
Return
<VisStatusbar>:
SendPos(2909)
Return
<VisCmdLine>:
SendPos(2910)
Return
<VisKeyButtons>:
SendPos(2911)
Return
<ShowHint>:
SendPos(2914)
Return
<ShowQuickSearch>:
SendPos(2915)
Return
<SwitchLongNames>:
SendPos(2010)
Return
<RereadSource>:
SendPos(540)
Return
<ShowOnlySelected>:
SendPos(2023)
Return
<SwitchHidSys>:
SendPos(2011)
Return
<Switch83Names>:
SendPos(2013)
Return
<SwitchDirSort>:
SendPos(2012)
Return
<DirBranch>:
SendPos(2026)
Return
<DirBranchSel>:
SendPos(2046)
Return
<50Percent>:
SendPos(909)
Return
<100Percent>:
SendPos(910)
Return
<VisDirTabs>:
SendPos(2916)
Return
<VisXPThemeBackground>:
SendPos(2923)
Return
<SwitchOverlayIcons>:
SendPos(2917)
Return
<VisHistHotButtons>:
SendPos(2919)
Return
<SwitchWatchDirs>:
SendPos(2921)
Return
<SwitchIgnoreList>:
SendPos(2922)
Return
<SwitchX64Redirection>:
SendPos(2925)
Return
<SeparateTreeOff>:
SendPos(3200)
Return
<SeparateTree1>:
SendPos(3201)
Return
<SeparateTree2>:
SendPos(3202)
Return
<SwitchSeparateTree>:
SendPos(3203)
Return
<ToggleSeparateTree1>:
SendPos(3204)
Return
<ToggleSeparateTree2>:
SendPos(3205)
Return
Return
<UserMenu1>:
SendPos(701)
Return
<UserMenu2>:
SendPos(702)
Return
<UserMenu3>:
SendPos(703)
Return
<UserMenu4>:
SendPos(704)
Return
<UserMenu5>:
SendPos(70)
Return
<UserMenu6>:
SendPos(70)
Return
<UserMenu7>:
SendPos(70)
Return
<UserMenu8>:
SendPos(70)
Return
<UserMenu9>:
SendPos(70)
Return
<UserMenu10>:
SendPos(710)
Return
Return
<OpenNewTab>:
SendPos(3001)
Return
<OpenNewTabBg>:
SendPos(3002)
Return
<OpenDirInNewTab>:
SendPos(3003)
Return
<OpenDirInNewTabOther>:
SendPos(3004)
Return
<SwitchToNextTab>:
SendPos(3005)
Return
<SwitchToPreviousTab>:
SendPos(3006)
Return
<CloseCurrentTab>:
SendPos(3007)
Return
<CloseAllTabs>:
SendPos(3008)
Return
<DirTabsShowMenu>:
SendPos(3009)
Return
<ToggleLockCurrentTab>:
SendPos(3010)
Return
<ToggleLockDcaCurrentTab>:
SendPos(3012)
Return
<ExchangeWithTabs>:
SendPos(535)
Return
<GoToLockedDir>:
SendPos(3011)
Return
<SrcActivateTab1>:
SendPos(5001)
Return
<SrcActivateTab2>:
SendPos(5002)
Return
<SrcActivateTab3>:
SendPos(5003)
Return
<SrcActivateTab4>:
SendPos(5004)
Return
<SrcActivateTab5>:
SendPos(5005)
Return
<SrcActivateTab6>:
SendPos(5006)
Return
<SrcActivateTab7>:
SendPos(5007)
Return
<SrcActivateTab8>:
SendPos(5008)
Return
<SrcActivateTab9>:
SendPos(5009)
Return
<SrcActivateTab10>:
SendPos(5010)
Return
<TrgActivateTab1>:
SendPos(5101)
Return
<TrgActivateTab2>:
SendPos(5102)
Return
<TrgActivateTab3>:
SendPos(5103)
Return
<TrgActivateTab4>:
SendPos(5104)
Return
<TrgActivateTab5>:
SendPos(5105)
Return
<TrgActivateTab6>:
SendPos(5106)
Return
<TrgActivateTab7>:
SendPos(5107)
Return
<TrgActivateTab8>:
SendPos(5108)
Return
<TrgActivateTab9>:
SendPos(5109)
Return
<TrgActivateTab10>:
SendPos(5110)
Return
<LeftActivateTab1>:
SendPos(5201)
Return
<LeftActivateTab2>:
SendPos(5202)
Return
<LeftActivateTab3>:
SendPos(5203)
Return
<LeftActivateTab4>:
SendPos(5204)
Return
<LeftActivateTab5>:
SendPos(5205)
Return
<LeftActivateTab6>:
SendPos(5206)
Return
<LeftActivateTab7>:
SendPos(5207)
Return
<LeftActivateTab8>:
SendPos(5208)
Return
<LeftActivateTab9>:
SendPos(5209)
Return
<LeftActivateTab10>:
SendPos(5210)
Return
<RightActivateTab1>:
SendPos(5301)
Return
<RightActivateTab2>:
SendPos(5302)
Return
<RightActivateTab3>:
SendPos(5303)
Return
<RightActivateTab4>:
SendPos(5304)
Return
<RightActivateTab5>:
SendPos(5305)
Return
<RightActivateTab6>:
SendPos(5306)
Return
<RightActivateTab7>:
SendPos(5307)
Return
<RightActivateTab8>:
SendPos(5308)
Return
<RightActivateTab9>:
SendPos(5309)
Return
<RightActivateTab10>:
SendPos(5310)
Return
Return
<SrcSortByCol1>:
SendPos(6001)
Return
<SrcSortByCol2>:
SendPos(6002)
Return
<SrcSortByCol3>:
SendPos(6003)
Return
<SrcSortByCol4>:
SendPos(6004)
Return
<SrcSortByCol5>:
SendPos(6005)
Return
<SrcSortByCol6>:
SendPos(6006)
Return
<SrcSortByCol7>:
SendPos(6007)
Return
<SrcSortByCol8>:
SendPos(6008)
Return
<SrcSortByCol9>:
SendPos(6009)
Return
<SrcSortByCol10>:
SendPos(6010)
Return
<SrcSortByCol99>:
SendPos(6099)
Return
<TrgSortByCol1>:
SendPos(6101)
Return
<TrgSortByCol2>:
SendPos(6102)
Return
<TrgSortByCol3>:
SendPos(6103)
Return
<TrgSortByCol4>:
SendPos(6104)
Return
<TrgSortByCol5>:
SendPos(6105)
Return
<TrgSortByCol6>:
SendPos(6106)
Return
<TrgSortByCol7>:
SendPos(6107)
Return
<TrgSortByCol8>:
SendPos(6108)
Return
<TrgSortByCol9>:
SendPos(6109)
Return
<TrgSortByCol10>:
SendPos(6110)
Return
<TrgSortByCol99>:
SendPos(6199)
Return
<LeftSortByCol1>:
SendPos(6201)
Return
<LeftSortByCol2>:
SendPos(6202)
Return
<LeftSortByCol3>:
SendPos(6203)
Return
<LeftSortByCol4>:
SendPos(6204)
Return
<LeftSortByCol5>:
SendPos(6205)
Return
<LeftSortByCol6>:
SendPos(6206)
Return
<LeftSortByCol7>:
SendPos(6207)
Return
<LeftSortByCol8>:
SendPos(6208)
Return
<LeftSortByCol9>:
SendPos(6209)
Return
<LeftSortByCol10>:
SendPos(6210)
Return
<LeftSortByCol99>:
SendPos(6299)
Return
<RightSortByCol1>:
SendPos(6301)
Return
<RightSortByCol2>:
SendPos(6302)
Return
<RightSortByCol3>:
SendPos(6303)
Return
<RightSortByCol4>:
SendPos(6304)
Return
<RightSortByCol5>:
SendPos(6305)
Return
<RightSortByCol6>:
SendPos(6306)
Return
<RightSortByCol7>:
SendPos(6307)
Return
<RightSortByCol8>:
SendPos(6308)
Return
<RightSortByCol9>:
SendPos(6309)
Return
<RightSortByCol10>:
SendPos(6310)
Return
<RightSortByCol99>:
SendPos(6399)
Return
Return
<SrcCustomView1>:
SendPos(271)
Return
<SrcCustomView2>:
SendPos(272)
Return
<SrcCustomView3>:
SendPos(273)
Return
<SrcCustomView4>:
SendPos(274)
Return
<SrcCustomView5>:
SendPos(275)
Return
<SrcCustomView6>:
SendPos(276)
Return
<SrcCustomView7>:
SendPos(277)
Return
<SrcCustomView8>:
SendPos(278)
Return
<SrcCustomView9>:
SendPos(279)
Return
<LeftCustomView1>:
SendPos(710)
Return
<LeftCustomView2>:
SendPos(72)
Return
<LeftCustomView3>:
SendPos(73)
Return
<LeftCustomView4>:
SendPos(74)
Return
<LeftCustomView5>:
SendPos(75)
Return
<LeftCustomView6>:
SendPos(76)
Return
<LeftCustomView7>:
SendPos(77)
Return
<LeftCustomView8>:
SendPos(78)
Return
<LeftCustomView9>:
SendPos(79)
Return
<RightCustomView1>:
SendPos(171)
Return
<RightCustomView2>:
SendPos(172)
Return
<RightCustomView3>:
SendPos(173)
Return
<RightCustomView4>:
SendPos(174)
Return
<RightCustomView5>:
SendPos(175)
Return
<RightCustomView6>:
SendPos(176)
Return
<RightCustomView7>:
SendPos(177)
Return
<RightCustomView8>:
SendPos(178)
Return
<RightCustomView9>:
SendPos(179)
Return
<SrcNextCustomView>:
SendPos(5501)
Return
<SrcPrevCustomView>:
SendPos(5502)
Return
<TrgNextCustomView>:
SendPos(5503)
Return
<TrgPrevCustomView>:
SendPos(5504)
Return
<LeftNextCustomView>:
SendPos(5505)
Return
<LeftPrevCustomView>:
SendPos(5506)
Return
<RightNextCustomView>:
SendPos(5507)
Return
<RightPrevCustomView>:
SendPos(5508)
Return
<LoadAllOnDemandFields>:
SendPos(5512)
Return
<LoadSelOnDemandFields>:
SendPos(5513)
Return
<ContentStopLoadFields>:
SendPos(5514)
Return