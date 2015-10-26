## WeatherLazy for iOS

Thanks for your interest! WeatherLazy is in Beta!

If you'd like to test it out yourself (and don't want to build our code), send an email to johnblanier@gmail.com and I can send you an Apple Testflight invitation to download the beta release!

## Who We Are

WeatherLazy Team consists of UC Santa Barbara Students [John B. Lanier](http://www.jblanier.xyz), and [Arthur Pan](https://www.linkedin.com/in/arthurpan).

We spent late September and early October researching iOS and have been working on WeatherLazy between schoolwork since then.

## What it Does

WeatherLazy uses the Dark Sky Forecast API to grab json weather data in the background and schedule iOS notifications containing daily forecasts according to the user's settings. Users can specify to never recieve notifications, recieve them evey day at a chosen time, or at that time but only on days with at least a specific, chosen percent chance of rain.

WeatherLazy is geared towards people who don't have (or don't want to have) a habit of checking the weather. With WeatherLazy, people can be informed when the rain might mess up their schedules without checking the weather themselves.

Currently, WeatherLazy uses the iOS background fetch feature to keep itself updated. Even though WeatherLazy schedules (or reschedules) notifications up to a week in advance for redundancy, we've learned that background fetch is not a reliable way have our app work without being open for long periods of time. Consequentially, we are now learning how to implement push-notifcation services to keep the app sliently and reliably updating in the background.

Check back in a few weeks to our new push-notification powered version of WeatherLazy!

## Important Note!

If you plan on building the app from GitHub, keep in mind that the  "key" method in LWDataFetcher.m returns an oudated/stub API key. To get a working key for yourself, sign up for one (for free) from Dark Sky Forecast at https://developer.forecast.io/

If you build without providing a working key, the app will crash!
