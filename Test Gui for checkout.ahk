#SingleInstance, force
;~ Configuration_File_Location = \\n1gfs01.mw.NA.cat.com\shares\92738145A\Macro Instructions\Checkout.ini
Configuration_File_Location = \\arwdfsp01.mw.na.cat.com\shares\auth_strategy\Jarett Karnia\Checkout.ini
red = %a_desktop%\red.png
green = %a_desktop%\green.png


Config_screen()

return

F1::
gosub, Refresh
return


			Load_ini_file(Configuration_File_Location) ; unit && Documentation
				{
					global
ListLines Off
					Ini_var_store_array:= Object()
					Tab_placeholder  =
					loop,read,%Configuration_File_Location%
					{
						If A_LoopReadLine =
						continue

						if regexmatch(A_Loopreadline,"\[(.*)?]")
						{
							Section :=regexreplace(A_loopreadline,"(\[)(.*)?(])","$2")
							StringReplace, Section,Section, %a_space%,,All

							If Tab_PLaceholder =
							{
								Tab_placeholder := Section
							}
							Else
								Tab_placeholder := Tab_placeholder "|" Section

							continue
						}

						else if A_LoopReadLine !=
						{
							StringGetPos, keytemppos, A_LoopReadLine, =,
							StringLeft, keytemp, A_LoopReadLine,%keytemppos%
							StringReplace, keytemp,keytemp,%A_SPace%,,All
							INIstoretemp := Keytemp ":" Section
							Ini_var_store_array.Insert(INIstoretemp)
							IniRead,%keytemp%, %Configuration_File_Location%, %Section%, %keytemp%
							ListLines, on
							}
				}
	gui,Submit,NoHide
					return
				}
				
							Write_ini_file(Configuration_File_Location) ; unit && Documentation
				{
					global
					ListLines Off

					for index, element in Ini_var_store_array
					{

					StringSplit, INI_Write,element, `:

					Varname := INI_Write1
					IniWrite ,% %INI_Write1%, %Configuration_File_Location%, %INI_Write2%, %INI_Write1%
				}
			return
}

          Config_screen()
               {
                  global
                  GuiWIdth = 710
                  GuiHeight = 525
                  Load_ini_file(Configuration_File_Location)
                  GuiNumber = 1
                 Gui, %GuiNumber%:add, tab2,x5 y0 w700 h500,%Tab_placeholder%
                  for index, element in Ini_var_store_array
                  {
                     StringSplit, INI_Write,element, `:
                     If INI_write2 != %INIWrites_Temp%
                     {
                        Gui,%GuiNumber%:Tab, %INI_Write2%
                        Gui, %GuiNumber%:add, Text,x10 y50,%INI_Write1%
							If (%INI_Write1% = "1")
							Gui, %GuiNumber%:add, Picture ,xp+150 h20 w20 v%ini_write1%image gimage, %green%
							else
							Gui, %GuiNumber%:add, Picture ,xp+150 h20 w20 v%ini_write1%image gimage, %red%
							   Gui, %GuiNumber%:add, Edit, w300 h25 xp+30 v%ini_write1%notes, % INI_Write1notes

                        INIWrites_Temp = %INI_write2%
                     }else  {
                        Gui, %GuiNumber%:add, Text,x10 yp+30,%INI_Write1%
           					If (%INI_Write1% = "1")
							Gui, %GuiNumber%:add, Picture ,xp+150 h20 w20 v%ini_write1%image gimage, %green%
							else
							Gui, %GuiNumber%:add, Picture ,xp+150 h20 w20 v%ini_write1%image gimage, %red%
								   Gui, %GuiNumber%:add, Edit, w300 h25 xp+30 v%ini_write1%notes, % INI_Write1notes
                     }}
                  gui,%GuiNumber%:show, ,Check out Tasks
                  return
               }
			   
image(item, ininum)
{

	If (ininum)
	 GuiControl,, %item%image,%A_desktop%\green.png
	 else
		GuiControl,, %item%image ,%A_desktop%\red.png
	
	MsgBox %item%image
	return
	
}

image:
{
ListLines on
Gui,Submit,NoHide

ini_locaiton := A_GuiControl
StringReplace,  ini_locaiton,ini_locaiton, image,,

If (%ini_locaiton% = "1")
	{
		%ini_locaiton% = 0
		GuiControl,,%ini_locaiton%image,%red%
	
	}
else if (%ini_locaiton% = "0")
	{
		%ini_locaiton% = 1
		GuiControl,,%ini_locaiton%image,%green%
	}

ListLines Off
Write_ini_file(Configuration_File_Location)

ListLines, on
 return
 }
 
		
Refresh:
{
	gather = 
Gui,Submit,NoHide
Load_ini_file(Configuration_File_Location)

  for index, element in Ini_var_store_array
                  {					
                     StringSplit, INI_Write,element, `:
						 If (%ini_write1% = "1")					
							{
								GuiControl,,%ini_write1%image ,%green%
						}							
							else {
								GuiControl,,%ini_write1%image ,%red%
}
}

gui,Submit,NoHide
	return
					}
					
					esc::
					Reload
					
					f2::
					ToolTip 
					return
					
					#o::
					Run %Configuration_File_Location%
					return