/*
 * * * Compile_AHK SETTINGS BEGIN * * *

[AHK2EXE]
Exe_File=%In_Dir%\todo list 1.3.5.1.exe
[VERSION]
Set_Version_Info=1
File_Version=1.3.5.2
Inc_File_Version=0
Legal_Copyright=Jarett Karnia
Original_Filename=To Do List
Product_Version=1.3.5.2
[ICONS]
Icon_1=%In_Dir%\test for todo list.ahk_1.ico

* * * Compile_AHK SETTINGS END * * *
*/

/*
****** To Do still  *******

actions with due dates
add in checked for submenu items
add in reminders for submenu items
*/

/*
***** Done ******
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

1.2.4
Spaced context menu a lil bit for better readibility
Added a context menu item to change the task name

1.2.5
added submenu items

*/

#SingleInstance, force
#InstallKeybdHook
SetWinDelay,100
DetectHiddenWindows, on
global Load_counter, infile, Linenumber, Timer_store_Array, Controltemp, IniSubtask, sub_Timer_store_Array

PID:=DllCall("GetCurrentProcessId") ; Gets this programs Process ID
for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where name LIKE  '%todo list%' and processID  <> " PID ) 
{
process, close, % process.ProcessId ; kills the process (closed the program)
}


;~ folder_check() 
Result := FileExist("C:\To Do List")
If Result =
   FileCreateDir, C:\To Do List

Result := FileExist("C:\To Do List\Testtodo.ini")
If Result =
   FileAppend,,C:\To Do List\Testtodo.ini

Result := FileExist("C:\To Do List\Sub_tasks")
If Result =
    FileCreateDir, C:\To Do List\Sub_tasks
Install_files()
infile = C:\To Do List\Testtodo.ini
 IniSubtask =  C:\To Do List\Sub_tasks\
 Load_ini_file(infile)
 Load_ini_file_sub(IniSubtask)
Build_Gui()
Sleep 100

Menu, Context, UseErrorLevel
Create_tray_menu()
SetTimer, sync_clock, 500

start_up_check()
;~ sub_Create_reminder_timer()
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

help_gui()
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
Quit_app()
{
 ExitApp
return   
}

Options_gui()
{
   global infile
   IniRead, status, %infile%, Options, startup 
 Gui, options:add, Checkbox,checked%status% vstartup gStart_up, Start with computer
 gui, options:Show, w200,Options
 return
 }

start_up_check()
{
   global infile
IniRead, Startup, %infile%, Options, Startup
if (Startup)
{
EXE_check() 
 install_shortcut()
}
return
}
Exe_Check()
{
   	Folder := A_Startup
		loop, %folder%\*.lnk
		{
			If A_LoopFileName Contains To DO
        	{
         		;msgbox, foudn name %A_LoopFileName%
				   FileGetShortcut, %folder%\%A_LoopFileName%, File_Location
                   
                       If File_Location contains `.ahk
                        return
                        
                   IfExist,  %File_Location%
                     FileGetVersion, file_version_old, %File_location%
                     FileGetVersion, file_version_Current, %A_ScriptFullPath%
                     ;~ MsgBox, % FIle_version_old " is old version`n" FIle_version_Current
                     If file_version_old = 
                        return
                     If FIle_version_Current = 
                        return
                     
                     if FIle_version_old < %FIle_version_Current%               
                      MsgBox, 52, Delete old File?, Do you want to delete the previous version of the To Do LIst from your computer?
                             IfMsgBox Yes
                           {
                              ;~ MsgBox, Yes
                                FileDelete, %File_location%        
                              ;~ MsgBox %A_LastError%
}                              
                Sleep 500
			}}
   return
}

start_up()
{
   global infile
gui, options:Submit, NoHide
GuiControlGet, startup
IniWrite, %startup%, %infile%, Options, startup

if (Startup)
 install_shortcut()
return
}
install_shortcut()
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
Show_hide_gui()
return
}

Show_hide_gui()
{
   static mx,my
   IfWinExist, To Do ahk_class AutoHotkeyGUI
   {
      ;~ MsgBox, Exist
      WinGetPos, mx,my,,,To Do ahk_class AutoHotkeyGUI
      gui, main:Destroy
      return
   }
   ;~ WinHide, To Do
    IfWinNotExist, To Do ahk_class AutoHotkeyGUI
   {
      ;~ MsgBox not Exist
      ;~ WinShow, To Do
      Build_gui(mx, my)
      Sleep 10
   guicontrol,Main:Focus, Addtolist
   ;~ WinActivate, To Do
   }  
   return
}
Add:
{
Gui, Submit, NoHide
GuiControlGet, Addtolist
If Addtolist =
   return

Line_Count := Line_number("Add")
item := Parse_loop(, Addtolist)
IniWrite, %item%, %infile%, line%Line_Count%, item
 INIstorechecked :=  "0:line" line_count
 IniWrite, 0, %infile%, line%Line_Count%, Checked
 
If Addtolist contains `/r
  {
  Reminder :=  Parse_loop("r", Addtolist)
}

  If Addtolist contains `/l
{
     Link :=  Parse_loop("l", Addtolist) 
     if Link != canceled
      IniWrite, %Link%, %infile%, line%Line_Count%, Link
 }

Build_gui()
return
}

Line_number(Task := "")
{
   static Line_Number =0
   
   If task = reset
      Line_Number = 0
   
else  If Task = add 
   Line_Number++
   
   return Line_Number
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
 ;Build_gui()

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
            ;~ MsgBox % Contextselect
            If Contextselect = 1
            {
               Line_Count :=  Controltemp
            Contextselect = 0
     IniWrite, %mydateTime%, %infile%, line%Line_Count%, Reminder
  }
  
  If Contextselect = 2
{
      IniWrite, %mydateTime%, %IniSubtask%line%Linenumber%.ini, s%subtask_number%, Reminder
   
}
     Gui, date:Destroy
     
   return
}

Create_reminder_timer()
{
   global infile, Timer_store_Array
   global Timer_string := ""   
   timersplit3 = 
   Timer_String = 
      for index, element in Timer_store_Array
                  {
                     StringSplit, Timersplit,element, `:
                     
                       timestring := SubStr( Timersplit1, 1, 8)
                        date := SubStr( A_now, 1, 8)
                          If Date = %timestring%
                        {
                             Timer_string := Timer_String  timersplit2  "|"
                        }
                     }
                     
 sub_Create_reminder_timer()                    
 gosub, alarms
SetTimer, sync_clock, 10

 return  
}

sub_Create_reminder_timer()
{
   global infile, Sub_Timer_store_Array, Timer_string
     timersplit3 = 
      for index, element in sub_Timer_store_Array
                  {
                     StringSplit, Timersplit,element, `:
                     Loop, 3
                        text := % text  Timersplit%A_Index% " is timersplit " A_Index "`n"
                     ;~ MsgBox % text
                       timestring := SubStr( Timersplit1, 1, 8)
                        date := SubStr( A_now, 1, 8)
                          If Date = %timestring%
                        {
                       StringReplace, timersplit3,timersplit3, `.ini,,
                       ;~ MsgBox, % timersplit3 " is timersplit3"
                           Timer_string := Timer_String  timersplit2 ":" timersplit3 "|"
                           timersplit3 = 
                        }}
 return  
}


Sync_clock:
 ListLines Off
{
  
    Seconds := SubStr( A_now, 13, 2)
    If Seconds < 1
   {
      SetTimer, sync_clock, Off
      gosub, alarms
      SetTimer, alarms, 60000
   }

   return
   ListLines on 
}

alarms:
{
   ;~ MsgBox, % Timer_String
 Loop, parse, Timer_String , |
{
   if A_LoopField contains `:
   {
      StringSplit,Temparray, A_LoopField, `:
      ;~ MsgBox % temparray1 "`n" temparray
       IniRead, Reminder_time, %IniSubtask%%temparray2%.ini, %Temparray1%, Reminder
       IniRead, Itemname, %IniSubtask%%temparray2%.ini, %Temparray1%, Item
       Reminder_time := SubStr( Reminder_time, 9, 4)
  If Reminder_time = % SubStr( A_now, 9, 4)
Create_alarm(Temparray1, temparray2)
continue
    }
       else
{
   ;~ MsgBox, parent alarm
 IniRead, Reminder_time, %infile%, %A_LoopField%, Reminder

Reminder_time := SubStr( Reminder_time, 9, 4)
If Reminder_time = % SubStr( A_now, 9, 4)
Create_alarm(A_LoopField)
}}
   
   return
}

Create_alarm(line, Subtask_line := "")
{
   static wb
   
      IfWinExist, alarm
      Exist = 1
      
   IfWinExist, alarm%line%a
   {
      ;~ MsgBox, win Exists
Exist = 0
return    
}

activeMonitorInfo(  aX,  aY,  aWidth,    aHeight,  mouseX,  mouseY  )
If line contains s
       IniRead, itemtext, %IniSubtask%%subtask_line%.ini, %line%, item
       else
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
If line contains s
IniDelete, %IniSubtask%%subtask_line%.ini, %line%, Reminder
else
IniDelete, %infile%, line%linetemp%, Reminder
Sleep 100
GuiControl, Hide, picture%linetemp%
   return
}


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
   ;~ MsgBox % itemnum
   If itemnum contains s
   {
      Extract_sub_task_information(itemnum,line,subline)
      ;~ MsgBox, %line% is line  %subline% is subline
      IniDelete, %IniSubtask%line%line%.ini,s%subline%
      Renumber_sub_ini(line)
      return
   }
   ;~ MsgBox % itemnum
    IniDelete,%infile%, %itemnum%
    FileDelete, %IniSubtask%%itemnum%.ini
    Sleep 10
   Renumberini()
   Sleep 10
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
     Menu, Context, add, Change File Link, Attach_file
     Menu, Context, add, Remove File Link, Remove_file  
      Menu, Context, add
    }
    else
        Menu, Context, add, Add File Link, Attach_file

            Menu, Context, add, Edit Task Name, Change_Name
            
            Menu, Context, add, Add Sub Task, Add_Sub_task
            
        Menu, Context, add 
  If list  not contains reminder
{
       Menu, Context, add, Add Alarm, alarmset
 Menu, Context, add   
} 
       If list contains reminder
      {
         Menu, Context, Add, Change Alarm Time, alarmset
         Menu, Context, Add, Remove Alarm Time, alarmremove
         Menu, Context, add   
      }
else if not contains Link   
{
Menu, Context, add, Attach File, Attach_file
 Menu, Context, add
}


Menu, Context, add, Delete Task, Delete_line
 Menu, Context, add
Menu, Context, add, Delete All Checked Tasks, Delete_checked

      return
   }
   
  
  ;~ Work with subtasks
  Add_sub_task:
{
   ;~ MsgBox %Linenumber% is  Linenumber
   ;~ MsgBox %IniSubtask% is IniSubtask
  ;~ MsgBox, % Linenumber 
   IfExist, %IniSubtask%line%Linenumber%.ini
   {
      ;~ MsgBox exist
   Loop
      {
         IniRead, linecheck, %IniSubtask%line%Linenumber%.ini, s%A_Index%, Item
         ;~ MsgBox, % linecheck " is linecheck"
         If linecheck = Error
         {
            subtask_number := A_Index
            ;~ MsgBox, % subtask_number
           Add_Subtask_gui(subtask_number)
            break
         }
      }
      
   ;~ return
   }
 else 
{
      ;~ MsgBox make
      FileAppend,, %IniSubtask%line%Linenumber%.ini
      Sleep 100
      subtask_number = 1
           Add_Subtask_gui(subtask_number)
   ;~ IniWrite,  test , c:\To Do List\line%Linenumber%.ini, test, test
}
   return
}

 Add_Subtask_gui(number)
 {

   ;~ Gui, Destroy
   ;~ Sleep 500
   global Linenumber, Task_infile, Section_index, changeHWID, subtask_number
   ;~ MsgBox, add subtask gui
   Task_infile = %IniSubtask%line%Linenumber%.ini
         ;~ MsgBox, % subtask_number "is subtask num"
   Section_index := "s" subtask_number

;~ WinGetPos, ax, ay, ,,To Do ahk_class AutoHotkeyGUI

;~ Gui, change:add,text, ,Sub Task %number% name:
;~ Gui, change:add,Edit, vTask_name w250, 
;~ Gui, change:add,button,Default gupdate_Task_Change, Ok
;~ Gui, change:add,button,yp xp+100  gchange_cancel_gui ,Cancel
;~ gui, change:show, , Add Sub Task GUI
;~ Gui, Change: +LastFound 
Gui,2: add,text, ,Sub Task %number% name:
Gui, 2:add,Edit, vTask_name w250, 
Gui, 2:add,button,Default gupdate_Task_Change, Ok
Gui, 2:add,button,yp xp+100  gchange_cancel_gui ,Cancel
gui, 2:show, , Add Sub Task GUI
Gui, 2:+LastFound 
ChangeHWID := WinExist()
GuiControl, Focus, Task_name  

   return
}

update_Task_Change:
{
  gui, 2:Submit, NoHide
GuiControlGet,Task_name
IF Task_name = 
   return
;~ MsgBox % Task_name " is task name`n" Task_infile " is task infile`n" Section_index " is section index"
;~ WinClose, ahk_id %changeHWID%
;~ WinClose, To Do ahk_class AutoHotkeyGUI
gui,2:Destroy
  IniWrite, %Task_name%, %Task_infile%, %Section_index%, Item 
  Build_gui()
   return
}

Attach_file:
{
 Link := Parse_loop("l")  
    if Link != canceled
    IniWrite, %Link%, %infile%, line%Linenumber%, Link
    ;~ IniRead, %Item%, %infile%, line%Linenumber%, item
        Build_gui()
    return
   
}   

Sub_Attach_file:
{
 Link := Parse_loop("l")  
    if Link != canceled
    IniWrite, %Link%, %IniSubtask%line%Linenumber%.ini, s%subtask_number%, Link
    ;~ IniRead, %Item%, %infile%, line%Linenumber%, item
        Build_gui()
    return
   
}   

Change_Name:
{
 IniRead, Item_name, %infile%, line%Linenumber%, item  

Name_gui(Item_Name,"Linenumber")
 
   return
}

sub_Change_Name:
{
 IniRead, Item_name, %IniSubtask%line%Linenumber%.ini, s%subtask_number%, item  

Sub_Name_gui(Item_Name)
 
   return
}

Sub_Name_gui(Item_Name)
{
   global Linenumber, Section_index, infile, subtask_number
   
   
     ;~ WinClose, To Do ahk_class AutoHotkeyGUI
   ;~ MsgBox % Item_Name " is item_name`n" task_define " is task define"
   ;~ MsgBox % Linenumber


   Section_index:=  "s" subtask_number
   
activeMonitorInfo(  aX,  aY,  aWidth,  aHeight,  mouseX,  mouseY  )
   WinGetPos, x, y,,,To Do ahk_class AutoHotkeyGUI
   Sleep 100
 
Gui, 2:add,text, ,Task Name:

 Gui, 2:add,Edit, vTask_name w250, %Item_Name%
 Gui, 2:add,button,Default gSub_update_name_change, Ok
 Gui, 2:add,button,yp xp+100 gchange_cancel_gui, Cancel
 gui, 2:show, x%x% y%y%,
GuiControl, Focus, Task_name  
return
}

Name_gui(Item_Name, task_define)
{
   global Linenumber, Section_index, infile
   
   
     ;~ WinClose, To Do ahk_class AutoHotkeyGUI
   ;~ MsgBox % Item_Name " is item_name`n" task_define " is task define"
   ;~ MsgBox % Linenumber
   If task_define = Linenumber
   {
      ;~ Linenumber := Linenumber
   Section_index := "line" Linenumber
   }
   
   if task_define = subtask
   {
      infile = 
   Section_index:=  "s" Item_Name
   Sub_Name := Item_Name
   Item_Name =
   }
activeMonitorInfo(  aX,  aY,  aWidth,  aHeight,  mouseX,  mouseY  )
   WinGetPos, x, y,,,To Do ahk_class AutoHotkeyGUI
   Sleep 100
 
   Sleep 100
   
   
Gui, 2:add,text, ,Task Name:

 Gui, 2:add,Edit, vTask_name w250, %Item_Name%
 Gui, 2:add,button,Default gupdate_name_change, Ok
 Gui, 2:add,button,yp xp+100 gchange_cancel_gui, Cancel
 gui, 2:show, x%x% y%y%,
GuiControl, Focus, Task_name  
return
}

change_cancel_gui:
{
 Gui, 2:Destroy  
   return
}
2cancel:
2close:
2escape:
{
      ;~ Gui, Destroy
   Gui, 2:Destroy
   
   ;~ Build_gui()
   return
}

update_name_change:
{
      ;~ Gui, Destroy
 gui, 2:Submit, NoHide
GuiControlGet,Task_name
gui, 2:Destroy
   ;~ MsgBox % Section_index " is sectionindex"
IniWrite, %Task_name%, %infile%, %Section_index%, Item
;~ infile = %Root_folder%\Testtodo.ini

Sleep 10
Build_gui()
;~ ListLines
return
}

Sub_update_name_change:
{
      ;~ Gui, Destroy
 gui, 2:Submit, NoHide
GuiControlGet,Task_name
gui, 2:Destroy
   ;~ MsgBox % Section_index " is sectionindex"
IniWrite, %Task_name%, %IniSubtask%line%Linenumber%.ini, %Section_index%, Item
;~ infile = %Root_folder%\Testtodo.ini

Sleep 10
Build_gui()
;~ ListLines
return
}

Delete_checked:
{
 Load_ini_file(infile, 1)
 Renumberini()
 Build_gui()
   return
}
alarmremove:
{   
   IniDelete, %infile%, line%Linenumber%, Reminder
   Build_gui()
   return
}

Sub_alarmremove:
{
     IniDelete, %IniSubtask%line%Linenumber%.ini, s%subtask_number%, Reminder
   Build_gui()
   return
}
alarmset:
   {
      ;~ MsgBox, %Linenumber%

      StringReplace, Controltemp, Controltemp, line,,
      Contextselect = 1
      Select_date_time(Controltemp) 
      Build_gui()
return
}
Sub_alarmset:
   {
      ;~ MsgBox, %Linenumber%

      StringReplace, Controltemp, Controltemp, line,,
      Contextselect = 2
      Select_date_time(Controltemp) 
      Build_gui()
return
}

Remove_file:
 {
   IniDelete, %infile%, line%Linenumber%, Link   
   Build_gui()
   return
   }
   
   Sub_Remove_file:
    {
   IniDelete, %IniSubtask%line%Linenumber%.ini, s%subtask_number%, Link   
   Build_gui()
   return
   }
Delete_Sub_line:
   {  
      ;~ MsgBox % Controltemp
   Delete_ini(Controltemp) 
  Sleep 10
  gui, main:Destroy
  Sleep 100
  Build_gui()
      return
   }
   delete_line:
   {  
      ;~ MsgBox % Controltemp
   Delete_ini(Controltemp) 
  Sleep 10
  gui, main:Destroy
  Sleep 100
  Build_gui()
      return
   }
   
;*********************************************************************
   
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
      global IniSubtask, infile
      Counter = 1
      ;~ MsgBox, % subfile
   
      Loop, read, %infile%, `n
      {
         If  (a_LoopReadLine = "") || (A_LoopReadLine  = "`n")
            continue
         
       If A_LoopReadLine contains `[line
      {
         StringReplace, Lineitem,A_LoopReadLine, `[,,
         StringReplace, Lineitem,Lineitem, `],,
         ;~ MsgBox, % lineitem
         Temptext := Temptext "`[line" Counter  "`]`n"   
         IfExist,%IniSubtask%%lineitem%.ini
         {
            FileMove,%IniSubtask%%lineitem%.ini,%IniSubtask%line%Counter%.ini,1
        Renumber_sub_ini(Counter)
      }
         
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
   
   Renumber_sub_ini(subfile)
   {
          global IniSubtask, infile
      Counter = 1  
       If subfile != 
    {
      tempini = %IniSubtask%line%subfile%.ini
      ;~ MsgBox % tempini
       Loop, read, %tempini%, `n
      {
         ;~ MsgBox % A_LoopReadLine
         If  (a_LoopReadLine = "") || (A_LoopReadLine  = "`n")
            continue
         
       If A_LoopReadLine contains `[s
      {
         
         Temptext := Temptext "`[s" Counter  "`]`n"   
         Counter++
      }
      else
         Temptext := Temptext A_LoopReadLine "`n"   
      }
      Sleep 100
FileDelete, %tempini%
Sleep 100
FileAppend, %temptext%, %tempini%     
      return
   }  
      
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
 Build_gui()
 return  
 }
 
Build_gui( x := "", y := "")
{
global 
 ListLines Off
exist = 0

ifWinExist, To DO
   Gui, main:Destroy

IfWinExist, To Do
{
   ;~ MsgBox Exists
 WinGetPos ,x,y,,,To Do ahk_class AutoHotkeyGUI
  Gui, main:Destroy
 Exist = 1
   }
   
  Load_ini_file(infile)
  Line_Count := Line_number()
    ;~ Load_ini_file_sub(IniSubtask)
   ;~ MsgBox, % Line_Count
   Create_reminder_timer()
 Loop, %Line_Count%
{
   IniRead, check_status,  %infile%, line%A_Index%, Checked
   IniRead, line,  %infile%, line%A_Index%, item
   IniRead, Link,  %infile%, line%A_Index%, Link
   IniRead, Reminder,  %infile%, line%A_Index%, Reminder
   
        If (Reminder !="") && (Reminder != "ERROR")
         Gui, main:add, Picture, x1 h12 w12 vpicture%A_Index%, C:\To Do List\alarm.png
      if (Link !="") && (Link != "ERROR")
      Gui, main:Font, cblue underline 
         If (Reminder !="") && (Reminder != "ERROR")
       GUi, main:Add, Checkbox,  x20  yp CHecked%check_status% vline%A_Index% gcheck_mark, %line%
       else 
             GUi, main:Add, Checkbox,  x20   CHecked%check_status% vline%A_Index% gcheck_mark, %line%
       gui, main:Font
       subcheck := A_Index
       ;~ MsgBox subcheck is %subcheck%
       Loop, 
      {         
         IfNotExist, %IniSubtask%line%subcheck%.ini
         {
            ;~ MsgBox, no subtasks
            break
         }
         ;~ MsgBox, %IniSubtask%line%subcheck%.ini,
         ;~ MsgBox %IniSubtask%line%subcheck%.ini
   IniRead, check_status, %IniSubtask%line%subcheck%.ini, s%A_Index%, Checked
   ;~ MsgBox   %IniSubtask%line%subcheck%.ini, s%A_Index%, line%subcheck% s%A_Index% checked is %check_status%
   IniRead, line, %IniSubtask%line%subcheck%.ini,s%A_Index%, item
   IniRead, Link,  %IniSubtask%line%subcheck%.ini,s%A_Index%, Link
   IniRead, Reminder,  %IniSubtask%line%subcheck%.ini,s%A_Index%, Reminder
   ;~ MsgBox % check_status " is check status`n" line " is line`n" Link " is link`n" Reminder " is reminder"
       if line = Error
            break
            
       If (Reminder !="") && (Reminder != "ERROR")
         Gui, main:add, Picture, x20 h12 w12 vpictures%subcheck%s%A_Index%, C:\To Do List\alarm.png
      if (Link !="") && (Link != "ERROR")
      Gui, main:Font, cblue underline 
         If (Reminder !="") && (Reminder != "ERROR")
       GUi, main:Add, Checkbox,  x38  yp CHecked%check_status% vline%subcheck%s%A_Index% gcheck_mark, %line%
       else 
             GUi, main:Add, Checkbox,  x38   CHecked%check_status% vline%subcheck%s%A_Index% gcheck_mark, %line%
       gui, main:Font
   
      }
 }   
Gui, main:Add, Edit, x20 vaddtolist w300,
Gui, main:Add, Button,  xp yp Default  gadd Hidden, Ok

 if (x = "" ) || (y ="") 
Gui, main:Show , ,To Do
else
{
Gui, main:Show , x%x% y%y%,To Do
Exist = 0
}

  OnMessage(0x204, "WM_RBUTTONDOWN")
  GuiControl,main:Focus, Addtolist
ListLines, on
return
}

mainGuiClose:
mainGuiEscape:
{
 gui, main:Destroy  
   
   return
}
run:
{
   return
}
check_mark:
{
   line = 
   subline = 
   gui,Submit, NoHide
GuiControlGet, isitchecked,, %A_GuiControl%
;~ MsgBox % A_GuiControl

If A_GuiControl contains s
{
   Extract_sub_task_information(A_GuiControl, line,subline)
   GuiControlGet, isitchecked,, line%line%s%subline%
   ;~ MsgBox % A_GuiControl "`n" line "`n" subline
      If isitchecked = 1
IniWrite,1, %IniSubtask%line%line%.ini,  s%subline%, Checked
   If isitchecked = 0
IniWrite,0, %IniSubtask%line%line%.ini,  s%subline%, Checked
Stopped_loop = 0
scount = 0
Scount := Count_subtasks(line)
                     
         Loop, %Scount%
         {
      IniRead, check_status, %IniSubtask%line%line%.ini, s%A_Index%, Checked
      ;~ MsgBox % check_status
      If (check_status = 1)
         Stopped_loop = 0
 else IF (check_status = "error") or (check_status = 0)
{    
    Stopped_loop = 1
      break
   }   
}
IF stopped_loop = 0
{
 IniWrite,1, %infile%,  line%line%, Checked  
GuiControl,main:,line%line%,1
}
else
{
 IniWrite,0, %infile%,  line%line%, Checked  
 GuiControl,main:,line%line%,0
 ;~ Build_gui()
 }
}
else
{    
   StringReplace,line, A_GuiControl, line,, 
    Scount := Count_subtasks(line)
    ;~ MsgBox %  line "is line `n scount is "Scount
   If isitchecked = 1
   { 
 Loop, %Scount%
{
 IniWrite, 1, %IniSubtask%line%line%.ini, s%A_Index%, Checked
GuiControl,main:,line%line%s%a_index%,1
}
IniWrite,1, %infile%,  %A_GuiControl%, Checked

}
   If isitchecked = 0
   {
       Loop, %Scount%
{
 IniWrite, 0, %IniSubtask%line%line%.ini, s%A_Index%, Checked
GuiControl,main:,line%line%s%a_index%,0
}
IniWrite,0, %infile%,  %A_GuiControl%, Checked
}}

   return
}
count_subtasks(line)
{
   global IniSubtask
   Scount = 0
   Loop, Read, %IniSubtask%line%line%.ini
{
         if regexmatch(A_Loopreadline,"\[(.*)?]")
                     {
                        Section :=regexreplace(A_loopreadline,"(\[)(.*)?(])","$2")
                        StringReplace, Section,Section, %a_space%,,All
                        if Section != options
                     scount++                     
                     }
                  }
                  return Scount
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

Sub_Run_file()
{
      global subtask_number, Linenumber, IniSubtask
;~ MsgBox % control
      IniRead, Run_file, %IniSubtask%line%Linenumber%.ini, s%subtask_number%, Link
      ;~ MsgBox, % Run_file
      If (Run_file !="") && (Run_file != "ERROR")
      Run, %Run_file%
      return
   }
   
   

               Load_ini_file(inifile, DeleteAll := 0)
               {
                  global
                  ListLines, Off
                  Ini_var_store_array:= Object()
                  Timer_store_Array := Object()
                  Tab_placeholder  =
                  Timer_store_Array := []
                  Line_Number("reset")
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
                    Line_number("Add")
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
                          ;~ Load_ini_file_sub(IniSubtask)
                     ListLines, on
                     
                  return 
               }
               
     Load_ini_file_sub(inifile)
               {
                  global
                  ListLines, Off
                  Line_Count=0
                   Tab_placeholder  =
                  Sub_Timer_store_Array := Object()
         Sub_Timer_store_Array := []
      
                  
                  Loop, Files, %inifile%*.ini
             {
                  loop,read, %A_LoopFileFullPath%
                  {
                     ;~ MsgBox % A_Loopreadline
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
                        ;~ MsgBox, % Keytemp " is keytemp`n" A_LoopFileFullPath " is full path`n" section " is section`n" keytemp " = " %keytemp% " is keytemp"
                        IniRead,%keytemp%, %A_LoopFileFullPath%, %Section%, %keytemp%
                        If keytemp = Reminder
                           if Reminder !=
                              If Reminder != Error
                              {                               
                                 ;~ MsgBox, Found raminder
                                 Date := %Keytemp%
                                 ;~ MsgBox % A_LoopFileName
                                 Sub_Timer_store_Array.Insert(date ":" Section  ":" A_LoopFileName)
                              }
                     }}}
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

Extract_sub_task_information(control_item, ByRef line, ByRef subline)
{
   StringReplace, control_item,control_item, line,,
      Position := InStr(control_item, "s")
      
;~ MsgBox % control_item " is control_item `n" position " is position `n"
line := SubStr(control_item,1, (Position-1))
subline := SubStr(control_item,(Position+1))
;~ StringTrimRight, line, control_item, %Position%, 2
;~ StringTrimLeft, subline, control_item, %Position%,
;~ MsgBox % line " is line`n" subline " is subline"
return
}


Sub_Task_context_Menu(Guicontrolitem)
{
   global
   ;~ MsgBox % Guicontrolitem
           Extract_sub_task_information(Guicontrolitem,  Linenumber,  subtask_number)
           ;~ MsgBox, % Linenumber "`n" subtask_number
IniRead,Reminder, %IniSubtask%line%Linenumber%.ini, s%subtask_number%, Reminder
IniRead,Link, %IniSubtask%line%Linenumber%.ini,s%subtask_number%, Link

   Menu, sub_Context, DeleteAll 
;~ MsgBox % Link
                      If (Link !="") && (Link != "ERROR") 
         {
      Menu, sub_Context, add, Run File, Sub_Run_file
     Menu, sub_Context, add, Change File Link, Sub_Attach_file
     Menu, sub_Context, add, Remove File Link, Sub_Remove_file  
      Menu, sub_Context, add
    }
  

            Menu, sub_Context, add, Edit Sub Task Name, sub_Change_Name
            
            Menu, sub_Context, add, Add Sub Task, Add_Sub_task
            
        Menu, sub_Context, add 

     
 Menu, Context, add   

       If (Reminder !="") && (Reminder != "ERROR") 
      {
         Menu, sub_Context, Add, Change Alarm Time, Sub_alarmset
         Menu, sub_Context, Add, Remove Alarm Time, Sub_alarmremove
         Menu, sub_Context, add   
      }
      else
           Menu, sub_Context, add, Add Alarm, Sub_alarmset
           
 If (Link ="") || (Link = "ERROR") 
{
Menu, sub_Context, add, Attach File, Sub_Attach_file
 Menu, sub_Context, add
}


Menu, sub_Context, add, Delete Sub Task, Delete_line
 Menu, sub_Context, add
Menu, sub_Context, add, Delete All Checked Tasks, Delete_checked
  
  Menu,sub_Context, Show
   return
}
WM_RBUTTONDOWN(wParam, lParam)
{
   global Linenumber, Controltemp, subtask_number
   list = 
   ;~ MsgBox % wParam "`n" lParam
   WinGetActiveTitle, Activetitle
   If activetitle !contains To Do
      return
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
      If A_GuiControl contains s
      {
         Sub_Task_context_Menu(Controltemp)
         return
      }

      else
      {
subtask_number = 
StringReplace,Linenumber,A_GuiControl,line,,
IniRead,Link, %infile%, line%Linenumber%, Link
IniRead,Reminder, %infile%, line%Linenumber%, Reminder
}


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

If title contains alarm 
{
   WinGetClass, title_class, %title%
   If title_class != AutoHotkeyGUI
      return
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
If title contains alarm 
{
     WinGetClass, title_class, %title%
   If title_class != AutoHotkeyGUI
      return
   
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
