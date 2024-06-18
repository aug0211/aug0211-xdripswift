//
//  xDripWatchApp.swift
//  xDrip Watch App
//
//  Created by Paul Plant on 11/2/24.
//  Copyright © 2024 Johan Degraeve. All rights reserved.
//

import SwiftUI

@main
struct xDrip_Watch_AppApp: App {
    @StateObject var watchState = WatchStateModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
            }.environmentObject(watchState)
        }
    }
}

//Auggie - code for gradients based on BG number
func gradientForValue(_ value: Int) -> LinearGradient {
    
    //Auggie - define dynamic BG color
    // Auggie's dynamic color - Define the hue values for the key points
    let redHue: CGFloat = 0.0 / 360.0       // 0 degrees
    let greenHue: CGFloat = 120.0 / 360.0   // 120 degrees
    let purpleHue: CGFloat = 270.0 / 360.0  // 270 degrees
    
    var color: UIColor = UIColor.white // Default color
    
    // Define the bgLevel thresholds
   /*
    let minLevel = Int(ConstantsBGGraphBuilder.defaultUrgentLowMarkInMgdl) // Use the urgent low BG value for red text
    let targetLevel = Int(ConstantsBGGraphBuilder.defaultTargetMarkInMgdl) // Use the target BG for green text
    let maxLevel = Int(ConstantsBGGraphBuilder.defaultUrgentHighMarkInMgdl) // Use the urgent high BG value for purple text
    print("Auggie: min/target/max: \(minLevel)/\(targetLevel)/\(maxLevel).")
    */
    
    // Define the bgLevel thresholds
    let minLevel = Int(Texts_SettingsView.labelUrgentLowValue) ?? 54 // Use the urgent low BG value for red text
    let targetLevel = Int(Texts_SettingsView.labelTargetValue) ?? 90 // Use the target BG for green text
    let maxLevel = Int(Texts_SettingsView.labelUrgentHighValue) ?? 181 // Use the urgent high BG value for purple text
    print("Auggie XDripWatchApp gradient: min/target/max: \(minLevel)/\(targetLevel)/\(maxLevel).")
    
    // Calculate the hue based on the bgLevel
    var hue: CGFloat
    if value <= minLevel {
        hue = redHue
    } else if value >= maxLevel {
        hue = purpleHue
    } else if value <= targetLevel {
        // Interpolate between red and green
        let ratio = CGFloat(value - minLevel) / CGFloat(targetLevel - minLevel)
        hue = redHue + ratio * (greenHue - redHue)
    } else {
        // Interpolate between green and purple
        let ratio = CGFloat(value - targetLevel) / CGFloat(maxLevel - targetLevel)
        hue = greenHue + ratio * (purpleHue - greenHue)
    }
    
    // Return the color with full saturation and brightness
    color = UIColor(hue: hue, saturation: 0.6, brightness: 0.9, alpha: 1.0)
    return LinearGradient(
        gradient: Gradient(colors: [Color(color), Color(color)]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    //Auggie - comment out gradient code, use dynamic BG color instead
    /*
    switch value {
    case ...54:
        return LinearGradient(
            gradient: Gradient(colors: [Color.red, Color.red]),
            startPoint: .top,
            endPoint: .bottom
        )
    case 55...64:
        return LinearGradient(
            gradient: Gradient(colors: [Color.red, Color.red]),
            startPoint: .top,
            endPoint: .bottom
        )
    case 65...79:
        return LinearGradient(
            gradient: Gradient(colors: [Color.green, Color.yellow]),
            startPoint: .top,
            endPoint: .bottom
        )
    case 80...100:
        return LinearGradient(
            gradient: Gradient(colors: [Color.green, Color.green]),
            startPoint: .top,
            endPoint: .bottom
        )
    case 101...119:
        return LinearGradient(
            gradient: Gradient(colors: [Color.green, Color.teal]),
            startPoint: .top,
            endPoint: .bottom
        )
    case 120...140:
        return LinearGradient(
            gradient: Gradient(colors: [Color.teal, Color.blue]),
            startPoint: .top,
            endPoint: .bottom
        )
    case 141...180:
        return LinearGradient(
            gradient: Gradient(colors: [Color.blue, Color.indigo]),
            startPoint: .top,
            endPoint: .bottom
        )
    default:
        return LinearGradient(
            gradient: Gradient(colors: [Color.indigo, Color.purple]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    */
}

//Auggie - code for color based on BG number
func dynamicColorForValue(_ value: Int) -> Color {
    
    //Auggie - define dynamic BG color
    // Auggie's dynamic color - Define the hue values for the key points
    let redHue: CGFloat = 0.0 / 360.0       // 0 degrees
    let greenHue: CGFloat = 120.0 / 360.0   // 120 degrees
    let purpleHue: CGFloat = 270.0 / 360.0  // 270 degrees
    
    var color: UIColor = UIColor.white // Default color
    
    // Define the bgLevel thresholds
   /*
    let minLevel = Int(ConstantsBGGraphBuilder.defaultUrgentLowMarkInMgdl) // Use the urgent low BG value for red text
    let targetLevel = Int(ConstantsBGGraphBuilder.defaultTargetMarkInMgdl) // Use the target BG for green text
    let maxLevel = Int(ConstantsBGGraphBuilder.defaultUrgentHighMarkInMgdl) // Use the urgent high BG value for purple text
    print("Auggie: min/target/max: \(minLevel)/\(targetLevel)/\(maxLevel).")
    */
    
    // Define the bgLevel thresholds
    let minLevel = Int(Texts_SettingsView.labelUrgentLowValue) ?? 54 // Use the urgent low BG value for red text
    let targetLevel = Int(Texts_SettingsView.labelTargetValue) ?? 90 // Use the target BG for green text
    let maxLevel = Int(Texts_SettingsView.labelUrgentHighValue) ?? 181 // Use the urgent high BG value for purple text
    //print("Auggie XDripWatchApp dynamicColorForValue: min/target/max: \(minLevel)/\(targetLevel)/\(maxLevel).")
    
    // Calculate the hue based on the bgLevel
    var hue: CGFloat
    if value <= minLevel {
        hue = redHue
    } else if value >= maxLevel {
        hue = purpleHue
    } else if value <= targetLevel {
        // Interpolate between red and green
        let ratio = CGFloat(value - minLevel) / CGFloat(targetLevel - minLevel)
        hue = redHue + ratio * (greenHue - redHue)
    } else {
        // Interpolate between green and purple
        let ratio = CGFloat(value - targetLevel) / CGFloat(maxLevel - targetLevel)
        hue = greenHue + ratio * (purpleHue - greenHue)
    }
    
    // Return the color with full saturation and brightness
    color = UIColor(hue: hue, saturation: 0.6, brightness: 0.9, alpha: 1.0)
    return Color(color)
}
