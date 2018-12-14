#RequireAdmin

#pragma compile(FileDescription, LoA Fishing Bot)
#pragma compile(ProductName, LoA Fishing Bot)
#pragma compile(ProductVersion, 0.8)
#pragma compile(FileVersion, 0.8WinActivate($HWnD))
#pragma compile(LegalCopyright, DarkJaden)

$sBotName = "LoA Fishing Bot"
$sBotVersion = "0.8"
$sBotTitle = "AutoIt " & $sBotName & " v" & $sBotVersion

#include <Bots/Util/SetLog.au3>
#include <Bots/Util/Time.au3>
#include <Bots/Util/CreateLogFile.au3>
#include <Bots/Util/_Sleep.au3>
#include <Bots/Util/Click.au3>
#include <Bots/Util/ControlMouseDrag.au3>
#include <Bots/Util/SaveImageToFile.au3>
#include <Bots/Util/Pixels/_ColorCheck.au3>
#include <Bots/Util/Pixels/_GetPixelColor.au3>
#include <Bots/Util/Pixels/_PixelSearch.au3>
#include <Bots/Util/Pixels/_CaptureRegion.au3>
#include <Bots/Util/Image Search/ImageSearch.au3>
#include <ScreenCapture.au3>
#include <Bots/GlobalVariables.au3>
#include <Bots/Config.au3>
#include <Bots/AutoFlow.au3>
#include <Bots/ActionFunc.au3>
#include <Bots/Form/MainView.au3>
#include <String.au3>
#include <Date.au3>
#include-once

Opt("MouseCoordMode", 0)
Opt("GUICoordMode", 2)
Opt("GUIResizeMode", 1)
Opt("GUIOnEventMode", 1)
Opt("TrayIconHide", 1)

GUIRegisterMsg($WM_COMMAND, "GUIControl")
GUIRegisterMsg($WM_SYSCOMMAND, "GUIControl")

; Initialize
DirCreate($dirLogs)
DirCreate($dirCapture)
_GDIPlus_Startup()
CreateLogFile()
loadConfig()
applyConfig()

HotKeySet("^+c", "calcHotKeyFunc")
HotKeySet("^+x", "btnStop")

Func calcHotKeyFunc()
   Opt("MouseCoordMode", 1)
   Local $aPos = MouseGetPos()
   Opt("MouseCoordMode", 2)

   saveConfig()
   loadConfig()
   applyConfig()
   If findWindow() Then
	  GUICtrlSetData($inputCalcPosX, $aPos[0] - $WinRect[0])
	  GUICtrlSetData($inputCalcPosY, $aPos[1] - $WinRect[1])
	  calcPos()
   EndIf
EndFunc

Func findWindow()

   Local $found = False
   Local $arr = StringSplit($setting_win_title, "|")
   Local $foundNoxRect;
   For $i = 1 To $arr[0]
	  $rect = WinGetPos($arr[$i])
	  If Not @error Then
		 $winList = WinList($arr[$i])
		 $count = $winList[0][0]
		 For $w = 1 To $count

			$rect = WinGetPos( $winList[$w][1] )
			If Not @error Then
			   If $rect[2] > $NoxMinWinSize AND $rect[3] > $NoxMinWinSize Then
				  $Title = $winList[$w][0]
				  $HWnD = $winList[$w][1]
				  $foundNoxRect = $rect
				  $found = True
			   EndIf
			EndIf

			If $found Then
			   ExitLoop
			EndIf
		 Next

		 If $found Then
			ExitLoop
		 EndIf
	  EndIf
   Next

   If $found Then
	  UpdateWindowRect()
   EndIf

   Return $found
EndFunc

; Just idle around
While 1
   Sleep(10)
WEnd

Func runBot()
   _log($INFO, "START")
   Local $iSec, $iMin, $iHour

   Local $errorCount = 0

   Local $hTimer = TimerInit()

   $Restart = False

   ; Config re-apply
   saveConfig()
   loadConfig()
   applyConfig()

   Local $res = AutoFlow()

   Local $time = _TicksToTime(Int(TimerDiff($hTimer)), $iHour, $iMin, $iSec)

   $lastElapsed = StringFormat("%02i:%02i:%02i", $iHour, $iMin, $iSec)

   _log($INFO, "Bye" )
   btnStop()
EndFunc

Func GUIControl($hWind, $iMsg, $wParam, $lParam)
   Local $nNotifyCode = BitShift($wParam, 16)
   Local $nID = BitAND($wParam, 0x0000FFFF)
   Local $hCtrl = $lParam
   #forceref $hWind, $iMsg, $wParam, $lParam

   Switch $iMsg
	  Case 273
		Switch $nID
			Case $GUI_EVENT_CLOSE
			   mainViewClose()
			Case $btnStop
			   btnStop()
			Case $btnPause
			   btnPause()
			Case $btnResume
			   btnResume()
			EndSwitch
	  Case 274
		 Switch $wParam
			Case 0xf060
			   mainViewClose()
		 EndSwitch
   EndSwitch
   Return $GUI_RUNDEFMSG
 EndFunc   ;==>GUIControl


;------------------------------------------------------------------------------
;
; Util Function
;
;------------------------------------------------------------------------------

Func UpdateWindowRect()
   $r = WinGetPos($HWnD)
   If Not @error Then
	  If $r[2] > $NoxMinWinSize AND $r[3] > $NoxMinWinSize Then
		 $WinRect = $r
		 _log($TRACE, "Window Rect : " & $WinRect[0] & "," & $WinRect[1] & " " & $WinRect[2] & "x" & $WinRect[3])
	  EndIf
   EndIf
EndFunc

Func ControlPos($posInfo)

   Local $xy = StringSplit($posInfo, $PosXYSplitter)
   If $xy[0] <= 1 Then
	  Local $pos = [-1, -1]
	  Return $pos
   EndIf

   Local $x = Round(Number($xy[1]) * ($WinRect[2] + ($ThickFrameSize * 2)) / 100)
   Local $y = Round(Number($xy[2]) * ($WinRect[3] - $TitleBarHeight - $ThickFrameSize) / 100)

   $x = $x + $ThickFrameSize
   $y = $y + $TitleBarHeight

   Local $pos = [$x, $y]
   return $pos
EndFunc

Func ClickControlPos($posInfo, $clickCount = 1, $delayMsec = 300, $speed = 300)
   ClickPos(ControlPos($posInfo), $delayMsec, $clickCount, $speed)
EndFunc

Func ClickControlScreen($screenInfo, $clickCount = 1, $delayMsec = 300, $speed = 300)
   Local $infoArr = StringSplit($screenInfo, "|")
   ClickPos(ControlPos($infoArr[1]), $delayMsec, $clickCount, $speed)
EndFunc

Func ScreenToPosInfo($screenInfo)
   Local $infoArr = StringSplit($screenInfo, "|")
   Return $infoArr[1]
EndFunc

Func MoveControlPos($posInfo, $speed = 10, $randomDistance = 0)
   Local $pos = ControlPos($posInfo)

   if $randomDistance > 0 Then
	  $signX = Random(0, 1, 1)
	  $signY = Random(0, 1, 1)
	  $halfDis = $randomDistance / 2
	  If $halfDis <= 0 Then $halfDis = 1
	  $randX = Random(0, $halfDis, 1)
	  $randY = Random(0, $halfDis, 1)
	  If $signX Then
		 $randX *= 1
	  Else
		 $randX *= -1
	  EndIf
	  If $signY Then
		 $randY *= 1
	  Else
		 $randY *= -1
	  EndIf

 	  _log($DEBUG, "MoveControlPos : " & $pos[0] & "x" & $pos[1] & " => " & ($pos[0] + $randX) & "x" & ($pos[1] + $randY))

	  $pos[0] = $pos[0] + $randX
	  $pos[1] = $pos[1] + $randY

   EndIf

   MouseMove($pos[0], $pos[1], $speed)
EndFunc

Func SendKey($key, $delay = 0)
   ;WinActivate($HWnD)
   If $delay > 0 Then
	  If _Sleep($delay) Then Return False
   EndIf
   ;Send( $key )
   Local $currentActiveWindowTitle = WinGetTitle("[ACTIVE]")
   ;_log($INFO, "active title : " & $sText & " => " & WinActive($sText))
   ControlSend ($HWnd, "", $HWnd, $key)
   WinActivate($currentActiveWindowTitle)
EndFunc

Func RegionToRect($regionInfo)
   Local $posArr = StringSplit($regionInfo, "-")

   Local $leftTopPos = ControlPos($posArr[1])
   Local $rightBottomPos = ControlPos($posArr[2])

   $x1 = $leftTopPos[0]
   $y1 = $leftTopPos[1]
   $x2 = $rightBottomPos[0]
   $y2 = $rightBottomPos[1]
   Local $rect = [$x1, $y1, $x2 - $x1 + 1, $y2 - $y1 + 1]
   Return $rect
EndFunc

Func DragControlPos($posInfo1, $posInfo2, $step = 3, $delayMsec = 300)
   $p1 = ControlPos($posInfo1)
   $p2 = ControlPos($posInfo2)

   ControlMouseDrag($HWnD, $p1[0], $p1[1], $p2[0], $p2[1], "left", $step, $delayMsec);
EndFunc

Func IsGameActivated()

   Local $iState = WinGetState($HWnD)
   If BitAND($iState, 8) Then
	  _log($DEBUG, "Game activated")
	  Return True
   EndIf
   _log($DEBUG, "Game Inactivated")
   Return False
EndFunc

Func GetPixelColor($x, $y)

   If $setting_capture_mode Then
	  _CaptureRegion($x, $y, $x+1, $y+1)
	  Local $c = _GetPixelColor(0, 0)
	  Return $c
   Else
	  $x = $WinRect[0] + $x
	  $y = $WinRect[1] + $y
	  Local $c = PixelGetColor($x, $y)
	  _log($DEBUG, "GetPixelColor : " & $x & "x" & $y & " => " & Hex($c));
	  Return StringMid(Hex($c), 3)
   EndIf
EndFunc

Func MyPixelSearch($iLeft, $iTop, $iRight, $iBottom, $iColor, $iColorVariation)

   While ($RunState And $PauseBot)
	  Sleep(1000)
   WEnd

   Local $result = [0, 0]
   If $setting_capture_mode Then

	  Local $aCoord = _PixelSearch($iLeft, $iTop, $iRight, $iBottom, $iColor, $iColorVariation)
	  If IsArray($aCoord) = True Then
		 $result = $aCoord
	  EndIf
   Else

	  Local $aCoord = PixelSearch($WinRect[0]+$iLeft, $WinRect[1]+$iTop, $WinRect[0]+$iRight, $WinRect[1]+$iBottom, $iColor, $iColorVariation)
	  If Not @error Then
		 $aCoord[0] = $aCoord[0] - $WinRect[0]
		 $aCoord[1] = $aCoord[1] - $WinRect[1]
		 $result = $aCoord
	  EndIf
   EndIf

   If IsArray($aCoord) = True Then
	  Return $result
   EndIf
   Return 0
EndFunc

Func CheckForPixel($screenInfo, $PixelTolerance = 15, $RegionSize = 1)
   _log($TRACE, "CheckForPixel start :" & $screenInfo);
   UpdateWindowRect()

   Local $infoArr = StringSplit($screenInfo, "|")
   Local $posArr = StringSplit($infoArr[1], ",")

   If UBound($infoArr) - 1 >= 3 Then
	  $PixelTolerance = Number($infoArr[3])
   EndIf

   If UBound($infoArr) - 1 >= 4 Then
	  $RegionSize = Number($infoArr[4])
   EndIf

   If $RegionSize <= 0 Then
	  $RegionSize = 1
   EndIf

   $okCount = 0
   For $p = 1 To UBound($posArr) - 1
	  Local $pos = ControlPos($posArr[$p])
	  $x = $pos[0]
	  $y = $pos[1]

	  Local $found = False
	  Local $colorArr = StringSplit($infoArr[2], ",")
	  Local $answerColor = GetPixelColor($x, $y)	; For Log

	  For $c = 1 To UBound($colorArr) - 1
		 Local $color = StringStripWS($colorArr[$c], $STR_STRIPLEADING + $STR_STRIPTRAILING)
		 Local $aCoord = MyPixelSearch($x-$RegionSize, $y-$RegionSize, $x+$RegionSize, $y+$RegionSize+$RegionSize, $color, $PixelTolerance)
		 If IsArray($aCoord) = True Then
			_log($DEBUG, "CheckForPixel : [" & $p & "] " & $pos[0] & " x " & $pos[1] & " => OK " & ($aCoord[0]) & " x " & ($aCoord[1]) & ", " & $color & " (" & $answerColor & ") <" & $PixelTolerance & ">");
			$okCount = $okCount + 1
			$found = True
			ExitLoop
		 EndIf
	  Next

	  If $found = False Then
		 _log($DEBUG, "CheckForPixel : " & $pos[0] & "(" & $x & ")(" & $WinRect[0]+$x & ") x " & $pos[1] & "(" & $y & ")(" & $WinRect[1]+$y & ") => FAIL (" & $answerColor & ") : " & $screenInfo & " <" & $PixelTolerance & ">");
		 ExitLoop
	  EndIf
   Next

   If $okCount == UBound($posArr) - 1 Then
	  Return True
   EndIf

   Return False
EndFunc

Func CheckForPixelList($screenInfoList, $PixelTolerance = $DefaultTolerance, $orMode = False, $RegionSize = 1)

   If IsArray($screenInfoList) = False Then
	  Return CheckForPixel($screenInfoList, $PixelTolerance, $RegionSize)
   EndIf

   For $p = 0 To UBound($screenInfoList) - 1
	  If CheckForPixel($screenInfoList[$p], $PixelTolerance, $RegionSize) Then
		 If $orMode Then
			Return True
		 EndIf
	  Else
		 If Not $orMode Then
			Return False
		 EndIf
	  EndIf
   Next

   If $orMode Then
	  Return False
   EndIf
   Return True
EndFunc

Func WaitForPixel($screenInfo)
   Local Const $DefaultWaitMsec = 120000
   Local Const $DefaultCaptureDelay = 2000

   $timer = TimerInit()
   Do
	  If _Sleep($DefaultCaptureDelay) Then ExitLoop

	  If CheckForPixel($screenInfo) Then
		 return True
	  EndIf
   Until TimerDiff($timer) > $DefaultWaitMsec
   return False
EndFunc