
; -----------------------------
; Settings Variable
; -----------------------------

Local $setting_common_group = "Default"

Global $setting_win_title = "LOST ARK (64-bit) v.1.0.4.1"
Global $setting_thick_frame_size = "25:1"
Global $setting_fishing_pos = "70.15:25.36"
Global $setting_pixel_tolerance = 13
Global $setting_game_speed_rate = 1.0
Global $setting_fishing_pos_random_distance = 100 ; pixel
Global $setting_bg_mode = True
Global $setting_capture_mode = True

Func reloadConfig()
   saveConfig()
   loadConfig()
EndFunc

Func loadConfig()

   $setting_win_title = IniRead($config, $setting_common_group, "win_title", $setting_win_title)
   $setting_thick_frame_size = IniRead($config, $setting_common_group, "thick_frame_size", $setting_thick_frame_size)
   $setting_fishing_pos = IniRead($config, $setting_common_group, "fishing_pos", $setting_fishing_pos)
   $setting_game_speed_rate = IniRead($config, $setting_common_group, "game_speed_rate", $setting_game_speed_rate)
   $setting_fishing_pos_random_distance = IniRead($config, $setting_common_group, "random_distance", $setting_fishing_pos_random_distance)
   $setting_pixel_tolerance = IniRead($config, $setting_common_group, "pixel_tolerance", $setting_pixel_tolerance)
   $setting_bg_mode = IniRead($config, $setting_common_group, "enabled_bg_mode", "False") == "True" ? True : False
   $setting_capture_mode = $setting_bg_mode

   Local $arr = StringSplit($setting_thick_frame_size, ":")
   $TitleBarHeight = Number($arr[1])
   $ThickFrameSize = Number($arr[2])

EndFunc	;==>loadConfig

Func applyConfig()

   GUICtrlSetData($inputGameTitle, $setting_win_title)
   GUICtrlSetData($inputThickFraemSize, $setting_thick_frame_size)
   GUICtrlSetData($inputFishingPos, $setting_fishing_pos)
   GUICtrlSetData($inputGameSpeed, $setting_game_speed_rate)
   GUICtrlSetData($inputRandomDistance, $setting_fishing_pos_random_distance)
   GUICtrlSetData($inputPixelTolerance, $setting_pixel_tolerance)
   GUICtrlSetState($checkBotBackgroundModeEnabled, $setting_bg_mode ? $GUI_CHECKED : $GUI_UNCHECKED)
   $rate = Number(GUICtrlRead($inputGameSpeed), $NUMBER_DOUBLE)

   $v = ($rate - 1.0) * 50 + 50
   GUICtrlSetData($sliderGameSpeed, $v)

EndFunc	;==>applyConfig

Func saveConfig()

   IniWrite($config, $setting_common_group, "win_title", GUICtrlRead($inputGameTitle))
   IniWrite($config, $setting_common_group, "thick_frame_size", GUICtrlRead($inputThickFraemSize))
   IniWrite($config, $setting_common_group, "fishing_pos", GUICtrlRead($inputFishingPos))
   IniWrite($config, $setting_common_group, "game_speed_rate", GUICtrlRead($inputGameSpeed))
   IniWrite($config, $setting_common_group, "random_distance", GUICtrlRead($inputRandomDistance))
   IniWrite($config, $setting_common_group, "pixel_tolerance", GUICtrlRead($inputPixelTolerance))
   IniWrite($config, $setting_common_group, "enabled_bg_mode", _IsChecked($checkBotBackgroundModeEnabled))

EndFunc	;==>saveConfig

Func _IsChecked($idControlID)
    Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

