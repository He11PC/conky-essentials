--[[

VisualCrossing settings
https://www.visualcrossing.com/resources/documentation/weather-api/timeline-weather-api/

---

url = if it ain't broke, don't fix it

apiKey = create a free account to get your API Key (https://www.visualcrossing.com/sign-up) - 1000 records/day

latitude / longitude = use internet to find your coordinates (ex: Google maps)

lang = ar (Arabic), bg (Bulgiarian), cs (Czech), da (Danish), de (German), el (Greek Modern), en (English), es (Spanish) ), fa (Farsi), fi (Finnish), fr (French), he (Hebrew), hu, (Hungarian), it (Italian), ja (Japanese), ko (Korean), nl (Dutch), pl (Polish), pt (Portuguese), ru (Russian), sk (Slovakian), sr (Serbian), sv (Swedish), tr (Turkish), uk (Ukranian), vi (Vietnamese), zh (Chinese)

units = us, uk, metric, base (https://www.visualcrossing.com/resources/documentation/weather-api/unit-groups-and-measurement-units/)

updateRate = minimal time in seconds to wait between weather downloads (ex: 600 sec = 10 min)

temperatures = in celcius, convert to freedom units if necessary

colors = your taste

---

speedUnit = text to display after wind speed (ex: 15 Km/h)

hourFormat = how to display sunset/sunrise time (https://www.lua.org/pil/22.1.html)

days = translate to your language

--]]

local settings = {}

settings.weather = {
    url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/",
    apiKey = "MYSUPERSECRETAPIKEY",
    latitude = 43.978416,
    longitude = 15.383430,
    lang = "fr",
    units = "metric",
    updateRate = 600,
    temperatures = {
        belowIsVeryLow = 5,
        belowIsLow = 15,
        belowIsAverage = 25,
        belowIsWarm = 35
    },
    colors = {
        veryLow = "#1589FF",
        low = "#43C6DB",
        average = "#6CBB3C",
        warm = "#E9AB17",
        veryWarm = "#DC381F"
    }
}

settings.locale = {
    speedUnit = "km/h",
    hourFormat = "%H:%M",
    days = {"Dimanche","Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi"}
}

return settings
