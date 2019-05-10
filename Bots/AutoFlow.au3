
Func AutoFlow()

   If $setting_auto_mode == $AUTO_MODE_FISHING Then

	  MainFishingLoop

   ElseIf $setting_auto_mode == $AUTO_MODE_COLLECT Then

	  MainUnlimitedCollectLoop()

   ElseIf $setting_auto_mode == $AUTO_MODE_SEA_TRAVEL Then

	  MainSeaTravelLoop()

   EndIf

   Return True
EndFunc


