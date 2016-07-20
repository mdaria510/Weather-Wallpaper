#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <YWeather.au3>
#NoTrayIcon
#include <GuiConstants.au3>
#include <Constants.au3>

Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1)


TraySetOnEvent($TRAY_EVENT_PRIMARYUP, "SpecialEvent")

;TraySetState(2) ; hide --> not needed

;======================================================================================================
$iWOEID = "2451932" ;Mineola WOEID
$iUnits = 1 ;Imperial System
;======================================================================================================

$GUI = GUICreate("Weather Watcher", 454, 220, 550, 140)
$Group1 = GUICtrlCreateGroup("Current Weather", 8, 8, 433, 209)
$Label1 = GUICtrlCreateLabel("Temperature:", 16, 24, 67, 17)
$l_Temp = GUICtrlCreateLabel("40", 88, 24, 20, 17)
$Label3 = GUICtrlCreateLabel("Weather:", 16, 48, 48, 17)
$l_Weather = GUICtrlCreateLabel("", 64, 48, 276, 17)
$Label19 = GUICtrlCreateLabel("Wind Chill:", 16, 72, 54, 17)
$l_Chill = GUICtrlCreateLabel("", 72, 72, 18, 17)
$Label21 = GUICtrlCreateLabel("Direction:", 96, 72, 49, 17)
$l_Direction = GUICtrlCreateLabel("", 144, 72, 26, 17)
$Label23 = GUICtrlCreateLabel("Speed:", 176, 72, 38, 17)
$l_Speed = GUICtrlCreateLabel("", 216, 72, 26, 17)
$Label25 = GUICtrlCreateLabel("mph", 248, 72, 24, 17)
$Label26 = GUICtrlCreateLabel("Sunrise:", 16, 120, 42, 17)
$l_Sunrise = GUICtrlCreateLabel("", 64, 120, 42, 17)
$Label28 = GUICtrlCreateLabel("Sunset:", 112, 120, 40, 17)
$l_Sunset = GUICtrlCreateLabel("", 152, 120, 42, 17)
$Label30 = GUICtrlCreateLabel("Humidity:", 16, 96, 47, 17)
$l_Humidity = GUICtrlCreateLabel("", 64, 96, 18, 17)
$Label32 = GUICtrlCreateLabel("%", 88, 96, 12, 17)
$Label33 = GUICtrlCreateLabel("Visibility:", 104, 96, 43, 17)
$l_Visibility = GUICtrlCreateLabel("", 152, 96, 18, 17)
$Label35 = GUICtrlCreateLabel("mi", 176, 96, 14, 17)
$Label36 = GUICtrlCreateLabel("Pressure:", 192, 96, 48, 17)
$l_Pressure = GUICtrlCreateLabel("", 240, 96, 26, 17)
$Label38 = GUICtrlCreateLabel("Latitude:", 16, 144, 45, 17)
$l_Latitude = GUICtrlCreateLabel("", 64, 144, 34, 17)
$Label40 = GUICtrlCreateLabel("Longitude:", 104, 144, 54, 17)
$l_Longitude = GUICtrlCreateLabel("", 160, 144, 34, 17)
$Label42 = GUICtrlCreateLabel("City:", 16, 168, 24, 17)
$l_City = GUICtrlCreateLabel("", 40, 168, 114, 17)
$Label44 = GUICtrlCreateLabel("Region:", 168, 168, 41, 17)
$l_Region = GUICtrlCreateLabel("", 216, 168, 50, 17)
$Label46 = GUICtrlCreateLabel("Country:", 280, 168, 43, 17)
$l_Country = GUICtrlCreateLabel("", 328, 168, 106, 17)
$Label5 = GUICtrlCreateLabel("Check time:", 16, 192, 60, 17)
$l_Check = GUICtrlCreateLabel("", 80, 192, 236, 17)
$Label2 = GUICtrlCreateLabel("F", 112, 24, 10, 17)
$Label4 = GUICtrlCreateLabel("in", 272, 96, 12, 17)
$Label6 = GUICtrlCreateLabel("Rising:", 288, 96, 33, 17)
$l_Rising = GUICtrlCreateLabel("", 328, 96, 68, 17)
;~ GUICtrlCreateGroup("", -99, -99, 1, 1)
;~ $Group2 = GUICtrlCreateGroup("Forecast", 8, 224, 433, 89)
;~ $Label7 = GUICtrlCreateLabel("Low Temperature:", 16, 240, 90, 17)
;~ $l_Low1 = GUICtrlCreateLabel("", 112, 240, 20, 17)
;~ $Label9 = GUICtrlCreateLabel("F", 136, 240, 10, 17)
;~ $Label11 = GUICtrlCreateLabel("High Temperature:", 16, 264, 92, 17)
;~ $l_Hi1 = GUICtrlCreateLabel("", 112, 264, 18, 17)
;~ $Label12 = GUICtrlCreateLabel("F", 136, 264, 10, 17)
;~ $Label13 = GUICtrlCreateLabel("Weather:", 16, 288, 48, 17)
;~ $l_Weather1 = GUICtrlCreateLabel("", 64, 288, 290, 17)
;~ GUICtrlCreateGroup("", -99, -99, 1, 1)
;~ $Group3 = GUICtrlCreateGroup("", 8, 320, 433, 89)
;~ $Label15 = GUICtrlCreateLabel("Low Temperature:", 16, 336, 87, 17)
;~ $Label16 = GUICtrlCreateLabel("High Temperature:", 16, 360, 89, 17)
;~ $Label17 = GUICtrlCreateLabel("Weather:", 16, 384, 48, 17)
;~ $l_Weather2 = GUICtrlCreateLabel("", 64, 384, 298, 17)
;~ $l_Low2 = GUICtrlCreateLabel("", 104, 336, 18, 17)
;~ $Label14 = GUICtrlCreateLabel("F", 128, 336, 10, 17)
;~ $l_Hi2 = GUICtrlCreateLabel("", 112, 360, 18, 17)
;~ $Label20 = GUICtrlCreateLabel("F", 136, 360, 10, 17)
;~ GUICtrlCreateGroup("", -99, -99, 1, 1)


Global Const $tagCOLORIZATIONPARAMS = 'dword Color;dword AftGlow;uint Intensity;uint AftGlowBal;uint BlurBal;uint GlassReflInt; uint Opaque'
$iImageVersion = 2
$TimeOfDay = ""

$CurrentWeather = ""

UpdateWeather()
WallPaperChange()
AeroColorChange()

GUISetState(@SW_SHOW)

Global $hTimer = TimerInit() ; Begin the timer and store the handle in a variable.

While 1
	$nMsg = GUIGetMsg()

	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $GUI_EVENT_MINIMIZE
			GUISetState(@SW_HIDE)
			TraySetState(1) ; show
			TraySetToolTip("Weather Wallpaper")
			TraySetIcon(@ScriptDir & "\Weather\Aeroweather.ico")

	EndSwitch

	$fDiff = TimerDiff($hTimer) ; Find the difference in time from the previous call of TimerInit. The variable we stored the TimerInit handlem is passed as the "handle" to TimerDiff.

	If $fDiff > 900000 Then

		;2 Second Test Case
		;If $fDiff > 2000 Then

		UpdateWeather()

		$Weather = _YWeater_Get_Weather($iWOEID, $iUnits)

		$hTimer = TimerInit()

		WallPaperChange()
		AeroColorChange()

	EndIf
WEnd


Func UpdateWeather()
	Global $Weather = _YWeater_Get_Weather($iWOEID, $iUnits)

	If Not @error Then
		InetGet($Weather[1], @TempDir & "\Current_Picture.gif")
		GUICtrlSetData($l_Weather, $Weather[0])
		GUICtrlCreatePic(@TempDir & "\Current_Picture.gif", 368, 24, 60, 52)
		GUICtrlSetData($l_Temp, $Weather[2])
		GUICtrlSetData($l_Check, $Weather[3])
	EndIf

	Global $Forecast = _YWeater_Get_Forecast($iWOEID, $iUnits)

;~ If Not @error Then
;~ 	InetGet($Forecast[0][5], @TempDir & "\Tomorrow_Picture.gif")
;~ 	GUICtrlCreatePic(@TempDir & "\Tomorrow_Picture.gif", 368, 240, 60, 52)
;~ 	GUICtrlSetData($Group2, $Forecast[0][0] & " " & $Forecast[0][1])
;~ 	GUICtrlSetData($l_Low1, $Forecast[0][2])
;~ 	GUICtrlSetData($l_Hi1, $Forecast[0][3])
;~ 	GUICtrlSetData($l_Weather1, $Forecast[0][4])
;~ 	InetGet($Forecast[1][5], @TempDir & "\After_Tomorrow_Picture.gif")
;~ 	GUICtrlCreatePic(@TempDir & "\After_Tomorrow_Picture.gif", 368, 336, 60, 52)
;~ 	GUICtrlSetData($Group3, $Forecast[1][0] & " " & $Forecast[1][1])
;~ 	GUICtrlSetData($l_Low2, $Forecast[1][2])
;~ 	GUICtrlSetData($l_Hi2, $Forecast[1][3])
;~ 	GUICtrlSetData($l_Weather2, $Forecast[1][4])
;~ EndIf

	Global $Wind = _YWeater_Get_Wind($iWOEID, $iUnits)

	If Not @error Then
		GUICtrlSetData($l_Chill, $Wind[0])
		GUICtrlSetData($l_Direction, $Wind[1])
		GUICtrlSetData($l_Speed, $Wind[2])
	EndIf

	Global $Atmosphere = _YWeater_Get_Atmosphere($iWOEID, $iUnits)

	If Not @error Then
		GUICtrlSetData($l_Humidity, $Atmosphere[0])
		GUICtrlSetData($l_Visibility, $Atmosphere[1])
		GUICtrlSetData($l_Pressure, $Atmosphere[2])
		GUICtrlSetData($l_Rising, $Atmosphere[3])
	EndIf

	Global $Astronomy = _YWeater_Get_Astronomy($iWOEID)

	If Not @error Then
		GUICtrlSetData($l_Sunrise, $Astronomy[0])
		GUICtrlSetData($l_Sunset, $Astronomy[1])
	EndIf

	Global $Coordinates = _YWeater_Get_Coordinates($iWOEID)

	If Not @error Then
		GUICtrlSetData($l_Latitude, $Coordinates[0])
		GUICtrlSetData($l_Longitude, $Coordinates[1])
	EndIf

	Global $Location = _YWeater_Get_Location($iWOEID)

	If Not @error Then
		GUICtrlSetData($l_City, $Location[0])
		GUICtrlSetData($l_Region, $Location[1])
		GUICtrlSetData($l_Country, $Location[2])
	EndIf

EndFunc   ;==>UpdateWeather

Func SpecialEvent()
	GUISetState(@SW_SHOW)
	TraySetState(2) ; hide
EndFunc   ;==>SpecialEvent

Func WallPaperChange()

	;MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @CRLF & '$Weather' & @CRLF & @CRLF & 'Return:' & @CRLF & $Weather[0]) ;### Debug MSGBOX


	Switch $Weather[0]
		Case "cloudy", "partly cloudy", "mostly cloudy"
			$CurrentWeather = "cloudy"

		Case "sunny", "fair"
			$CurrentWeather = "fair"

		Case "rain", "light rain", "freezing rain", "light freezing rain"
			$CurrentWeather = "rain"

		Case "snow", "light snow", "blizzard", "snow/wind", "blowing snow"
			$CurrentWeather = "snow"

		Case "t-storms", "isolated t-storms", "scattered t-storms", "hurricane", "tropical storm"
			$CurrentWeather = "t-storms"

		Case "fog", "light fog", "heavy fog"
			$CurrentWeather = "fog"
	EndSwitch


	;MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @CRLF & '$CurrentWeather' & @CRLF & @CRLF & 'Return:' & @CRLF & $CurrentWeather) ;### Debug MSGBOX


	Switch @HOUR
		Case 00 To 05
			$TimeOfDay = "night"

		Case 06 To 08
			$TimeOfDay = "sun"

		Case 09 To 15
			$TimeOfDay = "day"

		Case 16 To 18
			$TimeOfDay = "sun"

		Case 19 To 24
			$TimeOfDay = "night"


	EndSwitch

	_ChangeDesktopWallpaper(@ScriptDir & "\Weather\" & $CurrentWeather & " " & $TimeOfDay & " (" & $iImageVersion & ").jpg", 2)
	ConsoleWrite(@ScriptDir & "\Weather\" & $CurrentWeather & " " & $TimeOfDay & " (" & $iImageVersion & ").jpg")

	$iImageVersion += 1

	If FileExists(@ScriptDir & "\Weather\" & $CurrentWeather & " " & $TimeOfDay & " (" & $iImageVersion & ").jpg") = 0 Then
		$iImageVersion = 2
	EndIf



EndFunc   ;==>WallPaperChange

Func AeroColorChange()

	$tCP = DllStructCreate($tagCOLORIZATIONPARAMS)
	$Ret = DllCall('dwmapi.dll', 'uint', 127, 'ptr', DllStructGetPtr($tCP))


	Switch $Weather[2]
		Case 0 To 6
			$Tempcolor = "0x0088FF"
			$Tempintensity = "0"

		Case 7 To 12
			$Tempcolor = "0x0088FF"
			$Tempintensity = "7"

		Case 13 To 19
			$Tempcolor = "0x0088FF"
			$Tempintensity = "13"

		Case 20 To 26
			$Tempcolor = "0x0088FF"
			$Tempintensity = "20"

		Case 27 To 32
			$Tempcolor = "0x0088FF"
			$Tempintensity = "27"

		Case 33 To 39
			$Tempcolor = "0x00CCFF"
			$Tempintensity = "33"

		Case 40 To 46
			$Tempcolor = "0x00FFFF"
			$Tempintensity = "40"

		Case 47 To 52
			$Tempcolor = "0x00FFCC"
			$Tempintensity = "47"

		Case 53 To 59
			$Tempcolor = "0x00FF88"
			$Tempintensity = "53"

		Case 60 To 66
			$Tempcolor = "0x00FF33"
			$Tempintensity = "60"

		Case 67 To 72
			$Tempcolor = "0x00FF00"
			$Tempintensity = "67"

		Case 73 To 79
			$Tempcolor = "0xCCFF00"
			$Tempintensity = "73"

		Case 80 To 86
			$Tempcolor = "0xFFCC00"
			$Tempintensity = "80"

		Case 87 To 92
			$Tempcolor = "0xFF3300"
			$Tempintensity = "87"

		Case 93 To 150
			$Tempcolor = "0xFF0000"
			$Tempintensity = "93"

	EndSwitch



	DllStructSetData($tCP, 'Color', $Tempcolor) ; Set a new color
	DllStructSetData($tCP, 'Intensity', $Tempintensity) ; Set a new Intensity
	DllStructSetData($tCP, 'Opaque', 0) ; Set a new Opaque
	$Ret = DllCall('dwmapi.dll', 'uint', 131, 'ptr', DllStructGetPtr($tCP), 'uint', 0)



EndFunc   ;==>AeroColorChange

Func _ChangeDesktopWallpaper($bmp, $style = 0)
	;===============================================================================
	;
	; Function Name:    _ChangeDesktopWallPaper
	; Description:     Update WallPaper Settings
	;Usage:           _ChangeDesktopWallPaper(@WindowsDir & '\' & 'zapotec.bmp',1)
	; Parameter(s):  $bmp - Full Path to BitMap File (*.bmp)
	;                             [$style] - 0 = Centered, 1 = Tiled, 2 = Stretched
	; Requirement(s):   None.
	; Return Value(s):  On Success - Returns 0
	;                  On Failure -   -1
	; Author(s):        FlyingBoz
	;Thanks:        Larry - DllCall Example - Tested and Working under XPHome and W2K Pro
	;                    Excalibur - Reawakening my interest in Getting This done.
	;
	;===============================================================================

	If Not FileExists($bmp) Then Return -1
	;The $SPI*  values could be defined elsewhere via #include - if you conflict,
	; remove these, or add if Not IsDeclared "SPI_SETDESKWALLPAPER" Logic
	Local $SPI_SETDESKWALLPAPER = 20
	Local $SPIF_UPDATEINIFILE = 1
	Local $SPIF_SENDCHANGE = 2
	Local $REG_DESKTOP = "HKEY_CURRENT_USER\Control Panel\Desktop"
	If $style = 1 Then
		RegWrite($REG_DESKTOP, "TileWallPaper", "REG_SZ", 1)
		RegWrite($REG_DESKTOP, "WallpaperStyle", "REG_SZ", 0)
	Else
		RegWrite($REG_DESKTOP, "TileWallPaper", "REG_SZ", 0)
		RegWrite($REG_DESKTOP, "WallpaperStyle", "REG_SZ", $style)
	EndIf


	DllCall("user32.dll", "int", "SystemParametersInfo", _
			"int", $SPI_SETDESKWALLPAPER, _
			"int", 0, _
			"str", $bmp, _
			"int", BitOR($SPIF_UPDATEINIFILE, $SPIF_SENDCHANGE))
	Return 0
EndFunc   ;==>_ChangeDesktopWallpaper
