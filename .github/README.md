# \[Conky\] Essentials

Essentials is a widget made for [Conky](https://github.com/brndnmtthws/conky) on Linux.  
The goal was to create a simple and functional design that brings together all the essential information about your system.

It comes in 3 variants:

- **no_weather:** date/time, CPU (temperature, usage, top 3 process, usage graph), RAM (free, used, top 3 process, usage graph), NET (upload/download for the current session, current speed, usage graph)
- **weather_simple:** same as *no_weather* plus current weather conditions
- **weather_details:** same as *weather_simple* plus next 4 hours and next 2 days forecasts

<br>

<p align="center">
    <img src="screenshots/no_weather.png" alt="No weather" />
    &emsp;
    <img src="screenshots/weather_simple.png" alt="Weather simple" />
    &emsp;
    <img src="screenshots/weather_details.png" alt="Weather details" />
</p>

<br>

## Installation

You obviously need to install **Conky** first.  
If you want to display the weather forecast, **lua** and **lua-sec** are required.

Download the widget files to **/home/username/.config/conky/Essentials/**

Make the **start.sh** and **stop.sh** scripts executable:
> `chmod u+x /home/username/.config/conky/Essentials/scripts/start.sh`  
> `chmod u+x /home/username/.config/conky/Essentials/scripts/stop.sh`

<br>

## Configuration

Inside the *Essentials* directory, you can find one *.conf* file for each widget variants.

Open the one you want to use with a text editor and change the following lines:

- **temperature_unit = 'celsius':** Change to *Fahrenheit* if necessary
- **${time *format*}:** Change the [format](https://conky.cc/variables#time) to suit your locale
- **${hwmon *module_name* temp *temp_number*}:** Change *module_name* and *temp_number* to display your CPU temperature

> In a terminal, execute `ls /sys/class/hwmon/` to find your modules.  
> Each *hwmon* subdirectories should have a *name* and several *temp_label*.  
> For example, I'm using *${hwmon asusec temp 2}* because:  
> `cat /sys/class/hwmon/hwmon4/name` returns *asusec*  
> `cat /sys/class/hwmon/hwmon4/temp2_label` returns *CPU*

- Find and replace **interface_name** with the name of your network card

> In a terminal, execute `ip addr` to find it. For example: *enp5s0* or *wlan0*

<br>

## Weather

**The weather forecast is provided by the [Visual Crossing API](https://www.visualcrossing.com/weather-api/)**

First, install the [Weather Icons font](https://erikflowers.github.io/weather-icons/) from the *erikflowers* GitHub repository or the */weather/fonts/* directory.

And make the **Simple.lua** and/or **Details.lua** executable, depending on the one you want to use:
> `chmod u+x /home/username/.config/conky/Essentials/weather/VisualCrossing/Simple.lua`  
> `chmod u+x /home/username/.config/conky/Essentials/weather/VisualCrossing/Details.lua`

Next, go to the [Visual Crossing](https://www.visualcrossing.com/) website and create a free account to get your **API key**.

Finally, open */weather/VisualCrossing/var/settings.lua* with a text editor and change:

- **apiKey**
- **latitude**
- **longitude**
- **lang**
- **units**
- **temperatures:** In *Celsius* by default
- **speedUnit**
- **hourFormat**
- **days:** Translate to your language

The *settings.lua* file contains the necessary explanations.

<br>

## Usage

You can start the widget manually from a terminal:

- **no_weather:** `/home/username/.config/conky/Essentials/scripts/start.sh`
- **weather_simple:** `/home/username/.config/conky/Essentials/scripts/start.sh weather_simple`
- **weather_details:** `/home/username/.config/conky/Essentials/scripts/start.sh weather_details`

Or automatically after login with an auto-start entry according to your desktop environment.

<br>

## Troubleshooting

If you are using a custom font size or display scaling, you may have to play with *offset* and *aling* values inside the `conky.text = [[ ... ]]` section of the *.conf* files and/or change the *scaling_factor* inside **background/settings.lua**.

If you are using Wayland, these settings appear to be the most compatible:

    -- Wayland
        out_to_x = false,
        out_to_wayland = true,

    -- Window --
        own_window_type = 'override',

If you are using X11, try these settings:

    -- Wayland
        --out_to_x = false,
        --out_to_wayland = true,

    -- Window --
        own_window_type = 'desktop',

If you are using an older version of Conky, try uncommenting these lines:

    -- Window --
        own_window_transparent = true,
        own_window_argb_visual = true,

More information on [Conky website](https://conky.cc/config_settings).

<br>

## Credits and Third-Party Licenses

**Widget:** Licensed under GNU GPLv3 by HellPC

**json.lua:** Licensed under MIT by [rxi](https://github.com/rxi/json.lua)

**Weather Icons font:** By [Erik Flower](https://erikflowers.github.io/weather-icons/)
- Font: [SIL OFL 1.1](http://scripts.sil.org/OFL)
- Code: [MIT License](http://opensource.org/licenses/mit-license.html)
- Documentation: [CC BY 3.0](http://creativecommons.org/licenses/by/3.0/)

**Weather data provider:** [Visual Crossing](https://www.visualcrossing.com/)
