/*
 * * * Compile_AHK SETTINGS BEGIN * * *

[AHK2EXE]
Exe_File=%In_Dir%\todo list1.2.2.3.exe
[VERSION]
Set_Version_Info=1
File_Version=1.2.3.0
Inc_File_Version=0
Legal_Copyright=Jarett Karnia
Original_Filename=To Do List
Product_Version=1.0.0.10
Inc_Product_Version=1
[ICONS]
Icon_1=%In_Dir%\test for todo list.ahk_1.ico

* * * Compile_AHK SETTINGS END * * *
*/

/*

actions with due dates
*/

/*
Done:
1.21
Register checkbox and write to ini file
Regisert line commands
Ctrl + rbutton = run link
1.2.2
IF delete, renumber [line] in ini file
Actions with reminders
1.2.3
Startup file check
Fixed Options for startup.
removed context menu from the editfield box

*/

#SingleInstance, force
#InstallKeybdHook
SetWinDelay,2
DetectHiddenWindows, on
global Load_counter, infile, Linenumber, Timer_store_Array, Controltemp
Install_files()
PID:=DllCall("GetCurrentProcessId") ; Gets this programs Process ID
for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where name = 'TO DO.exe' and processID  <> " PID ) 

Result := FileExist("C:\To Do List")
If Result =
   FileCreateDir, C:\To Do List

Result := FileExist("C:\To Do List\Testtodo.ini")
If Result =
   FileAppend,,C:\To Do List\Testtodo.ini

infile = C:\To Do List\Testtodo.ini
 Load_ini_file(infile)
Build_Gui(infile)
Sleep 100

Menu, Context, UseErrorLevel
Create_tray_menu()
SetTimer, sync_clock, 10

gosub, start_up
   
return

Install_files()
{
   IfNotExist, C:\To Do List\Flash.gif
 FileInstall, C:\Users\karnijs\Documents\NiMi Containers\Autohotkey\Autohotkey\05_todo\Flash.gif,  C:\To Do List\Flash.gif
 IfNotExist, C:\To Do List\alarm.png
 FileInstall, C:\Users\karnijs\Documents\NiMi Containers\Autohotkey\Autohotkey\05_todo\alarm.png,  C:\To Do List\alarm.png
 return   
}
Create_tray_menu()
{
Menu, Tray, add, Show/Hide To Do Window, Show_hide_gui
 Menu, tray, add,   Options, Options_gui
 Menu, Tray, add, Help, Help_gui
 Menu, tray, add,
 Menu, tray, add, Quit,  Quit_app
 Menu, tray, Default, Show/Hide To Do Window
 Menu, tray, NoStandard
return 
}

help_gui:
{
   gui, help:add ,GroupBox, x0 y0 h300 w200,Command line entries
 gui, help:add, text,, Type /r after item to set a Reminder  
 gui, help:add, text,, Type /l after item to Link the item to a File

 
   
   return
}
helpguiclose:
helpguiexcape:
helpguicancel:
{
 gui,help:Destroy  
 return
 
}
Quit_app:
{
 ExitApp
return   
}

Options_gui:
{
   IniRead, status, %infile%, Options, startup 
 Gui, options:add, Checkbox,checked%status% vstartup gStart_up, Start with computer
 gui, options:Show, w200,Options
 return
 }

start_up:
{
gui, options:Submit, NoHide
GuiControlGet, startup
IniWrite, %startup%, %infile%, Options, startup

if (Startup)
   gosub, install_shortcut
return
}
install_shortcut:
{
 Filename := "To Do"
		Folder := A_Startup
		loop, %folder%\*.*
		{
			If A_LoopFileName Contains To DO
        	{
				;msgbox, foudn name %A_LoopFileName%
				FileDelete, %A_LoopFileFullPath%
                Sleep 2000
			}}
            
 If (Startup)
  FileCreateShortcut, %A_Scriptfullpath%, %A_startup%\%Filename%.lnk, C:\,%A_ScriptFullPath%, %Filename%
 return
}

^LWin::
^rwin::
{
   gosub, Show_hide_gui
return
}

Show_hide_gui:
{
 Winget, Gui1, Id, To Do ahk_class AutoHotkeyGUI
 If DllCall( "IsWindowVisible", UInt,Gui1 )
   WinHide, To Do
   else
   {
      WinShow, To Do
   guicontrol,Focus, Addtolist
   WinActivate, To Do
   }  
   return
}
Add:
{
Gui, Submit, NoHide
GuiControlGet, Addtolist
If Addtolist contains `*d
{
      Delete_entry(Addtolist)
return
}      
Line_Count++
item := Parse_loop(, Addtolist)
IniWrite, %item%, %infile%, line%Line_Count%, item
 INIstorechecked :=  "0:line" line_count
 IniWrite, 0, %infile%, line%Line_Count%, Checked

If Addtolist contains `/r
  {
  Reminder :=  Parse_loop("r", Addtolist)
  ;~ If Reminder = blank
   ;~ Select_date_time(Line_Count) 
  ;~ Create_reminder_timer(Reminder, "line" linecount)
}

  If Addtolist contains `/l
{
     Link :=  Parse_loop("l", Addtolist) 
     if Link != canceled
      IniWrite, %Link%, %infile%, line%Line_Count%, Link
 }
   If Addtolist contains `/d
{
     Due :=  Parse_loop("d", Addtolist) 
      iniWrite, %Due%, %infile%, line%Line_Count%, Due
 }

Build_gui(infile)
return
}

Select_date_time(Line_item)
{
global mydateTime, Mytime, Line_Count
 Gui,Date:Add, MonthCal, vMyDateTime
 Gui, Date:Add, DateTime, vMyTime  1, hh:mm tt
 Gui, Date:add, button, Default  Hidden  gsetdate, Add Date
 Gui, date:Show,
 gui, Date: +LastFound
 datehwid := WinExist()
 
 ;~ Line_Count := Line_item
  gui,date:Submit, NoHide
  
 Winwait, ahk_id %datehwid%

  
  WinWaitClose, ahk_id %datehwid%

   return
}

dateguicancel:
dateguiescape:
dateguiclose:
{
   gui, date:Submit, NoHide
 Reminder = 
  gui, date:Destroy
 ;Build_gui(infile)

return   
}

setdate:
{
  
   gui, date:Submit, NoHide
   GuiControlGet, mydateTime   
      GuiControlGet, MyTime
       MyTime := SubStr( MyTime, 9, 4)
            mydateTime := mydateTime Mytime
            ;~ MsgBox, % Line_Count
            If Contextselect = 1
            {
               Line_Count :=  Controltemp
            Contextselect = 0
         }
     IniWrite, %mydateTime%, %infile%, line%Line_Count%, Reminder
     Gui, date:Destroy
     
   return
}

Create_reminder_timer()
{
   global infile, Timer_store_Array
   global Timer_string := ""   
   
   Timer_String = 
      for index, element in Timer_store_Array
                  {
                     StringSplit, Timersplit,element, `:
                     
                       timestring := SubStr( Timersplit1, 1, 8)
                        date := SubStr( A_now, 1, 8)
                          If Date = %timestring%
                           Timer_string := Timer_String  timersplit2 "|"
                     }
 gosub, alarms
SetTimer, sync_clock, 10

 return  
}

Sync_clock:
{
    Seconds := SubStr( A_now, 13, 2)
    If Seconds < 1
   {
      SetTimer, sync_clock, Off
      gosub, alarms
      SetTimer, alarms, 60000
   }

   return
}
alarms:
{
 Loop, parse, Timer_String , |
{
 IniRead, Reminder_time, %infile%, %A_LoopField%, Reminder
  Reminder_time := SubStr( Reminder_time, 9, 4)
  If Reminder_time = % SubStr( A_now, 9, 4)
Create_alarm(A_LoopField)
}
   
   return
}

Create_alarm(line)
{
   static wb
      IfWinExist, alarm
      Exist = 1
   IfWinExist, alarm%line%a
   {
Exist = 0
return    
}

activeMonitorInfo(  aX,  aY,  aWidth,    aHeight,  mouseX,  mouseY  )
       IniRead, itemtext, %infile%, %line%, item
gifheight := 300
gifwidth := 300
CustomColor = EEAA99  
var = C:\To Do List\Flash.gif ;location of gif you want to show

Gui, alarm%Line%a: +LastFound  -caption  +ToolWindow 
gif_id := winexist()
gui, alarm%Line%b: -caption  +ToolWindow
Gui, alarm%Line%b:Color, %CustomColor%
gui, Alarm%line%b:Font, s14
gui, alarm%Line%b:add, text , cblack , %itemtext%

Gui, alarm%Line%b:Show, NoActivate Hide, alarm%line%b
WinGetPos, ,, Hwidth, hheight, alarmlineb
 Gui,alarm%Line%a:Add, ActiveX, x0 y0 w%gifwidth% h%gifheight% vwb , shell explorer 
  wb.Navigate("about:blank")
  html := "<html>`n<title>name</title>`n<body>`n<center>`n<img src=""" var """ Height="""  (gifheight  - 15) """  width="""  (gifwidth- 15) """ n</center>`n</body>`n</html>"
  wb.document.write(html)

gui, alarm%Line%b: +lastfound
trans_id := winexist()
WinSet, TransColor, %CustomColor% 255
         activeMonitorInfo(  aX,  aY,  aWidth,    aHeight,  mouseX,  mouseY  )
          WinGetPos , ,,Width, Height,  alarm%line%b
         xposb := ax  + (aWidth -  (Width/2))
         yposb := ay  + (aHeight - (Height/2))
         xposa :=  ax + (aWidth -  (gifwidth/2))
         yposa := ay + (aHeight - (gifheight/2))
       If (Exist)
      {
         aXstore := aX
      Loop, (line - 1)
         IfWinExist alarm%A_Index%
         {
            aX := (aX + (300 * a_index))
            If aX > (aWidth*2)
            {
                 ay := (ay + 300)
                 aX := aXStore
              }
            WinMove, alarm%A_Index%a, , %aX% ,%ay%
            Move_child(A_Index)
         }   
Exist = 0         
      
   }
gui, alarm%Line%b:show,NoActivate x%xposb% y%yposb%, alarm%line%b
  Gui, alarm%Line%a:show , NoActivate h%gifheight% w%gifwidth% x%xposa% y%yposa% , alarm%line%a
      OnMessage(0x201, "WM_LBUTTONDOWN")
  gui, alarm%Line%a: +LastFound
  ;~ OnMessage(0x03 , "WM_Move")
    ;~ OnMessage(0x201, "Go_away")

gui, alarm%Line%b: +Owneralarm%Line%a

gui, alarm%line%b: +AlwaysOnTop
Sleep 100
gui, alarm%line%b: -AlwaysOnTop

Move_child(line)
StringReplace, linetemp, line, line,,
;~ MsgBox, % linetemp

IniDelete, %infile%, line%linetemp%, Reminder
Sleep 100
GuiControl, Hide, picture%linetemp%
   return
}
;~ go_away:
;~ {
;~ WinGetActiveTitle, title
;~ If title contains alarmline
;~ {
      ;~ titletemp := SubStr( title, 1, 5)
      ;~ if (titletemp contains "a") || (titletemp contains "b")
         ;~ StringTrimRight, title, title, 1
;~ Gui, %title%a: Destroy
   ;~ }

;~ return
;~ }

Move_child(line)
{ 
 WinGetPos  x, y,Width1, Height1,alarm%line%a
WinGetPos, ,,Width, Height,  alarm%line%b
WinMove, alarm%line%b,,(x+ (Width1/2)-(Width/2)), (y+ (Height1/2)-(Height/2)) 
 return
}

optionsguiclose:
optionsguiescape:
{
gui, options:Destroy
return
}

Delete_ini(itemnum) 
{  
   global infile
   temptext = 
    IniDelete,%infile%, line%itemnum%
    Sleep 10
   Renumberini()
   Sleep 100
 return  
}

Parse_loop(identifier := 1, Texts := 2)
{
   
      Start_recording = 0
      temptexts =
     If (identifier = 1)
      Start_recording = 1
 Loop, Parse, Texts, %A_Space%
      {
         If (Start_recording)
         {
            If A_LoopField contains `/
            {
               Start_recording = 0
               break
            }
           temptexts :=  temptexts A_LoopField A_Space
        }
         If A_loopfield = `/%identifier%
         {
            Start_recording=1
            continue
         }  
         
}

If identifier = l
   FileSelectFile, temptexts, ,%A_Desktop%
If (ErrorLevel)
   return "canceled"

If identifier = r
{
   Select_date_time(Line_Count) 
return temptexts
}
If  (temptexts = "") || (temptexts = A_Space)
   return "blank"

      return temptexts      
  }
  
  #`::ListLines
  
   Create_context_menu(List)
   {
         global
      Menu, Context, DeleteAll 
         If list  contains Link
         {
      Menu, Context, add, Run File, Run_file
     Menu, Context, add, Change Link, Attach_file
     Menu, Context, add, Remove Link, Remove_file  
    }
    
  If list  not contains reminder
       Menu, Context, add, Add Reminder, alarmset
       If list contains reminder
      {
         Menu, Context, Add, Change Reminder Time, alarmset
         Menu, Context, Add, Remove Reminder Time, alarmremove
      }
         
else if not contains Link   
Menu, Context, add, Attach File, Attach_file

Menu, Context, add, Delete Item, Delete_line
Menu, Context, add, Delete All Checked Items, Delete_checked

      return
   }

Delete_checked:
{
 Load_ini_file(infile, 1)
 Renumberini()
 Build_gui(infile)
   
   
   return
}
alarmremove:
{   
   IniDelete, %infile%, line%Linenumber%, Reminder
   Build_gui(infile)
   return
}
   alarmset:
   {
      ;~ MsgBox, %Linenumber%

      StringReplace, Controltemp, Controltemp, line,,
      Contextselect = 1
      Select_date_time(Controltemp) 
      Build_gui(infile)
return
}

   Remove_file:
   {
   IniDelete, %infile%, line%Linenumber%, Link   
   Build_gui(infile)
   return
   }
   
   delete_line:
   {  
   Delete_ini(Linenumber) 
  Sleep 10
  Build_gui(infile)
      return
   }
   
   
       activeMonitorInfo( ByRef aX, ByRef aY, ByRef aWidth,  ByRef  aHeight, ByRef mouseX, ByRef mouseY  )
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
               
     Renumberini()
     {
      global infile
      Counter = 1
      Loop, read, %infile%, `n
      {
         If  (a_LoopReadLine = "") || (A_LoopReadLine  = "`n")
            continue
         
       If A_LoopReadLine contains `[line
      {
         Temptext := Temptext "`[line" Counter  "`]`n"   
         Counter++
      }
      else
         Temptext := Temptext A_LoopReadLine "`n"   
      }
      Sleep 100
FileDelete, %infile%
Sleep 100
FileAppend, %temptext%, %infile%     
      return
   }
   
 Delete_entry(Entry)
 {
 global infile
StringReplace, Entry,Entry, `*d%a_space%,,
StringReplace,entry, entry, %A_Space%,,All
If entry = checked
{
 gosub, Delete_checked
return   
}
  Loop, read, %infile%
{
   if A_LoopReadLine contains `[line
   {    
      StringReplace, Storelinenum, A_LoopReadLine,`[line,,All
      StringReplace, Storelinenum, Storelinenum,`],,All
      continue
   }
   
If A_LoopReadLine contains item`=
{
   StringReplace,  Temp,A_LoopReadLine, item`=,,
   StringReplace,Temp, Temp, %A_Space%,,All
   If temp = %entry%
   {
   Delete_ini(Storelinenum) 
   break
   } 
}
}
Sleep 10
  Renumberini()
  Sleep 10
 Build_gui(infile)
 return  
 }
 
Build_gui(infile)
{
global
Load_ini_file(infile)
ListLines,Off
IfWinExist, To Do ahk_class AutoHotkeyGUI
{
 WinGetPos ,x,y,,,To Do 
  Gui, Destroy
 Exist = 1
   }
   ;~ MsgBox, % Line_Count
   Create_reminder_timer()
 Loop, %Line_Count%
{
   IniRead, check_status,  %infile%, line%A_Index%, Checked
   IniRead, line,  %infile%, line%A_Index%, item
   IniRead, Link,  %infile%, line%A_Index%, Link
   IniRead, Reminder,  %infile%, line%A_Index%, Reminder
        If (Reminder !="") && (Reminder != "ERROR")
         Gui, add, Picture, x1 h12 w12 vpicture%A_Index%, C:\To Do List\alarm.png
      if (Link !="") && (Link != "ERROR")
      Gui, Font, cblue underline 
         If (Reminder !="") && (Reminder != "ERROR")
       GUi, Add, Checkbox,  x20  yp CHecked%check_status% vline%A_Index% gcheck_mark, %line%
       else 
             GUi, Add, Checkbox,  x20   CHecked%check_status% vline%A_Index% gcheck_mark, %line%
       gui, Font
 }   
Gui, Add, Edit, vaddtolist w300,
Gui, Add, Button,  xp yp Default  gadd Hidden, Ok
if (Exist)
{
Gui, Show , x%x% y%y%,To Do
Exist = 0
}
else 
  Gui, Show , ,To Do
  OnMessage(0x204, "WM_RBUTTONDOWN")
  GuiControl,Focus, Addtolist
ListLines, on
return
}

GuiClose:
GuiEscape:
{
 gui, Hide  
   
   return
}
run:
{
   return
}
check_mark:
{
   gui,Submit, NoHide
GuiControlGet, isitchecked,, %A_GuiControl%
   If isitchecked = 1
IniWrite,1, %infile%,  %A_GuiControl%, Checked
   If isitchecked = 0
IniWrite,0, %infile%,  %A_GuiControl%, Checked
   return
}

Run_file()
{
   global Controltemp
;~ MsgBox % control
      IniRead, Run_file, %infile%, %Controltemp%, Link
      ;~ MsgBox, % Run_file
      If (Run_file !="") && (Run_file != "ERROR")
      Run, %Run_file%
      return
}

Attach_file:
{
 Link := Parse_loop("l")  
    if Link != canceled
    IniWrite, %Link%, %infile%, line%Linenumber%, Link
    ;~ IniRead, %Item%, %infile%, line%Linenumber%, item
        Build_gui(infile)
    return
   
}
               Load_ini_file(inifile, DeleteAll := 0)
               {
                  global
                  ListLines, Off
                  Line_Count=0
                  Ini_var_store_array:= Object()
                  Timer_store_Array := Object()
                  Tab_placeholder  =
                  Timer_store_Array := []
                  If (DeleteAll)
                  {
                      loop,read,%inifile%
                     {
                        
                            if regexmatch(A_Loopreadline,"\[(.*)?]")
                     {
                        Section :=regexreplace(A_loopreadline,"(\[)(.*)?(])","$2")
                        StringReplace, Section,Section, %a_space%,,All
                           if Section != options
                                  continue
                        }
                        
                                  else if A_LoopReadLine = checked`=1
                     {
                              IniDelete, %infile%, %Section%
                     }
                  }
                     
                  }
                  loop,read,%inifile%
                  {
                     If A_LoopReadLine =
                     continue

                     if regexmatch(A_Loopreadline,"\[(.*)?]")
                     {
                        Section :=regexreplace(A_loopreadline,"(\[)(.*)?(])","$2")
                        StringReplace, Section,Section, %a_space%,,All
                        if Section != options
                     Line_Count++
                     continue
                     }

                     else if A_LoopReadLine !=
                     {
                        StringGetPos, keytemppos, A_LoopReadLine, =,
                        StringLeft, keytemp, A_LoopReadLine,%keytemppos%
                        StringReplace, keytemp,keytemp,%A_SPace%,,All
                        INIstoretemp := Keytemp ":" Section
                        Ini_var_store_array.Insert(INIstoretemp)
                        IniRead,%keytemp%, %inifile%, %Section%, %keytemp%
                        If keytemp = Reminder
                           if Reminder !=
                              If Reminder != Error
                              {                               
                                 Date := %Keytemp%
                                 Timer_store_Array.Insert(date ":" Section)
                              }
                     }}
                     ListLines, on
                  return
               }

               Write_ini_file(inifile)
               {
                  global

                  for index, element in Ini_var_store_array
                  {
                     StringSplit, INI_Write,element, `:

                     Varname := INI_Write1
                     IniWrite ,% %INI_Write1%, %inifile%, %INI_Write2%, %INI_Write1%
                  }

                  return
               }


WM_RBUTTONDOWN(wParam, lParam)
{
   global Linenumber, Controltemp
   list = 
KeyIsDown := GetKeyState("Ctrl" )
If (KeyIsDown)
   If A_GuiControl
   {
            Controltemp := A_GuiControl
      Run_file()
      return
   }
      
    X := lParam & 0xFFFF
    Y := lParam >> 16
    if A_GuiControl
   {
      if A_GuiControl = Addtolist
         return
      Controltemp := A_GuiControl
StringReplace,Linenumber,A_GuiControl,line,,
IniRead,Link, %infile%, line%Linenumber%, Link
IniRead,Reminder, %infile%, line%Linenumber%, Reminder

   If (Reminder !="") && (Reminder != "ERROR") 
list := list  "Reminder "

   
   If (Link !="") && (Link != "ERROR")      
      list := List "link "
   Create_context_menu(list)

Menu,Context, Show
}
return
}

WM_LBUTTONDOWN(wParam, lParam)
{
WinGetActiveTitle, title

If title contains alarmline
{
   StringReplace, number, title, alarm,,
   StringReplace, number, number, a,,
   StringReplace, number, number, b,,         
   MouseGetPos,KDE_X1,KDE_Y1,KDE_id
WinGetPos,KDE_WinX1,KDE_WinY1,,,ahk_id %KDE_id%
Loop
{
    GetKeyState,KDE_Button,LButton,P ; Break if button has been released.
    If KDE_Button = U
        break
    MouseGetPos,KDE_X2,KDE_Y2 ; Get the current mouse position.
    KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
    KDE_Y2 -= KDE_Y1
    KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; Apply this offset to the window position.
    KDE_WinY2 := (KDE_WinY1 + KDE_Y2)
    WinMove,ahk_id %KDE_id%,,%KDE_WinX2%,%KDE_WinY2% ; Move the window to the new position.
Move_child(number)
   }}
   return
}

~LButton::
WinGetActiveTitle, title
If title contains alarmline
{
if (A_PriorHotkey <> "~LButton" or A_TimeSincePriorHotkey > 400)
{
    return
}
            titletemp := SubStr( title, 1, 5)
         if (titletemp contains "a") || (titletemp contains "b")
         StringTrimRight, title, title, 1
      Gui, %title%a: Destroy
}
return
