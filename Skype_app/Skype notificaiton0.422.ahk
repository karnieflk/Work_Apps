/*
 * * * Compile_AHK SETTINGS BEGIN * * *

[AHK2EXE]
Exe_File=%In_Dir%\Skype Notification 0.42.exe
[VERSION]
Set_Version_Info=1
File_Description=Skype Notification
File_Version=0.0.0.7
Inc_File_Version=1
Legal_Copyright=Jarett Karnia
Product_Version=0.0.0.7
Inc_Product_Version=1
[ICONS]
Icon_1=%In_Dir%\Skype icon.ico
Icon_3=%In_Dir%\Skype icon n.ico

* * * Compile_AHK SETTINGS END * * *
*/

/*
Changes from last version
Added in Start menu option
added in option to not auto move window.

*/

#Persistent
#SingleInstance, Force
SetMouseDelay, 0
CoordMode, mouse, Screen
DetectHiddenWindows on
	global notecheck, config_file, Screen_sharing, Trans_window_percent, Disabled
	Screen_sharing = 0
Disabled = 0
	;Check for folder and config file, If they are not there, create them.
	Folder = C:\Skype_Notify
		Result := FileExist(Folder)
		If Result =		
	FileCreateDir, %Folder%
	
	config_file = %Folder%\Skype_notify_config.ini
	Result := FileExist(config_file)
		If Result =
	{
	FileAppend,,%config_file%
	IniWrite, 1, %config_file%, notecheck, notecheck
}
	
	;load the config file contents
	IniRead,  notecheck, %config_file%, notecheck, notecheck

Create_submenu()
;~ Create_tray_Menu() ; for stadnard tray
Create_tray_Menu(1) ; for no standard tray
;Create the tray menu

        

        

SetTimer, Find_Skype_notificaiton, 2000
gui, Show, ,Skype Notification
gui, Hide
gosub, ini_error_check
Notify("Skype Notification `nStartup","Skype Notiication is running in the background.`nSelect Quit from the Tray icon to quit this program.","5","Style=BalloonTip")	
gosub, read_ini_file
gosub, install_shortcut
return

create_tray_menu(NoStandard := 0)
{
 If (NoStandard)
 	Menu, Tray, NoStandard
    
		Menu, Tray, Add, Options, Optionsgui
		Menu, Tray, Add, Disable,  :Submenu
		Menu ,Tray, Add, Quit, quitapp
 
 return
}
 
create_submenu()
{
         Menu, Submenu, Add, 30 Minutes, thirty_min
        Menu, Submenu, Add, One Hour, one_hour
        Menu, Submenu, Add, Two Hours, Two_hour
        Menu, Submenu, Add, Three Hours, Three_hour
        Menu, Submenu, Add, Four Hours, Four_hour
        Menu, Submenu, Add, Disable  Indefinite, DisableApp
 
 return
}

thirty_min:
{
DisableApp("30 Minutes")
 ;~ Menu,Submenu, Check, 30 Minutes
 SetTimer, DisableApp, 1800000
 return 
}

one_hour:
{
DisableApp("One Hour")
  ;~ Menu,Submenu, Check, One Hour
 SetTimer, DisableApp, 3600000
 return 
}

Two_hour:
{
 DisableApp("Two Hours")
  ;~ Menu,Submenu, Check, Two Hours
 SetTimer, DisableApp, 7200000
 return 
}
Three_hour:
{
 DisableApp("Three Hours")
  ;~ Menu,Submenu, Check, Three Hours
 SetTimer, DisableApp, 10800000
 return 
}

Four_hour:
{
 DisableApp("Four Hours")
  ;~ Menu,Submenu, Check, Four Hours
 SetTimer, DisableApp, 14400000
 return 
}



DisableApp(Timer := "DisableApp", MenuItem := "Submenu")
{
global Disabled


  
If (Disabled) 
{
Disabled = 0
Suspend, Toggle
Menu,Tray, UnCheck, Disable
Menu,%MenuItem%, UnCheck, %Timer%


 Notify("Skype Notification`nEnable","Enabiling Skype notifications.","5","Style=BalloonTip")	`
}
else if (!Disabled) 
{
Disabled = 1
Menu,Tray, Check, Disable
Menu,%MenuItem%, Check, %Timer%

SetTimer, DisableApp, off
Suspend, Toggle
 Notify("Skype Notification`nDisable","Disabiling Skype notifications.","5","Style=BalloonTip")	

}
return
}
Optionsgui:
{
	IfWinExist, Options
		Gui, Options:Show
else
{
notecheck = 1
trans_window_percent = 100
	gosub, Read_ini_file
color := red_value "," Green_value "," Blue_value
color := rgbToHex(color)
Gui, Options:Add, Tab2, x4 y5 w459 h237 , Notifications|Border
Gui, Options:Tab, Notifications
Gui, Options:Add, CheckBox, x11 y35 w218   Checked%notecheck% vnotecheck gEnable_checkbox , Bring Skype message window to front
Gui, Options:Add, CheckBox, xp+20 yp+15   Checked%Move_window% vMove_window gEnable_checkbox , Move Skype window to Top Left edge of active monitor
Gui, Options:Add, Text, xp yp+20 h27   vTransparent_window_text gupdateinifile , Set Skype window notification transparancy ( in `%)
Gui, Options:Add, Edit, xp+245  yp-3 w25 h20  vtrans_window_percent gupdateinifile  ,%trans_window_percent%

Gui, Options:Add, CheckBox, xp-265 yp+34  w218 h22 Checked%Boarder% vboarder gupdateinifile, Show monitor(s) notification borders
Gui, Options:Add, CheckBox, xp yp+55 w236 h27 Checked%Startup% vStartup gStart_with_computer,Startup with computer
;~ Gui, Options:Add, CheckBox, x11 y98 w236 h27 Checked%Notification% vNotification gupdateinifile, Display Notification window on active monitor
Gui, Options:Tab, Border
Gui, Options:Add, Text, x10 y36 w448 h35 , This tab is for the monitor notification border. You can set the transparency, color, and thickness. You can also set the amount of times the border will flash per cycle
Gui, Options:Add, GroupBox, x7 y81 w115 h120 , Color (RGB)
Gui, Options:Add, Text, x16 yp+22 w37 h17 , RED
Gui, Options:Add, Text, xp yp+27 w41 h21 , GREEN
Gui, Options:Add, Text, xp yp+27 w45 h16 , BLUE
Gui, Options:Add, Edit, x59 yp-57 w48 h18 vRed_value gupdateinifile , %red_value%
Gui, Options:Add, Edit, xp yp+27 w48 h18  vGreen_Value gupdateinifile, %Green_value%
Gui, Options:Add, Edit, xp yp+27 w48 h18 vBlue_Value gupdateinifile, %Blue_value%

Gui, Options:Add, GroupBox, x141 y91 w94 h65 , Thickness
Gui, Options:Add, Edit, x143 y110 w79 h26 vthick_value gupdateinifile , %thick_value%
Gui, Options:Add, Text, xp y140 w79 h26   , (In Pixels)
Gui, Options:Add, GroupBox, x249 y92 w80 h66 , Flash Amount
Gui, Options:Add, Edit, x258 y111 w45 h22 vflash_value gupdateinifile , %Flash_value%
Gui, Options:Add, GroupBox, x340 y92 w80 h70 , Transparancy
Gui, Options:Add, Edit, x344 y111 w45 h22 vtransparancy gupdateinifile , %transparancy%
Gui, Options:Add, Text, xp y135 w45 h22  , (0-255)

Gui, Options:Add, Button, x180 y160 w45 h22 GTest_output  , Test

; Generated using SmartGUI Creator for SciTE
Gui, Options:Show, w465 h245, Options
If (!notecheck)
{
 ;~ GuiControl, Options:, Move_window,0
 Guicontrol, Options:Disable, Move_window
}
}
return
}

Enable_checkbox:
{
  gosub, updateinifile
  If (!notecheck)
{
 ;~ GuiControl, Options:, Move_window,0
 Guicontrol, Options:Disable, Move_window
;~ Guicontrol, Options:Disable, trans_window_percent
 ;~ Guicontrol, Options:Disable, Transparent_window_text
 return
}
else
{
  Guicontrol, Options:Enable, Move_window
   ;~ Guicontrol, Options:Enable, trans_window_percent
   ;~ Guicontrol, Options:Enable, Transparent_window_text
 }
 
 ;~ GUIControlGet, Move_window, Enabled, Move_window
 ;~ Gui,Submit, NoHide
 ;~ If (!Move_window)
 ;~ {
  ;~ Guicontrol, Options:Disable, trans_window_percent
 ;~ Guicontrol, Options:Disable, Transparent_window_text
;~ }
 ;~ else
 ;~ { 
        ;~ Guicontrol, Options:Enable, trans_window_percent
   ;~ Guicontrol, Options:Enable, Transparent_window_text
 ;~ }
 return
}

Start_with_computer:
{
 gosub, updateinifile
gosub, install_shortcut

 return
}

install_shortcut:
{
 Filename := "Skype Notification"
		Folder := A_Startup
		loop, %folder%\*.*
		{
			If A_LoopFileName Contains Skype
              If A_LoopFileName Contains Notification
			{
				;msgbox, foudn name %A_LoopFileName%
				FileDelete, %A_LoopFileFullPath%
                Sleep 2000
			}}
            
 If (Startup)
  FileCreateShortcut, %A_Scriptfullpath%, %A_startup%\%Filename%.lnk, C:\,%A_ScriptFullPath%, %Filename%
 return
}
Test_output:
{
gosub, updateinifile
Flash_monitor()
return
}

OptionsguiClose:
Optionsguiescape:
{
gui, Options: Hide
return
}
updateinifile:
{
Gui, Submit, NoHide
GuiControlGet, notecheck
GuiControlGet, Boarder
GuiControlGet, red_value
GuiControlGet, Green_value
GuiControlGet, Blue_value
CHeck_empty("red_value")
CHeck_empty("Green_value")
CHeck_empty("Blue_value")
GuiControlGet, thick_value
GuiControlGet, Flash_value
GuiControlGet, Notification
GuiControlGet, transparancy
GuiControlGet, Startup
GuiControlGet, Move_window
GuiControlGet, trans_window_percent


gosub, Write_ini_file
return
}

CHeck_empty(ByRef Color_val)
{
	global
		If  %Color_val% = 
		{
		%Color_val% = 0	
		GuiControl,,%Color_val%, 0
	}
	return
}
quitapp:
{
ExitApp
return
}

ShellEvent(wParam, lParam)
{
	global
	if (Screen_sharing) || (Disabled)
		return
	
    if (wParam = 0x8006) ; HSHELL_FLASH
    {   ; lParam contains the ID of the window which flashed:
  		WinGetClass, classcheck, ahk_id %lParam%
		;~ MsgBox, %classcheck%
	if (classcheck = "LyncTabFrameHostWindowClass")
		NOtify_User(lParam, classcheck)
	else if (classcheck =  "LyncConversationWindowClass")
			NOtify_User(lParam, classcheck)	
				
}

	return
}

Notify_user(lParam, classcheck)
{
	global notecheck,  Boarder,  Trans_window_percent
	SetTimer, Find_Skype_notificaiton, off

		WinGetTitle, Title, ahk_id %lParam%
		IF (notecheck)
			Activate("ahk_class " classcheck, Trans_window_percent)
		
		 If (Boarder)
				Flash_monitor(Title)
		
		;~ if (Notification)
				;~ Show_Window(Title)	
SetTimer, Find_Skype_notificaiton, on
return
}

Activate(Item, Trans_window_percent)
{
 global Move_window, Window_reset, Disabled
		activeMonitorInfo(  aX,  aY,  aWidth,  aHeight )
        wINGET,windowstate, MinMax, %Item%
     IfWinActive ahk_exe lync.exe
      return
     If (Disabled)
      return

     If windowstate = -1
     {
      ;~ ToolTip, Hide window
     ;~ WinHide, %Item%
     ;~ Sleep 250
     ;~ ToolTip, WinRestore
     Winset, Transparent, 0, %Item%
     Sleep 100
	WinRestore, %Item%	
 ;~ WinHide, %Item%

;~ Sleep 500
     }      
      Sleep 250       
                Trans_window_actual := Round( (255 * Round(Trans_window_percent / 100,2) ))
       Winset, Transparent, %Trans_window_actual%, %Item%
       Sleep 10
         Window_reset := Item
       SetTimer, Reset_window, 100
       Sleep 100
      If (Move_window)
          WinMove, %Item%,,%ax%, %ay%
   
                   	;~ WinShow, 	%Item%
                    Sleep 100
             	winset, AlwaysOnTop , on,   %Item%
				Sleep 100
				;~ WinHide, 	%Item%	
				;~ WinShow, 	%Item%	
				;~ Sleep 100
				winset, AlwaysOnTop, off,   %Item%
                Sleep 100
                
                SetTimer, Resetwindow, 30000
	return
}

Resetwindow:
{
 
 	Winget, Value, Transparent,  ahk_class LyncTabFrameHostWindowClass
    If Value := 255
        Winset, Transparent, 255, ahk_class LyncTabFrameHostWindowClass
        	Winget, Value, Transparent,  ahk_class LyncConversationWindowClass
    If Value := 255
                   Winset, Transparent, 255, ahk_class LyncConversationWindowClass
                   SetTimer, Resetwindow, off
 return
}
Reset_window:
{
 IfWinActive, %Window_reset%
  {
  SetTimer, Reset_window, off
  WinSet, Transparent, 255, %Window_reset%
 }
 
 return
}
Show_Window(Title)
{
	activeMonitorInfo(  aX,  aY,  aWidth,  aHeight )		
	Gui, window:Add, Text,,You have recieved a Message on skype
	Gui, window:show, x%aX% y%ay% NoActivate , Skype Notify	
	Gui, window: +AlwaysOnTop
	return
}

Find_Skype_notificaiton:
{

IfWinExist, ahk_class LyncAppSharingToolbar
{		
		IF (!Screen_sharing)
         Notify("Skype Notification`nDisable","Detected that you are presenting. `nDisabiling Skype notifications.","5","Style=BalloonTip")	
		Screen_sharing = 1
		;~ SetTimer,  Find_Skype_notificaiton, off
		return
}
If (Screen_sharing)
 Notify("Skype Notification`nEnable","Detected that you are no longer presenting. `nEnabling Skype notifications.","5","Style=BalloonTip")


Screen_sharing=0

IfWinExist,  ahk_class LyncToastWindowClass
{
			 If (Boarder)
				Flash_monitor(Title)
if (notecheck)
ControlClick, x5 y5, ahk_class LyncToastWindowClass
}		

		ifWinExist, ahk_class LyncTabFrameHostWindowClass
		Detect_Flash()
		

	else ifWinExist, ahk_class LyncConversationWindowClass
			Detect_Flash()
			
return
}

Detect_Flash()
{
	
		Script_Hwnd := WinExist("Skype Notification ahk_pid " DllCall("GetCurrentProcessId"))
			; Register shell hook to detect flashing windows.
		DllCall("RegisterShellHookWindow", "uint", Script_Hwnd)
		OnMessage(DllCall("RegisterWindowMessage", "str", "SHELLHOOK"), "ShellEvent")
	return
	}
	
	
ini_error_check:
{
	gosub, Read_ini_file

If notecheck = Error
	notecheck = 1
If Boarder = Error
	Boarder = 0
If red_value = Error
	red_value = 255
If Green_value = Error
	Green_value = 0
If Blue_value = Error
	Blue_value = 0
If thick_value = Error
	thick_value = 10
If Flash_value = Error
	Flash_value = 3
If transparancy = Error
	transparancy = 175
	If Notification = Error
	Notification = 0
If Startup = Error
 Startup = 0
If Move_window = Error
 Move_window = 0
If trans_window_percent = Error
 trans_window_percent = 100
If trans_window_percent = 
 trans_window_percent = 100



gosub, Write_ini_file
return
}

Write_ini_file:
{
IniWrite, %notecheck%, %config_file%, notecheck, notecheck
IniWrite, %Boarder%, %config_file%, Boarder, Boarder
IniWrite, %red_value%, %config_file%, red_value, red_value
IniWrite, %Green_value%, %config_file%, Green_value, Green_value
IniWrite, %Blue_value%, %config_file%, Blue_value, Blue_value
IniWrite, %thick_value%, %config_file%, thick_value, thick_value
IniWrite, %Flash_value%, %config_file%, Flash_value, Flash_value
IniWrite, %transparancy%, %config_file%, transparancy, transparancy
IniWrite, %Notification%, %config_file%, Notification, Notification
IniWrite, %Startup%, %config_file%, Startup, Startup
IniWrite, %Move_window%, %config_file%, Move_window, Move_window
IniWrite, %trans_window_percent%, %config_file%, trans_window_percent, trans_window_percent
	
	return
}
read_ini_file:
{
IniRead,  notecheck, %config_file%, notecheck, notecheck
IniRead,  Boarder, %config_file%, Boarder, Boarder
IniRead,  red_value, %config_file%, red_value, red_value
IniRead,  Green_value, %config_file%, Green_value, Green_value
IniRead,  Blue_value, %config_file%, Blue_value, Blue_value
IniRead,  thick_value, %config_file%, thick_value, thick_value
IniRead,  Flash_value, %config_file%, Flash_value, Flash_value
IniRead,  transparancy, %config_file%, transparancy, transparancy
IniRead,  Notification, %config_file%, Notification, Notification
IniRead,  Startup, %config_file%, Startup, Startup
IniRead,  Move_window, %config_file%, Move_window, Move_window
IniRead,  trans_window_percent, %config_file%, trans_window_percent, trans_window_percent
return
}
Flash_monitor(Title := "")
{
IniRead,  red_value, %config_file%, red_value, red_value
IniRead,  Green_value, %config_file%, Green_value, Green_value
IniRead,  Blue_value, %config_file%, Blue_value, Blue_value
IniRead,  Boarder, %config_file%, thick_value, thick_value
IniRead,  Flash_value, %config_file%, Flash_value, Flash_value
IniRead,  transparancy, %config_file%, transparancy, transparancy

color := red_value "," Green_value "," Blue_value
color := rgbToHex(color)


	  SysGet, monCount, MonitorCount
	    Loop %monCount%
            {
               SysGet, curMon, Monitor, %a_index%
			   x :=  curMonLeft
			   y := curMonTop
			    h := (curMonBottom - curMonTop) 
                  w  := (curMonRight  - curMonLeft)
			   
			    offset:=0

    outerX:=offset
    outerY:=offset
    outerX2:=w-offset
    outerY2:=h-offset

    innerX:=Boarder+offset
    innerY:=Boarder+offset
    innerX2:=w-Boarder-offset
    innerY2:=h-Boarder-offset
	guinumber:= (A_index + 1)
    newX:=x
    newY:=y
    newW:=w
    newH:=h

	Gui, %guinumber%:+Lastfound +AlwaysOnTop +Toolwindow
		Gui,%guinumber%: Color, %color%
Gui, %guinumber%: -Caption
 WinSet, Region, %outerX%-%outerY% %outerX2%-%outerY% %outerX2%-%outerY2% %outerX%-%outerY2% %outerX%-%outerY%    %innerX%-%innerY% %innerX2%-%innerY% %innerX2%-%innerY2% %innerX%-%innerY2% %innerX%-%innerY% 
 WinSet, Transparent, %transparancy%,
Gui, %guinumber%:Show, w%newW% h%newH% x%newX% y%newY% NoActivate, Skype Message 
}

Loop, %Flash_value%
{
	
		IfWinActive, ahk_class LyncTabFrameHostWindowClass
		{
			Loop, %monCount%
{
		guinumber := (A_Index + 1)
	Gui, %guinumber%:Hide	
}
		break
	}
		
	Loop, %monCount%
	{
	guinumber := (A_Index + 1)
	Gui, %guinumber%:Show, NoActivate	
}
Sleep 500
Loop, %monCount%
{
		guinumber := (A_Index + 1)
	Gui, %guinumber%:Hide	
	
}
Sleep 500
}
return	
}

#`:: ListLines

rgbToHex(s, d = "")
{

	StringSplit, s, s, % d = "" ? "," : d

	SetFormat, Integer, % (f := A_FormatInteger) = "D" ? "H" : f

	h := s1 + 0 . s2 + 0 . s3 + 0

	SetFormat, Integer, %f%

	Return, RegExReplace(RegExReplace(h, "0x(.)(?=$|0x)", "0$1"), "0x")

}

     activeMonitorInfo( ByRef aX, ByRef aY, ByRef aWidth,  ByRef  aHeight, ByRef mouseX := 0, ByRef mouseY := 0  )
         {
            CoordMode, Mouse, Screen
            MouseGetPos, mouseX , mouseY
            SysGet, monCount, MonitorCount
            Loop %monCount%
            {
               SysGet, curMon, Monitor, %a_index%
               if ( mouseX >= curMonLeft and mouseX <= curMonRight and mouseY >= curMonTop and mouseY <= curMonBottom )
               {
                  aHeight := (curMonBottom - curMonTop) / 2
                  aWidth  := (curMonRight  - curMonLeft) / 2
                  aX      := curMonLeft
                  ay      := curMonTop
                  return
               }}}
			   
			   
			   
			   

			   
Notify(Title="Notify()",Message="",Duration="",Options="")
{
 static GF := 50        ;      Gui First Number      ;= override Gui: # used
 static GL := 74        ;      Gui Last Number       ;= between GF and GL
 static GC := "FFFFAA"  ;      Gui Color             ;   ie: don't use GF<=Gui#<=GL
 static GR := 9         ;      Gui Radius            ;       elsewhere in your script
 static GT := "Off"     ;      Gui Transparency
 static TS := 10        ;    Title Font Size
 static TW := 625       ;    Title Font Weight
 static TC := "Default" ;    Title Font Color
 static TF := "Default" ;    Title Font Face
 static MS := 10        ;  Message Font Size
 static MW := "Default" ;  Message Font Weight
 static MC := "Default" ;  Message Font Color
 static MF := "Default" ;  Message Font Face
 static BC := "000000"  ;   Border Colors
 static BK := "Silver"  ;   Border Flash Color
 static BW := 2         ;   Border Width/Thickness
 static BR := 13        ;   Border Radius
 static BT := 105       ;   Border Transpacency
 static BF := 300       ;   Border Flash Speed
 static SI := 0         ;    Speed In      (AnimateWindow)
 static SC := 0         ;    Speed Clicked (AnimateWindow)
 static ST := 0         ;    Speed TimeOut (AnimateWindow)
 static IW := 32        ;    Image Width
 static IH := 32        ;    Image Height
 static IN := 0         ;    Image Icon Number (from shell32.dll if no Image used)
 static XC := "Default" ; Action X Color
 static XS := 12        ; Action X Size
 static XW := 800       ; Action X Weight
 static PC := "Default" ; Progress bar color
 static PB := "Default" ; Progress bar background color
 static PW := ""        ; Progress bar width
 static PH := ""        ; Progress bar height
; local WF, IF          ; Wallpaper File, Image File
; local AC, AT, AX      ; Action Clicked,Timeout,X Close
 static GNList, ACList, ATList, AXList, Exit, _Wallpaper_, _Title_, _Message_, _Progress_, _Image_

If (Options)
{
  Options.=" "
  Loop,Parse,Options,= 			;= parse options string, needs better whitespace handling
  {
      If A_Index = 1
        Option := A_LoopField
      Else
      {
        %Option% := SubStr(A_LoopField, 1, (pos := InStr(A_LoopField, A_Space, false, 0))-1)
        ; MsgBox, % "<" Option "=" %Option% ">"
        Option   := SubStr(A_LoopField, pos+1)
      }
  }
  If Return <>
   Return, % (%Return%)
  If Wait <>
  {
      If Wait Is Number			;= wait for a specific notify
      {
        Gui %Wait%:+LastFound
        If NotifyGuiID := WinExist()
        {
          WinWaitClose, , , % Abs(Duration)
          If (ErrorLevel && Duration < 1)
          {
            Gui, % Wait + GL - GF + 1 ":Destroy"
            If ST
              DllCall("AnimateWindow","UInt",NotifyGuiID,"Int",ST,"UInt","0x00050001")
            Gui, %Wait%:Destroy
          }
        }
      }
      Else				;= wait for all notify's
      {
        Loop, % GL-GF
        {
          Wait := A_Index + GF - 1
          Gui %Wait%:+LastFound
          If NotifyGuiID := WinExist()
          {
            WinWaitClose, , , % Abs(Duration)
            If (ErrorLevel && Duration < 1)
            {
              Gui, % Wait + GL - GF + 1 ":Destroy"
              If ST
                DllCall("AnimateWindow","UInt",NotifyGuiID,"Int",ST,"UInt","0x00050001")
              Gui, %Wait%:Destroy
            }
          }
        }
        GNList := ACList := ATList := AXList := ""
      }
      Return
  }
  Else If Update <>
  {
      If Title <>
       GuiControl, %Update%:,_Title_,%Title%
      If Message <>
       GuiControl, %Update%:,_Message_,%Message%
      If Duration <>
       GuiControl, %Update%:,_Progress_,%Duration%
      Return
  }
  Else If Style <>
   If Style = Default
    Return % Notify(Title,Message,Duration,"SI=0 ST=0 SC=0 GC=FFFFAA BC=00000 GR=9 BR=13 BW=2 BT=105 TS=10 MS=10")
   If Style = ToolTip
    Return % Notify(Title,Message,Duration,"SI=50 ST=50 SC=50 GC=FFFFAA BC=00000 GR=0 BR=0 BW=1 BT=255 TS=8 MS=8")
   Else If Style = BalloonTip
    Return % Notify(Title,Message,Duration,"SI=350 ST=250 SC=250 GC=FFFFAA BC=00000 GR=13 BR=15 BW=1 BT=255 TS=10 MS=8 AX=1 XC=999922")
   Else If Style = Error
    Return % Notify(Title,Message,Duration,"SI=100 ST=100 SC=100 GC=Default BC=00000 GR=0 BR=0 BW=1 BT=255 TS=12 MS=12 AX=1 XC=999922 IN=10 IW=32 IH=32 Image=" A_WinDir "\explorer.exe")
   Else If Style = Warning
    Return % Notify(Title,Message,Duration,"SI=100 ST=100 SC=100 GC=Default BC=00000 GR=0 BR=0 BW=1 BT=255 TS=12 MS=12 AX=1 XC=999922 IN=9 IW=32 IH=32 Image=" A_WinDir "\explorer.exe")
   Else If Style = Info
    Return % Notify(Title,Message,Duration,"SI=100 ST=100 SC=100 GC=Default BC=00000 GR=0 BR=0 BW=1 BT=255 TS=12 MS=12 AX=1 XC=999922 IN=8 IW=32 IH=32 Image=" A_WinDir "\explorer.exe")
   Else If Style = Question
    Return % Notify(Title,Message,Duration,"SI=100 ST=100 SC=100 GC=Default BC=00000 GR=0 BR=0 BW=1 BT=255 TS=12 MS=12 AX=1 XC=999922 Image=24 IW=32 IH=32")
   Else If Style = Progress
    Return % Notify(Title,Message,Duration,"SI=0 ST=0 SC=0 GC=Default BC=00000 GR=9 BR=13 BW=2 BT=105 TS=10 MS=10 PG=100 PH=10 GW=300")
   Else If Style = Huge
    Return % Notify(Title,Message,Duration,"SI=200 ST=200 SC=200 GC=FFFFAA BC=00000 GR=27 BR=39 BW=6 BT=105 TS=24 MS=22")

  If GW <>
  {
   wGW = w%GW%
   wPW := "w" GW - 20
  }
  If GH <>
   hGH = h%GH%
  If GW <>
   wGW_ := "w" GW - 20
  If GH <>
   hGH_ := "h" GH - 20
  If PW <>
   wPW = w%PW%
  If PH <>
   hPH = h%PH%
  If TS =
   TS = 10
  IF MS =
   MS = 10
}
;————————————————————————————————————————————————————————————————————————
 If Duration =
  Duration = 30
 GN := GF
 Loop
  IfNotInString, GNList, % "|" GN
   Break
  Else
   If (++GN > GL)
    Return 0            	  ;=== too many notifications open!
 GNList .= "|" GN
 GN2 := GN + GL - GF + 1
;————————————————————————
 If AC <>
  ACList .= "|" GN "=" AC
 If AT <>
  ATList .= "|" GN "=" AT
 If AX <>
  AXList .= "|" GN "=" AX


 P_DHW := A_DetectHiddenWindows
 P_TMM := A_TitleMatchMode
 DetectHiddenWindows On
 SetTitleMatchMode 1
 If (WinExist("_Notify()_GUI_"))  ;=== find all Notifications from ALL scripts, for placement
  WinGetPos, OtherX, OtherY       ;=== change this to a loop for all open notifications?
 DetectHiddenWindows %P_DHW%
 SetTitleMatchMode %P_TMM%

 Gui, %GN%:-Caption +ToolWindow +AlwaysOnTop -Border
 Gui, %GN%:Color, %GC%
 If FileExist(WP)
 {
  Gui, %GN%:Add, Picture, x0 y0 w0 h0 v_Wallpaper_, % WP
  ImageOptions = x+8 y+4
 }
 If Image <>
 {
  If FileExist(Image)
   Gui, %GN%:Add, Picture, w%IW% h%IH% Icon%IN% v_Image_ %ImageOptions%, % Image
  Else
   Gui, %GN%:Add, Picture, w%IW% h%IH% Icon%Image% v_Image_ %ImageOptions%, %A_WinDir%\system32\shell32.dll
  ImageOptions = x+10
 }
 If Title <>
 {
  Gui, %GN%:Font, w%TW% s%TS% c%TC%, %TF%
  Gui, %GN%:Add, Text, %ImageOptions% BackgroundTrans v_Title_, % Title
 }
 If PG
  Gui, %GN%:Add, Progress, Range0-%PG% %wPW% %hPH% c%PC% Background%PB% v_Progress_
 Else
  If ((Title) && (Message))
   Gui, %GN%:Margin, , -5
 If Message <>
 {
  Gui, %GN%:Font, w%MW% s%MS% c%MC%, %MF%
  Gui, %GN%:Add, Text, BackgroundTrans v_Message_, % Message
 }
 If ((Title) && (Message))
  Gui, %GN%:Margin, , 8
 Gui, %GN%:Show, Hide %wGW% %hGH%, _Notify()_GUI_
 Gui  %GN%:+LastFound
 WinGetPos, GX, GY, GW, GH
 GuiControl, %GN%:, _Wallpaper_, % "*w" GW " *h" GH " " WP
 GuiControl, %GN%:MoveDraw, _Title_,    % "w" GW-20 " h" GH-10
 GuiControl, %GN%:MoveDraw, _Message_,  % "w" GW-20 " h" GH-10
 If AX <>
 {
  GW += 10
  Gui, %GN%:Font, w%XW% s%XS% c%XC%, Arial Black
  Gui, %GN%:Add, Text, % "x" GW-15 " y-2 Center w12 h20 g_Notify_Kill_" GN - GF + 1, ×
 } ; ×
 Gui, %GN%:Add, Text, x0 y0 w%GW% h%GH% BackgroundTrans g_Notify_Action_Clicked_ ; to catch clicks
 If (GR)
  WinSet, Region, % "0-0 w" GW " h" GH " R" GR "-" GR
 If (GT)
  WinSet, Transparent, % GT

 SysGet, Workspace, MonitorWorkArea
 NewX := WorkSpaceRight-GW-5
 If (OtherY)
  NewY := OtherY-GH-2-BW*2
 Else
  NewY := WorkspaceBottom-GH-5
 If NewY < % WorkspaceTop
  NewY := WorkspaceBottom-GH-5

 Gui, %GN2%:-Caption +ToolWindow +AlwaysOnTop -Border +E0x20
 Gui, %GN2%:Color, %BC%
 Gui  %GN2%:+LastFound
 If (BR)
  WinSet, Region, % "0-0 w" GW+(BW*2) " h" GH+(BW*2) " R" BR "-" BR
 If (BT)
  WinSet, Transparent, % BT

 Gui, %GN2%:Show, % "Hide x" NewX-BW " y" NewY-BW " w" GW+(BW*2) " h" GH+(BW*2), _Notify()_BGGUI_
 Gui, %GN%:Show,  % "Hide x" NewX " y" NewY " w" GW, _Notify()_GUI_
 Gui  %GN%:+LastFound
 If SI
  DllCall("AnimateWindow","UInt",WinExist(),"Int",SI,"UInt","0x00040008")
 Else
  Gui, %GN%:Show, NA, _Notify()_GUI_
 Gui, %GN2%:Show, NA, _Notify()_BGGUI_
 WinSet, AlwaysOnTop, On

 If ((Duration < 0) OR (Duration = "-0"))
  Exit := GN
 If (Duration)
  SetTimer, % "_Notify_Kill_" GN - GF + 1, % - Abs(Duration) * 1000
 Else
  SetTimer, % "_Notify_Flash_" GN - GF + 1, % BF

Return %GN%

;==========================================================================
;========================================== when a notification is clicked:
_Notify_Action_Clicked_:
 ; Critical
 SetTimer, % "_Notify_Kill_" A_Gui - GF + 1, Off
 Gui, % A_Gui + GL - GF + 1 ":Destroy"
 If SC
 {
  Gui, %A_Gui%:+LastFound
  DllCall("AnimateWindow","UInt",WinExist(),"Int",SC,"UInt", "0x00050001")
 }
 Gui, %A_Gui%:Destroy
 If (ACList)
  Loop,Parse,ACList,|
   If ((Action := SubStr(A_LoopField,1,2)) = A_Gui)
   {
    Temp_Notify_Action:= SubStr(A_LoopField,4)
    StringReplace, ACList, ACList, % "|" A_Gui "=" Temp_Notify_Action, , All
    If IsLabel(_Notify_Action := Temp_Notify_Action)
     Gosub, %_Notify_Action%
    _Notify_Action =
    Break
   }
 StringReplace, GNList, GNList, % "|" A_Gui, , All
 SetTimer, % "_Notify_Flash_" A_Gui - GF + 1, Off
 If (Exit = A_Gui)
  ExitApp
Return

;==========================================================================
;=========================================== when a notification times out:
_Notify_Kill_1:
_Notify_Kill_2:
_Notify_Kill_3:
_Notify_Kill_4:
_Notify_Kill_5:
_Notify_Kill_6:
_Notify_Kill_7:
_Notify_Kill_8:
_Notify_Kill_9:
_Notify_Kill_10:
_Notify_Kill_11:
_Notify_Kill_12:
_Notify_Kill_13:
_Notify_Kill_14:
_Notify_Kill_15:
_Notify_Kill_16:
_Notify_Kill_17:
_Notify_Kill_18:
_Notify_Kill_19:
_Notify_Kill_20:
_Notify_Kill_21:
_Notify_Kill_22:
_Notify_Kill_23:
_Notify_Kill_24:
_Notify_Kill_25:
 Critical
 StringReplace, GK, A_ThisLabel, _Notify_Kill_
 SetTimer, _Notify_Flash_%GK%, Off
 GK := GK + GF - 1
; MsgBox, %GK%
 Gui, % GK + GL - GF + 1 ":Destroy"
 If ST
 {
  Gui, %GK%:+LastFound
  DllCall("AnimateWindow","UInt",WinExist(),"Int",ST,"UInt", "0x00050001")
 }
 Gui, %GK%:Destroy
 StringReplace, GNList, GNList, % "|" GK, , All
 If (Exit = GK)
  ExitApp
Return 1

;==========================================================================
;======================================== flashes a permanent notification:
_Notify_Flash_1:
_Notify_Flash_2:
_Notify_Flash_3:
_Notify_Flash_4:
_Notify_Flash_5:
_Notify_Flash_6:
_Notify_Flash_7:
_Notify_Flash_8:
_Notify_Flash_9:
_Notify_Flash_10:
_Notify_Flash_11:
_Notify_Flash_12:
_Notify_Flash_13:
_Notify_Flash_14:
_Notify_Flash_15:
_Notify_Flash_16:
_Notify_Flash_17:
_Notify_Flash_18:
_Notify_Flash_19:
_Notify_Flash_20:
_Notify_Flash_21:
_Notify_Flash_22:
_Notify_Flash_23:
_Notify_Flash_24:
_Notify_Flash_25:
 StringReplace, FlashGN, A_ThisLabel, _Notify_Flash_
 FlashGN += GF - 1
 FlashGN2 := FlashGN + GL - GF + 1
 If Flashed%FlashGN2% := !Flashed%FlashGN2%
  Gui, %FlashGN2%:Color, %BK%
 Else
  Gui, %FlashGN2%:Color, %BC%
Return
}
