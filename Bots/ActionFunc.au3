#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         gunoodaddy

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include <Math.au3>

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
		 MoveControlPos($setting_fishing_pos, 10, $setting_pos_random_distance)
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

	  If Not $setting_collect_only Then
		 If Not CheckForPixelList($CHECK_STATUS_FULL_HEALTH, $setting_pixel_tolerance, True, $setting_pixel_region) Then
			SetLog($INFO, "monster hit me", $COLOR_RED)
			If StringLen($setting_skill_cast_pos) > 0 Then
			   MoveControlPos($setting_skill_cast_pos, 10, $setting_pos_random_distance)
			EndIf
			If StringLen($setting_skill_cast_key) > 0 Then
			   SendKey( $setting_skill_cast_key, 1000 )
			EndIf
		 EndIf
	  Endif

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

   If $RunState = False Then
	  Return False
   EndIf

   SetLog($INFO, "Start Item Enchant Mode (Cont. OK)", $COLOR_BLUE)

   Local $timer = TimerInit()
   Local $TotCount = Round ($setting_itemenchant_ratio * 5);
   Const $RatioNum = $setting_itemenchant_ratio * 100
   Const $LOOP_LOG_STEP = 500000
   Local $succCount = 0
   Local $maxCount = 0
   Local $doCount = 0

   If $setting_itemenchant_ok_count > 0 Then
	  $TotCount = $setting_itemenchant_ok_count
   EndIf

   Local $buttonPos
   $buttonPos = $setting_itemenchant_button_pos

   SetLog($INFO, "Setting : tot = " & $TotCount & ", ratio = " & $setting_itemenchant_ratio, $COLOR_BLACK)

   $succIndex = 0
   While $RunState
	  Local $iRandom = Random(0, 10000, 1)
	  $doCount += 1
	  If $iRandom <= $RatioNum Then
		 $succCount += 1
		 $succIndex = $doCount
		 If $maxCount < $succCount OR $setting_itemenchant_sleep > 0 Then
			SetLog($INFO, "item enchant : ok (" & $iRandom & "), tot = " & $succCount, $COLOR_GREEN)
			$maxCount = $succCount
		 EndIf

		 If $succCount >= $TotCount Then
			ExitLoop
		 EndIf
	  Else
		 If $setting_itemenchant_sleep > 0 Then
			SetLog($INFO, "item enchant : fail (" & $iRandom & ")", $COLOR_PINK)
		 EndIf

		 If $doCount - $succIndex > $setting_itemenchant_rate_threshold_cnt Then
			$succCount = 0
		 EndIf
	  EndIf

	  If $setting_itemenchant_sleep > 0 Then
		 If _Sleep($setting_itemenchant_sleep) Then Return False
	  EndIf

	  $loop = Mod($doCount, $LOOP_LOG_STEP)
	  If $loop = 0 Then
		 SetLog($INFO, "item loop : " & $doCount, $COLOR_DARKGREY)
	  EndIf

   WEnd

   Local $now = TimerDiff($timer)
   SetLog($INFO, "Result : " & Round($now/1000, 2) & " Sec, count = " & $doCount, $COLOR_ORANGE)

   If $RunState Then
	  WinActivate($HWnD)
	  MoveControlPos($buttonPos, $setting_itemenchant_move_speed)
	  ClickControlPos2($buttonPos, 3, 0, 0)
	  ClickControlPos2($setting_scrollenchant_button_pos2, 3, 1000, 0)
   EndIf

   SetLog($INFO, "End Item Enchant Mode", $COLOR_BLUE)
EndFunc


Func MainItemEnchantOfferingLoop()

   If $RunState = False Then
	  Return False
   EndIf

   SetLog($INFO, "Start Item Enchant Mode (Offering)", $COLOR_BLUE)

   Local $buttonPos
   If $setting_auto_mode == $AUTO_MODE_ITEM_ENCHANT_REAL Then
	  $buttonPos = $setting_itemenchant_button_pos
   Else
	  $buttonPos = $setting_scrollenchant_button_pos
   EndIf

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

	  If $setting_itemenchant_simulate_click Then
		 MoveControlPos($buttonPos, $setting_itemenchant_move_speed)
		 MouseClick($MOUSE_CLICK_RIGHT)
	  EndIf

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
	  MoveControlPos($buttonPos, $setting_itemenchant_move_speed)
	  ClickControlPos2($buttonPos, 3, 0, 0)
	  ClickControlPos2($setting_scrollenchant_button_pos2, 3, 1000, 0)
   EndIf

   SetLog($INFO, "End Item Enchant Mode", $COLOR_BLUE)
EndFunc


Func MainItemEnchantRealLoop()

   If $RunState = False Then
	  Return False
   EndIf

   Local $buttonPos
   If $setting_auto_mode == $AUTO_MODE_ITEM_ENCHANT_REAL Then
	  $buttonPos = $setting_itemenchant_button_pos
   Else
	  $buttonPos = $setting_scrollenchant_button_pos
   EndIf

   SetLog($INFO, "Start Item Enchant Mode (Real)", $COLOR_BLUE)

   Local $timer = TimerInit()
   Local $RatioNum = $setting_itemenchant_ratio * 100
   If $RatioNum <= 0 Then
	  $RatioNum = 1
   EndIf
   Local $doCount = 0
   Local $succCount = 0

   Local $TotCount = 1
   If $setting_itemenchant_ok_count > 0 Then
	  $TotCount = $setting_itemenchant_ok_count
   EndIf

   SetLog($INFO, "Setting : ratio = " & $setting_itemenchant_ratio & ", sleep = " & $setting_itemenchant_sleep, $COLOR_BLACK)

   While $RunState

	  If $setting_itemenchant_sleep > 0 Then
		 Local $iRandomSec = Random($setting_itemenchant_sleep/2, $setting_itemenchant_sleep, 1)
		 If _Sleep($iRandomSec) Then Return False
	  EndIf

	  If $setting_itemenchant_simulate_click And $setting_itemenchant_sleep > 0 Then
		 MoveControlPos($buttonPos, $setting_itemenchant_move_speed)
		 MouseClick($MOUSE_CLICK_RIGHT)
	  EndIf

	  Local $iRandom = Random(0, 10000, 1)

	  $doCount += 1
	  If $iRandom > $RatioNum Then
		 If $setting_itemenchant_sleep > 0 Then
			SetLog($INFO, "item enchant : failed (" & $iRandom & "), try = " & $doCount, $COLOR_PINK)
		 EndIf
		 $succCount = 0
	  Else
		 $succCount = $succCount + 1
		 If $setting_itemenchant_sleep > 100 Then
			SetLog($INFO, "item enchant : ok (" & $iRandom & ") , Count = " & $doCount & "(" & $succCount & ")", $COLOR_GREEN)
		 EndIf

		 If $succCount >= $TotCount Then
			WinActivate($HWnD)
			MoveControlPos($buttonPos, $setting_itemenchant_move_speed)
			ClickControlPos2($buttonPos, 3, 0, 0)
			ClickControlPos2($setting_scrollenchant_button_pos2, 3, 1000, 0)
			ExitLoop
		 EndIf
	  EndIf
   WEnd

   Local $now = TimerDiff($timer)
   SetLog($INFO, "Result : " & Round($now/1000, 2) & " Sec, count = " & $doCount, $COLOR_ORANGE)

   SetLog($INFO, "End Item Enchant Test Mode", $COLOR_BLUE)
EndFunc


Func MainSkillCastLoop()
   If $RunState = False Then
	  Return False
   EndIf

   SetLog($INFO, "Start Skill Cast Mode", $COLOR_BLUE)
   SetLog($INFO, "Setting : key = " & $setting_skill_cast_key & ", pos = " &$setting_skill_cast_pos & ", sec = " & $setting_skill_cast_sec, $COLOR_BLACK)

   $doCount = 1

   Local $castPosArray = [$setting_skill_cast_pos, $setting_skill_cast_pos2]
   Local $castPosArrayCnt = UBound($castPosArray)
   While $RunState

	  $posIndex = Mod($doCount, $castPosArrayCnt)
	  MoveControlPos($castPosArray[$posIndex], 10, $setting_pos_random_distance)

	  SendKey( $setting_skill_cast_key )

	  Local $iRandomSec = $setting_skill_cast_sec + Random(1, 5, 1)
	  SetLog($INFO, "Skill Cast(" & $doCount & "), pos=" & $castPosArray[$posIndex] & " after " & $iRandomSec & " sec", $COLOR_PINK)
	  If _Sleep($iRandomSec * 1000) Then Return False
	  $doCount += 1
   WEnd

   SetLog($INFO, "End Skill Cast Mode", $COLOR_BLUE)
EndFunc


Func MainItemChannelMoveLoop()

   Local $PartLeaderPos     = "9.49:42.47"
   Local $ChannelMoveButton = "11.72:52.72"
   Local $speedRate = 0.8

   $doCount = 1

   While $RunState
	  CtrlRightClickControlPos($PartLeaderPos, 2, 0, 0)
	  If _Sleep(300 * $speedRate) Then Return False
	  MoveControlPos($ChannelMoveButton, 0)
	  If _Sleep(100 * $speedRate) Then Return False
	  ClickControlPos2($ChannelMoveButton, 1, 100 * $speedRate, 0)
	  If _Sleep(300 * $speedRate) Then Return False

	  SetLog($INFO, "Try to move channel, count = " & $doCount, $COLOR_DARKGREY)
	  $doCount += 1
   WEnd
EndFunc

Func MainStoneHandWorkLoop()
   SetLog($INFO, "Start Stone HandWork Mode", $COLOR_BLUE)
   SetLog($INFO, "Random : " & $setting_stone_handmake_random, $COLOR_PURPLE)
   SetLog($INFO, "Prefer Item : " & $setting_stone_handmake_prefer_index + 1, $COLOR_PURPLE)
   SetLog($INFO, "Max Stone Step : " & $setting_stone_handmake_max_step, $COLOR_PURPLE)

   Const $CheckMode = False
   Const $PreferIndex = 0
   Const $ItemClickStepSize = 2.39
   Const $FailureColor = 0x424242
   Const $PixelTolerance = 9
   Const $RegionSize = 2
   Const $ClickSpeed = 200
   Const $SleepRandomMsec = 100
   Const $SuccessfulRate = 55
   Const $FailoverRate = 45
   Const $PreferSuccessfulRate = 65

   Local $temp_pos = StringSplit($setting_stone_handmake_topleft, $PosXYSplitter)
   If $temp_pos[0] <= 1 Then
	   SetLog($INFO, "Error Stone HandWork Mode", $COLOR_RED)
	  Return False
   EndIf

   Const $Item_StartX = $temp_pos[1]
   Const $Item_StartYArray[3] = [$temp_pos[2], $temp_pos[2] + 8.97, $temp_pos[2] + 20.59]
   Const $Button_X = $temp_pos[1] + 25.35

   Local $itemStepArray[3] = [0, 0, 0]
   Local $currentRate = 75
   Local $clickCount = 0
   Local $currentItemIndex = 0
   Local $lastFailedItem3Flag = False

   While $RunState
	  If $clickCount >= ($setting_stone_handmake_max_step * 3) Then
		 ExitLoop
	  EndIf

	  Local $prevRate = $currentRate

	  ; Select Item Slot
	  $currentItemIndex = -1
	  Local $tryCount = 0

	  If $setting_stone_handmake_random Then

		 Local $i = 0
		 Local $doCount = 0
		 While $RunState
			$i = Mod($doCount, 3)
			If ($itemStepArray[$i] < $setting_stone_handmake_max_step) Then
			   Local $iRandom = Random(0, 10000, 1)
			   $tryCount += 1
			   If ($i <= 1 And $iRandom < $currentRate * 100) OR ($i = 2 And $iRandom >= $currentRate * 100) Then
				  $currentItemIndex = $i
				  ExitLoop
			   EndIf
			EndIf
			$doCount += 1
		 WEnd

	  Else

		 ; Best priority

		 ; Penalty Item(3) Checking
		 If $currentRate >= $SuccessfulRate Then
			If $itemStepArray[0] = $setting_stone_handmake_max_step And $itemStepArray[1] = $setting_stone_handmake_max_step Then	; Already clicked all
			   $currentItemIndex = 2
			EndIf
		 Else
			If ($itemStepArray[2] < $setting_stone_handmake_max_step) And ($lastFailedItem3Flag = False OR $currentRate < $FailoverRate) Then
			   $currentItemIndex = 2
			EndIf	; already penalty full
		 EndIf

		 If $currentItemIndex == -1 Then
			If $setting_stone_handmake_prefer_index == -1 Then
			   If $itemStepArray[0] <= $itemStepArray[1] Then
				  $currentItemIndex = 0
			   Else
				  $currentItemIndex = 1
			   EndIf
			Else
			   If $currentRate >= $PreferSuccessfulRate OR $lastFailedItem3Flag Then
				  $currentItemIndex = $setting_stone_handmake_prefer_index
			   Else
				  If $setting_stone_handmake_prefer_index = 0 Then
					 $currentItemIndex = 1
				  Else
					 $currentItemIndex = 0
				  EndIf
			   EndIf

			   If $itemStepArray[$currentItemIndex] = $setting_stone_handmake_max_step Then
				  If $currentItemIndex = 0 Then
					 $currentItemIndex = 1
				  Else
					 $currentItemIndex = 0
				  EndIf
			   EndIf
			EndIf
		 EndIf

	  EndIf

	  $lastFailedItem3Flag = False

	  ; Click Button
	  Local $buttonPos = $Button_X & ":" & $Item_StartYArray[$currentItemIndex]

	  While $RunState
		 Local $iRandom = Random(0, 10000, 1)
		 If $iRandom < $currentRate * 100 Then
			; Click
			MoveControlPos($buttonPos, 10)
			If $CheckMode == False Then
			   ClickControlPos2($buttonPos, 1, $ClickSpeed, 0)
			   If _Sleep(300) Then Return False
			Else
			   If _Sleep($ClickSpeed) Then Return False
			EndIf
			;SetLog($INFO, "Stone Handmake Click : " & $iRandom / 100 & ", pos = " & $buttonPos, $COLOR_RED)
			; Wait result
			ExitLoop
		 EndIf
		 If _Sleep($SleepRandomMsec) Then Return False
	  WEnd

	  ; Check Color Result
	  Local $checkColorPosInfo1[1];
	  $checkColorPosInfo1[0] = ($Item_StartX + ($ItemClickStepSize * $itemStepArray[$currentItemIndex])) & ":" & $Item_StartYArray[$currentItemIndex] & "|0x" & StringMid(Hex($FailureColor), 3) & "|" & $PixelTolerance & "|" & $RegionSize

	  Local $resultColor = $COLOR_BLACK
	  If CheckForPixelList($checkColorPosInfo1, $setting_pixel_tolerance, False, $setting_pixel_region) Then
		 ; Failure
		 $currentRate += 10
		 $currentRate = _Min(75, $currentRate)

		 If $currentItemIndex = 2 Then $lastFailedItem3Flag = True
	  Else
		 ; Success
		 $resultColor = $COLOR_GREEN
		 $currentRate -= 10
		 $currentRate = _Max(25, $currentRate)
	  EndIf

	  ; Result Logging..
	  SetLog($INFO, "- item " & ($currentItemIndex + 1) & " : step = " & $itemStepArray[$currentItemIndex] + 1 & ", rate = " & $prevRate & "->" & $currentRate & ", try = " & $tryCount, $resultColor)

	  $itemStepArray[$currentItemIndex] += 1
	  $clickCount += 1
   WEnd

   SetLog($INFO, "End Stone HandWork Mode", $COLOR_BLUE)
EndFunc
