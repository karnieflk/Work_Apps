#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir   %A_ScriptDir% ; Ensures a consistent starting directory.
#SingleInstance, force
Loop_count = 15
StepDesc1 = hellp
GreateGui(Loop_count)
MsgBox, Pause
Gui,Submit, NoHide
Gui, Destroy
Sleep 100
GreateGui(Loop_count)
return

GreateGui(Loop_count)
{

	global
		Tab_names = 
		
	Loop, %Loop_count%
		Tab_names = %Tab_names%STEP %A_Index%|
	
	Gui, Add, Tab3,Left Buttons -Background, %Tab_names%
	
Loop, %Loop_count%
{
	gui, tab, %A_Index%	
Gui, Add, GroupBox, x150 y15 h300 w525,  STEP Descripton
Gui, Add, Edit, h30 x160 yp+30 h250 w500 VStepDesc%A_Index%, % StepDesc%A_index%
Gui, Add, GroupBox, x150 y325 h115 w175,  Part number(s)
Gui, Add, Edit, h30 x160 yp+30  h75 w150 VPartNumber%A_Index%, % PartNumber%a_index%
Gui, Add, GroupBox, x150 y445  h200 w525,  Ok
Gui, Add, Edit, h30 x160 yp+30 h150 w500 Vok%A_Index%, % ok%A_Index%
Gui, Add, GroupBox, x150 y650 h200 w525,  Not Ok
Gui, Add, Edit, h30 x160 yp+30 h150 w500 VNotOk%A_Index%,% NotOk%A_Index%
}
Gui, Show, h875
return
}

GuiEscape:
GuiClose:
ExitApp