local icons = require("weather.VisualCrossing.var.icons")
local Helpers = {}

function Helpers.Round(num)
	if num == nil then
		return 0
	else
		return math.floor(tonumber(num+0.5))
	end
end

function Helpers.WeatherIcon(icon, moonIcon)
	if moonIcon ~= nil and icon == 'clear-night' then
		return moonIcon
	else
		return icons.weather[icon]
	end
end

function Helpers.MoonIcon(phase)
	local avgPhase = Helpers.Round(tonumber(phase)/(1/28))+1
	return icons.moon[avgPhase]
end

function Helpers.WindIcon(direction)
	local avgDirection = Helpers.Round(tonumber(direction)/45)+1
	return icons.wind[avgDirection]
end

function Helpers.RiseInfo(sunrise, sunset, moonIcon, hourFormat)
	local currentEpoch = os.time()
	if (currentEpoch > tonumber(sunrise) and currentEpoch < tonumber(sunset)) then
		return { hour = os.date(hourFormat, sunset), icon = moonIcon }
	else
		return { hour = os.date(hourFormat, sunrise), icon = "" }
	end
end

function Helpers.TempColor(temp, temps, colors)
	local color
	if temp <= temps.belowIsVeryLow then
		color = colors.veryLow
	elseif temp <= temps.belowIsLow then
		color = colors.low
	elseif temp <= temps.belowIsAverage then
		color = colors.average
	elseif temp <= temps.belowIsWarm then
		color = colors.warm
	else
		color = colors.veryWarm
	end

	return color
end

function Helpers.DayName(epoch, days)
	return days[os.date('%w', tonumber(epoch))+1]
end

return Helpers
