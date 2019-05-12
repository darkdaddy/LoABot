
; -----------------------------
; Settings Variable
; -----------------------------

Local $setting_common_group = "Default"

Global $setting_win_title = "LOST ARK (64-bit) v.1.0.4.1"
Global $setting_thick_frame_size = "25:1"
Global $setting_fishing_pos = "70.15:25.36"
Global $setting_pixel_tolerance = 13
Global $setting_pixel_region = 5
Global $setting_game_speed_rate = 1.0
Global $setting_fishing_pos_random_distance = 100 ; pixel
Global $setting_bg_mode = True
Global $setting_capture_mode = True
Global $setting_auto_mode = 0
Global $setting_open_esc_menu = True
Global $setting_enabled_fish_trap = False
Global $setting_sea_travel_key_delay = 500
Global $setting_sea_travel_key_list = "{ALTDOWN},53.27:52.91,{ALTUP},{ALTDOWN},52.39:61.31,{ALTUP},{ALTDOWN},50.88:54.29,{ALTUP},{ALTDOWN},45.33:58.63,{ALTUP}"
;Global $setting_sea_travel_key_list = "{ALTDOWN},52.59:20.87,{ALTUP},{ALTDOWN},45.38:21.51,{ALTUP},{ALTDOWN},52.07:23.64,{ALTUP},{ALTDOWN},37.78:26.59,{ALTUP}"

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
   $setting_pixel_region = IniRead($config, $setting_common_group, "pixel_region", $setting_pixel_region)
   $setting_bg_mode = IniRead($config, $setting_common_group, "enabled_bg_mode", "False") == "True" ? True : False
   $setting_auto_mode = Number(IniRead($config, $setting_common_group, "auto_mode", "0"))
   $setting_open_esc_menu = IniRead($config, $setting_common_group, "enabled_open_esc_menu", "False") == "True" ? True : False
   $setting_enabled_fish_trap = IniRead($config, $setting_common_group, "enabled_fishing_trap", "False") == "True" ? True : False
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
   GUICtrlSetData($inputPixelRegion, $setting_pixel_region)
   GUICtrlSetState($checkBotBackgroundModeEnabled, $setting_bg_mode ? $GUI_CHECKED : $GUI_UNCHECKED)
   GUICtrlSetState($checkOpenEscMenuEnabled, $setting_open_esc_menu ? $GUI_CHECKED : $GUI_UNCHECKED)
   GUICtrlSetState($checkFishingTrapEnabled, $setting_enabled_fish_trap ? $GUI_CHECKED : $GUI_UNCHECKED)

   _GUICtrlComboBox_SetCurSel($comboAutoMode, Int($setting_auto_mode))
   _GUICtrlRichEdit_AppendText($txtKeyList, $setting_sea_travel_key_list)

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
   IniWrite($config, $setting_common_group, "pixel_region", GUICtrlRead($inputPixelRegion))
   IniWrite($config, $setting_common_group, "enabled_bg_mode", _IsChecked($checkBotBackgroundModeEnabled))
   IniWrite($config, $setting_common_group, "enabled_open_esc_menu", _IsChecked($checkOpenEscMenuEnabled))
   IniWrite($config, $setting_common_group, "enabled_fishing_trap", _IsChecked($checkFishingTrapEnabled))
   IniWrite($config, $setting_common_group, "auto_mode", _GUICtrlComboBox_GetCurSel($comboAutoMode))

EndFunc	;==>saveConfig

Func _IsChecked($idControlID)
    Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

