#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <FileConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <GUIEdit.au3>
#include <GUIComboBox.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPIProc.au3>
#include <ScreenCapture.au3>
#include <Date.au3>
#include <Misc.au3>
#include <File.au3>
#include <TrayConstants.au3>
#include <GUIMenu.au3>
#include <ColorConstants.au3>
#include <GDIPlus.au3>
#include <GuiRichEdit.au3>
#include <GuiTab.au3>
#include <WinAPISys.au3>

Global Const $64Bit = StringInStr(@OSArch, "64") > 0

Global $TitleBarHeight = 25
Global $ThickFrameSize = 1
Global Const $NoxMinWinSize = 220
Global Const $AppMinWinWidth = 560
Global $WinRect = [0, 0, 0, 0]
Global $WindowClass = "[Qt5QWindowIcon]"
Global $Title

Global $PosXYSplitter = ":"

Global $HWnD = WinGetHandle($Title) ;Handle for Bluestacks window

Global $Compiled
If @Compiled Then
	$Compiled = "Executable"
Else
	$Compiled = "Au3 Script"
EndIf

Global $sLogPath ; `Will create a new log file every time the start button is pressed
Global $hLogFileHandle
Global $Restart = False
Global $RunState = False
Global $PauseBot = False

Global $hBitmap; Image for pixel functions
Global $hHBitmap; Handle Image for pixel functions

Global $dirLogs = @ScriptDir & "\logs\"
Global $dirCapture = @ScriptDir & "\capture\"
Global $ReqText
Global $config = @ScriptDir & "\config.ini"

Global $BSpos[2] ; Inside BlueStacks positions relative to the screen

; ---------- Log -----------
Global const $TRACE = 0
Global const $DEBUG = 1
Global const $INFO = 2
Global const $ERROR = 3
Global $CurrentLogLevel = 2


; ---------- COLORS ------------
; https://www.autoitscript.com/trac/autoit/ticket/26
Global Const $COLOR_ORANGE = 0xFFA500
Global Const $COLOR_PINK = 0xf1735f
Global Const $COLOR_DARKGREY = 0x555555

; ---------- Logic -----------

; ---------- Settings -----------
Global Const $RetryWaitCount = 30
Global Const $SleepWaitMSec = 1500
Global Const $ViewChangeWaitMSec = 4000
Global Const $FieldActionIdleMSec = 1000 ;(5000) need to include check enemy & buff time
Global Const $DefaultTolerance = 21
Global Const $MaxTryCount = 10

; ---------- STATS ---------------
Global $Stats_LoopCount = 0
Global $Stats_FishCatchCount = 0
Global $Stats_FishFailureCount = 0
Global $Stats_FishTrapCount = 0

; ---------- Positions ------------
;Global const $POS_BUTTON_XXX = "94.6:2.3"

; ---------- Screen Check ------------
Global const $CHECK_ESC_MENU[3] = ["54.77:44.04|0xBEC0C1", "54.93:41.46|0xDBDBDB", "54.62:46.72|0xBABBBB"]
Global const $CHECK_FISH_TRAP_ACTIVE_ICON[1] = ["14.83:1.39|0x4F514F|10|3"]
Global const $CHECK_SWAP_NPC_MENU[4] = ["96.78:93.54|0x29363F", "97.2:95.94|0x253139", "91.49:96.12|0x253039", "49.59:77.47|0x76CED9"]
Global const $CHECK_STATUS_ATTACT_HUD[1] = ["47.95:99.14|0x39B6FA"]
Global const $CHECK_STATUS_FISH_SKILL_ACTIVE[2] = ["40.15:92.34|0xBBB881", "38.02:91.14|0xD2CA9F"]
Global const $CHECK_STATUS_WEB_SKILL_ACTIVE[4] = ["39.16:96.77|0xDDC064", "41.29:96.95|0xD0A846", "41.29:95.01|0xE3BF57", "41.34:98.43|0xBAA653"]
Global const $CHECK_STATUS_FISH_OK_MARK[6] = ["49.75:46.06|0xFCD47C", "49.88:45.09|0xFFB664", "49.81:45.29|0xF0BA67", "49.94:45.96|0xF3AE5C", "49.95:43.58|0xD39765|13|8", "49.84:43.67|0xAE9562|13|8"]
