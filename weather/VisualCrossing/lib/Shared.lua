local VisualCrossing = {}

function VisualCrossing.Download(args)
	-- Requires lua-sec to be installed on your system
	local https = require("ssl.https")
	return https.request(("%s%s,%s/next5days?key=%s&unitGroup=%s&lang=%s&iconSet=icons2"):format(args.url, args.latitude, args.longitude, args.apiKey, args.units, args.lang))
end

function VisualCrossing.isNew(dateWeather, dateCache)
	return dateCache < dateWeather
end

return VisualCrossing
