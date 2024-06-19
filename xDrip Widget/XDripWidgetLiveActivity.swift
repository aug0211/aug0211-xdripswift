//
//  XDripWidgetLiveActivity.swift
//  XDripWidget
//
//  Created by Paul Plant on 29/12/23.
//  Copyright © 2023 Johan Degraeve. All rights reserved.
//

import ActivityKit
import WidgetKit
import SwiftUI

//Auggie - code for gradients based on BG number
func gradientForValue(_ value: Int) -> LinearGradient {
    
    //Auggie - define dynamic BG color
    // Auggie's dynamic color - Define the hue values for the key points
    let redHue: CGFloat = 0.0 / 360.0       // 0 degrees
    let greenHue: CGFloat = 120.0 / 360.0   // 120 degrees
    let purpleHue: CGFloat = 270.0 / 360.0  // 270 degrees
    
    var color: UIColor = UIColor.white // Default color
    
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

struct XDripWidgetLiveActivity: Widget {
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: XDripWidgetAttributes.self) { context in
            
            if context.state.liveActivitySize == .minimal {
                
                // 1 = minimal widget with no chart
                HStack(alignment: .center) {
                    Text("\(context.state.bgValueStringInUserChosenUnit) \(context.state.trendArrow())")
                        .font(.system(size: 35)).bold()
                        .foregroundStyle(context.state.bgTextColor())
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if context.state.warnUserToOpenApp {
                        Text("Open app...")
                            .font(.footnote).bold()
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.center)
                            .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                            .background(.cyan).opacity(0.9)
                            .cornerRadius(10)
                        
                        Spacer()
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(context.state.deltaChangeStringInUserChosenUnit())
                            .font(.title).fontWeight(.semibold)
                            .foregroundStyle(context.state.deltaChangeTextColor())
                            .minimumScaleFactor(0.2)
                            .lineLimit(1)
                        
                        Text(context.state.bgUnitString)
                            .font(.title)
                            .foregroundStyle(.colorTertiary)
                            .minimumScaleFactor(0.2)
                            .lineLimit(1)
                    }
                }
                .activityBackgroundTint(.black)
                .padding([.top, .bottom], 0)
                .padding([.leading, .trailing], 20)
                
            } else if context.state.liveActivitySize == .normal {
                
                // 0 = normal size chart
                HStack(spacing: 30) {
                    VStack(spacing: 0) {
                        Text("\(context.state.bgValueStringInUserChosenUnit)\(context.state.trendArrow())")
                            .font(.system(size: 44)).bold()
                            .foregroundStyle(context.state.bgTextColor())
                            .minimumScaleFactor(0.1)
                            .lineLimit(1)
                        
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text(context.state.deltaChangeStringInUserChosenUnit())
                                .font(.system(size: 20)).fontWeight(.semibold)
                                .foregroundStyle(context.state.deltaChangeTextColor())
                                .minimumScaleFactor(0.2)
                                .lineLimit(1)
                            
                            Text(context.state.bgUnitString)
                                .font(.system(size: 20))
                                .foregroundStyle(.colorTertiary)
                                .minimumScaleFactor(0.2)
                                .lineLimit(1)
                        }
                    }
                    
                    ZStack {
                        GlucoseChartView(glucoseChartType: .liveActivity, bgReadingValues: context.state.bgReadingValues, bgReadingDates: context.state.bgReadingDates, isMgDl: context.state.isMgDl, urgentLowLimitInMgDl: context.state.urgentLowLimitInMgDl, lowLimitInMgDl: context.state.lowLimitInMgDl, highLimitInMgDl: context.state.highLimitInMgDl, urgentHighLimitInMgDl: context.state.urgentHighLimitInMgDl, liveActivitySize: .normal, hoursToShowScalingHours: nil, glucoseCircleDiameterScalingHours: nil, overrideChartHeight: nil, overrideChartWidth: nil)
                        
                        if context.state.warnUserToOpenApp {
                            VStack(alignment: .center) {
                                Spacer()
                                Text("Open \(ConstantsHomeView.applicationName)")
                                    .font(.footnote).bold()
                                    .foregroundStyle(.black)
                                    .multilineTextAlignment(.center)
                                    .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                                    .background(.cyan).opacity(0.9)
                                    .cornerRadius(10)
                                Spacer()
                            }
                            .padding(8)
                        }
                    }
                }
                .activityBackgroundTint(.black)
                .padding(.top, 10)
                .padding(.bottom, 10)
                
            } else {
                
                // 3 = large chart is final default option
                ZStack {
                    
                    VStack(spacing: 0) {
                        HStack(alignment: .center) {
                            Text("\(context.state.bgValueStringInUserChosenUnit) \(context.state.trendArrow())")
                                .font(.system(size: 32)).fontWeight(.bold)
                                .foregroundStyle(context.state.bgTextColor())
                                .scaledToFill()
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text(context.state.deltaChangeStringInUserChosenUnit())
                                    .font(.system(size: 28)).fontWeight(.semibold)
                                    .foregroundStyle(context.state.deltaChangeTextColor())
                                    .lineLimit(1)
                                Text(context.state.bgUnitString)
                                    .font(.system(size: 28))
                                    .foregroundStyle(.colorTertiary)
                                    .lineLimit(1)
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 2)
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                        
                        GlucoseChartView(glucoseChartType: .liveActivity, bgReadingValues: context.state.bgReadingValues, bgReadingDates: context.state.bgReadingDates, isMgDl: context.state.isMgDl, urgentLowLimitInMgDl: context.state.urgentLowLimitInMgDl, lowLimitInMgDl: context.state.lowLimitInMgDl, highLimitInMgDl: context.state.highLimitInMgDl, urgentHighLimitInMgDl: context.state.urgentHighLimitInMgDl, liveActivitySize: .large, hoursToShowScalingHours: nil, glucoseCircleDiameterScalingHours: nil, overrideChartHeight: nil, overrideChartWidth: nil)
                        
                        HStack {
                            Text(context.state.dataSourceDescription)
                                .font(.caption).bold()
                                .foregroundStyle(.colorSecondary)
                            
                            Spacer()
                            
                            Text("Last reading at \(context.state.bgReadingDate?.formatted(date: .omitted, time: .shortened) ?? "--:--")")
                                .font(.caption)
                                .foregroundStyle(.colorTertiary)
                        }
                        .padding(.top, 6)
                        .padding(.bottom, 10)
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(0)
                    
                    if context.state.warnUserToOpenApp {
                        VStack(alignment: .center) {
                            Text("Please open \(ConstantsHomeView.applicationName)")
                                .font(.footnote).bold()
                                .foregroundStyle(.black)
                                .multilineTextAlignment(.center)
                                .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                                .background(.cyan).opacity(0.9)
                                .cornerRadius(10)
                        }
                    }
                }
                .activityBackgroundTint(.black)
            }
            
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {                    Text("\(context.state.bgValueStringInUserChosenUnit)\(context.state.trendArrow())")
                        .font(.largeTitle).bold()
                        .foregroundStyle(context.state.bgTextColor())
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(context.state.deltaChangeStringInUserChosenUnit())
                            .font(.title).fontWeight(.semibold)
                            .foregroundStyle(context.state.deltaChangeTextColor())
                            .minimumScaleFactor(0.2)
                            .lineLimit(1)
                        
                        Text(context.state.bgUnitString)
                            .font(.title)
                            .foregroundStyle(.colorSecondary)
                            .minimumScaleFactor(0.2)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    GlucoseChartView(glucoseChartType: .dynamicIsland, bgReadingValues: context.state.bgReadingValues, bgReadingDates: context.state.bgReadingDates, isMgDl: context.state.isMgDl, urgentLowLimitInMgDl: context.state.urgentLowLimitInMgDl, lowLimitInMgDl: context.state.lowLimitInMgDl, highLimitInMgDl: context.state.highLimitInMgDl, urgentHighLimitInMgDl: context.state.urgentHighLimitInMgDl, liveActivitySize: nil, hoursToShowScalingHours: nil, glucoseCircleDiameterScalingHours: nil, overrideChartHeight: nil, overrideChartWidth: nil)
                }
            } compactLeading: {
                Text("\(context.state.bgValueStringInUserChosenUnit)\(context.state.trendArrow())")
                    .foregroundStyle(context.state.bgTextColor())
                    .minimumScaleFactor(0.1)
            } compactTrailing: {
                Text(context.state.deltaChangeStringInUserChosenUnit())
                    .foregroundStyle(context.state.deltaChangeTextColor())
                    .minimumScaleFactor(0.1)
            } minimal: {
                Text("\(context.state.bgValueStringInUserChosenUnit)")
                    .foregroundStyle(context.state.bgTextColor())
                    .minimumScaleFactor(0.1)
            }
            .widgetURL(URL(string: "xdripswift"))
            .keylineTint(context.state.bgTextColor())
        }
    }
}

struct XDripWidgetLiveActivity_Previews: PreviewProvider {
    
    // generate some random dates for the preview
    static func bgDateArray() -> [Date] {
        let endDate = Date()
        let startDate = endDate.addingTimeInterval(-3600 * 12)
        var currentDate = startDate
        
        var dateArray: [Date] = []
        
        while currentDate < endDate {
            dateArray.append(currentDate)
            currentDate = currentDate.addingTimeInterval(60 * 5)
        }
        return dateArray
    }
    
    // generate some random bg values for the preview
    static func bgValueArray() -> [Double] {
        var bgValueArray:[Double] = Array(repeating: 0, count: 144)
        var currentValue: Double = 100
        var increaseValues: Bool = true
        
        for index in bgValueArray.indices {
            let randomValue = Double(Int.random(in: -10..<10))
            
            if currentValue < 80 {
                increaseValues = true
                bgValueArray[index] = currentValue + abs(randomValue)
            } else if currentValue > 160 {
                increaseValues = false
                bgValueArray[index] = currentValue - abs(randomValue)
            } else {
                bgValueArray[index] = currentValue + (increaseValues ? randomValue : -randomValue)
            }
            currentValue = bgValueArray[index]
        }
        return bgValueArray
    }
    
    static let attributes = XDripWidgetAttributes()
    
    static let contentState = XDripWidgetAttributes.ContentState(bgReadingValues: bgValueArray(), bgReadingDates: bgDateArray(), isMgDl: true, slopeOrdinal: 5, deltaChangeInMgDl: -2, urgentLowLimitInMgDl: 54, lowLimitInMgDl: 66, highLimitInMgDl: 166, urgentHighLimitInMgDl: 181, liveActivitySize: .large, dataSourceDescription: "Dexcom G7")
    
    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
    }
}

