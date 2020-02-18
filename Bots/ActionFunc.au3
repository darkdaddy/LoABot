#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         gunoodaddy

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

Local const $MaxCatchFailureCount = 5
Local const $FishingEndDelay = 7000
Local const $MaxWaitCatchTime = 18
Local const $MaxWaitFishingTrapTime = 310; 5min + extra 30sec

Func CloseAllMenu()
   If CheckForPixelList($CHECK_ESC_MENU, $setting_pixel_tolerance, False, $setting_pixel_region) Then SendKey( "{ESCAPE}" )
   If CheckForPixelList($CHECK_SWAP_NPC_MENU, $setting_pixel_tolerance, False, $setting_pixel_region) Then SendKey( "{ESCAPE}" )
EndFunc

Func CheckEscMenu()
   If CheckForPixelList($CHECK_ESC_MENU, $setting_pixel_tolerance, False, $setting_pixel_region) Then
	  Return True
   EndIf
   Return False
EndFunc


Func OpenCloseEscMenu()
   SendKey( "{ESCAPE}" )
   If _Sleep(1000) Then Return False
   If CheckForPixelList($CHECK_ESC_MENU, $setting_pixel_tolerance, False, $setting_pixel_region) Then
	  SendKey( "{ESCAPE}" )
   EndIf
   If _Sleep(500) Then Return False
EndFunc


Func CheckFishingNeedle()
   Local const $MaxCheckNeedleCount = 5

   $tryCount = 0
   While $RunState And $tryCount < $MaxCheckNeedleCount
	  If CheckForPixelList($CHECK_STATUS_FISH_SKILL_ACTIVE, $setting_pixel_tolerance, True, $setting_pixel_region) Then
		 ExitLoop
	  EndIf
	  $tryCount += 1
	  If _SleepAbs(50) Then Return False
   WEnd
   If $tryCount >= $MaxCheckNeedleCount Then
	  SetLog($INFO, "Failed to throw the rod...", $COLOR_RED)
	  Return False
   EndIf
   Return True
EndFunc


Func CheckAndRunWebSkill()
   If Not CheckForPixelList($CHECK_STATUS_WEB_SKILL_ACTIVE, $setting_pixel_tolerance, True, $setting_pixel_region) Then
	  Return
   EndIf
   If _SleepAbs(300) Then Return False
   SendKey( "A" )
   SetLog($INFO, "Web skill start", $COLOR_GREEN)
   If _SleepAbs(7000) Then Return False

   SetLog($INFO, "Pressing Space key!!", $COLOR_DARKGREY)

   Local $timer = TimerInit()
   While $RunState
	  SendKey( "{SPACE}{SPACE}" )
	  If _SleepAbs(298) Then Return False
	  Local $now = TimerDiff($timer)
	  _console("web skill waiting : " & ($now/1000) & ", " & $timer)
	  If ($now / 1000 > 9) Then
		 ExitLoop
	  EndIf
   WEnd
   SetLog($INFO, "Web skill end", $COLOR_DARKGREY)
EndFunc


Func MainFishingLoop()
   SetLog($INFO, "Go Fishing", $COLOR_BLUE)

   Local $timer = TimerInit()
   Local $continuousFailCount = 0
   Local $fishingTrapStartMsec = -1

   If $setting_enabled_fish_trap Then
	  If Not CheckForPixelList($CHECK_FISH_TRAP_ACTIVE_ICON, $setting_pixel_tolerance, False, $setting_pixel_region) Then
		  Local $now = TimerDiff($timer)
		  $fishingTrapStartMsec = $now
		  SetLog($INFO, "Fishing trap already installed", $COLOR_GREEN)
	  EndIf
   EndIf

   While $RunState
	  loadConfig()

	  $Stats_LoopCount += 1
	  updateStats()

	  If $setting_enabled_fish_trap Then
		 Local $now = TimerDiff($timer)
		 _console("fish trap waiting : " & (($now - $fishingTrapStartMsec)/1000) & ", " & $fishingTrapStartMsec)

		 If $fishingTrapStartMsec > 0 And ((($now - $fishingTrapStartMsec)) / 1000 > $MaxWaitFishingTrapTime) Then
			SetLog($INFO, "Fishing trap collected", $COLOR_GREEN)
			$fishingTrapStartMsec = -1
			SendKey( "G" )
			$Stats_FishTrapCount += 1
			updateStats()
			If _SleepAbs(4000) Then Return False
		 EndIf

 		 If $fishingTrapStartMsec < 0 Then
			If _SleepAbs(1000) Then Return False
			SendKey( "G" )

			SetLog($INFO, "checking fishing trap...", $COLOR_DARKGREY)
			If _SleepAbs(8000) Then Return False

			If CheckForPixelList($CHECK_FISH_TRAP_ACTIVE_ICON, $setting_pixel_tolerance, False, $setting_pixel_region) Then
			   SetLog($INFO, "Fishing trap failed", $COLOR_RED)
			   $fishingTrapStartMsec = -1
			Else
			   SetLog($INFO, "Fishing trap installed", $COLOR_GREEN)
			   $fishingTrapStartMsec = $now
			EndIf
		 EndIf

	  EndIf

	  If CheckForPixelList($CHECK_STATUS_ATTACT_HUD, $setting_pixel_tolerance, False, $setting_pixel_region) Then
		 SendKey( "B" )
		 SetLog($INFO, "Change Life HUD", $COLOR_GREEN)
		 If _SleepAbs(1000) Then Return False
	  EndIf

	  CheckAndRunWebSkill()

	  SetLog($INFO, "Throw fishing rod", $COLOR_DARKGREY)

	  If Not $setting_bg_mode Then
		 WinActivate($HWnD)
		 MoveControlPos($setting_fishing_pos, 10, $setting_fishing_pos_random_distance)
	  EndIf

	  SendKey( "W" )

	  If _SleepAbs(2200) Then Return False

	  If Not CheckFishingNeedle() Then
		 If _SleepAbs(1000) Then Return False
		 $continuousFailCount += 1
		 If $continuousFailCount >= $MaxCatchFailureCount Then
			SetLog($INFO, "Warning! too many failed to throw : " & $continuousFailCount, $COLOR_RED)
			Return False
		 EndIf
		 ContinueLoop
	  EndIf

	  SetLog($INFO, "Fishing needle ok", $COLOR_DARKGREY)

	  ; wait for fish!
	  $tryCount = 0
	  Local $now = TimerDiff($timer)
	  Local $catchStartMsec = TimerDiff($timer)
	  While $RunState
		 If _Sleep(100) Then Return False
		 Local $now = TimerDiff($timer)
		 _console("fish catching : " & Number(($now - $catchStartMsec)/1000, 1))

		 If CheckForPixelList($CHECK_STATUS_FISH_OK_MARK, $setting_pixel_tolerance, True, $setting_pixel_region) Then
			SetLog($INFO, "Catch a fish in " & Number(($now - $catchStartMsec)/1000, 1) & "sec", $COLOR_ORANGE)

			$Stats_FishCatchCount += 1
			updateStats()

			SendKey( "W" ) ; to catch!
			$continuousFailCount = 0
			If _SleepAbs($FishingEndDelay) Then Return False
			ExitLoop
		 EndIf

		 If (($now - $catchStartMsec)/1000) > $MaxWaitCatchTime Then
			SetLog($INFO, "Failed to catch a fish!", $COLOR_RED)
			SendKey( "W" ) ; to cancel
			$continuousFailCount += 1
			If $continuousFailCount >= $MaxCatchFailureCount Then
			   SetLog($INFO, "Warning! too many failed to catch : " & $continuousFailCount, $COLOR_RED)
			   Return False
			EndIf
			If _SleepAbs($FishingEndDelay) Then Return False
			ExitLoop
		 EndIF
	  WEnd
   WEnd
   ;ControlPos("11.88:97.67", 2)Click

EndFunc

Func MainUnlimitedCollectLoop()

   SetLog($INFO, "Start collect mode", $COLOR_BLUE)

   $tryCount = 0
   While $RunState

	  CloseAllMenu()

	  If StringLen($setting_collect_pos) > 0 Then
		 MoveControlPos($setting_collect_pos, 10, 1)
		 MouseClick($MOUSE_CLICK_RIGHT)
	  Else
		 SendKey( "G" )
	  EndIf

	  If $setting_open_esc_menu And Mod($tryCount, 10) == 0 Then
		 OpenCloseEscMenu()
	  EndIf

	  If StringLen($setting_collect_pos) > 0 Then
		 If _Sleep(200) Then Return False
	  Else
		 If _Sleep(1000) Then Return False
	  EndIf
	  $tryCount += 1
   WEnd

   SetLog($INFO, "End collect mode", $COLOR_BLUE)
EndFunc


Func MainSkillTripodChangeExpLoop()

   SetLog($INFO, "Start Skill Tripod Change Exp mode", $COLOR_BLUE)

   Local $iNb = 0
   While $RunState
	  WinActivate($HWnD)

	  If Mod($iNb, 2) = 0 Then
		 MoveControlPos("83.56:19.85", 10, 1)
		 MouseClick($MOUSE_CLICK_LEFT)
	  Else
		 MoveControlPos("95.59:18.47", 10, 1)
		 MouseClick($MOUSE_CLICK_LEFT)
	  EndIf
	  MoveControlPos("91.03:59.56", 10, 1)
	  MouseClick($MOUSE_CLICK_LEFT)

	  If _Sleep(1000) Then Return False

	  $iNb += 1
   WEnd

   SetLog($INFO, "End Skill Tripod Change Exp Mode mode", $COLOR_BLUE)
EndFunc

Func CheckNormalSeaTravelStatus()

   If CheckForPixelList($CHECK_STATUS_NORMAL_SEA_TRAVEL_MARK_OFF, $setting_pixel_tolerance, True, $setting_pixel_region) Then
	  Return True
   EndIf
   Return False
EndFunc

Func MainSeaTravelLoop()

   SetLog($INFO, "Start Sea Travel Mode", $COLOR_BLUE)
   SetLog($INFO, "Guide1 : resolution must be 1920x1280.", $COLOR_PURPLE)
   SetLog($INFO, "Guide2 : World Map must be moved to 0x0.", $COLOR_PURPLE)

   Local $luckyEnergyCheckPos = StringReplace($CHECK_STATUS_LUCKY_ENERGY_END_COND, "X" , $setting_see_travel_min_lucky_energy_ratio, 0, 1)

   If CheckForPixelList($CHECK_ESC_MENU, $setting_pixel_tolerance, False, $setting_pixel_region) Then Send( "{ESCAPE}" )

   If Not CheckNormalSeaTravelStatus() Then
	  SetLog($INFO, "Please reset sea trabel status.", $COLOR_RED)
	  Return
   EndIf

   While $RunState

  	  If CheckForPixelList($CHECK_ESC_MENU, $setting_pixel_tolerance, False, $setting_pixel_region) Then
		 WinActivate($HWnD)
		 Send( "{ESCAPE}" )
	  EndIf

	  If Not CheckForPixelList($luckyEnergyCheckPos, $setting_pixel_tolerance, True, $setting_pixel_region) Then
		 SetLog($INFO, "Lack of lucky energe. waiting...", $COLOR_DARKGREY)
		 If _Sleep(10000) Then Return False
		 ContinueLoop
	  EndIf

	  If CheckNormalSeaTravelStatus() Then

		 WinActivate($HWnD)

		 If $Stats_AutoSeaTravelCount <= 0 Then
			SetLog($INFO, "Started first sea travel round", $COLOR_PINK)
		 Else
			SetLog($INFO, "Arrived at the target", $COLOR_PINK)
		 EndIf

		 If _Sleep(1000) Then Return False

		 ; Check if entering city
		 SendKey( "Z" )
		 If _SleepAbs(1000) Then Return False
		 If CheckForPixelList($CHECK_BUTTON_ENTER_CITY, $setting_pixel_tolerance, True, $setting_pixel_region) Then

			ClickControlPos2("55.03:94.55", 1, 300)

			ClickControlPos2("47.1:58.91", 1, 300)
			If _SleepAbs(300) Then Return False

			SetLog($INFO, "Repair ship", $COLOR_DARKGREY)

			$Stats_ShipRepairCount += 1
			updateStats()
		 Else
			SetLog($INFO, "Here is not nearby a port...", $COLOR_PINK)
		 EndIf

		 Send( "{ESCAPE}" )
		 If _SleepAbs(1000) Then Return False

		 If CheckForPixelList($CHECK_ESC_MENU, $setting_pixel_tolerance, False, $setting_pixel_region) Then Send( "{ESCAPE}" )

		 ; Set the travel route
		 SendKey( "M" )
		 If _Sleep(200) Then Return False

		 DoKeyList($setting_sea_travel_key_list)
		 ;DoKeyList("{ALTDOWN},51.56:16.25,{ALTUP},{ALTDOWN},45.64:13.85,{ALTUP},{ALTDOWN},52.18:13.39,{ALTUP},{ALTDOWN},37.71:18.84,{ALTUP}")	; Shushaia
		 ;DoKeyList("{ALTDOWN},53.27:52.91,{ALTUP},{ALTDOWN},52.39:61.31,{ALTUP},{ALTDOWN},50.88:54.29,{ALTUP},{ALTDOWN},45.33:58.63,{ALTUP}")	; Ruteran
		 ;DoKeyList("{ALTDOWN},43.15:34.16,{ALTUP},{ALTDOWN},46.99:51.15,{ALTUP},{ALTDOWN},46.99:37.95,{ALTUP},{ALTDOWN},49.79:29.46,{ALTUP}")	; Ardetein
		 ;DoKeyList("{ALTDOWN},43:33.98,{ALTUP},{ALTDOWN},42.89:32.32,{ALTUP},{ALTDOWN},49.79:29.46,{ALTUP}")	; Ardetein
		 ;DoKeyList("14.42:59.56,{ALTDOWN},37.19:33.33,{ALTUP},{ALTDOWN},51.45:66.3,{ALTUP},{ALTDOWN},56.79:34.35,{ALTUP},{ALTDOWN},18.67:66.94,{ALTUP}")	; Ardetein

		 If _SleepAbs(500) Then Return False
		 SendKey( "{ESCAPE}" )
		 $Stats_AutoSeaTravelCount += 1
		 updateStats()
	  EndIf

	  ; Get treasure
	  Send( "Q" )
	  Send( "Q" )
	  If _Sleep(300) Then Return False

	  If $setting_sea_travel_key_g_enabled Then
		 ; Get floating matter
		 Send( "G" )
		 If _Sleep(200) Then Return False
	  EndIf

	  ; Get floating matter
	  Send( "R" )
	  Send( "R" )
	  If _Sleep(300) Then Return False

	  If CheckForPixelList($CHECK_STATUS_AUTO_SEA_TRAVEL_MARK_OFF, $setting_pixel_tolerance, True, $setting_pixel_region) Then
		 SendKey( "T" )
		 SetLog($INFO, "Resume sea travel", $COLOR_DARKGREY)
	  EndIf

	  If _Sleep(300) Then Return False
   WEnd

   SetLog($INFO, "End Sea Travel Mode", $COLOR_BLUE)
EndFunc

Func MainItemEnchantContOkLoop()
   SetLog($INFO, "Start Item Enchant Mode (Cont. OK)", $COLOR_BLUE)

   Local $timer = TimerInit()
   Local $TotCount = Round (100 / $setting_itemenchant_ratio);
   Const $RatioNum = $setting_itemenchant_ratio * 100
   Local $succCount = 0
   Local $maxCount = 0
   Local $doCount = 0

   If $setting_itemenchant_ok_count > 0 Then
	  $TotCount = $setting_itemenchant_ok_count
   EndIf

   SetLog($INFO, "Setting : tot = " & $TotCount & ", ratio = " & $setting_itemenchant_ratio, $COLOR_BLACK)

   While $RunState
	  Local $iRandom = Random(0, 10000, 1)
	  $doCount += 1
	  If $iRandom <= $RatioNum Then
		 $succCount += 1

		 If $maxCount < $succCount Then
			SetLog($INFO, "item enchant : max success = " & $succCount & "(" & $iRandom & ")", $COLOR_PINK)
			$maxCount = $succCount
		 EndIf

		 If $succCount >= $TotCount Then
			ExitLoop
		 EndIf
	  Else
		 $succCount = 0
	  EndIf

	  If $setting_itemenchant_sleep > 0 Then
		 If _Sleep($setting_itemenchant_sleep) Then Return False
	  EndIf
   WEnd

   Local $now = TimerDiff($timer)
   SetLog($INFO, "Result : " & Round($now/1000, 2) & " Sec, count = " & $doCount, $COLOR_ORANGE)

   If $RunState Then
	  WinActivate($HWnD)
	  ClickControlPos2($setting_itemenchant_button_pos, 1, 0, $setting_itemenchant_move_speed)
   EndIf

   SetLog($INFO, "End Item Enchant Mode", $COLOR_BLUE)
EndFunc


Func MainItemEnchantOfferingLoop()
   SetLog($INFO, "Start Item Enchant Mode (Offering)", $COLOR_BLUE)

   Local $MagicRate = 20.5
   Local $MagicTry = 12
   Local $TotCount = Round ($MagicRate / $setting_itemenchant_ratio * $MagicTry);
   Const $RatioNum = $setting_itemenchant_ratio * 100
   Local $failCount = 0
   Local $maxCount = 0
   Local $doCount = 0
   Local $offeringCount = $setting_itemenchant_ok_count
   Local $timer = TimerInit()

   If $offeringCount > 0 Then
	  $TotCount = $offeringCount
   EndIf

   SetLog($INFO, "Setting : tot = " & $TotCount & ", ratio = " & $setting_itemenchant_ratio & ", sleep = " & $setting_itemenchant_sleep, $COLOR_BLACK)

   While $RunState

	  If $setting_itemenchant_sleep > 0 Then
		 If _Sleep($setting_itemenchant_sleep) Then Return False
	  EndIf
	  MoveControlPos($setting_itemenchant_button_pos, $setting_itemenchant_move_speed)
	  MouseClick($MOUSE_CLICK_RIGHT)

	  Local $iRandom = Random(0, 10000, 1)

	  $doCount += 1
	  If $iRandom > $RatioNum Then
		 $failCount += 1
		 SetLog($INFO, "item enchant : offering = " & $failCount & "(" & $iRandom & ")", $COLOR_PINK)

		 If $maxCount < $failCount Then
			; to do something
			$maxCount = $failCount
		 EndIf

		 If $failCount >= $TotCount Then
			ExitLoop
		 EndIf
	  Else
		 SetLog($INFO, "item enchant : ok (" & $iRandom & ")", $COLOR_GREEN)
		 $failCount = 0
	  EndIf
   WEnd

   Local $now = TimerDiff($timer)
   SetLog($INFO, "Result : " & Round($now/1000, 2) & " Sec, count = " & $doCount, $COLOR_ORANGE)

   If $RunState Then
	  WinActivate($HWnD)
	  ClickControlPos2($setting_itemenchant_button_pos, 1, 0, $setting_itemenchant_move_speed)
   EndIf

   SetLog($INFO, "End Item Enchant Mode", $COLOR_BLUE)
EndFunc


Func MainItemEnchantRealLoop()
   SetLog($INFO, "Start Item Enchant Mode (Real)", $COLOR_BLUE)

   Local $timer = TimerInit()
   Const $RatioNum = $setting_itemenchant_ratio * 100
   Local $doCount = 0

   SetLog($INFO, "Setting : ratio = " & $setting_itemenchant_ratio & ", sleep = " & $setting_itemenchant_sleep, $COLOR_BLACK)

   While $RunState

	  If $setting_itemenchant_sleep > 0 Then
		 If _Sleep($setting_itemenchant_sleep) Then Return False
	  EndIf

	  MoveControlPos($setting_itemenchant_button_pos, $setting_itemenchant_move_speed)
	  MouseClick($MOUSE_CLICK_RIGHT)

	  Local $iRandom = Random(0, 10000, 1)

	  $doCount += 1
	  If $iRandom > $RatioNum Then
		 SetLog($INFO, "item enchant : failed (" & $iRandom & ")", $COLOR_PINK)
	  Else
		 SetLog($INFO, "item enchant : ok (" & $iRandom & ")", $COLOR_GREEN)
		 WinActivate($HWnD)
		 ClickControlPos2($setting_itemenchant_button_pos, 1, 0, $setting_itemenchant_move_speed)
		 ExitLoop
	  EndIf
   WEnd

   Local $now = TimerDiff($timer)
   SetLog($INFO, "Result : " & Round($now/1000, 2) & " Sec, count = " & $doCount, $COLOR_ORANGE)

   SetLog($INFO, "End Item Enchant Test Mode", $COLOR_BLUE)
EndFunc
