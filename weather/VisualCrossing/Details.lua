#!/usr/bin/env lua

json = require("weather.VisualCrossing.lib.Json")
local Helpers = require("weather.VisualCrossing.lib.Helpers")
local Cache = require("weather.VisualCrossing.lib.Cache")
local Shared = require("weather.VisualCrossing.lib.Shared")
local settings = require("weather.VisualCrossing.var.settings")

local cacheFile = os.getenv("HOME")..("/.config/conky/Essentials/weather/VisualCrossing/cache/details.json")

-- Weather

local Weather = {}

function Weather.GetHours(num, step, days, moonIcon)
	local hour = tonumber(os.date("%H")) + step + 1
	local day = 1
	local data = {}

	for count = 1,num,1 do
		if hour >= 24 then
			hour = hour - 23
			day = day + 1
		end

		data[count] = {
			temp = Helpers.Round(days[day].hours[hour].temp),
			tempColor = Helpers.TempColor(days[day].hours[hour].temp, settings.weather.temperatures, settings.weather.colors),
			icon = Helpers.WeatherIcon(days[day].hours[hour].icon, moonIcon)
		}

		hour = hour + step
	end

	return data
end

function Weather.GetDays(num, days)
	local day = 2
	local data = {}

	for count = 1,num,1 do
		data[count] = {
			name = Helpers.DayName(days[day].datetimeEpoch, settings.locale.days),
			icon = Helpers.WeatherIcon(days[day].icon, nil),
			tempMin = Helpers.Round(days[day].tempmin),
			tempMinColor = Helpers.TempColor(days[day].tempmin, settings.weather.temperatures, settings.weather.colors),
			tempMax = Helpers.Round(days[day].tempmax),
			tempMaxColor = Helpers.TempColor(days[day].tempmax, settings.weather.temperatures, settings.weather.colors),
			precipProb = Helpers.Round(days[day].precipprob)
		}

		day = day + 1
	end

	return data
end

function Weather.Format(weatherRaw)
	local moonIcon = Helpers.MoonIcon(weatherRaw.currentConditions.moonphase)
	local riseInfo = Helpers.RiseInfo(weatherRaw.currentConditions.sunriseEpoch, weatherRaw.currentConditions.sunsetEpoch, moonIcon, settings.locale.hourFormat)

	return {
		dateCreation = os.time(),
		dateUpdated = weatherRaw.currentConditions.datetimeEpoch,
		now = {
			temp = weatherRaw.currentConditions.temp,
			tempColor = Helpers.TempColor(weatherRaw.currentConditions.temp, settings.weather.temperatures, settings.weather.colors),
			precipProb = Helpers.Round(weatherRaw.currentConditions.precipprob),
			riseHour = riseInfo.hour,
			riseIcon = riseInfo.icon,
			windSpeed = Helpers.Round(weatherRaw.currentConditions.windgust),
			windIcon = Helpers.WindIcon(weatherRaw.currentConditions.winddir),
			icon = Helpers.WeatherIcon(weatherRaw.currentConditions.icon, moonIcon)
		},
		hours = Weather.GetHours(4, 1, weatherRaw.days, moonIcon),
		days = Weather.GetDays(2, weatherRaw.days)
	}
end

function Weather.Get()
	local weather = Cache.Read(cacheFile)

	if weather == nil or Cache.isObsolete(weather.dateCreation, settings.weather.updateRate) then
		local weatherRaw = Shared.Download(settings.weather)
		if weatherRaw ~= nil then
			weatherRaw = json.decode(weatherRaw)
			if weather == nil or Shared.isNew(weatherRaw.currentConditions.datetimeEpoch, weather.dateUpdated) then
				weather = Weather.Format(weatherRaw)
				Cache.Write(cacheFile, weather)
			end
		end
	end

	return weather
end


-- Conky

local weather = Weather.Get()
conky_text = [[
${offset 8}${voffset 12}${font2}${color %s}%s°${alignr 10}${font4}${color1}%s%%${alignr 8}${voffset -5}${font7}
${alignc}${voffset -14}${font5}${color}%s
${offset 8}${voffset -58}${font7}${color1}%s${alignr 9}${font7}%s
${offset 8}${voffset -5}${font4}%s${alignr 8}%s %s
${offset 12}${voffset 22}${color %s}%s°${goto 52}${color %s}%s°${goto 87}${color %s}%s°${goto 122}${color %s}%s°
${offset 10}${font7}${color}%s${goto 50}%s${goto 85}%s${goto 120}%s
${offset 15}${voffset 5}${font}%s${alignr 15}%s
${offset 15}${font6}%s${alignr 15}%s
${offset 15}${voffset -14}${font}${color %s}%s°  ${color %s}%s°${alignr 15}${color %s}%s°  ${color %s}%s°
${offset 18}${voffset -1}${color1}${font7} ${voffset -2}${font4}%s%%${alignr 18}%s%% ${voffset -5}${font7}
]]
io.write((conky_text):format(
	weather.now.tempColor,
	weather.now.temp,
	weather.now.precipProb,
	weather.now.icon,
	weather.now.riseIcon,
	weather.now.windIcon,
	weather.now.riseHour,
	weather.now.windSpeed,
	settings.locale.speedUnit,
	weather.hours[1].tempColor,
	weather.hours[1].temp,
	weather.hours[2].tempColor,
	weather.hours[2].temp,
	weather.hours[3].tempColor,
	weather.hours[3].temp,
	weather.hours[4].tempColor,
	weather.hours[4].temp,
	weather.hours[1].icon,
	weather.hours[2].icon,
	weather.hours[3].icon,
	weather.hours[4].icon,
	weather.days[1].name,
	weather.days[2].name,
	weather.days[1].icon,
	weather.days[2].icon,
	weather.days[1].tempMinColor,
	weather.days[1].tempMin,
	weather.days[1].tempMaxColor,
	weather.days[1].tempMax,
	weather.days[2].tempMinColor,
	weather.days[2].tempMin,
	weather.days[2].tempMaxColor,
	weather.days[2].tempMax,
	weather.days[1].precipProb,
	weather.days[2].precipProb
))
