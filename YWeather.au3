#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7

; #INDEX# =======================================================================================================================
; Title .........: YWeater v.1.1.0
; AutoIt Version : v3.3.8.1
; Description ...: Retrieves details about the weather in a specific region, using the Yahoo Weather API.
; Author(s) .....: Nessie
; ===============================================================================================================================

; #INCLUDES# =========================================================================================================
; None

; #GLOBAL VARIABLES# =================================================================================================
; None

; #CURRENT# =====================================================================================================================
;_YWeater_Retrieval_WOEID
;_YWeater_Get_Weather
;_YWeater_Get_Forecast
;_YWeater_Get_Atmosphere
;_YWeater_Get_Astronomy
;_YWeater_Get_Wind
;_YWeater_Get_Coordinates
;_YWeater_Get_Location
; ===============================================================================================================================


; #INTERNAL_USE_ONLY# ===========================================================================================================
;__YWeater_Get_Source
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name ..........: _YWeater_Retrieval_WOEID
; Description ...: Retrieves details about the Location of a specific region
; Syntax ........: _YWeater_Retrieval_WOEID($s_City)
; Parameters ....: $s_City             - The town, state, country, address, zipcode or landmark of the location that you want retrive the WOEID
; Return values .: On Success - Returns a multidimensional array with all possible WOEID
;								$array[n][0] = District-County
;								$array[n][1] = Province-State
;								$array[n][2] = Country
;								$array[n][3] = WOEID
;				   On Failure - Returns "" and set @error.
;                                @error = 0 Empty parameter
;                                @error = 1 Unable to retrive the source
;                                @error = 2 Unable to get the results
; Author ........: Nessie
; Example .......: _YWeater_Retrieval_WOEID("york")
; ===============================================================================================================================

Func _YWeater_Retrieval_WOEID($s_City)
	Local $bRead, $sRead, $aReturn[10][4]

	If $s_City = "" Then SetError(0, 0, "")

	$bRead = InetRead('http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20geo.places%20where%20text%3D%22' & $s_City & '%22&format=xml', 1)
	If @error Then Return SetError(1, 0, "")

	$sRead = BinaryToString($bRead)
	If @error Then Return SetError(1, 0, "")

	Local $aCountry = StringRegExp($sRead, "(?s)<country.*?>(.*?)</country>", 3)
	If @error Then Return SetError(2, 0, "")

	Local $aState = StringRegExp($sRead, "(?s)<admin1.*?>(.*?)</admin1>", 3)
	If @error Then Return SetError(2, 0, "")

	Local $County = StringRegExp($sRead, "(?s)<admin2.*?>(.*?)</admin2>", 3)
	If @error Then Return SetError(2, 0, "")

	Local $aWOEID = StringRegExp($sRead, '(?s)/v1/place/(.*?)">', 3)
	If @error Then Return SetError(2, 0, "")

	ReDim $aReturn[UBound($aCountry)][4]

	For $i = 0 To UBound($aCountry) - 1
		$aReturn[$i][0] = $County[$i]
		$aReturn[$i][1] = $aState[$i]
		$aReturn[$i][2] = $aCountry[$i]
		$aReturn[$i][3] = $aWOEID[$i]
	Next

	Return $aReturn
EndFunc   ;==>_YWeater_Retrieval_WOEID

; #FUNCTION# ====================================================================================================================
; Name ..........: _YWeater_Get_Weather
; Description ...: Retrieves details about the Weather in a specific region
; Syntax ........: _YWeater_Get_Weather($i_WOEID[, $i_Units = 2])
; Parameters ....: $i_WOEID             - The location parameter needs to be a WOEID
;                  $i_Units             - [optional] The measurement system index: Default is 2
;
;				   $i_Units = 1         - Imperial system
;				   $i_Units = 2         - Metric system
; Return values .: On Success - Returns an array with all the Weather info
;								$array[0] = Weather Text (A textual description of the weather conditions, for example, "Partly Cloudy")
;								$array[1] = Weather Image Link (A link to display the weather condition, for example, : http://l.yimg.com/a/i/us/we/52/32.gif)
;								$array[2] = The current temperature (Temperature, in the units (C or F) based on chosen measurement system)
;								$array[3] = Date (The current date and time for which this forecast applies. The date is in RFC822 Section 5 format
;											, for example "Wed, 30 Nov 2005 1:56 pm PST")
;				   On Failure - Returns "" and set @error.
; Author ........: Nessie
; Example .......: _YWeater_Get_Weather("2459115")
; ===============================================================================================================================

Func _YWeater_Get_Weather($i_WOEID, $i_Units = 2)
	Local $aReturn[4]

	Local $sSource = __YWeater_Get_Source($i_WOEID, $i_Units)
	If @error Then Return SetError(@error, 0, "")

	Local $aRegex = StringRegExp($sSource, '<yweather:condition  text="(.*?)"  code="(.*?)"  temp="(.*?)"  date="(.*?)" />', 3)
	If @error Then Return SetError(3, 0, "")

	$aReturn[0] = $aRegex[0]
	$aReturn[1] = "http://l.yimg.com/a/i/us/we/52/" & $aRegex[1] & ".gif"
	$aReturn[2] = $aRegex[2]
	$aReturn[3] = $aRegex[3]

	Return $aReturn
EndFunc   ;==>_YWeater_Get_Weather


; #FUNCTION# ====================================================================================================================
; Name ..........: _YWeater_Get_Forecast
; Description ...: Retrieves details about the forecast for the next 2 days
; Syntax ........: _YWeater_Get_Forecast($i_WOEID[, $i_Units = 2])
; Parameters ....: $i_WOEID             - The location parameter needs to be a WOEID
;                  $i_Units             - [optional] The measurement system index: Default is 2
;
;				   $i_Units = 1         - Imperial system
;				   $i_Units = 2         - Metric system
; Return values .: On Success - Returns an multidimensional array with the forecast for the next 2 days
;								$array[0][0] = Day (day of the week to which this forecast applies. Possible values are Mon Tue Wed Thu Fri Sat Sun)
;								$array[0][1] = Date (the date to which this forecast applies. The date is in "dd Mmm yyyy" format, for example "30 Nov 2005")
;								$array[0][2] = Low Temperature (the forecasted low temperature for this day, in the units specified by the yweather:units element)
;								$array[0][3] = High Temperature (the forecasted high temperature for this day, in the units specified by the yweather:units element)
;								$array[0][4] = Text Description (a textual description of conditions, for example, "Partly Cloudy")
;								$array[0][5] = Condition Image Link (A link to display the weather condition, for example, : http://l.yimg.com/a/i/us/we/52/32.gif)
;								$array[1][0], $array[1][1]  and so on ;)
;				   On Failure - Returns "" and set @error.
; Author ........: Nessie
; Example .......: _YWeater_Get_Forecast("2459115")
; ===============================================================================================================================

Func _YWeater_Get_Forecast($i_WOEID, $i_Units = 2)
	Local $aReturn[2][6]

	Local $sSource = __YWeater_Get_Source($i_WOEID, $i_Units)
	If @error Then Return SetError(@error, 0, "")

	Local $aRegex = StringRegExp($sSource, '<yweather:forecast day="(.*?)" date="(.*?)" low="(.*?)" high="(.*?)" text="(.*?)" code="(.*?)" />', 3)
	If @error Then Return SetError(3, 0, "")

	$aReturn[0][0] = $aRegex[0]
	$aReturn[0][1] = $aRegex[1]
	$aReturn[0][2] = $aRegex[2]
	$aReturn[0][3] = $aRegex[3]
	$aReturn[0][4] = $aRegex[4]
	$aReturn[0][5] = "http://l.yimg.com/a/i/us/we/52/" & $aRegex[5] & ".gif"
	$aReturn[1][0] = $aRegex[6]
	$aReturn[1][1] = $aRegex[7]
	$aReturn[1][2] = $aRegex[8]
	$aReturn[1][3] = $aRegex[9]
	$aReturn[1][4] = $aRegex[10]
	$aReturn[1][5] = "http://l.yimg.com/a/i/us/we/52/" & $aRegex[11] & ".gif"

	Return $aReturn
EndFunc   ;==>_YWeater_Get_Forecast


; #FUNCTION# ====================================================================================================================
; Name ..........: _YWeater_Get_Atmosphere
; Description ...: Retrieves details about the atmosphere in a specific region
; Syntax ........: _YWeater_Get_Atmosphere($i_WOEID[, $i_Units = 2])
; Parameters ....: $i_WOEID             - The location parameter needs to be a WOEID
;                  $i_Units             - [optional] The measurement system index: Default is 2
;
;				   $i_Units = 1         - Imperial system
;				   $i_Units = 2         - Metric system
; Return values .: On Success - Returns an array with all the Atmosphere info
;								$array[0] = Humidity (integer)
;								$array[1] = Visibility (Visibility, in the units (mi or km) based on chosen measurement system)
;								$array[2] = Pressure (Pressure, in the units (in or mb) based on chosen measurement system)
;								$array[3] = Rising (Rising, state of the barometric pressure: steady (0), rising (1), or falling (2))
;				   On Failure - Returns "" and set @error.
; Author ........: Nessie
; Example .......: _YWeater_Get_Atmosphere("2459115")
; ===============================================================================================================================

Func _YWeater_Get_Atmosphere($i_WOEID, $i_Units = 2)
	Local $aReturn[4], $sRising
	Local $sSource = __YWeater_Get_Source($i_WOEID, $i_Units)
	If @error Then Return SetError(@error, 0, "")

	Local $aRegex = StringRegExp($sSource, '<yweather:atmosphere humidity="(.*?)"  visibility="(.*?)"  pressure="(.*?)"  rising="(.*?)" />', 3)
	If @error Then Return SetError(3, 0, "")

	Switch $aRegex[3]
		Case 0
			$sRising = "Steady"
		Case 1
			$sRising = "Rising"
		Case 2
			$sRising = "Falling"
	EndSwitch

	$aReturn[0] = $aRegex[0]
	$aReturn[1] = $aRegex[1]
	$aReturn[2] = $aRegex[2]
	$aReturn[3] = $sRising

	Return $aReturn
EndFunc   ;==>_YWeater_Get_Atmosphere


; #FUNCTION# ====================================================================================================================
; Name ..........: _YWeater_Get_Astronomy
; Description ...: Retrieves details about the astronomy in a specific region
; Syntax ........: _YWeater_Get_Astronomy($i_WOEID)
; Parameters ....: $i_WOEID             - The location parameter needs to be a WOEID
; Return values .: On Success - Returns an array with all the Astronomy info
;								$array[0] = Today's sunrise time (The time is a string in a local time format of "h:mm am/pm", for example "7:02 am")
;								$array[1] = Today's sunset time (The time is a string in a local time format of "h:mm am/pm", for example "7:02 am")
;				   On Failure - Returns "" and set @error.
; Author ........: Nessie
; Example .......: _YWeater_Get_Astronomy("2459115")
; ===============================================================================================================================

Func _YWeater_Get_Astronomy($i_WOEID)
	Local $sSource = __YWeater_Get_Source($i_WOEID)
	If @error Then Return SetError(@error, 0, "")

	Local $aReturn = StringRegExp($sSource, '<yweather:astronomy sunrise="(.*?)"   sunset="(.*?)"/>', 3)
	If @error Then Return SetError(3, 0, "")

	Return $aReturn
EndFunc   ;==>_YWeater_Get_Astronomy


; #FUNCTION# ====================================================================================================================
; Name ..........: _YWeater_Get_Wind
; Description ...: Retrieves details about the wind in a specific region
; Syntax ........: _YWeater_Get_Wind($i_WOEID[, $i_Units = 2])
; Parameters ....: $i_WOEID             - The location parameter needs to be a WOEID
;                  $i_Units             - [optional] The measurement system index: Default is 2
;
;				   $i_Units = 1         - Imperial system
;				   $i_Units = 2         - Metric system
; Return values .: On Success - Returns an array with all the Wind info
;								$array[0] = Wind Chill (degrees)
;								$array[1] = Direction (degrees)
;								$array[2] = Speed (wind speed, in the units (mph or kph) based on chosen measurement system)
;				   On Failure - Returns "" and set @error.
; Author ........: Nessie
; Example .......: _YWeater_Get_Wind("2459115")
; ===============================================================================================================================

Func _YWeater_Get_Wind($i_WOEID, $i_Units = 2)
	Local $sSource = __YWeater_Get_Source($i_WOEID, $i_Units)
	If @error Then Return SetError(@error, 0, "")

	Local $aReturn = StringRegExp($sSource, '<yweather:wind chill="(.*?)"   direction="(.*?)"   speed="(.*?)" />', 3)
	If @error Then Return SetError(3, 0, "")

	Return $aReturn
EndFunc   ;==>_YWeater_Get_Wind


; #FUNCTION# ====================================================================================================================
; Name ..........: _YWeater_Get_Coordinates
; Description ...: Retrieves details about the coordinates of a specific region
; Syntax ........: _YWeater_Get_Coordinates($i_WOEID)
; Parameters ....: $i_WOEID             - The location parameter needs to be a WOEID
; Return values .: On Success - Returns an array with latitude and longitude of a specific region
;								$array[0] = The latitude of the location.
;								$array[1] = The longitude of the location.
;				   On Failure - Returns "" and set @error.
; Author ........: Nessie
; Example .......: _YWeater_Get_Coordinates("2459115")
; ===============================================================================================================================

Func _YWeater_Get_Coordinates($i_WOEID)
	Local $aReturn[2], $aRegex

	Local $sSource = __YWeater_Get_Source($i_WOEID)
	If @error Then Return SetError(@error, 0, "")

	$aRegex = StringRegExp($sSource, '<geo:lat>(.*?)</geo:lat>', 3)
	If @error Then Return SetError(3, 0, "")
	$aReturn[0] = $aRegex[0]

	$aRegex = StringRegExp($sSource, '<geo:long>(.*?)</geo:long>', 3)
	If @error Then Return SetError(3, 0, "")
	$aReturn[1] = $aRegex[0]

	Return $aReturn
EndFunc   ;==>_YWeater_Get_Coordinates


; #FUNCTION# ====================================================================================================================
; Name ..........: _YWeater_Get_Location
; Description ...: Retrieves details about the Location of a specific region
; Syntax ........: _YWeater_Get_Location($i_WOEID)
; Parameters ....: $i_WOEID             - The location parameter needs to be a WOEID
; Return values .: On Success - Returns an array with latitude and longitude of a specific region
;								$array[0] = City name
;								$array[1] = Region (state, territory, or region, if given)
;								$array[2] = Country
;				   On Failure - Returns "" and set @error.
; Author ........: Nessie
; Example .......: _YWeater_Get_Location("2459115")
; ===============================================================================================================================

Func _YWeater_Get_Location($i_WOEID)

	Local $sSource = __YWeater_Get_Source($i_WOEID)
	If @error Then Return SetError(@error, 0, "")

	Local $aReturn = StringRegExp($sSource, '<yweather:location city="(.*?)" region="(.*?)"   country="(.*?)"/>', 3)
	If @error Then Return SetError(3, 0, "")

	Return $aReturn
EndFunc   ;==>_YWeater_Get_Location


; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __YWeater_Get_Source
; Description ...: Return the source from Yahoo API
; Author ........: Nessie
; ===============================================================================================================================

Func __YWeater_Get_Source($i_WOEID, $i_Units = 2)
	Local $s_Unit
	If $i_Units = 1 Then
		$s_Unit = "f"
	Else
		$s_Unit = "c"
	EndIf

	Local $bRead = InetRead("http://weather.yahooapis.com/forecastrss?w=" & $i_WOEID & "&u=" & $s_Unit, 1)
	If @error Then Return SetError(1, 0, "")
	Local $sRead = BinaryToString($bRead)
	If @error Then Return SetError(1, 0, "")

	If StringInStr($sRead, "City not found") Then Return SetError(2, 0, "")

	Return $sRead
EndFunc   ;==>__YWeater_Get_Source