
Func AutoFlow()

   ;DoKeyList("{ALTDOWN},46.52:56.69,{ALTUP},{ALTDOWN},45.44:58.63,{ALTUP}")
   ;MainSeaTravelLoop()
   ;If CheckForPixelList($CHECK_BUTTON_ENTER_CITY, $setting_pixel_tolerance, True, $setting_pixel_region) Then SetLog($INFO, "OK", $COLOR_BLUE)
   ;Return

   If $setting_auto_mode == $AUTO_MODE_FISHING Then

	  MainFishingLoop()

   ElseIf $setting_auto_mode == $AUTO_MODE_COLLECT Then

	  MainUnlimitedCollectLoop()

   ElseIf $setting_auto_mode == $AUTO_MODE_SEA_TRAVEL Then

	  MainSeaTravelLoop()

   EndIf

   Return True
EndFunc


