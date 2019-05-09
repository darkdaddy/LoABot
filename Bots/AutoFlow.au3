
Func AutoFlow()

   ;If CheckForPixelList($CHECK_STATUS_WEB_SKILL_ACTIVE, $setting_pixel_tolerance, True, $setting_pixel_region) Then SetLog($INFO, "Web skill start", $COLOR_GREEN)
   ;Return False

   If $setting_collect_mode Then

	  MainUnlimitedCollectLoop()

   Else

	  MainFishingLoop()

   EndIf

   Return True
EndFunc


