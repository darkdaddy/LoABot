
Func AutoFlow()

   If $setting_collect_mode Then

	  MainUnlimitedCollectLoop()

   Else

	  MainFishingLoop()

   EndIf

   Return True
EndFunc


