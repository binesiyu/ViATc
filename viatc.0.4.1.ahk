;viatc-0.4.1.ahk : VIM Mode For Total Commander 7.5+ Version 0.3
;By linxinhong
;Date 2012-01-30
;mailto lin.xh@lve.cn

; Init Script {{{1
;=======================================
#SingleInstance Force
#Persistent
#NoTrayIcon
#NoEnv

Process, Priority, , High
SetDefaultMouseSpeed,0
SetkeyDelay,-1
DetectHiddenWindows,On

;}}}
; defend var {{{1
;=======================================
; Global var {{{2
Version := "0.4.1"
VimMode := 1
KeyCount:= 0
GroupKey :=
ThisGroup :=
KeyTemp :=
; Control var {{{2
EnableTrayON :=
MaxKeyCount :=
; onekey=>0  munlkey=>1 groupkey=>2 sendcm=>3
Okey := 0
Mkey := 1
Gkey := 2
Skey := 3
IsCmd:= 0
; array def {{{2
;NumArray := Object()
Loop,10
{
	NumArray[%A_Index%] := A_Index -1 
}

Gosub L_READINI
; Init Tray {{{1
;======================================
Menu,Tray,Add,%traytext1%,l_OPENTC
Menu,Tray,Add,%traytext2%,l_EXPLORER
Menu,Tray,Add,%traytext3%,L_HELP
Menu,Tray,Add,%traytext4%,L_OPTIONS
Menu,Tray,add,%traytext5%,L_ExitViatc
Menu,Tray,Default,%traytext1%
settimer,L_AUTHTC,500
If A_IsCompiled
{
	Menu,Tray,NoStandard
}
Else
{
	Menu,Tray,icon,%A_WorkingDir%\viatc.ico
}
If !GetTrayON
	GoSub,L_OPENTC
; Hotkey def {{{1
;=======================================
;HotKeydef:
;{
; Sys Key {{{2

#IfWinActive 

#e::
	GoSub,L_OPENTC
return

#IfWinActive ahk_class TTOTAL_CMD

!`::
	VimMode := !VimMode
	if VimMode 
		TrayTip,,%traytiptext2%,10,1
	
	else
		TrayTip,,%traytiptext1%,10,1
	;Suspend
return

; Number Key {{{2
1::
	f_key(1,1,Mkey)
return
2::
	f_key(2,2,Mkey)
return
3::
	f_key(3,3,Mkey)
return
+3::
	f_key("#",3312,Skey)
return
4::
	f_key(4,4,Mkey)
return
+4::
	f_key("$",3314,Skey)
return
5::
	f_key(5,5,Mkey)
return
+5::
	f_key("%",3313,Skey)
return
6::
	f_key(6,6,Mkey)
return
+6::
	f_key("^",3315,Skey)
return
7::
	f_key(7,7,Mkey)
return
+7::
	f_key("&",541,Skey)
return
8::
	f_key(8,8,Mkey)
return
+8::
	f_key("*",542,Skey)
return
9::
	f_key(9,9,Mkey)
return
+9::
	f_key("(",527,Skey)
return
0::
	f_key(0,0,Mkey)
return
+0::
	f_key(")",528,Skey)
return

; Base Key {{{2
q::
	f_key("q",304,Skey)
return
+q::
	f_key("+q","+q",Okey)
return
+w::
	f_key("+w",534,Skey)
return
w::
	f_key("w",533,Skey)
return
+e::
	f_key("+e",511,Skey)
return
e::
	f_key("e",2500,Skey)
return
+p::
	f_key("+p",509,Skey)
return
p::
	f_key("p",508,Skey)
return
+t::
	f_key("+t",3002,Skey)
return
t::
	f_key("t",3001,Skey)
return
+n::
	f_key("+n",495,Skey)
return
n::
    	IniRead,temp_map_key,%ini_file%,Mapkey,map
	context :=
	loop,parse,temp_map_key,`,
	{
		Iniread,get_usr_cmd,%INI_File%,Mapkey,%A_LoopField%
		context := context . A_LoopField . A_Space . "=" . A_Space . get_usr_cmd . "`n"
	}
	if temp_map_key
		f_key("n",temp_map_key,Gkey)
	else
		f_key("n","n",Okey)
return
+a::
	f_key("+a",507,Skey)
return
a::
	f_key("a",502,Skey)
return

j::
	f_key("j","{Down}",Mkey)
return

+j::
	f_key("+j","+{Down}",MKey)
return

k::
	f_key("k","{up}",Mkey)
return

+k::
	f_key("+k","+{up}",Mkey)
return

h::
	f_key("h","{Left}",Mkey)
return

+h::
	f_key("+h","!{Left}",OKey)
return

l::
	f_key("l","{Right}",Mkey)
return

+l::
	f_key("+l","!{Right}",Okey)
return

+f::
	f_key("+f","+f",Okey)
return
f::
	f_key("f","{PgDn}",Okey)
return

g::
	context := context_g
	f_key("g","gg,gG,gn,gN,gl,gL,gt,gT,gc,gC,g1,g2,g3,g4,g5,g6,g7,g8,g9",Gkey)
return

+g::
	f_key("+g","{Down}",Mkey)
return

+b::
	f_key("+b","+b",Okey)
return
b::
	f_key("b","{PgUp}",Okey)
return

+d::
	f_key("+d","+d",Okey)
return
d::
	ControlGetFocus,vartln,ahk_class TTOTAL_CMD
	Stringleft,vartln,vartln,7
	If vartln = TInEdit
		f_key("d","{BS}",MKey)
	else
		f_key("d",526,Skey)
	GetSysShadow := 1
return
+z::
	f_key("+z","+z",Okey)
return
z::
	context := context_z
	f_key("z","zz,zi,zo,zm,zn,zr,zt,zv",Gkey)
return
+c::
	f_key("+c","+c",Gkey)
return
c::
	context := context_c
	f_key("c","cr,cl,cc",Gkey)
return
o::
	f_key("o",131,Skey)
return
+o::
	f_key("+o",231,SKey)
return
y::
	f_key("y",2017,Skey)
return
+y::
	f_key("+y",2018,Skey)
return
r::
	f_key("r",1002,SKey)
return
+r::
	f_key("+r",2400,Skey)
return
u::
	f_key("u","{Backspace}",Okey)
return
+u::
	f_key("+u",2001,Skey)
return
i::
	f_key("i","i",Gkey)
;	if IsCmd = 1
;	If A_IsCompiled
;		f_key("i","i",Okey)
;	else
;		f_key("i","!{i}",Okey)
;	ControlGetFocus,vartln,ahk_class TTOTAL_CMD
;	Stringleft,vartln,vartln,7
;	If vartln = TInEdit
;		IsCmd = 1
return
+i::
	f_key("+i",907,Skey)
return
+v::	
	context := context_v
	f_key("+v","Vb,Vd,Vo,Vl,Vi,Vr,Vc,Vp,Vt,Vs,Vn,Vf,Vw,Vx,Va,Vh",Gkey)
return
v::	
	f_key("v",270,Skey)
	GetSysShadow := 0
return
x::
	ControlGetFocus,vartln,ahk_class TTOTAL_CMD
	Stringleft,vartln,vartln,7
	If vartln = TInEdit
		f_key("x","{del}",Mkey)
	else
		f_key("x","{del}",Okey)
return
+x::
	f_key("+x","+{del}",Okey)
return
+s::
	f_key("+s","+s",Okey)
return
s::
	context := context_s
	f_key("s","sn,sd,se,ss,sr,s1,s2,s3,s4,s5,s6,s7,s8,s9",Gkey)
return
m::
	f_key("m","m",GKey)
	;if GroupKey
	;	f_key("m","m",Okey)
	;else
	;{
	;	if !IsCmd 
	;	{
	;		Controlsettext,edit1,Mark: ,ahk_class TTOTAL_CMD
	;		PostMessage 1075, 4003, 0, , ahk_class TTOTAL_CMD
;			send {Right}
;		}
;		else
;			f_key("m","m",Okey)
;		IsCmd := 1
;	}
return

+m::
	f_key("+m","+m",Okey)
return

'::
	
	f_key("'","'",Gkey)
;	If GroupKey ;因为带有IsCmd，所以要做判断，保证不影响GroupKey的功能
;		f_key("'","'",Okey)
;	else
;	{
;		if !IsCmd 
;		{
;			Controlsettext,edit1,GetMark: ,ahk_class TTOTAL_CMD
;			PostMessage 1075, 4003, 0, , ahk_class TTOTAL_CMD
;			send {Right}
;		}
;		else
;			f_key("'","'",Okey)
;		IsCmd := 1
;	}
return

; other key {{{2
*Esc::
	TrayTip
	ControlGetFocus,vartln,ahk_class TTOTAL_CMD
	Stringleft,vartln,vartln,7
	If vartln = TInEdit 
		if IsCmd = 1
			IsCmd = 0
		else
		{
			Okey := 0
			Mkey := 1
			Gkey := 2
			Skey := 3
			IsCmd := 0
			KeyTemp := 
			KeyCount := 0
    			Gui,Destroy
			Tooltip
			Send {Esc}
		}
	else
		{
			Okey := 0
			Mkey := 1
			Gkey := 2
			Skey := 3
			IsCmd := 0
			KeyTemp := 
			KeyCount := 0
			Groupkey :=
    			Gui,Destroy
			Tooltip
			Send {Esc}
		}
Return

;*BackSpace::
	
;return

Enter::
	If IsCmd
		f_cmdEnter()
	else
		send {Enter}
return

`;::
	f_key(";","",Okey)
	ControlGetFocus,vartln,ahk_class TTOTAL_CMD
	Stringleft,vartln,vartln,7
	If vartln = TInEdit
		IsCmd = 1
	else
	{
		IsCmd = 1
		ControlFocus,Edit1,ahk_class TTOTAL_CMD
	}
return

:::
	ControlGetFocus,vartln,ahk_class TTOTAL_CMD
	Stringleft,vartln,vartln,7
	If vartln = TInEdit
		IsCmd = 1
	else
	{
		IsCmd := 1
		Controlgetpos,xe,ye,we,he,edit1,ahk_class TTOTAL_CMD
		tooltip,%context_colon%,xe,ye-230
		ControlFocus,Edit1,ahk_class TTOTAL_CMD
	}
	f_key(":",":",Okey)
return

/::
	f_key("/",2915,Skey)
return

+/::
	f_key("?",501,Skey)
return
+-::
	f_key("+-","+-",Okey)
return
-::
	f_key("-","-",Okey)
return
+=::
	f_key("+=","+=",Okey)
return
=::
	f_key("=",532,Skey)
return
+[::
	f_key("+[",521,Skey)
return
[::
	f_key("[",523,Skey)
return
+]::
	f_key("+]",522,Skey)
return
]::
	f_key("]",538,Skey)
return
+\::
	f_key("+\",2023,Skey)
return
\::
	f_key("\",525,Skey)
return
+,::
	f_key("+,","+,",Okey)
return
,::
	f_key(",",530,Skey)
return
+.::
	f_key("+.","+.",Okey)
return
.::
	f_key(".",529,Skey)
return
+`::
	f_key("+``",582,Skey)
	TrayTip,,%traytiptext3%,10,1
return
`::
	f_key("``",572,Skey)
return

;}
; Helptxt {{{2
#IfWinActive ViATcHelp
j::
	GuiControlGet,outputvar,,SysTabControl321
	If Outputvar = Introduce
		GuiControl,Focus,Edit1
	If Outputvar = HotkeyList
		GuiControl,Focus,Edit2
	If Outputvar = CommandList
		GuiControl,Focus,Edit3
	If Outputvar = About
		GuiControl,Focus,Edit4
	send {down}
return
k::
	GuiControlGet,outputvar,,SysTabControl321
	If Outputvar = Introduce
		GuiControl,Focus,Edit1
	If Outputvar = HotkeyList
		GuiControl,Focus,Edit2
	If Outputvar = CommandList
		GuiControl,Focus,Edit3
	If Outputvar = About
		GuiControl,Focus,Edit4
	send {up}
return
h::
	GuiControl,Focus,SysTabControl321
	send {Left}
return
l::
	GuiControl,Focus,SysTabControl321
	send {Right}
return
#IfWinActive 
; Label def {{{1
;===========================================================
; L_READINI {{{2
L_READINI:
{
	TC_INI := A_WorkingDir . "\wincmd.ini"
	INI_File := A_WorkingDir . "\viatc.ini"
	IF(! FileExist(INI_File))
	{
		IniWrite,1,%INI_File%,Setting,TrayON
		IniWrite,1,%INI_File%,Setting,VimMode
		IniWrite,EN,%INI_File%,Setting,Language
		IniWrite,%A_WorkingDir%\TOTALCMD.EXE,%INI_File%,Setting,TCPath
		IniWrite,99,%INI_File%,Setting,MaxKeyCount
	}
	IniRead,GetTrayON,%A_WorkingDir%\viatc.ini,Setting,TrayON
	If GetTrayON = error 
	{
		GetTrayON := 1
		IniWrite,%GetTrayON%,%INI_File%,Setting,TrayON
	}
	IniRead,GetVimMode,%A_WorkingDir%\viatc.ini,Setting,VimMode
	If GetVimMode = error
	{
		GetVimMode := 1
		IniWrite,%GetVimMode%,%INI_File%,Setting,VimMode
	}
	IniRead,GetLanguage,%A_WorkingDir%\viatc.ini,Setting,Language
	If GetLanguage = error
	{
		GetLanguage := "EN"
		IniWrite,%GetLanguage%,%INI_File%,Setting,Language
	}
	IniRead,GetTCPath,%A_WorkingDir%\viatc.ini,Setting,TCPath
	If GetTCPath = error
	{
		GetTCPath := A_WorkingDir . "\TOTALCMD.EXE"
		IniWrite,%GetTCPath%,%INI_File%,Setting,TCPath
	}
	IniRead,MaxKeyCount,%A_WorkingDir%\viatc.ini,Setting,MaxKeyCount
	If MaxKeyCount = error
	{
		MaxKeyCount := 99
		IniWrite,%MaxKeyCount%,%INI_File%,Setting,MaxKeyCount
	}
	If GetLanguage = EN
	{
		optiontext1 := "Language"
		optiontext2 := "Enable Tray(&T)"
		optiontext3 := "Enable Vim Mode(&V)"
		findtext1 := "Select TotalCommander Path:"
		findtext2 := "OK (&O)"
		findtext3 := "Browse(&B)"
		findtext4 := "Cancel(&C)"
		TrayTiptext1 := "Disable Vim Mode"
		TrayTiptext2 := "Enable Vim Mode"
		TrayTiptext3 := "History Saved"
		Traytext1 := "Run TC(&R)"
		Traytext2 := "Explorer(&E)"
		Traytext3 := "Help(&H)"
		Traytext4 := "Options(&O)"
		Traytext5 := "Exit(&X)"
		DELRH := "Delete right history . Are you sure ?"
		DELLH := "Delete Left history . Are you sure ?"
		DELCH := "Delete command history . Are you sure ?"
		LngChk := 1
		context_g := "gt : Switch to next Tab`ngT : Switch to previous Tab`ngc : Close tab`ngC : Close all tab`ngg : Swap panels`ngG : Swap all Tabs`ngn : Open dir under cursor in tab`ngN : Open dir under cursor (other window)`ngl : Turn on/off tab locking`ngL : Same gl but with dir changes allowed`ng1 : Activate first tab`ng2 : Activate second tab`n……`ng9 : Activate 9th tab`n"
		context_z := "zm : Maximize TC`nzn : Minimum TC`nzr : Restore TC`nzi : Maximize the right panel`nzo : Maximize the left panel`nzz : Split panel window`nzv : Vertical　arrangment"
		context_c := "cl : Clear left history`ncr : Clear right history`ncc : Clear command history"
		context_V := "Vb : Show/Hide button bar`nVd : Show/Hide drive buttons`nVo : Show/Hide two drive button bars`nVl : Flat icons`nVi : Flat user interface(button bar configured separately`nVr : Show/Hide drive combobox`nVw : Show/Hide folder tabs`nVc : Show/Hide current directory`nVp : Show/Hide clickable path parts('breadcrumb bar')`nVa : Auto-open when moving mouse over it`nVh : Show/Hide buttons for history list and hotlist`nVt : Show/Hide tabstop header`nVs : Show/Hide status bar`nVn : Show/Hide command line`nVf : Show/Hide function key buttons`nVx : Windows XP theme background(menu+all bars)"
		context_s := "sn : sort by file name `nse : Sort by extension`nsd : Sort by date`nss : Sort by size`nsr : Reverse　order`ns1 : Sort by 1st Column `ns2 : Sort by 2nd Column `n…… `ns9 : Sort by 9th Column"
		context_colon := ":help Open VIATC help window`n:set Open VIATC options`n:config Open TC options`n:q Quit viatc`n:w Save the current selection`n:r Restore the current selection`n:d Delete saved selection`n:! Open a command line (CMD.exe)`n:pwd Show current path`n:top Turn on/off Always on Top`n:download Background transfer manager`n:sy Synchronize directories`n:lm view all marks"
	}
	If GetLanguage = CN
	{
		optiontext1 := "语言"
		optiontext2 := "启用任务栏图标(&T)"
		optiontext3 := "启用VIM模式(&V)"
		findtext1 := "请选择TotalCommander的路径:"
		findtext2 := "确定(&O)"
		findtext3 := "浏览(&B)"
		findtext4 := "取消(&C)"
		TrayTiptext1 := "禁用VIM模式"
		TrayTiptext2 := "启用VIM模式"
		TrayTiptext3 := "文件夹历史已保存"
		Traytext1 := "运行TC(&R)"
		Traytext2 := "资源管理器(&E)"
		Traytext3 := "帮助(&H)"
		Traytext4 := "选项(&O)"
		Traytext5 := "退出(&X)"
		DELRH := "确定删除右面板历史?"
		DELLH := "确定删除左面板历史?"
		DELCH := "删除命令行历史?"
		LngChk := 2
		context_g := "gg : 交换左右窗口`ngG : 交换左右窗口及标签`ngn : 新建标签(并打开光标处的文件夹)`ngN : 新建标签(在另一窗口打开文件夹)`ngl : 锁定/解锁当前标签`ngL : 锁定/解锁当前标签(可改变文件夹)`ngt : 转到下一个标签`ngT : 转到上一个标签`ngc : 关闭当前标签`ngC : 关闭所有标签`ng1 : 激活标签1`ng2 : 激活标签2`n…… 依此类推`ng9 : 激活标签9`"
		context_z := "zm : 最大化TC`nzn : 最小化TC`nzr : 恢复TC正常`nzi : 最大化右面板`nzo : 最大化左面板`nzz : 平分面板窗口`nzt : 顶置/取消顶置TC`nzv : 纵向排列`n"
		context_c := "cr : 清空左面板文件夹历史(需要重启TC)`ncl : 清空右面板文件夹历史(需要重启TC)`ncc : 清空命令行历史(需要重启TC)"
		context_V := "Vb : 显示/隐藏工具栏`nVd : 显示/隐藏驱动器按钮`nVo : 显示/隐藏两个驱动器按钮栏`nVl : 切换:平坦/立体驱动器按钮`nVr : 显示/隐藏驱动器列表`nVw : 显示/隐藏文件夹标签`nVc : 显示/隐藏当前文件夹栏`nVp : 显示/隐藏路径导航栏`nVa : 光标位于可点击部分之上时自动显示文件夹列表`nVh : 显示/隐藏文件夹历史和常用文件夹按钮`nVt : 显示/隐藏排序制表符`nVs : 显示/隐藏状态栏`nVn : 显示/隐藏命令行`nVf : 显示/隐藏功能键按钮`nVi : 切换:平坦/立体用户界面`nVx : 显示/隐藏XP主题背景"
		context_s := "sn : 按文件名排序`nse : 按扩展名排序`nsd : 按日期排序`nss : 按大小排序`nsr : 反向排序`ns1 : 按第1列排序`ns2 : 按第2列排序`n…… 依此类推`ns9 : 按第9列排序"
		context_colon := ":help 打开VIATC帮助`n:set  打开VIATC选项`n:config 打开TC选项`n:q    退出viatc`n:w    保存当前选择列表`n:r    恢复当前选择列表`n:d    删除保存的选择列表`n:!    打开命令行(CMD)`n:pwd  查看当前路径`n:top  设置/取消顶置TC`n:download  后台传输管理器`n:sy   同步文件夹`n:lm 查看所有标记"
	}
	If GetTrayON
	{
		SetTimer,L_DEAMON,off
		Menu,Tray,Icon
	}
	else
	{
		SetTimer,L_DEAMON,500
		Menu,Tray,NoIcon
	}
	VimMode := GetVimMode
	;GoSub,L_OPENTC
	return
}

; L_OPENTC {{{2
L_OPENTC:
{
	IFWinExist ahk_class TTOTAL_CMD
	{
		WinActivate ahk_class TTOTAL_CMD
		ControlSetText,Edit1,,ahk_class TTOTAL_CMD
	}
	Else
	{
		IF FileExist(GetTCPath)
		{
			Run %GetTCPath%
			;WinWait,ahk_class TTOTAL_CMD,5
;			GoSub,L_AUTHTC
			;If ErrorLevel
			;{
			;	Msgbox,17,Viatc, Run TotalCMD Fail ! Retry?
			;	IFMsgBox Yes
			;		GoSub L_OPENTC
			;	Else
			;		GoSub L_ExitViatc	
			;}
			WinActivate ahk_class TTOTAL_CMD
		}
		Else
			GoSub L_FINDTCPATH
	}	
	RegRead,GetTitle,HKEY_CURRENT_USER,Software\Ghisler\Total Commander,ViATc
	If ErrorLevel
	{
		RegWrite,REG_SZ,HKEY_CURRENT_USER,Software\Ghisler\Total Commander,ViATc,%Version%
		GoSub,L_Help
	}
	Return
}
; L_ExitViatc {{{2
L_ExitViatc:
{
	ExitApp
	Return
}
; L_DEAMON {{{2
L_DEAMON:
{
	IfWinNotExist ahk_class TTOTAL_CMD
	If !GetTrayON
		GoSub,L_ExitViatc
	return
}
; L_OPTIONS {{{2
L_OPTIONS:
{
	Gui, Destroy
	Gui, Add, Checkbox, h20 w130 vEnableTrayON  gCheckTrayON , %optiontext2%
        Gui, Add, Checkbox, h20 w130 vEnableVimMode gCheckVimMode, %optiontext3%
	Gui, Add, text,h20 y+9 w60 left vlngtxt ,%optiontext1%
	Gui, Add, DropDownList,AltSubmit R2 h20 w70 xp+50 yp-3 vlngsel choose%lngchk% gLanguage,English|简体中文
	GoSub,L_READINI
	If GetTrayON
		GuiControl,,EnableTrayON,1
	Else
		GuiControl,,EnableTrayON,0
	If GetVimMode
		GuiControl,,EnableVimMode,1
	Else
		GuiControl,,EnableVimMode,0
	Gui, Show,w170,ViATc Options
	GoSub L_READINI
	return
}
; L_FINDTCPATH {{{2
L_FINDTCPATH:
{
	Gui, Destroy
    	Gui, Add, Text, w260 ,%findtext1%
    	Gui, Add, Edit, w200 vname,
    	Gui, Add, Button, xp+210 yp-2  w60 gButtonOK  Defualt ,%findtext2%
    	Gui, Add, Button, xp-70  yp+26 w60 gButtonBrowse      ,%findtext3%
    	Gui, Add, Button, xp+70        w60 gButtonCancel      ,%findtext4%
   	Gui, Show,,ViATc
	Return
}
; L_WRITELIST {{{2
L_WRITELIST:
{
    ClipSaved := ClipboardAll ;保存原来剪切板里的内容UserInput
    Clipboard = ;初始化剪切板
    PostMessage 1075, 2029, 0, , ahk_class TTOTAL_CMD
    ClipWait
    Location = %clipboard%
    clipboard =
    n := 1 
    TempField := 
    Loop 
    {
    	IniRead,TempField,%ini_file%,SelectHistory,%Location%%n%
    	If TempField = ERROR
        	Break
    	IniDelete,%ini_file%,SelectHistory,%Location%%n%
    	;删除当前目录的历史记录，以便添加新的选择列表
    	n++
    }
    PostMessage 1075, 2017, 0, , ahk_class TTOTAL_CMD
    ClipWait
    Loop, parse, clipboard, `n, `r
    {
    	IniWrite,%A_LoopField%,%ini_file%,SelectHistory,%Location%%A_Index%
    	;保存到INI文件
    }
    Clipboard := ClipSaved ;回复剪切板内容
    ClipSaved = 
    Return
}
; L_DELLIST {{{2
L_DELLIST:
{
    n := 1 
    TempField := 
    Loop 
    {
    	IniRead,TempField,%ini_file%,SelectHistory,%Location%%n%
    	If TempField = ERROR
       	 Break
    	IniDelete,%ini_file%,SelectHistory,%Location%%n%
    	;删除当前目录的历史记录
    	n++
    }
    Return
}
; L_READLIST {{{2
L_READLIST:
{
    ClipSaved := ClipboardAll ;保存原来剪切板里的内容
    clipboard = ;初始化剪切板
        PostMessage 1075, 2029, 0, , ahk_class TTOTAL_CMD
    ClipWait
    Location = %clipboard%
    clipboard =
    n := 1
    TempField := 
    Loop ;
    {
    	IniRead,TempField,%ini_file%,SelectHistory,%Location%%n%
    	If TempField = ERROR
       	 Break
    	Clipboard = %Clipboard%%TempField%`n
    	ClipWait
    	;将选择列表添加到剪切板里
    	n++
    }
    PostMessage 1075, 2033, 0, , ahk_class TTOTAL_CMD    
    Sleep 500
    Clipboard := ClipSaved ;回复剪切板内容
    ClipSaved = 
    Return
}
; L_HELP {{{2
L_HELP:
{
	HELP_File := A_WorkingDir . "\viatchelp.txt"
	If FileExist(HELP_File)
	{
	htn := 0
	Loop,read,%HELP_File%
	{
		If A_LoopReadLine = =========
			htn++
		If htn = 1
			If A_LoopReadLine = =========
				Helptxt1 := 
			else
				Helptxt1 := helptxt1 . A_LoopReadLine . "`n"
		If htn = 2
			If A_LoopReadLine = =========
				Helptxt2 := 
			else
				Helptxt2 := helptxt2 . A_LoopReadLine . "`n"
		If htn = 3
			If A_LoopReadLine = =========
				Helptxt3 := 
			else
				Helptxt3 := helptxt3 . A_LoopReadLine . "`n"
		If htn = 4
			If A_LoopReadLine = =========
				Helptxt4 := 
			else
				Helptxt4 := helptxt4 . A_LoopReadLine . "`n"
		If htn = 5
			If A_LoopReadLine = =========
				Helptxt5 := 
			else
				Helptxt5 := helptxt5 . A_LoopReadLine . "`n"
		If htn = 6
			If A_LoopReadLine = =========
				Helptxt6 := 
			else
				Helptxt6 := helptxt6 . A_LoopReadLine . "`n"
		If htn = 7
			If A_LoopReadLine = =========
				Helptxt7 := 
			else
				Helptxt7 := helptxt7 . A_LoopReadLine . "`n"
		If htn = 8
			If A_LoopReadLine = =========
				Helptxt8 := 
			else
				Helptxt8 := helptxt8 . A_LoopReadLine . "`n"
	}
	Gui,Destroy
	Gui,Font,s10
	Gui,+owner +AlwaysOnTop +LastFound  +Border +Theme
    	WinSet, Transparent  , 210
	Gui,Add,Tab2,w528 h440 ntaps ,Introduce|HotkeyList|CommandList|About
	If LngChk = 1
	{
	Gui,Add,Edit,w500 h400 readonly,%HelpTxt5%
	Gui,Tab,2
	Gui,Add,Edit,w500 h400 readonly,%HelpTxt6%
	Gui,Tab,3
	Gui,Add,Edit,w500 h400 readonly,%HelpTxt7%
	Gui,Tab,4
	Gui,Add,Edit,w500 h400 readonly,%HelpTxt8%
	}
	If LngChk = 2
	{
	Gui,Add,Edit,w500 h400 readonly,%HelpTxt1%
	Gui,Tab,2
	Gui,Add,Edit,w500 h400 readonly,%HelpTxt2%
	Gui,Tab,3
	Gui,Add,Edit,w500 h400 readonly,%HelpTxt3%
	Gui,Tab,4
	Gui,Add,Edit,w500 h400 readonly,%HelpTxt4%
	}
	Gui,show,,ViATcHelp
	GuiControl,Focus,SysTabControl321
	}
	else
		msgbox can't find viatchelp.txt
	return
}
; L_EXPLORER {{{2
L_Explorer:
{
	Run Explorer.exe
	return
}
; L_AUTHTC {{{2
L_AUTHTC:
{
	Ifwinexist ahk_class TNASTYNAGSCREEN
	{
	WinWait,ahk_class TNASTYNAGSCREEN,,3
        WinActivate, ahk_class TNASTYNAGSCREEN
        WinGetText, OutputVar,ahk_class TNASTYNAGSCREEN
        StringLeft,InputVar,OutputVar,11
        StringRight,OutputVar,InputVar,1
        loop
        {
            SetControlDelay -1
            if(OutputVar = 1)
            {
                ControlClick,TButton3,ahk_class TNASTYNAGSCREEN,,,,NA
                Break
            }

            if(OutputVar = 2)
            {
                ControlClick,TButton2,ahk_class TNASTYNAGSCREEN,,,,NA
                Break
            }

            if(OutputVar = 3)
            {
                ControlClick,TButton1,ahk_class TNASTYNAGSCREEN,,,,NA
                Break
            }
            Break
        }
	}
	return
}
; L_DelRH {{{2
L_DelRH:
{
	Msgbox,4,,%DELRH%
	Ifmsgbox YES
	{
		Winkill ahk_class TTOTAL_CMD
		n := 0 
    		TempField := 
    		Loop 
    		{
    			IniRead,TempField,%TC_INI%,RightHistory,%n%
    			If TempField = ERROR
       				Break
    			IniDelete,%TC_INI%,RightHistory,%n%
    			n++
    		}
		GoSub,L_OPENTC
	}
	Else
		Winactivate ahk_class TTOTAL_CMD	
	return
}
; L_DelLH {{{2
L_DelLH:
{
	Msgbox,4,,%DELLH%
	Ifmsgbox YES
	{
		Winkill ahk_class TTOTAL_CMD
		n := 0 
    		TempField := 
    		Loop 
    		{
    			IniRead,TempField,%TC_INI%,LeftHistory,%n%
    			If TempField = ERROR
       				Break
    			IniDelete,%TC_INI%,LeftHistory,%n%
    			n++
    		}	
		GoSub,L_OPENTC
	}
	Else
		Winactivate ahk_class TTOTAL_CMD	
	return
}
; L_DelCH {{{2
L_DelCH:
{
	Msgbox,4,,%DELCH%
	Ifmsgbox YES
	{
		Winkill ahk_class TTOTAL_CMD
		n := 0 
    		TempField := 
    		Loop 
    		{
    			IniRead,TempField,%TC_INI%,Command line history,%n%
    			If TempField = ERROR
       				Break
    			IniDelete,%TC_INI%,Command line history,%n%
    			n++
    		}	
		GoSub,L_OPENTC
	}
	Else
		Winactivate ahk_class TTOTAL_CMD	
	return
}
; L_SETTITLE {{{2
L_SETTITLE:
{
	IfWinExist ahk_class TTOTAL_CMD
	{
	ControlGetFocus,fcuctl,ahk_class TTOTAL_CMD
    	Controlgetpos tx1,ty1,tw1,th1,THeaderClick1,ahk_class TTOTAL_CMD
    	Controlgetpos tx2,ty2,tw2,th2,THeaderClick2,ahk_class TTOTAL_CMD
    	Controlgetpos tx3,ty3,tw3,th3,%fcuctl%,ahk_class TTOTAL_CMD
    	ControlGetPos,,,tm1W,tm1H,TPanel1,ahk_class TTOTAL_CMD
      	If (tm1w < tm1h) ; 判断纵向还是横向 Ture为竖 false为横
        If tx3 < %tx2% 
	{
	;左
		Controlgettext,title1,TMyPanel5,ahk_class TTOTAL_CMD
		Controlgettext,title2,TMyPanel6,ahk_class TTOTAL_CMD
		title := title1 . "    " . title2
	}
        else
	{
	;右
		Controlgettext,title1,TMyPanel8,ahk_class TTOTAL_CMD
		Controlgettext,title1,TMyPanel9,ahk_class TTOTAL_CMD
		title := title1 . "    " . title2
	}
        else
        If ty3 < %ty2% 
	{
	;左
		Controlgettext,title1,TMyPanel5,ahk_class TTOTAL_CMD
		Controlgettext,title1,TMyPanel6,ahk_class TTOTAL_CMD
		title := title1 . "    " . title2
	}
        else
	{
	;右
		Controlgettext,title1,TMyPanel8,ahk_class TTOTAL_CMD
		Controlgettext,title1,TMyPanel9,ahk_class TTOTAL_CMD
		title := title1 . "    " . title2
	}
;	Controlgettext,
		WinSetTitle,%Title%
	}
return
}
; L_ForceRec {{{2
L_ForceRec:
{
	ClipSaved := ClipboardAll 
    	clipboard = 
	PostMessage 1075, 2029,0, , ahk_class TTOTAL_CMD	
    	ClipWait
    	DeletePath= %clipboard%
    	clipboard = 
 	PostMessage 1075, 2017, 0, , ahk_class TTOTAL_CMD
    	ClipWait
	DeleteFiles = %clipboard%
 	PostMessage 1075, 2017, 0, , ahk_class TTOTAL_CMD
    	Loop, parse, DeleteFiles, `n, `r
    	{
		Filerecycle,%DeletePath%\%A_loopField%
    	}
    	Clipboard := ClipSaved 
    	ClipSaved = 
return
}
; L_ForceDel {{{2
L_ForceDel:
{
	ClipSaved := ClipboardAll 
    	clipboard = 
	PostMessage 1075, 2029,0, , ahk_class TTOTAL_C    	ClipWait
    	DeletePath= %clipboard%
    	clipboard = 
 	PostMessage 1075, 2017, 0, , ahk_class TTOTAL_CMD
    	ClipWait
	DeleteFiles = %clipboard%
    	Loop, parse, DeleteFiles, `n, `r
    	{
		FileDelete,%DeletePath%\%A_loopField%
    	}
    	Clipboard := ClipSaved 
    	ClipSaved = 
return
}
; L_FroceCopy {{{2
L_FroceCopy:
{
	ClipSaved := ClipboardAll 
    	clipboard = 
	PostMessage 1075, 2029,0, , ahk_class TTOTAL_CMD	
    	ClipWait
    	CopySrcPath= %clipboard%

    	clipboard = 
	PostMessage 1075, 2030,0, , ahk_class TTOTAL_CMD	
    	ClipWait
    	CopyDesPath= %clipboard%

    	clipboard = 
 	PostMessage 1075, 2017, 0, , ahk_class TTOTAL_CMD
    	ClipWait
	CopyFiles = %clipboard%

    	Loop, parse, CopyFiles, `n, `r
    	{
		Stringright,IsDir,A_LoopField,1
		If IsDir = \
		{
			
			Stringleft, Dirs, A_LoopField ,strlen(A_LoopField)-1
			SplitPath, Dirs , SFN
			FileCopyDir,%CopySrcPath%\%Dirs%,%CopyDesPath%\%SFN%,1

			If ErrorLevel
				Msgbox error
		}
		else
		{
			FileCopy,%CopySrcPath%\%A_LoopField%,%CopyDesPath%,1
		}
    	}

    	Clipboard := ClipSaved 
    	ClipSaved = 
return
}
; L_FroceMove {{{2
L_FroceMove:
{
	ClipSaved := ClipboardAll 
    	clipboard = 
	PostMessage 1075, 2029,0, , ahk_class TTOTAL_CMD	
    	ClipWait
    	MoveSrcPath= %clipboard%

    	clipboard = 
	PostMessage 1075, 2030,0, , ahk_class TTOTAL_CMD	
    	ClipWait
    	MoveDesPath= %clipboard%

    	clipboard = 
 	PostMessage 1075, 2017, 0, , ahk_class TTOTAL_CMD
    	ClipWait
	MoveFiles = %clipboard%

    	Loop, parse, MoveFiles, `n, `r
    	{
		Stringright,IsDir,A_LoopField,1
		If IsDir = \
		{
			
			Stringleft, Dirs, A_LoopField ,strlen(A_LoopField)-1
			SplitPath, Dirs , SFN
			FileMoveDir,%MoveSrcPath%\%Dirs%,%MoveDesPath%\%SFN%,1

			If ErrorLevel
				Msgbox error
		}
		else
		{
			FileMove,%MoveSrcPath%\%A_LoopField%,%MoveDesPath%,1
		}
    	}

    	Clipboard := ClipSaved 
    	ClipSaved = 
return
}
; L_ListMark {{{2
L_ListMark:
{
		Tooltiplm :=
		IniRead,ms,%A_WorkingDir%\viatc.ini,mark,ms
		h := 0
		loop, Parse , ms , `,
		{
			h++
			Iniread,lm,%A_WorkingDir%\viatc.ini,mark,%A_LoopField%
			if lm != ERROR
				tooltiplm = %tooltiplm%%A_LoopField%`=%lm%`n
		}	
		Controlgetpos,xe,ye,we,he,edit1,ahk_class TTOTAL_CMD
		tooltip,%Tooltiplm%,xe,ye-h*16-5
		return
}
; ButtonOK {{{2
ButtonOK:
{
	If FileExist(name)
	{	
		IniWrite,%name%,%INI_File%,Setting,TCPath
		Gui,Destroy
		;Run %name%
		GoSub L_READINI
		GoSub,L_OPENTC
	}
	Else
		Msgbox "TC Path Error"
	return
}
; ButtonBrowse {{{2
ButtonBrowse:
{
	FileSelectFile,name,1,,Open TotalCMD,TOTALCMD.EXE
	GuiControl,,Edit1,%Name%
	return
}
; ButtonCancel {{{2
ButtonCancel:
{
	Gui, Destroy
	return
}
; CheckTrayON {{{2
CheckTrayON:
{
	GuiControlGet,VarTrayON,,EnableTrayON
	INIWrite,%VarTrayON%,%INI_File%,Setting,TrayON
	GoSub,L_READINI
	return	
}
; CheckVimMode {{{2
CheckVimMode:
{
	GuiControlGet,VarVimMode,,EnableVimMode
	INIWrite,%VarVimMode%,%INI_File%,Setting,VimMode
	GoSub,L_READINI
	return
}
; CheckLanguage {{{2
Language:
{
	GuiControlGet,LngChk,,LngSel
	If LngChk = 1
		LngTemp := "EN"
	If LngChk = 2
		LngTemp := "CN"
	Iniwrite,%LngTemp%,%INI_File%,Setting,Language
	tt1 := traytext1			
	tt2 := traytext2			
	tt3 := traytext3			
	tt4 := traytext4			
	tt5 := traytext5			

	GoSub,L_READINI
	Guicontrol,text,Lngtxt,%optiontext1%
	Guicontrol,text,EnableTrayOn,%optiontext2%
	Guicontrol,text,EnableVimMode,%optiontext3%

	Menu,Tray,rename,%tt1%,%traytext1%,l_OPENTC
	Menu,Tray,rename,%tt2%,%traytext2%,l_EXPLORER
	Menu,Tray,rename,%tt3%,%traytext3%,L_HELP
	Menu,Tray,rename,%tt4%,%traytext4%,L_OPTIONS
	Menu,Tray,rename,%tt5%,%traytext5%,L_ExitViatc
	Menu,Tray,Default,%traytext1%

	return
}
; GuiEscape {{{2
GuiEscape:
{
    	Gui,Destroy
	Ifwinactive Breaker
		Winactivate Breaker
	Else	
    		WinActivate ahk_class TTOTAL_CMD
    return
}
; function def {{{1
;===========================================================
; f_key {{{2
f_key(defkey,vimkey,keymode)
{
	Global VimMode
	Global KeyCount
	Global MaxKeyCount
	Global GroupKey
	Global ThisGroup
	Global GetSysShadow
	Global IsCmd
	Global KeyTemp
	Global syssd
	Global context
	
	IsNum := 0
	WinGet,syssd,id,ahk_class #32768
	If (syssd And GetSysShadow) OR IsCmd
		KeyMode = 4
	If KeyMode = 2
		If !GroupKey ;GroupKey收集按下的键来形成组合键
		{
			ThisGroup := Vimkey  ;模式为GKey，且GroupKey空时，才定义ThisGroup
			;ControlSetText,Edit1,,ahk_class TTOTAL_CMD
			Controlgetpos,xe,ye,we,he,edit1,ahk_class TTOTAL_CMD
			;If ThisGroup = m OR ThisGroup = ' OR ThisGroup = i
			If ThisGroup = m
				context := 
			If ThisGroup = '
				context := 
			If ThisGroup = i
				context := 
			If ( VimMode = 0 )
				Context := 
			tooltip,%context%,xe+20,ye+he
		}
	If GroupKey 
		KeyMode = 2
	If VimMode = 1
	{
		If keymode = 0
		{
			send %vimkey%
		}	
		If keymode = 1
		{
			loop,10
			{
				if (A_ThisHotKey = NumArray[%A_Index%])
				{
					KeyTemp := KeyTemp A_ThisHotKey
					Controlsettext,edit1,%KeyTemp%,ahk_class TTOTAL_CMD
					IsNum := 1
					If (KeyCount = 0)
					{
						KeyCount := A_ThisHotKey
						Break
					}
					If (KeyCount < 100)
					{
						KeyCount := A_thisHotkey + (KeyCount * 10)
					}
					If (KeyCount > 100)
					{
						KeyCount := MaxKeyCount
						Break
					}
				}
			}
			If (KeyCount = 0)
				KeyCount = 1
			If !IsNum
			{
				if defkey = +g
					send {Home}
				Loop,%KeyCount%
					Send %vimkey%
				KeyCount := 0
				KeyTemp :=
				Controlsettext,edit1,,ahk_class TTOTAL_CMD
			}
		}
		If KeyMode = 2
		{
			;KeyTemp := KeyTemp A_ThisHotKey
			Stringreplace,newstr, A_ThisHotkey,+,,All
			If ErrorLevel
				GroupKey :=  GroupKey A_ThisHotKey
			Else
			{
				Stringupper, outstr , newstr
				GroupKey := GroupKey outstr
			}
			If  Groupkey <> i
				Controlsettext,edit1,%GroupKey%,ahk_class TTOTAL_CMD
			Loop,Parse,ThisGroup,`,
			{
				If (GroupKey = A_LoopField)
				{
					Tooltip
					f_groupkey_func(Groupkey)
					Break
				}
				If Strlen(GroupKey) > Strlen(A_loopField)
				{
					Tooltip
					GroupKey :=
					ThisGroup :=
					KeyTemp := 
					Controlsettext,edit1,,ahk_class TTOTAL_CMD
					break
				}
			}
		}
		If KeyMode = 3
		{
			PostMessage 1075, %vimKey%,0, , ahk_class TTOTAL_CMD	
		}
		If KeyMode = 4
		{
        		Send %defKey%
		}
	}
	else
		Send %defkey%
}
; f_groupkey_func {{{2
f_groupkey_func(gk)
{
	Stringcasesense,ON
	Global GroupKey
	Global Okey
	Global Mkey
	Global Gkey
	Global Skey
	Global KeyTemp
	Global VrenameEdit
	Global IsCmd
	Global syssd
	Global INI_File
		
	GroupKey :=
	ClearEdit := 0
	
	;msgbox % gk
	loop
	{
	If gk = m
	{
		If syssd
			IsCmd := 1
		else
		{
			Controlsettext,edit1,Mark: ,ahk_class TTOTAL_CMD
			PostMessage 1075, 4003, 0, , ahk_class TTOTAL_CMD
			send {Right}
			IsCmd := 1
			ClearEdit := 0
			GoSub,L_ListMark
			break
		}
	}
	If gk = '
	{
		If syssd
			IsCmd := 1
		else
		{
			Controlsettext,edit1,GetMark: ,ahk_class TTOTAL_CMD
			PostMessage 1075, 4003, 0, , ahk_class TTOTAL_CMD
			send {Right}
			IsCmd := 1
			ClearEdit := 0
			GoSub,L_ListMark
			break
		}
	}
	If gk = zz
 	{
		f_key("z","909",Skey)
		ClearEdit := 1
		break
        }
	If gk = zt
 	{
		ControlSetText,Edit1
		WinGet,ExStyle,ExStyle,ahk_class TTOTAL_CMD
		If (ExStyle & 0x8)
    			WinSet,AlwaysOnTop,off,ahk_class TTOTAL_CMD
		else
    			WinSet,AlwaysOnTop,on,ahk_class TTOTAL_CMD 
		ClearEdit := 1
		break
        }
	If gk = zi
	{
		SetControlDelay,100
                MouseGetPos, xpos, ypos 
		BlockInput,Mouse
                MouseMove,4,0,0
                ControlClick, TPanel1,ahk_class TTOTAL_CMD 
                MouseMove,xpos,ypos,0
		BlockInput,Off
		WinActivate ahk_class TTOTAL_CMD
		ClearEdit := 1
		break
        }
	If gk = zo
	{
		SetControlDelay,100
 		MouseGetPos, xpos, ypos 
		ControlGetPos,x,y,w,h,TMyPanel8,ahk_class TTOTAL_CMD
		ControlGetPos,,,tm1W,tm1H,TPanel1,ahk_class TTOTAL_CMD
		BlockInput,Mouse
		If (tm1w < tm1h) ; 判断纵向还是横向 Ture为竖 false为横
               		MouseMove,x+w,0,0
		else
			MouseMove,0,y+h,0
                ControlClick, TPanel1,ahk_class TTOTAL_CMD 
                MouseMove,xpos,ypos,0
		BlockInput,Off
		WinActivate ahk_class TTOTAL_CMD
		ClearEdit := 1
		break
	}
	If gk = zn
	{
		PostMessage 1075, 2000,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	If gk = zm
	{
		PostMessage 1075, 2015,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	If gk = zr
	{
		PostMessage 1075, 2016,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	If gk = zv
	{
		PostMessage 1075, 305,0, , ahk_class TTOTAL_CMD
		ClearEdit := 1
		break
	}
	if gk = ss
	{
		PostMessage 1075, 323,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = sn
	{
		PostMessage 1075, 321,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = sd
	{
		PostMessage 1075, 324,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = se
	{
		PostMessage 1075, 322,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = sr
	{
		PostMessage 1075, 330,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = s1
	{
		PostMessage 1075, 6001,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = s2
	{
		PostMessage 1075, 6002,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = s3
	{
		PostMessage 1075, 6003,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = s4
	{
		PostMessage 1075, 6004,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = s5
	{
		PostMessage 1075, 6005,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = s6
	{
		PostMessage 1075, 6006,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = s7
	{
		PostMessage 1075, 6007,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = s8
	{
		PostMessage 1075, 6008,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = s9
	{
		PostMessage 1075, 6009,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = i
	{
		if IsCmd = 1
		If A_IsCompiled
			f_key("i","i",Okey)
		else
			f_key("i","!{i}",Okey)
		ControlGetFocus,vartln,ahk_class TTOTAL_CMD
		Stringleft,vartln,vartln,7
		If vartln = TInEdit
			IsCmd = 1
	}
	if gk = gt
	{
		PostMessage 1075, 3005,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = gT
	{
		PostMessage 1075, 3006,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = g1
	{
		PostMessage 1075, 5001,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = g2
	{
		PostMessage 1075, 5002,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = g3
	{
		PostMessage 1075, 5003,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = g4
	{
		PostMessage 1075, 5004,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = g5
	{
		PostMessage 1075, 5005,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = g6
	{
		PostMessage 1075, 5006,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = g7
	{
		PostMessage 1075, 5007,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = g8
	{
		PostMessage 1075, 5008,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = g9
	{
		PostMessage 1075, 5009,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = gc
	{
		PostMessage 1075, 3007,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = gC
	{
		PostMessage 1075, 3008,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = gl
	{
		PostMessage 1075, 3010,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = gL
	{
		PostMessage 1075, 3012,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = gn
	{
		PostMessage 1075, 3003,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = gN
	{
		PostMessage 1075, 3004,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = gg
	{
		PostMessage 1075, 531,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = gG
	{
		PostMessage 1075, 535,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = Vb
	{
		PostMessage 1075, 2901,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	
	if gk = Vd
	{
		PostMessage 1075, 2902,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = Vo
	{
		PostMessage 1075, 2903,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = Vl
	{
		PostMessage 1075, 2904,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = Vi
	{
		PostMessage 1075, 2905,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = Vr
	{
		PostMessage 1075, 2906,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = Vc
	{
		PostMessage 1075, 2907,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = Vp
	{
		PostMessage 1075, 2926,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = Vt
	{
		PostMessage 1075, 2908,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = Vs
	{
		PostMessage 1075, 2909,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = Vn
	{
		PostMessage 1075, 2910,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = Vf
	{
		PostMessage 1075, 2911,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = Vw
	{
		PostMessage 1075, 2916,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = Vx
	{
		PostMessage 1075, 2923,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = Va
	{
		PostMessage 1075, 2917,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = Vh
	{
		PostMessage 1075, 2919,0, , ahk_class TTOTAL_CMD	
		ClearEdit := 1
		break
	}
	if gk = cr
	{
		GoSub L_DelRH
		ClearEdit := 1
		break
	}
	if gk = cl
	{
		GoSub L_DelLH
		ClearEdit := 1
		break
	}
	if gk = cc
	{
		GoSub L_DelCH
		ClearEdit := 1
		break
	}
    	IniRead,user_map_key,%ini_file%,Mapkey,map
	loop, Parse , user_map_key , `,
	if gk = %A_LoopField%
	{	
		Iniread,user_cmd,%INI_file%,Mapkey,%A_LoopField%
		ControlSetText,Edit1,%user_cmd%
		send {enter}
		break
		}
	break
	}
	GroupKey :=
	KeyTemp :=
	If ClearEdit
		Controlsettext,edit1,,ahk_class TTOTAL_CMD
	Return
	Stringcasesense,off
}
; f_cmdEnter {{{2
f_CmdEnter()
{
	Global GroupKey
	Global IsCmd
	Global ActWin
	Global INI_file
	Tooltip 
	ControlGetText,GetCmd,Edit1,ahk_class TTOTAL_CMD
	loop
	{
	IF GetCmd = :set
	{
		ControlSetText,Edit1
		GoSub,L_OPTIONS
		Break
	}
	If GetCmd = :help
	{
		ControlSetText,Edit1
		GoSub,L_HELP
		Break
	}
	If GetCmd = :w
	{
		ControlSetText,Edit1
		GoSub,L_WRITELIST
		Break
	}
	If GetCmd = :r
	{
		ControlSetText,Edit1
		GoSub,L_READLIST
		Break
	}
	If GetCmd = :d
	{
		ControlSetText,Edit1
		GoSub,L_DELLIST
		Break
	}
	If GetCmd = :!
	{
		ControlSetText,Edit1
		PostMessage 1075, 511,0, , ahk_class TTOTAL_CMD	
		Break
	}
	If GetCmd = :download
	{
		ControlSetText,Edit1
		PostMessage 1075, 559,0, , ahk_class TTOTAL_CMD	
		Break
	}
	If GetCmd = :pwd
	{
		ControlSetText,Edit1
		ClipSaved := ClipboardAll 
    		clipboard = 
		PostMessage 1075, 2029,0, , ahk_class TTOTAL_CMD	
    		ClipWait
    		GetTPath= %clipboard%
    		clipboard =
    		Clipboard := ClipSaved 
    		ClipSaved = 
		ControlSetText,Edit1,%GetTPath%
		Break
	}
	If GetCmd = :config
	{
		ControlSetText,Edit1
		PostMessage 1075, 490,0, , ahk_class TTOTAL_CMD	
		Break
	}
	If GetCmd = :top
	{
		ControlSetText,Edit1
		WinGet,ExStyle,ExStyle,ahk_class TTOTAL_CMD
		If (ExStyle & 0x8)
    			WinSet,AlwaysOnTop,off,ahk_class TTOTAL_CMD
		else
    			WinSet,AlwaysOnTop,on,ahk_class TTOTAL_CMD 
		
		Break
	}
	Stringleft,map,GetCmd,4
	If map = :map
	{
		Stringsplit,maparray,GetCmd,%A_Space%
		;Msgbox % maparray1 "_" maparray2 "_" maparray3
		If Substr(maparray2,1,1) = "n"
			If Strlen(maparray2) = 2
			{
    				IniRead,temp_map_key,%ini_file%,Mapkey,map
				if temp_map_key 
				{
				n := 0
				loop, Parse , temp_map_key , `,
					if A_LoopField = %maparray2%
					{
						n := 0
						break
					}
					else
						n := 1
				if n 
					temp_map_key := temp_map_key . "," . maparray2
				}
				else
					temp_map_key := maparray2
    				IniWrite,%temp_map_key%,%ini_file%,MapKey,map
				n := 3
				user_cmd :=
;				Loop, %MapArray0%
;				{
;    					user_cmd := MapArray%a_index%
;					MsgBox, Color number %a_index% is %user_cmd%.
;				}
				Loop, %MapArray0%
				{
    					user_cmd := user_cmd . A_Space . MapArray%n%
					n++
				}
    				IniWrite,%user_cmd%,%ini_file%,MapKey,%maparray2%
			}
		ControlSetText,Edit1
		Break
	}
	Stringleft,mark,GetCmd,5
	If mark = Mark:
	{
		Stringleft,m,GetCmd,6
		StringRight,p,m,1
		ClipSaved := ClipboardAll ;保存原来剪切板里的内容UserInput
    		Clipboard = ;初始化剪切板
    		Postmessage 1075, 2029, 0, , ahk_class TTOTAL_CMD
    		ClipWait
    		Location = %clipboard%
    		clipboard =
    		IniWrite,%Location%,%A_WorkingDir%\viatc.ini,mark,%p%
    		Clipboard := ClipSaved ;回复剪切板内容
    		ClipSaved = 	
    		IniRead,ms,%A_WorkingDir%\viatc.ini,mark,ms
		n := 1
		loop, Parse , ms , `,
		{
			If p = %A_LoopField%
				n := 0
		}
		if n
    			IniWrite,%ms%%p%`,,%A_WorkingDir%\viatc.ini,mark,ms

		ControlSetText,Edit1
		break
	}
	Stringleft,Getmark,GetCmd,8
	If Getmark = GetMark:
	{
		
		Stringleft,m,GetCmd,9
		StringRight,p,m,1
		Iniread,Location,%A_WorkingDir%\viatc.ini,mark,%p%
		control,hide,,edit1, ahk_class TTOTAL_CMD
		Controlsettext,edit1,cd %location%, ahk_class TTOTAL_CMD
		PostMessage 1075, 4003, 0, , ahk_class TTOTAL_CMD
		send {enter}
		send {esc}
		control,show,,edit1, ahk_class TTOTAL_CMD	
		ControlSetText,Edit1
		break
	}
	If GetCmd = :sy
	{
    		Postmessage 1075, 2020, 0, , ahk_class TTOTAL_CMD
	}
	If GetCmd = :lm
	{
		GoSub,L_ListMark
		ControlSetText,Edit1
		break
	}
	If GetCmd = :history
	{
		ControlSetText,Edit1
		PostMessage 1075, 572,0, , ahk_class TTOTAL_CMD	
		Break
	}
	If GetCmd = :q
	{
		ControlSetText,Edit1
		Exitapp
		Break
	}
	Send {Enter}
	Break
	}
	GroupKey :=
	IsCmd :=
}
