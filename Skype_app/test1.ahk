
#SingleInstance, force
F2::
 hWnd := WinExist( "ahk_class HH Parent" ) 
  DllCall( "FlashWindow", UInt,hWnd, Int,False )
ToolTip, Flashing in 3
Sleep 1000
ToolTip, Flashing in 2
Sleep 1000
ToolTip, Flashing in 1
Sleep 1000
 hWnd1 := WinExist( "ahk_class LyncTabFrameHostWindowClass" )

  hWnd2 := WinExist( "ahk_class LyncConversationWindowClass" )
   hWnd3 := WinExist( "ahk_class NetUiCtrlNotifySync" )
 ;~ If classcheck contains NetUi
 ;~ Loop 20 {
 ;~ DllCall( "FlashWindowEx", UInt,hWnd1, Int,5 )
 ;~ DllCall( "FlashWindow", UInt,hWnd2, Int,True )
 ;~ DllCall( "FlashWindow", UInt,hWnd2, Int,True )
 ;~ DllCall( "FlashWindow", UInt,hWnd3, Int,True )
 ;~ Sleep 3000
 ;~ }
 Loop, 10
 {
  ToolTip flash Loop is  on %A_Index%
  IfWinActive, ahk_class LyncTabFrameHostWindowClass
  {
   ToolTip
   return
  }
  IfWinActive, ahk_class LyncConversationWindowClass
   {
   ToolTip
   return
  }
  ;~ DllCall( "FlashWindow", UInt,hWnd2, Int,True )
 ;~ DllCall( "FlashWindow", UInt,hWnd2, Int,True )
 ;~ DllCall( "FlashWindow", UInt,hWnd3, Int,True )
 ;~ Sleep 1000
 DllCall( "FlashWindow", UInt,hWnd1, Int,False )
 DllCall( "FlashWindow", UInt,hWnd2, Int,False )
 DllCall( "FlashWindow", UInt,hWnd3, Int,False )
 Sleep 1000
}
 ToolTip, 
Return

^F3::
WinGetActiveTitle, title

Loop, 5
{
 ToolTip, activate
 WinActivate %title%
 ToolTip
 Sleep 1000
 
}
Return


F5::
Reload