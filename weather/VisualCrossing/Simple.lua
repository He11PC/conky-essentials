#!/usr/bin/env lua

json = require("weather.VisualCrossing.lib.Json")
local Helpers = require("weather.VisualCrossing.lib.Helpers")
local Cache = require("weather.VisualCrossing.lib.Cache")
local Shared = require("weather.VisualCrossing.lib.Shared")
local settings = require("weather.VisualCrossing.var.settings")

local cacheFile = os.getenv("HOME")..("/.config/conky/Essentials/weather/VisualCrossing/cache/simple.json")

-- Weather

local Weather = {}

function Weather.Format(weatherRaw)
	local moonIcon = Helpers.MoonIcon(weatherRaw.currentConditions.moonphase)
	local riseInfo = Helpers.RiseInfo(weatherRaw.currentConditions.sunriseEpoch, weatherRaw.currentConditions.sunsetEpoch, moonIcon, settings.locale.hourFormat)

	return {
		dateCreation = os.time(),
		dateUpdated = weatherRaw.currentConditions.datetimeEpoch,
		temp = weatherRaw.currentConditions.temp,
		tempColor = Helpers.TempColor(weatherRaw.currentConditions.temp, settings.weather.temperatures, settings.weather.colors),
		precipProb = Helpers.Round(weatherRaw.currentConditions.precipprob),
		riseHour = riseInfo.hour,
		riseIcon = riseInfo.icon,
		windSpeed = Helpers.Round(weatherRaw.currentConditions.windgust),
		windIcon = Helpers.WindIcon(weatherRaw.currentConditions.winddir),
		icon = Helpers.WeatherIcon(weatherRaw.currentConditions.icon, moonIcon)
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
${offset 8}${voffset 12}${font2}${color %s}%s°${alignr 10}${font4}${color1}%s%%${alignr 8}${voffset -5}${font6}
${alignc}${voffset -14}${font5}${color}%s
${offset 8}${voffset -58}${font6}${color1}%s${alignr 9}${font6}%s
${offset 8}${voffset -5}${font4}%s${alignr 8}%s %s
]]
io.write((conky_text):format(
	weather.tempColor,
	weather.temp,
	weather.precipProb,
	weather.icon,
	weather.riseIcon,
	weather.windIcon,
	weather.riseHour,
	weather.windSpeed,
	settings.locale.speedUnit
))
