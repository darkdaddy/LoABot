#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         gunoodaddy

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

Func CheckFishingNeedle()
   Local const $MaxCheckNeedleCount = 5

   $tryCount = 0
   While $RunState And $tryCount < $MaxCheckNeedleCount
	  If CheckForPixelList($CHECK_STATUS_FISH_NEEDLE, 13, True) Then
		 ExitLoop
	  EndIf
	  $tryCount += 1
	  If _SleepAbs(500) Then Return False
   WEnd
   If $tryCount >= $MaxCheckNeedleCount Then
	  SetLog($INFO, "Failed to wait a fish...", $COLOR_RED)
	  Return False
   EndIf
   Return True
EndFunc

Func MainFishingLoop()
   Local const $MaxWaitCatchTime = 18
   SetLog($INFO, "Go Fishing", $COLOR_BLUE)

   While $RunState
	  $Stats_LoopCount += 1
	  updateStats()

	  WinActivate($HWnD)

	  If CheckForPixelList($CHECK_STATUS_ATTACT_HUD) Then
		 SendKey( "B" )
		 SetLog($INFO, "Change Life HUD", $COLOR_GREEN)
		 If _SleepAbs(1000) Then Return False
	  EndIf

	  SetLog($INFO, "Throw fishing rod", $COLOR_DARKGREY)
	  MoveControlPos($setting_fishing_pos)
	  SendKey( "W" )

	  If _SleepAbs(3000) Then Return False

	  If $setting_check_needle Then
		 If Not CheckFishingNeedle() Then
			SendKey( "W" ) ; to cancel
			If _SleepAbs(2000) Then Return False
			ContinueLoop
		 EndIf
	  EndIf

	  SetLog($INFO, "Fishing needle ok", $COLOR_DARKGREY)

	  ; wait for fish!
	  $tryCount = 0
	  Local $timer = TimerInit()
	  While $RunState
		 If _Sleep(100) Then Return False
		 Local $diff = TimerDiff($timer)
		 Local $sec = Int(Mod($diff/1000, 60))

		 If CheckForPixelList($CHECK_STATUS_FISH_OK_MARK, 13, true) Then
			SetLog($INFO, "Catch a fish in " & $sec & "sec", $COLOR_ORANGE)

			$Stats_FishCatchCount += 1
			updateStats()

			SendKey( "W" ) ; to catch!
			If _SleepAbs(7000) Then Return False
			ExitLoop
		 EndIf

		 If $sec > $MaxWaitCatchTime Then
			SetLog($INFO, "Failed to catch a fish!", $COLOR_RED)
			SendKey( "W" ) ; to cancel
			If _SleepAbs(2000) Then Return False
			ExitLoop
		 EndIF
	  WEnd
   WEnd
   ;ClickControlPos("11.88:97.67", 2)

EndFunc
