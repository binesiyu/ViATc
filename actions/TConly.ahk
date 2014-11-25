﻿<TConly>:
;=======================================================
	Global TCPath
	TCPath := "totalcmd.exe"
	If RegExMatch(TcPath,"i)totalcmd64\.exe$")
	{
		Global TCListBox := "LCLListBox"
		Global TCEdit := "Edit1"
		Global TInEdit := "TInEdit1"
		GLobal TCPanel1 := "Window1"
		Global TCPanel2 := "Window11"
	}
	Else
	{
		Global TCListBox := "TMyListBox"
		Global TCEdit := "Edit1"
		Global TInEdit := "TInEdit1"
		Global TCPanel1 := "TPanel1"
		Global TCPanel2 := "TMyPanel8"
	}
	Global Mark := []
	Global NewFiles := []
	CustomActions("<Normal_Mode_TC>","返回正常模式")
	CustomActions("<Insert_Mode_TC>","进入插入模式")
	CustomActions("<ToggleTC>","打开/激活TC")
	CustomActions("<azHistory>","a-z历史导航")
	CustomActions("<DownSelect>","向下选择")
	CustomActions("<UpSelect>","向上选择")
	CustomActions("<Mark>","标记功能")
	CustomActions("<ForceDelete>","强制删除")
	CustomActions("<ListMark>","显示标记")
	CustomActions("<WinMaxLeft>","最大化左侧窗口")
	CustomActions("<WinMaxRight>","最大化右侧窗口")
	CustomActions("<GoLastTab>","切换到最后一个标签")
	CustomActions("<CopyNameOnly>","只复制文件名，不含扩展名")
	CustomActions("<GotoLine>","移动到[count]行，默认第一行")
	CustomActions("<LastLine>","移动到[count]行，默认最后一行")
	CustomActions("<Half>","移动到窗口中间行")
	CustomActions("<CreateNewFile>","文件模板")
	CustomActions("<GoToParentEx>","返回到上层文件夹，可返回到我的电脑")
	;;默认按键(VIM)
	RegisterHotkey("J","<Down>","TQUICKSEARCH")
	RegisterHotkey("K","<Up>","TQUICKSEARCH")
	RegisterHotkey("<ctrl>d","<Esc>","TQUICKSEARCH")
	RegisterHotkey("<ctrl>c","<Esc>","TQUICKSEARCH")
	RegisterHotkey("0","<0>","TTOTAL_CMD")
	RegisterHotkey("1","<1>","TTOTAL_CMD")
	RegisterHotkey("2","<2>","TTOTAL_CMD")
	RegisterHotkey("3","<3>","TTOTAL_CMD")
	RegisterHotkey("4","<4>","TTOTAL_CMD")
	RegisterHotkey("5","<5>","TTOTAL_CMD")
	RegisterHotkey("6","<6>","TTOTAL_CMD")
	RegisterHotkey("7","<7>","TTOTAL_CMD")
	RegisterHotkey("8","<8>","TTOTAL_CMD")
	RegisterHotkey("9","<9>","TTOTAL_CMD")
	RegisterHotkey("c","<cm_GetFileSpace>","TTOTAL_CMD")
	RegisterHotkey("C","<cm_Exchange>","TTOTAL_CMD")
	RegisterHotkey("d","<cm_Return>","TTOTAL_CMD")
	RegisterHotkey("D","<cm_OpenDesktop>","TTOTAL_CMD")
	RegisterHotkey("e","<cm_Edit>","TTOTAL_CMD")
	RegisterHotkey("E","<cm_ExeCuteDOS>","TTOTAL_CMD")
	RegisterHotkey("F","<cm_SearchFor>","TTOTAL_CMD")
	RegisterHotkey("h","<cm_FocusLeft>","TTOTAL_CMD")
	RegisterHotkey("H","<cm_GotoPreviousDir>","TTOTAL_CMD")
	RegisterHotkey("I","<CreateNewFile>","TTOTAL_CMD")
	RegisterHotkey("i","<Insert_Mode_TC>","TTOTAL_CMD")
	RegisterHotkey("j","<down>","TTOTAL_CMD")
	RegisterHotkey("J","<downSelect>","TTOTAL_CMD")
	RegisterHotkey("k","<up>","TTOTAL_CMD")
	RegisterHotkey("K","<upSelect>","TTOTAL_CMD")
	RegisterHotkey("l","<cm_FocusRight>","TTOTAL_CMD")
	RegisterHotkey("L","<cm_GotoNextDir>","TTOTAL_CMD")
	RegisterHotkey("m","<Mark>","TTOTAL_CMD")
	RegisterHotkey("M","<cm_ContextMenu>","TTOTAL_CMD")
	RegisterHotkey("n","<azHistory>","TTOTAL_CMD")
	RegisterHotkey("N","<cm_DirectoryHistory>","TTOTAL_CMD")
	RegisterHotkey("o","<cm_TransferRight>","TTOTAL_CMD")
	RegisterHotkey("O","<cm_TransferLeft>","TTOTAL_CMD")
	RegisterHotkey("P","<cm_PackFiles>","TTOTAL_CMD")
	RegisterHotkey("p","<cm_UnpackFiles>","TTOTAL_CMD")
	RegisterHotkey("r","<cm_RenameOnly>","TTOTAL_CMD")
	RegisterHotkey("R","<cm_MultiRenameFiles>","TTOTAL_CMD")
	RegisterHotkey("u","<GoToParentEx>","TTOTAL_CMD")
	RegisterHotkey("U","<cm_GoToRoot>","TTOTAL_CMD")
	RegisterHotkey("w","<cm_List>","TTOTAL_CMD")
	RegisterHotkey("W","<cm_ListInternalOnly>","TTOTAL_CMD")
	RegisterHotkey("x","<ForceDelete>","TTOTAL_CMD")
	RegisterHotkey("X","<cm_Delete>","TTOTAL_CMD")
	RegisterHotkey("y","<cm_CopyNamesToClip>","TTOTAL_CMD")
	RegisterHotkey("Y","<cm_CopyFullNamesToClip>","TTOTAL_CMD")
	RegisterHotkey("'","<ListMark>","TTOTAL_CMD")
	RegisterHotkey("/","<cm_ShowQuickSearch>","TTOTAL_CMD")
	RegisterHotkey("?","<cm_SearchFor>","TTOTAL_CMD")
	RegisterHotkey("[","<cm_SelectCurrentName>","TTOTAL_CMD")
	RegisterHotkey("{","<cm_UnselectCurrentName>","TTOTAL_CMD")
	RegisterHotkey("]","<cm_SelectCurrentExtension>","TTOTAL_CMD")
	RegisterHotkey("}","<cm_UnSelectCurrentExtension>","TTOTAL_CMD")
	RegisterHotkey("\","<cm_ExchangeSelection>","TTOTAL_CMD")
	RegisterHotkey("|","<cm_ClearAll>","TTOTAL_CMD")
	RegisterHotkey("-","<cm_SwitchSeparateTree>","TTOTAL_CMD")
	RegisterHotkey("=","<cm_MatchSrc>","TTOTAL_CMD")
	RegisterHotkey(":","<cm_CommandBrowser>","TTOTAL_CMD")
	RegisterHotkey(";","<cm_FocusCmdLine>","TTOTAL_CMD")
	RegisterHotkey(".","<Repeat>","TTOTAL_CMD")
	RegisterHotkey("G","<LastLine>","TTOTAL_CMD")
	RegisterHotkey("gg","<GoToLine>","TTOTAL_CMD")
	RegisterHotkey("gd","<cm_SrcOpenDrives>","TTOTAL_CMD")
	RegisterHotkey("g1","<cm_SrcActivateTab1>","TTOTAL_CMD")
	RegisterHotkey("g2","<cm_SrcActivateTab2>","TTOTAL_CMD")
	RegisterHotkey("g3","<cm_SrcActivateTab3>","TTOTAL_CMD")
	RegisterHotkey("g4","<cm_SrcActivateTab4>","TTOTAL_CMD")
	RegisterHotkey("g5","<cm_SrcActivateTab5>","TTOTAL_CMD")
	RegisterHotkey("g6","<cm_SrcActivateTab6>","TTOTAL_CMD")
	RegisterHotkey("g7","<cm_SrcActivateTab7>","TTOTAL_CMD")
	RegisterHotkey("g8","<cm_SrcActivateTab8>","TTOTAL_CMD")
	RegisterHotkey("g9","<cm_SrcActivateTab9>","TTOTAL_CMD")
	RegisterHotkey("g0","<GoLastTab>","TTOTAL_CMD")
	RegisterHotkey("to","<cm_OpenNewTab>","TTOTAL_CMD")
	RegisterHotkey("tO","<cm_OpenNewTabBg>","TTOTAL_CMD")
	RegisterHotkey("tw","<cm_ExchangeWithTabs>","TTOTAL_CMD")
    RegisterHotkey("tt","<cm_OpenDirInNewTab>","TTOTAL_CMD")
    RegisterHotkey("tT","<cm_OpenDirInNewTabOther>","TTOTAL_CMD")
    ;RegisterHotkey("tl","<cm_SwitchToNextTab>","TTOTAL_CMD")
    ;RegisterHotkey("th","<cm_SwitchToPreviousTab>","TTOTAL_CMD")
    RegisterHotkey("tc","<cm_CloseCurrentTab>","TTOTAL_CMD")
    RegisterHotkey("ta","<cm_CloseAllTabs>","TTOTAL_CMD")
    RegisterHotkey("tm","<cm_DirTabsShowMenu>","TTOTAL_CMD")
    RegisterHotkey("tl","<cm_ToggleLockCurrentTab>","TTOTAL_CMD")
    ;RegisterHotkey("tL","<cm_ToggleLockDcaCurrentTab>","TTOTAL_CMD")
	RegisterHotkey("sn","<cm_SrcByName>","TTOTAL_CMD")
	RegisterHotkey("se","<cm_SrcByExt>","TTOTAL_CMD")
	RegisterHotkey("ss","<cm_SrcBySize>","TTOTAL_CMD")
	RegisterHotkey("sd","<cm_SrcByDateTime>","TTOTAL_CMD")
	RegisterHotkey("sr","<cm_SrcNegOrder>","TTOTAL_CMD")
	RegisterHotkey("s1","<cm_SrcSortByCol1>","TTOTAL_CMD")
	RegisterHotkey("s2","<cm_SrcSortByCol2>","TTOTAL_CMD")
	RegisterHotkey("s3","<cm_SrcSortByCol3>","TTOTAL_CMD")
	RegisterHotkey("s4","<cm_SrcSortByCol4>","TTOTAL_CMD")
	RegisterHotkey("s5","<cm_SrcSortByCol5>","TTOTAL_CMD")
	RegisterHotkey("s6","<cm_SrcSortByCol6>","TTOTAL_CMD")
	RegisterHotkey("s7","<cm_SrcSortByCol7>","TTOTAL_CMD")
	RegisterHotkey("s8","<cm_SrcSortByCol8>","TTOTAL_CMD")
	RegisterHotkey("s9","<cm_SrcSortByCol9>","TTOTAL_CMD")
	RegisterHotkey("s0","<cm_SrcUnsorted>","TTOTAL_CMD")
	RegisterHotkey("v","<cm_SrcQuickView>","TTOTAL_CMD")
	RegisterHotkey("Vm","<cm_SrcCustomViewMenu>","TTOTAL_CMD")
	RegisterHotkey("Vb","<cm_VisButtonbar>","TTOTAL_CMD")
	RegisterHotkey("Vd","<cm_VisDriveButtons>","TTOTAL_CMD")
	RegisterHotkey("Vo","<cm_VisTwoDriveButtons>","TTOTAL_CMD")
	RegisterHotkey("Vr","<cm_VisDriveCombo>","TTOTAL_CMD")
	RegisterHotkey("Vc","<cm_VisDriveCombo>","TTOTAL_CMD")
	RegisterHotkey("Vt","<cm_VisTabHeader>","TTOTAL_CMD")
	RegisterHotkey("Vs","<cm_VisStatusbar>","TTOTAL_CMD")
	RegisterHotkey("Vn","<cm_VisCmdLine>","TTOTAL_CMD")
	RegisterHotkey("Vf","<cm_VisKeyButtons>","TTOTAL_CMD")
	RegisterHotkey("Vw","<cm_VisDirTabs>","TTOTAL_CMD")
	RegisterHotkey("Ve","<cm_CommandBrowser>","TTOTAL_CMD")
	RegisterHotkey("zz","<cm_50Percent>","TTOTAL_CMD")
	RegisterHotkey("zi","<WinMaxLeft>","TTOTAL_CMD")
	RegisterHotkey("zo","<WinMaxRight>","TTOTAL_CMD")
	RegisterHotkey("zt","<AlwayOnTop>","TTOTAL_CMD")
	RegisterHotkey("zn","<cm_Minimize>","TTOTAL_CMD")
	RegisterHotkey("zm","<cm_Maximize>","TTOTAL_CMD")
	RegisterHotkey("zr","<cm_Restore>","TTOTAL_CMD")
	RegisterHotkey("zv","<cm_VerticalPanels>","TTOTAL_CMD")
	RegisterHotkey("zv","<cm_VerticalPanels>","TTOTAL_CMD")
	RegisterHotkey("zs","<TransParent>","TTOTAL_CMD")
	RegisterHotkey("<ctrl>l","<cm_SwitchToNextTab>","TTOTAL_CMD")
	RegisterHotkey("<ctrl>h","<cm_SwitchToPreviousTab>","TTOTAL_CMD")
	RegisterHotkey("<ctrl>c","<Esc>","TTOTAL_CMD")
	RegisterHotkey("<lwin>e","<ToggleTC>")
	RegisterHotkey("<lwin>w","<ToggleVIM>")
	RegisterHotkey("<lwin>f","<ToggleFIREFOX>")
	SetHotkey("esc","<Normal_Mode_TC>","TTOTAL_CMD")
	;; 默认按键完
	ReadNewFile()
return
; TTOTAL_CMD_CheckMode()
TTOTAL_CMD_CheckMode()
{
	WinGet,MenuID,ID,AHK_CLASS #32768
	If MenuID	
		return True
	ControlGetFocus,ctrl,AHK_CLASS TTOTAL_CMD
	If RegExMatch(ctrl,TInEdit)
		Return True
	If RegExMatch(ctrl,TCEdit)
		Return True
	Return False
}
<ExcSubOK>:
	Tooltip
return
; <Esc_TC> {{{1
<Normal_Mode_TC>:
	Send,{Esc}
	Tooltip
	Vim_HotKeyCount := 0
	HotkeyControl(true)	
	EmptyMem()
return
; <insert_TC> {{{1
<Insert_Mode_TC>:
	HotkeyControl(False)	
return
; <ToggleTC> {{{1
<ToggleTC>:
    togglewindow("TTOTAL_CMD",TCPath)
return

<ToggleVIM>:
    togglewindow("Vim","gvim.exe")
return

<ToggleFIREFOX>:
    toggleexe("firefox.exe","firefox.exe")
return

toggleexe(EXE,PATH)
{
    WinGet, id, List, AHK_CLASS MozillaWindowClass
    Loop %id% 
    {
        this_id := id%A_Index%
        WinGetTitle,this_title,ahk_id %this_id%
        ; MsgBox %this_title%
        ifinstring this_title , Pentadactyl
        {
            Winactivate,AHK_ID %this_id%
            Loop,4
            {
                IfWinNotActive,AHK_ID %this_id%
                    WinActivate,AHK_ID %this_id%
                Else
                    Break
                Sleep,500
            }
            Return
        }
    }
	IfWinExist,AHK_EXE %EXE%	
		WinActivate,AHK_EXE %EXE%
	Else
		Run,%PATH%
	Loop,4
	{
		IfWinNotActive,AHK_EXE %EXE%
			WinActivate,AHK_EXE %EXE%
		Else
			Break
		Sleep,500
	}
	EmptyMem()
}
togglewindow(CLASS,PATH)
{
	IfWinExist,AHK_CLASS %CLASS%	
		WinActivate,AHK_CLASS %CLASS%
	Else
		Run,%PATH%
	Loop,4
	{
		IfWinNotActive,AHK_CLASS %CLASS%
			WinActivate,AHK_CLASS %CLASS%
		Else
			Break
		Sleep,500
	}
	EmptyMem()
}
; <azHistory> {{{1
<azHistory>:
		azhistory()
Return
azhistory()
{
	GoSub,<cm_DirectoryHistory>
	Sleep, 100
	if WinExist("ahk_class #32768")
	{
	SendMessage,0x01E1 ;Get Menu Hwnd
    hmenu := ErrorLevel
    if hmenu!=0
    {
		If Not RegExMatch(GetMenuString(Hmenu,1),".*[\\|/]$")
			Return
		Menu,sh,UseErrorLevel
		Menu,sh,add
		Menu,sh,deleteall
		If ErrorLevel
			return
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
; <DownSelect> {{{1
<DownSelect>:
	Send +{Down}
return
; <upSelect> {{{1
<upSelect>:
	Send +{Up}
return
; <WinMaxLeft> {{{1
<WinMaxLeft>:
	WinMaxLR(true)
Return
; <WinMaxRight> {{{1
<WinMaxRight>:
	WinMaxLR(false)
Return
WinMaxLR(lr)
{
	If lr
	{
		ControlGetPos,x,y,w,h,%TCPanel2%,ahk_class TTOTAL_CMD
		ControlGetPos,tm1x,tm1y,tm1W,tm1H,%TCPanel1%,ahk_class TTOTAL_CMD
		If (tm1w < tm1h) ; 判断纵向还是横向 Ture为竖 false为横
		{
			ControlMove,%TCPanel1%,x+w,,,,ahk_class TTOTAL_CMD
		}
		else
			ControlMove,%TCPanel1%,0,y+h,,,ahk_class TTOTAL_CMD
		ControlClick, %TCPanel1%,ahk_class TTOTAL_CMD 
		WinActivate ahk_class TTOTAL_CMD
	}
	Else
	{
		ControlMove,%TCPanel1%,0,0,,,ahk_class TTOTAL_CMD
		ControlClick,%TCPanel1%,ahk_class TTOTAL_CMD
		WinActivate ahk_class TTOTAL_CMD
	}
}
; <GoLastTab> {{{1
<GoLastTab>:
	GoSub,<cm_SrcActivateTab1>
	GoSub,<cm_SwitchToPreviousTab>
return
; <CopyNameOnly> {{{1
<CopyNameOnly>:
		CopyNameOnly()
Return
CopyNameOnly()
{
	clipboard :=
	GoSub,<cm_CopyNamesToClip>
	ClipWait
	If Not RegExMatch(clipboard,"^\..*")
		clipboard := RegExReplace(RegExReplace(clipboard,"\\$"),"\.[^\.]*$")
}
; <ForceDelete>  {{{1
; 强制删除
<ForceDelete>:
	Send +{Delete}
return
; <GotoLine> {{{1
; 转到[count]行,缺省第一行
<GotoLine>:
	If Vim_HotKeyCount
		GotoLine(Vim_HotKeyCount)
	Else
		GotoLine(1)
return
; <LastLine> {{{1
; 转到[count]行, 最后一行
<LastLine>:
	If Vim_HotKeyCount
		GotoLine(Vim_HotKeyCount)
	Else
		GotoLine(0)
return
GotoLine(Index)
{
	Vim_HotKeyCount := 0
	ControlGetFocus,Ctrl,AHK_CLASS TTOTAL_CMD
	If Index
	{
		Index--
		ControlGet,text,List,,%ctrl%,AHK_CLASS TTOTAL_CMD
		Stringsplit,T,Text,`n
		Last := T0 - 1
		If Index > %Last%
			Index := Last
		Postmessage,0x19E,%Index%,1,%Ctrl%,AHK_CLASS TTOTAL_CMD
	}
	Else
	{
		ControlGet,text,List,,%ctrl%,AHK_CLASS TTOTAL_CMD
		Stringsplit,T,Text,`n
		Last := T0 - 1
		PostMessage, 0x19E,  %Last% , 1 , %CTRL%, AHK_CLASS TTOTAL_CMD
	}
}
; <Half>  {{{1
; 移动到窗口中间
<Half>:
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
; <Mark> {{{1
; 标记功能
<Mark>:
	Mark()
Return
Mark()
{
	HotkeyControl(False)	
	GoSub,<cm_FocusCmdLine>
	ControlGet,EditId,Hwnd,,AHK_CLASS TTOTAL_CMD
	ControlSetText,%TCEdit%,m,AHK_CLASS TTOTAL_CMD
	Postmessage,0xB1,2,2,%TCEdit%,AHK_CLASS TTOTAL_CMD
	SetTimer,<MarkTimer>,100
}
<MarkTimer>:
	MarkTimer()
Return
MarkTimer()
{
	ControlGetFocus,ThisControl,AHK_CLASS TTOTAL_CMD
	ControlGetText,OutVar,%TCEdit%,AHK_CLASS TTOTAL_CMD
	Match_TCEdit := "i)^" . TCEdit . "$"
	If Not RegExMatch(ThisControl,Match_TCEdit) OR Not RegExMatch(Outvar,"i)^m.?")
	{
		HotkeyControl(true)	
		Settimer,<MarkTimer>,Off
		Return
	}
	If RegExMatch(OutVar,"i)^m.+")
	{
		HotkeyControl(true)	
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
		If RegExMatch(Mark["ms"],m)
		{
			DelM := Mark[m]
			Menu,MarkMenu,Delete,%DelM%
			Menu,MarkMenu,Add,%mPath%,<AddMark>
			Mark["ms"] := Mark["ms"] . m
			Mark[m] := mPath
		}
		Else
		{
			Menu,MarkMenu,Add,%mPath%,<AddMark>
			Mark["ms"] := Mark["ms"] . m
			Mark[m] := mPath
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
; <ListMark> {{{1
; 显示标记
<ListMark>:
	ListMark()
Return
ListMark()
{
	If Not Mark["ms"]
		Return
	ControlGetFocus,TLB,ahk_class TTOTAL_CMD
	ControlGetPos,xn,yn,,,%TLB%,ahk_class TTOTAL_CMD
	Menu,MarkMenu,Show,%xn%,%yn%
}
; <CreateNewFile> {{{1
; 新建文件
<CreateNewFile>:
	CreateNewFile()
return
CreateNewFile()
{
	ControlGetFocus,TLB,ahk_class TTOTAL_CMD
	ControlGetPos,xn,yn,,,%TLB%,ahk_class TTOTAL_CMD
	Menu,FileTemp,Add
	Menu,FileTemp,DeleteAll
	Menu,FileTemp,Add ,0 新建文件,:CreateNewFile
	Menu,FileTemp,Icon,0 新建文件,%A_WinDir%\system32\Shell32.dll,-152
	Menu,FileTemp,Add ,1 文件夹,<cm_Mkdir>
	Menu,FileTemp,Icon,1 文件夹,%A_WinDir%\system32\Shell32.dll,4
	Menu,FileTemp,Add ,2 快捷方式,<cm_CreateShortcut>
	Menu,FileTemp,Icon,2 快捷方式,%A_WinDir%\system32\Shell32.dll,264
	Menu,FileTemp,Add ,3 添加到新模板,<AddToTempFiles>
	Menu,FileTemp,Icon,3 添加到新模板,%A_WinDir%\system32\Shell32.dll,-155
	FileTempMenuCheck()
	Menu,FileTemp,Show,%xn%,%yn%
}
; 检查文件模板功能
FileTempMenuCheck()
{
	Global TCPath
	Splitpath,TCPath,,TCDir
	Loop,%TCDir%\shellnew\*.*
	{
		If A_Index = 1
			Menu,FileTemp,Add
		ft := chr(64+A_Index) . " >> " . A_LoopFileName
		Menu,FileTemp,Add,%ft%,FileTempNew
		Ext := "." . A_LoopFileExt
		IconFile := RegGetNewFileIcon(Ext)
		IconFIle := RegExReplace(IconFile,"i)%systemroot%",A_WinDir)
		IconFilePath := RegExReplace(IconFile,",-?\d*","")
		IconFileIndex := RegExReplace(IconFile,".*,","")
		If Not FileExist(IconFilePath)
			Menu,FileTemp,Icon,%ft%,%A_WinDir%\system32\Shell32.dll,-152
		Else
			Menu,FileTemp,Icon,%ft%,%IconFilePath%,%IconFileIndex%
	}
}
; 添加到文件模板中
<AddToTempFiles>:
	AddToTempFiles()
return
AddToTempFiles()
{
	ClipSaved := ClipboardAll
	Clipboard := 
	GoSub,<cm_CopyFullNamesToClip>
	ClipWait,2
	If clipboard
		AddPath := clipboard
	Else
		Return
	clipboard := ClipSaved
	If FileExist(AddPath)
		Splitpath,AddPath,filename,,fileext,filenamenoext
	else
		Return
	Gui, Destroy
	Gui, Add, Text, Hidden, %AddPath%
	Gui, Add, Text, x12 y20 w50 h20 +Center, 模板源
	Gui, Add, Edit, x72 y20 w300 h20 Disabled, %FileName%
	Gui, Add, Text, x12 y50 w50 h20 +Center, 模板名
	Gui, Add, Edit, x72 y50 w300 h20 , %FileName%
	Gui, Add, Button, x162 y80 w90 h30 gAddTempOK default, 确认(&S)
	Gui, Add, Button, x282 y80 w90 h30 gNewFileClose , 取消(&C)
	Gui, Show, w400 h120, 添加模板
	If Fileext
	{
		Controlget,nf,hwnd,,edit2,A
		PostMessage,0x0B1,0,Strlen(filenamenoext),Edit2,A
	}
}
AddTempOK:
	AddTempOK()
return
AddTempOK()
{
	Global TCPath
	GuiControlGet,SrcPath,,Static1
	Splitpath,SrcPath,filename,,fileext,filenamenoext
	GuiControlGet,NewFileName,,Edit2
	SNDir := RegExReplace(TCPath,"[^\\]*$") . "ShellNew\"
	If Not FileExist(SNDir)
		FileCreateDir,%SNDir%
	NewFile := SNDir . NewFileName 
	FileCopy,%SrcPath%,%NewFile%,1
	Gui,Destroy
}
; 新建文件模板
FileTempNew:
	NewFile(RegExReplace(A_ThisMenuItem,".\s>>\s",RegExReplace(TCPath,"\\[^\\]*$","\shellnew\")))
return
; 新建文件
NewFile:
	NewFile()
return
NewFile(File="")
{
	Global NewFile
	If Not File
		File := RegExReplace(NewFiles[A_ThisMenuItemPos],"(.*\[|\]$)","")
	If Not FileExist(File)
	{
		RegRead,ShellNewDir,HKEY_USERS,.default\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders
		If Not ShellNewDir
			ShellNewDir := "C:\windows\Shellnew"
		File := ShellNewDir . "\" file
		If RegExMatch(SubStr(file,-7),"NullFile")
		{
			fileext := RegExReplace(NewFiles[A_ThisMenuItemPos],"(.*\(|\).*)")
			File := "New" . fileext
			FileName := "New" . fileext
			FileNamenoext := "New"
		}
	}
	Else
		Splitpath,file,filename,,fileext,filenamenoext
	Gui, Destroy
	Gui, Add, Text, x12 y20 w50 h20 +Center, 模板源
	Gui, Add, Edit, x72 y20 w300 h20 Disabled, %file%
	Gui, Add, Text, x12 y50 w50 h20 +Center, 新建文件
	Gui, Add, Edit, x72 y50 w300 h20 , %filename%
	Gui, Add, Button, x162 y80 w90 h30 gNewFileOk default, 确认(&S)
	Gui, Add, Button, x282 y80 w90 h30 gNewFileClose , 取消(&C)
	Gui, Show, w400 h120, 新建文件
	If Fileext
	{
		Controlget,nf,hwnd,,edit2,A
		PostMessage,0x0B1,0,Strlen(filenamenoext),Edit2,A
	}
	return
}
; 关闭新建文件窗口
NewFileClose:
	Gui,Destroy
return

; 确认新建文件
NewFileOK:
	NewFileOK()
return
NewFileOK()
{
	GuiControlGet,SrcPath,,Edit1
	GuiControlGet,NewFileName,,Edit2
	ClipSaved := ClipboardAll
	Clipboard := 
	GoSub,<cm_CopySrcPathToClip>
	ClipWait,2
	If clipboard
		DstPath := Clipboard
	Else
		Return
	clipboard := ClipSaved
		If RegExMatch(DstPath,"^\\\\计算机$")
		Return
	If RegExMatch(DstPath,"i)\\\\所有控制面板项$")
		Return
	If RegExMatch(DstPath,"i)\\\\Fonts$")
		Return
	If RegExMatch(DstPath,"i)\\\\网络$")
		Return
	If RegExMatch(DstPath,"i)\\\\打印机$")
		Return
	If RegExMatch(DstPath,"i)\\\\回收站$")	
		Return
	If RegExmatch(DstPath,"^\\\\桌面$")
		DstPath := A_Desktop
	NewFile := DstPath . "\" . NewFileName
	If FileExist(NewFile)
	{
		MsgBox, 4, 新建文件, 新建文件已存在，是否覆盖？
		IfMsgBox No
			Return
	}
		FileCopy,%SrcPath%,%NewFile%,1
	Gui,Destroy
	WinActivate,AHK_CLASS TTOTAL_CMD
	ControlGetFocus,FocusCtrl,AHK_Class TTOTAL_CMD
	IF RegExMatch(FocusCtrl,TCListBox)
	{
		GoSub,<cm_RereadSource>
		ControlGet,Text,List,,%FocusCtrl%,AHK_CLASS TTOTAL_CMD
		Loop,Parse,Text,`n
		{
			If RegExMatch(A_LoopField,NewFileName)
			{
				Index := A_Index - 1 
				Postmessage,0x19E,%Index%,1,%FocusCtrl%,AHK_CLASS TTOTAL_CMD
				Break
			}
		}
	}
}
;============================================================================
; ReadNewFile()
; 新建文件菜单
ReadNewFile()
{
	NewFiles[0] := 0
	SetBatchLines -1
	Loop,HKEY_CLASSES_ROOT ,,1,0
	{
		If RegExMatch(A_LoopRegName,"^\..*")
		{
			Reg := A_LoopRegName
			Loop,HKEY_CLASSES_ROOT,%Reg%,1,1
			{
				If RegExMatch(A_LoopRegName,"i)shellnew")
				{
					NewReg := A_LoopRegSubKey "\shellnew"
					If RegGetNewFilePath(NewReg)
					{
						NewFiles[0]++
						Index := NewFiles[0]
						NewFiles[Index] := RegGetNewFileDescribe(Reg) . "(" . Reg . ")[" . RegGetNewFilePath(NewReg) . "]"
					}
				}
			}
		}
	}
	LoopCount := NewFiles[0]
	Half := LoopCount/2
	Loop % LoopCount
	{
		If A_Index < %Half% 
		{
			B_Index := NewFiles[0] - A_Index + 1
			C_Index := NewFiles[A_Index]
			NewFiles[A_Index] := NewFiles[B_Index]
			NewFiles[B_Index] := C_Index
		}
	}
	Menu,CreateNewFile,UseErrorLevel,On
	Loop % NewFiles[0]
	{
		File := RegExReplace(NewFiles[A_Index],"\(.*","")
		Exec := RegExReplace(NewFiles[A_Index],"(.*\(|\)\[.*)","")
		MenuFile := Chr(A_Index+64) . " >> " . File . "(" Exec . ")"
		Menu,CreateNewFile,Add,%MenuFile%,NewFile

		IconFile := RegGetNewFileIcon(Exec)
		IconFIle := RegExReplace(IconFile,"i)%systemroot%",A_WinDir)
		IconFilePath := RegExReplace(IconFile,",-?\d*","")
		If Not FileExist(IconFilePath)
			IconFilePath := ""
		IconFileIndex := RegExReplace(IconFile,".*,","")
		If Not RegExMatch(IconFileIndex,"^-?\d*$")
			IconFileIndex := ""
		If RegExMatch(Exec,"\.lnk")
		{
			IconFilePath := A_WinDir . "\system32\Shell32.dll"
			IconFileIndex := "264"
		}
		Menu,CreateNewFile,Icon,%MenuFile%,%IconFilePath%,%IconFileIndex%
	}
}
; 获取新建文件的源
; reg 为后缀
RegGetNewFilePath(reg)
{
	RegRead,GetRegPath,HKEY_CLASSES_ROOT,%Reg%,FileName
	IF Not ErrorLevel
		Return GetRegPath
	RegRead,GetRegPath,HKEY_CLASSES_ROOT,%Reg%,NullFile
	IF Not ErrorLevel
		Return "NullFile"
}
; RegGetNewFileType(reg) 
; 获取新建文件类型名
; reg 为后缀
RegGetNewFileType(reg)
{
	RegRead,FileType,HKEY_CLASSES_ROOT,%Reg%
	If Not ErrorLevel
		Return FileType
}
; 获取文件描述
; reg 为后缀
RegGetNewFileDescribe(reg)
{
	FileType := RegGetNewFileType(reg)
	RegRead,FileDesc,HKEY_CLASSES_ROOT,%FileType%
	If Not ErrorLevel
		Return FileDesc
}
; 获取文件对应的图标
; reg 为后缀
RegGetNewFileIcon(reg)
{
	IconPath := RegGetNewFileType(reg) . "\DefaultIcon"
	RegRead,FileIcon,HKEY_CLASSES_ROOT,%IconPath%
	If Not ErrorLevel
		Return FileIcon
}
; <GoToParentEx> {{{1
; 返回到上层文件夹，可返回到我的电脑
<GoToParentEx>:
	IsRootDir()
	GoSub,<cm_GoToParent>
return
IsRootDir()
{
	ClipSaved := ClipboardAll
	clipboard := 
	GoSub,<cm_CopySrcPathToClip>
	ClipWait,1
	Path := Clipboard
	Clipboard := ClipSaved
	If RegExMatch(Path,"^.:\\$")
	{
		GoSub,<cm_OpenDrives>
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
