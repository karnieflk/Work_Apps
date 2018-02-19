F12::
   UnderCursorToggle := ( ! UnderCursorToggle )
   If ( UnderCursorToggle )
      SetTimer ToolTipUnderCursor, 250
   Else
   {
      SetTimer ToolTipUnderCursor, Off
      ToolTip
      Clipboard := GetUnderCursorInfo(X, Y)
   }
Return

HexToDec(HexVal)
{
   Old_A_FormatInteger := A_FormatInteger
   SetFormat IntegerFast, D
   DecVal := HexVal + 0
   SetFormat IntegerFast, %Old_A_FormatInteger%
   Return DecVal
}

GetUnderCursorInfo(ByRef CursorX, ByRef CursorY)
{
   CoordMode Mouse, Screen
   CoordMode Pixel, Screen
   MouseGetPos, CursorX, CursorY, Window, Control
   WinGetTitle Title, ahk_id %Window%
   WinGetClass Class, ahk_id %Window%
   WinGetPos WindowX, WindowY, Width, Height, ahk_id %Window%
   WinGet PName, ProcessName, ahk_id %Window%
   WinGet PID, PID, ahk_id %Window%
   PixelGetColor BGR_Color, CursorX, CursorY
   WindowUnderCursorInfo := "ahk_id " Window "`n"
      . "ahk_class " Class "`n"
      . "title: " Title "`n"
      . "control: " Control "`n"
      . "PID: " PID "`n"
      . "process name: " PName "`n"
      . "top left (" WindowX ", " WindowY ")`n"
      . "(width x height) (" Width " x " Height ")`n"
      . "cursor's window position (" CursorX-WindowX ", " CursorY-WindowY ")`n"
      . "cursor's screen position (" CursorX ", " CursorY ")`n"
      . "BGR color: " BGR_Color " (" HexToDec("0x" SubStr(BGR_Color, 3, 2)) ", "
      . HexToDec("0x" SubStr(BGR_Color, 5, 2)) ", "
      . HexToDec("0x" SubStr(BGR_Color, 7, 2)) ")`n"
   Return WindowUnderCursorInfo
}

ToolTipUnderCursor:
   WindowUnderCursorInfo := GetUnderCursorInfo(CursorX, CursorY)
   CoordMode ToolTip, Screen
   ; place tooltip in quadrant opposite of cursor
   If ( CursorX < (A_ScreenWidth // 2) )
      TTXOffset = 150
   Else
      TTXOffset = -150
   If ( CursorY < (A_ScreenHeight // 2) )
      TTYOffset = 150
   Else
      TTYOffset = -150
   ToolTip %WindowUnderCursorInfo%
      , ( (A_ScreenWidth // 2) + TTXOffset )
      , ( (A_ScreenHeight // 2) + TTYOffset )
Return


F11::
Clipboard := GetUnderCursorInfo(CursorX, CursorY)
run, notepad,.exe
Sleep 1500
Send ^v
return

esc:: 
MsgBox, Exiting
ExitApp





wb := ComObjCreate("InternetExplorer.Application")
Wb.AddressBar := false
wb.MenuBar := false
wb.ToolBar := false
wb.StatusBar := false
wb.Resizable := false
wb.Width := 1000
wb.Height := 500
wb.Top := 0
wb.Left := 0
wb.Silent := true
hwnd := wb.hwnd
Gui, 2:+LastFound
ParentGUI := WinExist()
Gui,2:-SysMenu -ToolWindow -Border
Gui,2:Color, EEAA99                                 
Gui,2:+LastFound                                     
WinSet, TransColor, EEAA99                     
Gui,2:show,  W500 H500 , Updater

DllCall("SetParent", "uint",  hwnd, "uint", ParentGUI)
wb.Visible := True
WinSet, Style, -0xC00000, ahk_id %hwnd%

wb.navigate("https://alm.cat.com/qcbin/start_a.jsp")
while wb.busy
{
Sleep 100
}

return

