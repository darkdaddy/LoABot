Global $Initiate = 0

Local $tabX = 10
Local $tabY = 10
Local $contentPaneX = $tabX + 10
Local $contentPaneY = $tabY + 30

Local $gap = 10
Local $generalRightHeight = 0
Local $generalBottomHeight = 70
Local $logViewWidth = 350
Local $logViewHeight = 330
Local $frameWidth = $contentPaneX + $logViewWidth + $gap + $generalRightHeight + $tabX
Local $frameHeight = $contentPaneY + $logViewHeight + $gap + $generalBottomHeight + $tabY

Local $tabHeight = $frameHeight - $tabY - $tabY
Local $contentPaneWidth = $frameWidth - $contentPaneX * 2
Local $contentPaneHeight = $tabHeight - 30
Local $x
Local $y
Local $h = 20
Local $w = 150

; Main GUI Settings
$mainView = GUICreate($sBotTitle, $frameWidth, $frameHeight, -1, -1)

$idTab = GUICtrlCreateTab($tabX, $tabY, $frameWidth - $tabX * 2, $tabHeight)


;-----------------------------------------------------------
; Tab : General
;-----------------------------------------------------------
Local $generalRightX = $frameWidth - $tabX - $generalRightHeight
Local $generalBottomY = $frameHeight - $tabY - $generalBottomHeight

GUICtrlCreateTabItem("General")

$x = $generalRightX
$y = $contentPaneY + 5


; The Bot Status Screen
$txtLog = _GUICtrlRichEdit_Create($mainView, "", $contentPaneX, $contentPaneY, $logViewWidth, $logViewHeight, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, 8912))

; Start/Stop Button
$x = $contentPaneX

Local $btnPlayWidth = 60
Local $btnWidth = 90
Local $btnGap = 5
$btnStart = GUICtrlCreateButton("Start", $x, $generalBottomY, $btnPlayWidth, 55)
$btnStop = GUICtrlCreateButton("Stop", $x, $generalBottomY, $btnPlayWidth, 55)
$btnPause = GUICtrlCreateButton("Pause", $x + $btnPlayWidth + $btnGap, $generalBottomY, $btnPlayWidth, 55)
$btnResume = GUICtrlCreateButton("Resume", $x + $btnPlayWidth + $btnGap, $generalBottomY, $btnPlayWidth, 55)

$x += $btnPlayWidth + $btnGap + $btnPlayWidth + $btnGap
$btnExpTripodChange = GUICtrlCreateButton("Exp : Tripod Change", $x, $generalBottomY, 140, 25)

;-----------------------------------------------------------
; Tab : Option
;-----------------------------------------------------------

GUICtrlCreateTabItem("Option")

$x = $contentPaneX
$y = $contentPaneY

; Game Title
$Label_1 = GUICtrlCreateLabel("Game Title", $x, $y + 5, 80, 20)
$x += 120
$inputGameTitle = GUICtrlCreateInput("", $x, $y, 200, 20)

; Game ThickFrame
$x = $contentPaneX
$y += 30
$Label_2 = GUICtrlCreateLabel("Thick Frame", $x, $y + 5, 100, 20)
$x += 120
$inputThickFraemSize = GUICtrlCreateInput("", $x, $y, 40, 20)

; Pixel Tolerance
$x = $contentPaneX
$y += 30
GUICtrlCreateLabel("Pixel Tolerance", $x, $y + 5)
$inputPixelTolerance = GUICtrlCreateInput("0", $x + 120, $y, 40, 20)

; Pixel Region Size
$x = $contentPaneX
$y += 30
GUICtrlCreateLabel("Pixel Region Size", $x, $y + 5)
$inputPixelRegion = GUICtrlCreateInput("0", $x + 120, $y, 40, 20)

; Bot Background Mode
$y += 30
$x = $contentPaneX
$checkBotBackgroundModeEnabled = GUICtrlCreateCheckbox("Background Mode", $x, $y, 250, 25)
$y += 30

; Game Speed
$x = $contentPaneX
GUICtrlCreateLabel("Game Speed", $x, $y+5, 100, 20)
$x += 120
$sliderGameSpeed = GUICtrlCreateSlider($x, $y, 110, 20)
GUICtrlSetLimit(-1, 100, 0) ; change min/max value
GUICtrlSetData($sliderGameSpeed, 50)
$x += 120
$inputGameSpeed = GUICtrlCreateInput("", $x, $y, 30, 20)
$y += 30

; Collect Mode
$x = $contentPaneX
$w = 150
$checkCollectModeEnabled = GUICtrlCreateCheckbox("Unlimited Collect Mode", $x, $y, $w, 25)
$x += ($w + 10)
$checkOpenEscMenuEnabled = GUICtrlCreateCheckbox("ESC Menu", $x, $y, 100, 25)
$y += 30

; Fishing Trap
$x = $contentPaneX
$checkFishingTrapEnabled = GUICtrlCreateCheckbox("Fishing Trap", $x, $y, 250, 25)
$y += 30

; Fishing Position
$x = $contentPaneX
$Label_2 = GUICtrlCreateLabel("Fishing Position", $x, $y + 5, 120, 20)
$x += 120
$inputFishingPos = GUICtrlCreateInput("", $x, $y, 100, 20)
$y += 25

; Fishing Random Distance
$x = $contentPaneX
$y += 10
GUICtrlCreateLabel("Random Distance", $x, $y)
$inputRandomDistance = GUICtrlCreateInput("0", $x + 120, $y - 5, 30, $h)
GUICtrlCreateLabel("Pixel", $x + 153, $y)
$y += $h

; Utilty Group Box
$y += 20
GUICtrlCreateGroup("Utility", 20, $y, 347, 80)
$x = $contentPaneX + 10
$y += 20

; Pos Calc
$Label_1 = GUICtrlCreateLabel("PosCalc", $x, $y + 5, 55, 20)
$x += 60
$inputCalcPosX = GUICtrlCreateInput("", $x, $y, 30, 20)
$x += 30
GUICtrlCreateLabel($PosXYSplitter, $x, $y + 5, 10, 20)
$x += 10
$inputCalcPosY = GUICtrlCreateInput("", $x, $y, 30, 20)
$x += 40
$btnCalcPos = GUICtrlCreateButton("Calc", $x, $y, 40, 20)
$x += 50
$inputCalcResult = GUICtrlCreateInput("", $x, $y, 140, 20)
$y += 30

$x = $contentPaneX + 10
$Label_2 = GUICtrlCreateLabel("ColorTest", $x, $y + 5, 55, 20)
$x += 60
$inputPosInfo = GUICtrlCreateInput("", $x, $y, 130, 20)
$x += 135
$btnTestColor = GUICtrlCreateButton("Test", $x, $y, 40, 20)
$x += 50
$inputTestColor = GUICtrlCreateInput("", $x, $y, 60, 20)


;-----------------------------------------------------------
; Tab : Stats
;-----------------------------------------------------------

GUICtrlCreateTabItem("Stats")

; Battle Buff Items
$x = $contentPaneX
$y = $contentPaneY + 20
Local $statLabelW = 140
Local $statLabelGap = 20

GUICtrlCreateLabel("Loop Count", $x, $y, $statLabelW, 20)
$x += $statLabelW + $statLabelGap
$labelStats_LoopCount = GUICtrlCreateLabel("0", $x, $y, 60, 20)
GUICtrlSetColor($labelStats_LoopCount, $COLOR_BLUE)

$y += 30
$x = $contentPaneX
GUICtrlCreateLabel("Fish Catch Count", $x, $y, $statLabelW, 20)
$x += $statLabelW + $statLabelGap
$labelStats_FishCatchCount = GUICtrlCreateLabel("0", $x, $y, 60, 20)
GUICtrlSetColor($labelStats_FishCatchCount, $COLOR_ORANGE)

$y += 30
$x = $contentPaneX
GUICtrlCreateLabel("Fish Failure Count", $x, $y, $statLabelW, 20)
$x += $statLabelW + $statLabelGap
$labelStats_FishFailureCount = GUICtrlCreateLabel("0", $x, $y, 60, 20)
GUICtrlSetColor($labelStats_FishFailureCount, $COLOR_RED)

$y += 30
$x = $contentPaneX
GUICtrlCreateLabel("Fish Trap Count", $x, $y, $statLabelW, 20)
$x += $statLabelW + $statLabelGap
$labelStats_FishTrapCount = GUICtrlCreateLabel("0", $x, $y, 60, 20)
GUICtrlSetColor($labelStats_FishTrapCount, $COLOR_GREEN)

;==================================
; Control Initial setting
;==================================

GUISetOnEvent($GUI_EVENT_CLOSE, "mainViewClose", $mainView)
GUICtrlSetOnEvent($btnStart, "btnStart")
GUICtrlSetOnEvent($btnStop, "btnStop")	; already handled in GUIControl
GUICtrlSetOnEvent($btnPause, "btnPause")
GUICtrlSetOnEvent($btnResume, "btnResume")
GUICtrlSetOnEvent($btnExpTripodChange, "btnExpTripodChange")
GUICtrlSetOnEvent($idTab, "tabChanged")
GUICtrlSetOnEvent($btnCalcPos, "btnCalcPos")
GUICtrlSetOnEvent($btnTestColor, "btnTestColor")
GUICtrlSetOnEvent($sliderGameSpeed, "sliderGameSpeedEvent")
GUICtrlSetOnEvent($inputGameSpeed, "inputGameSpeed")

GUICtrlSetState($btnStart, $GUI_SHOW)
GUICtrlSetState($btnStop, $GUI_HIDE)
GUICtrlSetState($btnPause, $GUI_SHOW)
GUICtrlSetState($btnResume, $GUI_HIDE)
GUICtrlSetState($btnPause, $GUI_DISABLE)
GUICtrlSetState($btnResume, $GUI_DISABLE)
GUISetState(@SW_SHOW, $mainView)


;==================================
; Control Callback
;==================================

Func tabChanged()
   If _GUICtrlTab_GetCurSel($idTab) = 0 Then
	  ControlShow($mainView, "", $txtLog)
   Else
	  ControlHide($mainView, "", $txtLog)
   EndIf
EndFunc


Func InitBot()
   $RunState = True
   $PauseBot = False
   $DetectedReconnectButtonBeganTick = 0

   GUICtrlSetState($btnStart, $GUI_HIDE)
   GUICtrlSetState($btnStop, $GUI_SHOW)
   GUICtrlSetState($btnPause, $GUI_SHOW)
   GUICtrlSetState($btnResume, $GUI_HIDE)

   saveConfig()
   loadConfig()
   applyConfig()

   If findWindow() Then
	  WinActivate($HWnD)
	  IsGameActivated()

	   _log($INFO, "TitleBarHeight : " & $TitleBarHeight )
	   _log($INFO, "ThickFrameSize : " & $ThickFrameSize )
	  SetLog($INFO, "Game : " & $WinRect[0] & "," & $WinRect[1] & " " & $WinRect[2] & "x" & $WinRect[3] & "(" & $setting_thick_frame_size & ")", $COLOR_ORANGE)

	  If $WinRect[2] < $AppMinWinWidth Then
		  SetLog($ERROR, "Game Minimum Width = " & $AppMinWinWidth, $COLOR_RED)
		  Return False
	  EndIf
   Else
	  SetLog($ERROR, "Game Not Found", $COLOR_RED)
	  btnStop()
   EndIf

   UpdateWindowRect()
   GUICtrlSetState($btnPause, $GUI_ENABLE)
   GUICtrlSetState($btnResume, $GUI_ENABLE)
   GUICtrlSetState($btnExpTripodChange, $GUI_DISABLE)

   Return True
EndFunc


Func btnStart()
   _log($DEBUG, "START BUTTON CLICKED" )

   clearStats()

   _GUICtrlEdit_SetText($txtLog, "")
   _WinAPI_EmptyWorkingSet(WinGetProcess($HWnD)) ; Reduce Game Memory Usage

   If InitBot() = False Then
	  Return
   EndIf

   runBot()

EndFunc

Func btnStop()
   If $RunState = False Then
	  Return
   EndIf

   _log($DEBUG, "STOP BUTTON CLICKED" )

   GUICtrlSetState($btnStart, $GUI_SHOW)
   GUICtrlSetState($btnStop, $GUI_HIDE)
   GUICtrlSetState($btnPause, $GUI_SHOW)
   GUICtrlSetState($btnResume, $GUI_HIDE)

   $Restart = False
   $RunState = False
   $PauseBot = False

   GUICtrlSetState($btnPause, $GUI_DISABLE)
   GUICtrlSetState($btnResume, $GUI_DISABLE)
   GUICtrlSetState($btnExpTripodChange, $GUI_ENABLE)

   SetLog($INFO, "Bot has stopped", $COLOR_RED)
EndFunc

Func btnPause()
   _console("PAUSE BUTTON CLICKED" )
   If $RunState = False Then
	  Return
   EndIf

   GUICtrlSetState($btnPause, $GUI_HIDE)
   GUICtrlSetState($btnResume, $GUI_SHOW)

   $PauseBot = True

   SetLog($INFO, "Bot has paused", $COLOR_PINK)
EndFunc

Func btnResume()
   _console("RESUME BUTTON CLICKED" )
   If $RunState = False Then
	  Return
   EndIf

   GUICtrlSetState($btnPause, $GUI_SHOW)
   GUICtrlSetState($btnResume, $GUI_HIDE)

   $PauseBot = False

   SetLog($INFO, "Bot has resumed", $COLOR_MEDBLUE)
EndFunc

Func btnExpTripodChange()

   _log($DEBUG, "EXP TRIPOD CHANGE CLICKED" )

   btnStop()

   clearStats()

   _GUICtrlEdit_SetText($txtLog, "")
   _WinAPI_EmptyWorkingSet(WinGetProcess($HWnD)) ; Reduce Game Memory Usage

   If InitBot() = False Then
	  Return
   EndIf

   MainSkillTripodChangeExpLoop()

EndFunc

Func calcPos()
   $orgPosX = Int(GUICtrlRead($inputCalcPosX))
   $orgPosY = Int(GUICtrlRead($inputCalcPosY))

   $posX = $orgPosX - $ThickFrameSize
   $posY = $orgPosY - $TitleBarHeight

   $org = WinGetPos($HWnD)
   $r = $org
   If Not @error Then

	  $r[0] = $r[0] + $ThickFrameSize
	  $r[1] = $r[1] + $TitleBarHeight
	  $r[2] = $r[2] + ($ThickFrameSize * 2)
	  $r[3] = $r[3] - $TitleBarHeight - $ThickFrameSize

	  $x = Round($posX * 100.0 / $r[2], 2)
	  $y = Round($posY * 100.0 / $r[3], 2)

	  $result = $x & $PosXYSplitter & $y
	  GUICtrlSetData($inputPosInfo, $result)

	  $color = GetPixelColor($orgPosX, $orgPosY);
	  $colorStr = "0x" & $color
	  $result = $result & "|" & $colorStr

	  ClipPut($result)

	  Local $bgColor = Number($colorStr)

	  GUICtrlSetData($inputCalcResult, $result)
	  GUICtrlSetBkColor($btnCalcPos, $bgColor)
   Else
	  GUICtrlSetData($inputCalcResult, "Game Not Found")
   EndIf
EndFunc

Func btnCalcPos()

   saveConfig()
   loadConfig()
   applyConfig()

   If findWindow() Then
	  WinActivate($HWnD)
   EndIf

   calcPos()
EndFunc

Func btnTestColor()
   saveConfig()
   loadConfig()
   applyConfig()

   If findWindow() Then
	  WinActivate($HWnD)
   EndIf

   $screenInfo = GUICtrlRead($inputPosInfo)

   Local $infoArr = StringSplit($screenInfo, "|")
   Local $posArr = StringSplit($infoArr[1], ",")
   Local $PixelTolerance = 15
   If UBound($infoArr) - 1 >= 3 Then
	  $PixelTolerance = Number($infoArr[3])
   EndIf

   Local $pos = ControlPos($posArr[1])
   $x = $pos[0]
   $y = $pos[1]
   Local $answerColor = GetPixelColor($x, $y)

   _log($DEBUG, $pos[0] & "(" & $x & ")" & "x" & $pos[1] & "(" & $y & ")" & " => " & $answerColor)

   GUICtrlSetData($inputTestColor, "0x" & $answerColor)
   GUICtrlSetBkColor($btnTestColor, Number("0x" & $answerColor))
EndFunc

; System callback
Func mainViewClose()

   saveConfig()
   _GDIPlus_Shutdown()
   _GUICtrlRichEdit_Destroy($txtLog)
   $hKey_Proc = 0

   Exit
EndFunc

Func sliderGameSpeedEvent()
   $v = (GUICtrlRead($sliderGameSpeed) - 50) / 50;
   $rate = 1.0 + $v
   GUICtrlSetData($inputGameSpeed, $rate)
   changeGameSpeed($rate)
EndFunc

Func inputGameSpeed()
   $rate = Number(GUICtrlRead($inputGameSpeed), $NUMBER_DOUBLE)
   $v = ($rate - 1.0) * 50 + 50
   GUICtrlSetData($sliderGameSpeed, $v)
   changeGameSpeed($rate)
EndFunc

Func changeGameSpeed($newSpeed)
   If $newSpeed <> $setting_game_speed_rate Then
	  SetLog($INFO, "Game speed : " & $setting_game_speed_rate & " => " & $newSpeed, $COLOR_BLUE)
	  $setting_game_speed_rate = $newSpeed
   EndIf
EndFunc


Func clearStats()

   $Stats_LoopCount = 0
   $Stats_FishCatchCount = 0
   $Stats_FishFailureCount = 0
   $Stats_FishTrapCount = 0

   updateStats()
EndFunc

Func updateStats()
   GUICtrlSetData($labelStats_LoopCount, $Stats_LoopCount)
   GUICtrlSetData($labelStats_FishCatchCount, $Stats_FishCatchCount)
   GUICtrlSetData($labelStats_FishFailureCount, $Stats_FishFailureCount)
   GUICtrlSetData($labelStats_FishTrapCount, $Stats_FishTrapCount)
EndFunc
