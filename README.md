## WeatherLazy for iOS

Available now!

[![](Images/Download_on_the_App_Store_Badge_US-UK_135x40%207.48.35%20PM.png?raw=true "")](http://itunes.com/apps/weatherlazy)

## Who We Are

WeatherLazy Team consists of UC Santa Barbara Students [John B. Lanier](http://www.jblanier.xyz), and [Arthur Pan](https://www.linkedin.com/in/arthurpan).

We spent late September and early October researching iOS and the rest of October working on LazyWeather.

## What it Does

WeatherLazy uses the Dark Sky Forecast API to grab json weather data in the background and schedule iOS notifications containing daily forecasts according to the user's settings. Users can specify to never recieve notifications, recieve them evey day at a chosen time, or at that time but only on days with at least a specific, chosen percent chance of rain.

WeatherLazy is geared towards people who don't have (or don't want to have) a habit of checking the weather. With WeatherLazy, people can be informed when the rain might mess up their schedules without checking the weather themselves.

WeatherLazy uses the iOS background fetch feature to keep itself updated. Currently, WeatherLazy always keeps notifications scheduled for seven days in advance for redundancy (unless you change the in-app settings to never notify you).

## Important Note!

If you plan on building the app from GitHub, keep in mind that the  "key" method in LWDataFetcher.m returns an oudated/stub API key. To get a working key for yourself, sign up for one (for free) from Dark Sky Forecast at https://developer.forecast.io/

If you build without providing a working key, the app will crash!
