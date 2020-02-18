
Func AutoFlow()

   ;If CheckForPixelList($CHECK_ESC_MENU, $setting_pixel_tolerance, True, $setting_pixel_region) Then Send( "{ESCAPE}" )
   ;DoKeyList("{ALTDOWN},43:33.98,{ALTUP}")
   ;MainSeaTravelLoop()
   ;MainItemEnchant1Loop()
   ;Return True

   If $setting_auto_mode == $AUTO_MODE_FISHING Then

	  MainFishingLoop()

   ElseIf $setting_auto_mode == $AUTO_MODE_COLLECT Then

	  MainUnlimitedCollectLoop()

   ElseIf $setting_auto_mode == $AUTO_MODE_SEA_TRAVEL Then

	  MainSeaTravelLoop()

   ElseIf $setting_auto_mode == $AUTO_MODE_ITEM_ENCHANT1 Then

	  MainItemEnchant1Loop()

   ElseIf $setting_auto_mode == $AUTO_MODE_ITEM_ENCHANT2 Then

	  MainItemEnchant2Loop()

   EndIf


   Return True
EndFunc


