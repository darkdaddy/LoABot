
; -----------------------------
; Settings Variable
; -----------------------------

Local $setting_common_group = "Default"

Global $setting_win_title = "LOST ARK (64-bit) v.1.0.4.1"
Global $setting_thick_frame_size = "36:2"
Global $setting_fishing_pos = "39.93:16.94"
Global $setting_game_speed_rate = 1.0
Global $setting_check_needle = False
Global $setting_capture_mode = False

Func reloadConfig()
   saveConfig()
   loadConfig()
EndFunc

Func loadConfig()

   $setting_win_title = IniRead($config, $setting_common_group, "win_title", $setting_win_title)
   $setting_thick_frame_size = IniRead($config, $setting_common_group, "thick_frame_size", $setting_thick_frame_size)
   $setting_fishing_pos = IniRead($config, $setting_common_group, "fishing_pos", $setting_fishing_pos)
   $setting_game_speed_rate = IniRead($config, $setting_common_group, "game_speed_rate", $setting_game_speed_rate)

   Local $arr = StringSplit($setting_thick_frame_size, ":")
   $TitleBarHeight = Number($arr[1])
   $ThickFrameSize = Number($arr[2])

EndFunc	;==>loadConfig

Func applyConfig()

   GUICtrlSetData($inputGameTitle, $setting_win_title)
   GUICtrlSetData($inputThickFraemSize, $setting_thick_frame_size)
   GUICtrlSetData($inputFishingPos, $setting_fishing_pos)
   GUICtrlSetData($inputGameSpeed, $setting_game_speed_rate)
   $rate = Number(GUICtrlRead($inputGameSpeed), $NUMBER_DOUBLE)
   $v = ($rate - 1.0) * 50 + 50
   GUICtrlSetData($sliderGameSpeed, $v)

EndFunc	;==>applyConfig

Func saveConfig()

   IniWrite($config, $setting_common_group, "win_title", GUICtrlRead($inputGameTitle))
   IniWrite($config, $setting_common_group, "thick_frame_size", GUICtrlRead($inputThickFraemSize))
   IniWrite($config, $setting_common_group, "fishing_pos", GUICtrlRead($inputFishingPos))
   IniWrite($config, $setting_common_group, "game_speed_rate", GUICtrlRead($inputGameSpeed))

EndFunc	;==>saveConfig

Func _IsChecked($idControlID)
    Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

