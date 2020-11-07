
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

   ElseIf $setting_auto_mode == $AUTO_MODE_SKILL_CAST Then

	  MainSkillCastLoop()

   ElseIf $setting_auto_mode == $AUTO_MODE_ITEM_ENCHANT_CONTOK Then

	  MainItemEnchantContOkLoop()

   ElseIf $setting_auto_mode == $AUTO_MODE_ITEM_ENCHANT_OFFERING Then

	  MainItemEnchantOfferingLoop()

   ElseIf $setting_auto_mode == $AUTO_MODE_ITEM_ENCHANT_REAL Then

	  MainItemEnchantRealLoop()

   ElseIf $setting_auto_mode == $AUTO_MODE_SCROLL_ENCHANT_REAL Then

	  MainItemEnchantRealLoop()

   ElseIf $setting_auto_mode == $AUTO_MODE_CHANNEL_MOVE Then

	  MainItemChannelMoveLoop()

   ElseIf $setting_auto_mode == $AUTO_MODE_STONE_HANDWORK Then

	  MainStoneHandWorkLoop()

   EndIf

   Return True
EndFunc


