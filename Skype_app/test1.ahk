^F2::
Sleep 2000
 hWnd := WinExist( "ahk_class LyncTabFrameHostWindowClass" )
  hWnd := WinExist( "ahk_class LyncConversationWindowClass" )
 ;~ Loop 20 {
 DllCall( "FlashWindow", UInt,hWnd, Int,True )
 Sleep 3000
 ;~ }
 DllCall( "FlashWindow", UInt,hWnd, Int,False )
Return
^F3::
 ;~ Loop 20 {
 DllCall( "FlashWindow", UInt,hWnd, Int,True )
 Sleep 3000
 ;~ }
 DllCall( "FlashWindow", UInt,hWnd, Int,False )
Return