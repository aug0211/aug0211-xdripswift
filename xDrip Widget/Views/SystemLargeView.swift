//
//  SystemLargeView.swift
//  xDrip Widget Extension
//
//  Created by Paul Plant on 4/3/24.
//  Copyright © 2024 Johan Degraeve. All rights reserved.
//

import Foundation
import SwiftUI

extension XDripWidget.EntryView {
    var systemLargeView: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Image(systemName: "drop.fill")
                    .renderingMode(.template)
                    .foregroundStyle(entry.widgetState.bgTextColor())
                    .font(.title)
                    .minimumScaleFactor(0.5)
                Text("\(entry.widgetState.bgValueStringInUserChosenUnit)")
                    .font(.largeTitle).fontWeight(.bold)
                    .foregroundStyle(entry.widgetState.bgTextColor())
                    .scaledToFill()
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .baselineOffset(3)
                
                Spacer()
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(entry.widgetState.trendArrow())
                        .font(.title).fontWeight(.semibold)
                        .foregroundStyle(entry.widgetState.bgTextColor())
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Text(entry.widgetState.deltaChangeStringInUserChosenUnit())
                        .font(.title).fontWeight(.semibold)
                        .foregroundStyle(entry.widgetState.bgTextColor())
                        .lineLimit(1)
                        .baselineOffset(3)
                        .minimumScaleFactor(0.5)
                    /*
                    Text(entry.widgetState.bgUnitString)
                        .font(.title)
                        .foregroundStyle(entry.widgetState.bgTextColor())
                        .lineLimit(1)
                    */
                }
            }
            .padding(.bottom, 6)
            
            GlucoseChartView(glucoseChartType: .widgetSystemLarge, bgReadingValues: entry.widgetState.bgReadingValues, bgReadingDates: entry.widgetState.bgReadingDates, isMgDl: entry.widgetState.isMgDl, urgentLowLimitInMgDl: entry.widgetState.urgentLowLimitInMgDl, lowLimitInMgDl: entry.widgetState.lowLimitInMgDl, highLimitInMgDl: entry.widgetState.highLimitInMgDl, urgentHighLimitInMgDl: entry.widgetState.urgentHighLimitInMgDl, liveActivitySize: nil, hoursToShowScalingHours: nil, glucoseCircleDiameterScalingHours: nil, overrideChartHeight: nil, overrideChartWidth: nil)
            
            HStack(alignment: .center) {
                if let keepAliveImageString = entry.widgetState.keepAliveImageString {
                    Image(systemName: keepAliveImageString)
                        .font(.caption)
                        .foregroundStyle(.colorTertiary)
                        .padding(.trailing, -4)
                }
                
                Text(entry.widgetState.dataSourceDescription)
                    .font(.caption).bold()
                    .foregroundStyle(.colorSecondary)
                
                Spacer()
                
                Text("Last reading at \(entry.widgetState.bgReadingDate?.formatted(date: .omitted, time: .shortened) ?? "--:--")")
                    .font(.caption)
                    .foregroundStyle(.colorTertiary)
            }
            .padding(.top, 10)
        }
        .widgetBackground(backgroundView: Color.black)
    }
}
