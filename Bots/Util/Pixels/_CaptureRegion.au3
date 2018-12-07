;Saves a screenshot of the window into memory.

Func _CaptureRegion($iLeft = 0, $iTop = 0, $iRight = $WinRect[2], $iBottom = $WinRect[3], $ReturnBMP = False)

	_GDIPlus_BitmapDispose($hBitmap)
	_WinAPI_DeleteObject($hHBitmap)

	  Local $iW = Number($iRight) - Number($iLeft), $iH = Number($iBottom) - Number($iTop)

	  Local $hDC_Capture = _WinAPI_GetWindowDC($HWnD)
	  Local $hMemDC = _WinAPI_CreateCompatibleDC($hDC_Capture)
	  $hHBitmap = _WinAPI_CreateCompatibleBitmap($hDC_Capture, $iW, $iH)
	  Local $hObjectOld = _WinAPI_SelectObject($hMemDC, $hHBitmap)

	  DllCall("user32.dll", "int", "PrintWindow", "hwnd", $HWnD, "handle", $hMemDC, "int", 0)
	  _WinAPI_SelectObject($hMemDC, $hHBitmap)
	  _WinAPI_BitBlt($hMemDC, 0, 0, $iW, $iH, $hDC_Capture, $iLeft, $iTop, 0x00CC0020)

	  Global $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap)

	  ;$hImage1 = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap)
	  ;_GDIPlus_ImageSaveToFile($hImage1, @MyDocumentsDir & "\GDIPlus_Image22.jpg")

	  _WinAPI_DeleteDC($hMemDC)
	  _WinAPI_SelectObject($hMemDC, $hObjectOld)
	  _WinAPI_ReleaseDC($HWnD, $hDC_Capture)

	  _log($TRACE, "_CaptureRegion : " & $iLeft & "," & $iTop & " " & $iRight & "x" & $iBottom )

;	getBSPos()
;	$hHBitmap = _ScreenCapture_Capture("C:\\a.jpg", $iLeft + $BSpos[0], $iTop + $BSpos[1], $iRight + $BSpos[0], $iBottom + $BSpos[1])
;	Global $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap)

	If $ReturnBMP Then Return $hBitmap
EndFunc   ;==>_CaptureRegion