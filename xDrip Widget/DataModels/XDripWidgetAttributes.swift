//
//  XDripWidgetAttributes.swift
//  xDripWidgetExtension
//
//  Created by Paul Plant on 30/12/23.
//  Copyright © 2023 Johan Degraeve. All rights reserved.
//

import Foundation
import ActivityKit
import WidgetKit
import SwiftUI

struct XDripWidgetAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {

        // Store values with a 16 bit precision to save payload bytes
        private var bgReadingFloats: [Float16]
        // Expose those conveniently as Doubles
        var bgReadingValues: [Double] {
            bgReadingFloats.map(Double.init)
        }

        // To save those precious payload bytes, store only the earliest date as Date
        private var firstDate: Date
        // ...and all other as seconds from that moment.
        // No need for floating points, a second is precise enough for the graph
        // UInt16 maximum value is 65535 so that means 18.2 hours.
        // This would need to be changed if wishing to present a 24 hour chart.
        private var secondsSinceFirstDate: [UInt16]
        // Expose the dates conveniently
        var bgReadingDates: [Date] {
            secondsSinceFirstDate.map { Date(timeInterval: Double($0), since: firstDate) }
        }
        
        // For some reason, ActivityAttributes can't see the main target Assets folder
        // so we'll just duplicate the colors here for now
        // We have to store just the float value instead of the whole Color object to
        // keep the struct conforming to Codable
        private var colorPrimaryWhiteValue: Double = 0.9
        private var colorSecondaryWhiteValue: Double = 0.65
        private var colorTertiaryWhiteValue: Double = 0.45

        var isMgDl: Bool
        var slopeOrdinal: Int
        var deltaChangeInMgDl: Double?
        var urgentLowLimitInMgDl: Double
        var lowLimitInMgDl: Double
        var highLimitInMgDl: Double
        var urgentHighLimitInMgDl: Double
        var eventStartDate: Date = Date()
        var warnUserToOpenApp: Bool = true
        var liveActivitySize: LiveActivitySize
        var dataSourceDescription: String

        var bgUnitString: String {
            isMgDl ? Texts_Common.mgdl : Texts_Common.mmol
        }
        /// the latest bg reading
        var bgValueInMgDl: Double? {
            bgReadingValues[0]
        }
        /// the latest bg reading date
        var bgReadingDate: Date? {
            bgReadingDates[0]
        }

        var bgValueStringInUserChosenUnit: String {
            if let bgReadingDate = bgReadingDate, bgReadingDate > Date().addingTimeInterval(-ConstantsWidgetExtension.bgReadingDateVeryStaleInMinutes) {
                bgReadingValues[0].mgdlToMmolAndToString(mgdl: isMgDl)
            } else {
                isMgDl ? "---" : "-.-"
            }
        }

        init(bgReadingValues: [Double], bgReadingDates: [Date], isMgDl: Bool, slopeOrdinal: Int, deltaChangeInMgDl: Double?, urgentLowLimitInMgDl: Double, lowLimitInMgDl: Double, highLimitInMgDl: Double, urgentHighLimitInMgDl: Double, liveActivitySize: LiveActivitySize, dataSourceDescription: String? = "") {
        
            self.bgReadingFloats = bgReadingValues.map(Float16.init)

            let firstDate = bgReadingDates.last ?? .now
            self.firstDate = firstDate
            self.secondsSinceFirstDate = bgReadingDates.map { UInt16(truncatingIfNeeded: Int($0.timeIntervalSince(firstDate))) }
            
            self.isMgDl = isMgDl
            self.slopeOrdinal = slopeOrdinal
            self.deltaChangeInMgDl = deltaChangeInMgDl
            self.urgentLowLimitInMgDl = urgentLowLimitInMgDl
            self.lowLimitInMgDl = lowLimitInMgDl
            self.highLimitInMgDl = highLimitInMgDl
            self.urgentHighLimitInMgDl = urgentHighLimitInMgDl            
            self.liveActivitySize = liveActivitySize
            self.dataSourceDescription = dataSourceDescription ?? ""
        }
        
        /// Blood glucose color dependant on the user defined limit values and based upon the time since the last reading
        /// - Returns: a Color object either red, yellow or green
        func bgTextColor() -> Color {
            if let bgReadingDate = bgReadingDate, let bgValueInMgDl = bgValueInMgDl {
                if bgReadingDate > Date().addingTimeInterval(-ConstantsWidgetExtension.bgReadingDateStaleInMinutes) {
                    return dynamicColorForValue(Int(bgValueInMgDl))
                } else {
                    return Color(white: colorTertiaryWhiteValue)
                }
            } else {
                return Color(white: colorTertiaryWhiteValue)
            }
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
        
        /// Delta text color dependant on the time since the last reading
        /// - Returns: a Color either white(ish) or gray
        func deltaChangeTextColor() -> Color {
            if let bgReadingDate = bgReadingDate, bgReadingDate > Date().addingTimeInterval(-ConstantsWidgetExtension.bgReadingDateStaleInMinutes) {
                return Color(white: colorPrimaryWhiteValue)
            } else {
                return Color(white: colorTertiaryWhiteValue)
            }
        }
        
        /// convert the optional delta change int (in mg/dL) to a formatted change value in the user chosen unit making sure all zero values are shown as a positive change to follow Nightscout convention
        /// - Returns: a string holding the formatted delta change value (i.e. +0.4 or -6)
        func deltaChangeStringInUserChosenUnit() -> String {
            if let deltaChangeInMgDl = deltaChangeInMgDl, let bgReadingDate = bgReadingDate, bgReadingDate > Date().addingTimeInterval(-ConstantsWidgetExtension.bgReadingDateVeryStaleInMinutes) {
                let deltaSign: String = deltaChangeInMgDl > 0 ? "+" : ""
                let valueAsString = deltaChangeInMgDl.mgdlToMmolAndToString(mgdl: isMgDl)
                
                // quickly check "value" and prevent "-0mg/dl" or "-0.0mmol/l" being displayed
                // show unitized zero deltas as +0 or +0.0 as per Nightscout format
                if (isMgDl) {
                    return (deltaChangeInMgDl == 0) ?  "+0" : (deltaSign + valueAsString)
                } else {
                    return (deltaChangeInMgDl == 0.0) ? "+0.0" : (deltaSign + valueAsString)
                }
            } else {
                return isMgDl ? "-" : "-.-"
            }
        }
        
        ///  returns a string holding the trend arrow
        /// - Returns: trend arrow string (i.e.  "↑")
        func trendArrow() -> String {
            if let bgReadingDate = bgReadingDate, bgReadingDate > Date().addingTimeInterval(-ConstantsWidgetExtension.bgReadingDateVeryStaleInMinutes) {
                switch slopeOrdinal {
                case 7:
                    return "\u{2193}" // ↓ Auggie - text space \u{2193}" // ↓↓
                case 6:
                    return "\u{2193}" // ↓
                case 5:
                    return "\u{2198}" // ↘
                case 4:
                    return "\u{2192}" // →
                case 3:
                    return "\u{2197}" // ↗
                case 2:
                    return "\u{2191}" // ↑
                case 1:
                    return "\u{2191}\u{2191}" // ↑↑
                default:
                    return ""
                }
            } else {
                return ""
            }
        }
    }
}
