//
//  WeatherLazyTheme.swift
//  WeatherLazy
//
//  Created by Arthur Pan on 10/5/16.
//  Copyright © 2016 LazyWeather Team. All rights reserved.
//

import Foundation

@objc public class WeatherLazyTheme: NSObject {
    // MARK: - Font Sizes
    @objc static let temperatureFontSize: CGFloat = 25
    
    // MARK: - Fonts
    @objc static let temperatureFont = UIFont.systemFont(ofSize: temperatureFontSize, weight: UIFont.Weight.light)
}
