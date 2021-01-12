
; -----------------------------
; Settings Variable
; -----------------------------

Local $setting_common_group = "Default"

Global $setting_win_title = "LOST ARK (64-bit) v.1.0.4.1"
Global $setting_thick_frame_size = "25:1"
Global $setting_fishing_pos = "70.15:25.36"
Global $setting_collect_pos = "70.15:25.36"
Global $setting_skill_cast_pos = "70.15:25.36"
Global $setting_skill_cast_pos2 = "79.77:47.46"
Global $setting_skill_cast_key = "s"
Global $setting_skill_cast_sec = 30 ; sec
Global $setting_pixel_tolerance = 13
Global $setting_pixel_region = 5
Global $setting_game_speed_rate = 1.0
Global $setting_pos_random_distance = 100 ; pixel
Global $setting_bg_mode = True
Global $setting_capture_mode = True
Global $setting_auto_mode = 0
Global $setting_open_esc_menu = True
Global $setting_enabled_fish_trap = False
Global $setting_sea_travel_key_delay = 500
Global $setting_sea_travel_key_g_enabled = False
Global $setting_sea_travel_key_list = "{ALTDOWN},53.27:52.91,{ALTUP},{ALTDOWN},52.39:61.31,{ALTUP},{ALTDOWN},50.88:54.29,{ALTUP},{ALTDOWN},45.33:58.63,{ALTUP}"
Global $setting_see_travel_min_lucky_energy_ratio = 16
Global $setting_itemenchant_ratio = 20.5;22.0;
Global $setting_itemenchant_ok_count = 0;22.0;
Global $setting_itemenchant_button_pos = "39.68:67.00"
Global $setting_scrollenchant_button_pos = "39.68:67.00"
Global $setting_scrollenchant_button_pos2 = "49.33:64.73"
Global $setting_stone_handmake_topleft = "25.41:29.09"
Global $setting_stone_handmake_max_step = 8
Global $setting_stone_handmake_prefer_index = -1
Global $setting_stone_handmake_random = False
Global $setting_itemenchant_sleep = 400
Global $setting_itemenchant_move_speed = 5
Global $setting_itemenchant_rate_threshold_cnt = 3
Global $setting_itemenchant_simulate_click = False
Global $setting_collect_only = True
;Global $setting_sea_travel_key_list = "{ALTDOWN},52.59:20.87,{ALTUP},{ALTDOWN},45.38:21.51,{ALTUP},{ALTDOWN},52.07:23.64,{ALTUP},{ALTDOWN},37.78:26.59,{ALTUP}"

Func reloadConfig()
   saveConfig()
   loadConfig()
EndFunc

Func loadConfig()

   $setting_win_title = IniRead($config, $setting_common_group, "win_title", $setting_win_title)
   $setting_thick_frame_size = IniRead($config, $setting_common_group, "thick_frame_size", $setting_thick_frame_size)
   $setting_fishing_pos = IniRead($config, $setting_common_group, "fishing_pos", $setting_fishing_pos)
   $setting_collect_pos = IniRead($config, $setting_common_group, "collect_pos", $setting_collect_pos)
   $setting_skill_cast_pos = IniRead($config, $setting_common_group, "skill_cast_pos", $setting_skill_cast_pos)
   $setting_skill_cast_pos2 = IniRead($config, $setting_common_group, "skill_cast_pos2", $setting_skill_cast_pos2)
   $setting_skill_cast_key = IniRead($config, $setting_common_group, "skill_cast_key", $setting_skill_cast_key)
   $setting_skill_cast_sec = IniRead($config, $setting_common_group, "skill_cast_sec", $setting_skill_cast_sec)
   $setting_game_speed_rate = IniRead($config, $setting_common_group, "game_speed_rate", $setting_game_speed_rate)
   $setting_pos_random_distance = IniRead($config, $setting_common_group, "random_distance", $setting_pos_random_distance)
   $setting_pixel_tolerance = IniRead($config, $setting_common_group, "pixel_tolerance", $setting_pixel_tolerance)
   $setting_pixel_region = IniRead($config, $setting_common_group, "pixel_region", $setting_pixel_region)
   $setting_bg_mode = IniRead($config, $setting_common_group, "enabled_bg_mode", "False") == "True" ? True : False
   $setting_auto_mode = Number(IniRead($config, $setting_common_group, "auto_mode", "0"))
   $setting_open_esc_menu = IniRead($config, $setting_common_group, "enabled_open_esc_menu", "False") == "True" ? True : False
   $setting_enabled_fish_trap = IniRead($config, $setting_common_group, "enabled_fishing_trap", "False") == "True" ? True : False
   $setting_itemenchant_button_pos = IniRead($config, $setting_common_group, "itemenchant_btn_pos", $setting_itemenchant_button_pos)
   $setting_scrollenchant_button_pos = IniRead($config, $setting_common_group, "scrollenchant_btn_pos", $setting_scrollenchant_button_pos)
   $setting_itemenchant_ratio = Number(IniRead($config, $setting_common_group, "itemenchant_ratio", $setting_itemenchant_ratio), 3)
   $setting_itemenchant_ok_count = Number(IniRead($config, $setting_common_group, "itemenchant_ok_count", $setting_itemenchant_ok_count))
   $setting_itemenchant_sleep = Number(IniRead($config, $setting_common_group, "itemenchant_sleep", $setting_itemenchant_sleep))
   $setting_itemenchant_simulate_click = IniRead($config, $setting_common_group, "itemenchant_simulation_click", "True") == "True" ? True : False

   $setting_stone_handmake_random = IniRead($config, $setting_common_group, "stone_handmake_random", "False") == "True" ? True : False
   $setting_stone_handmake_max_step = Number(IniRead($config, $setting_common_group, "stone_handmake_max_step", $setting_stone_handmake_max_step), 3)
   $setting_stone_handmake_prefer_index = Number(IniRead($config, $setting_common_group, "stone_handmake_prefer_index", $setting_stone_handmake_prefer_index), 3)
   $setting_stone_handmake_topleft = IniRead($config, $setting_common_group, "stone_handmake_topleft", $setting_stone_handmake_topleft)

   $setting_capture_mode = $setting_bg_mode

   Local $arr = StringSplit($setting_thick_frame_size, ":")
   $TitleBarHeight = Number($arr[1])
   $ThickFrameSize = Number($arr[2])

EndFunc	;==>loadConfig

Func applyConfig()

   GUICtrlSetState($checkStoneHandmakeRandom, $setting_stone_handmake_random ? $GUI_CHECKED : $GUI_UNCHECKED)
   GUICtrlSetData($inputStoneHandmakeLeftTopPos, $setting_stone_handmake_topleft)
   GUICtrlSetData($inputPreferStoneHandMakeMaxStep, $setting_stone_handmake_max_step)
   GUICtrlSetData($inputPreferStoneHandMakeIndex, $setting_stone_handmake_prefer_index)
   GUICtrlSetData($inputGameTitle, $setting_win_title)
   GUICtrlSetData($inputThickFraemSize, $setting_thick_frame_size)
   GUICtrlSetData($inputFishingPos, $setting_fishing_pos)
   GUICtrlSetData($inputCollectPos, $setting_collect_pos)
   GUICtrlSetData($inputSkillPos, $setting_skill_cast_pos)
   GUICtrlSetData($inputSkillPos2, $setting_skill_cast_pos2)
   GUICtrlSetData($inputSkillKey, $setting_skill_cast_key)
   GUICtrlSetData($inputSkillSec, $setting_skill_cast_sec)
   GUICtrlSetData($inputGameSpeed, $setting_game_speed_rate)
   GUICtrlSetData($inputRandomDistance, $setting_pos_random_distance)
   GUICtrlSetData($inputPixelTolerance, $setting_pixel_tolerance)
   GUICtrlSetData($inputPixelRegion, $setting_pixel_region)
   GUICtrlSetData($inputItemEnchantButtonPos, $setting_itemenchant_button_pos)
   GUICtrlSetData($inputScrollEnchantButtonPos, $setting_scrollenchant_button_pos)
   GUICtrlSetData($inputItemEnchantRatio, $setting_itemenchant_ratio)
   GUICtrlSetData($inputItemEnchantOkCount, $setting_itemenchant_ok_count)
   GUICtrlSetData($inputItemEnchantSleep, $setting_itemenchant_sleep)
   GUICtrlSetState($checkBotBackgroundModeEnabled, $setting_bg_mode ? $GUI_CHECKED : $GUI_UNCHECKED)
   GUICtrlSetState($checkOpenEscMenuEnabled, $setting_open_esc_menu ? $GUI_CHECKED : $GUI_UNCHECKED)
   GUICtrlSetState($checkFishingTrapEnabled, $setting_enabled_fish_trap ? $GUI_CHECKED : $GUI_UNCHECKED)
   GUICtrlSetState($checkItemEnchantSimulationClickEnabled, $setting_itemenchant_simulate_click ? $GUI_CHECKED : $GUI_UNCHECKED)

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
   IniWrite($config, $setting_common_group, "collect_pos", GUICtrlRead($inputCollectPos))
   IniWrite($config, $setting_common_group, "skill_cast_pos", GUICtrlRead($inputSkillPos))
   IniWrite($config, $setting_common_group, "skill_cast_pos2", GUICtrlRead($inputSkillPos2))
   IniWrite($config, $setting_common_group, "skill_cast_key", GUICtrlRead($inputSkillKey))
   IniWrite($config, $setting_common_group, "skill_cast_sec", GUICtrlRead($inputSkillSec))
   IniWrite($config, $setting_common_group, "game_speed_rate", GUICtrlRead($inputGameSpeed))
   IniWrite($config, $setting_common_group, "random_distance", GUICtrlRead($inputRandomDistance))
   IniWrite($config, $setting_common_group, "pixel_tolerance", GUICtrlRead($inputPixelTolerance))
   IniWrite($config, $setting_common_group, "pixel_region", GUICtrlRead($inputPixelRegion))
   IniWrite($config, $setting_common_group, "enabled_bg_mode", _IsChecked($checkBotBackgroundModeEnabled))
   IniWrite($config, $setting_common_group, "enabled_open_esc_menu", _IsChecked($checkOpenEscMenuEnabled))
   IniWrite($config, $setting_common_group, "enabled_fishing_trap", _IsChecked($checkFishingTrapEnabled))
   IniWrite($config, $setting_common_group, "auto_mode", _GUICtrlComboBox_GetCurSel($comboAutoMode))
   IniWrite($config, $setting_common_group, "scrollenchant_btn_pos", GUICtrlRead($inputScrollEnchantButtonPos))
   IniWrite($config, $setting_common_group, "itemenchant_btn_pos", GUICtrlRead($inputItemEnchantButtonPos))
   IniWrite($config, $setting_common_group, "itemenchant_ratio", GUICtrlRead($inputItemEnchantRatio))
   IniWrite($config, $setting_common_group, "itemenchant_ok_count", GUICtrlRead($inputItemEnchantOkCount))
   IniWrite($config, $setting_common_group, "itemenchant_sleep", GUICtrlRead($inputItemEnchantSleep))
   IniWrite($config, $setting_common_group, "itemenchant_simulation_click", _IsChecked($checkItemEnchantSimulationClickEnabled))
   IniWrite($config, $setting_common_group, "stone_handmake_random", _IsChecked($checkStoneHandmakeRandom))
   IniWrite($config, $setting_common_group, "stone_handmake_max_step", GUICtrlRead($inputPreferStoneHandMakeMaxStep))
   IniWrite($config, $setting_common_group, "stone_handmake_prefer_index", GUICtrlRead($inputPreferStoneHandMakeIndex))
   IniWrite($config, $setting_common_group, "stone_handmake_topleft", GUICtrlRead($inputStoneHandmakeLeftTopPos))

EndFunc	;==>saveConfig

Func _IsChecked($idControlID)
    Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

