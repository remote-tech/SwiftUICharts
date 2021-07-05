//
//  XAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import SwiftUI

/**
 Labels for the X axis.
 */
internal struct XAxisLabels<T>: ViewModifier where T: CTLineBarChartDataProtocol {
    
    @ObservedObject private var chartData: T
    
    @State private var offset = CGSize.zero
    @State private var totalOffset = CGSize.zero
    
    internal init(chartData: T) {
        self.chartData = chartData
        self.chartData.viewData.hasXAxisLabels = true
    }
    
    internal func body(content: Content) -> some View {
        Group {
            switch chartData.chartStyle.xAxisLabelPosition {
            case .bottom:
                if chartData.isGreaterThanTwo() {
                    VStack {
                        content
                        chartData.getXAxisLabels().padding(.top, 2)
                        chartData.getXAxisTitle()
                    }
                } else { content }
            case .top:
                if chartData.isGreaterThanTwo() {
                    VStack {
                        chartData.getXAxisTitle()
                        chartData.getXAxisLabels().padding(.bottom, 2)
                        content
                    }
                } else { content }
            }
        }
        .gesture(
            DragGesture()
                .onChanged({ gesture in
                    self.offset = CGSize(width: gesture.translation.width/2, height: 0)
                })
                .onEnded({ gesture in
                    self.totalOffset = CGSize(width: self.totalOffset.width + gesture.translation.width/2, height: 0)
                    self.offset = CGSize.zero
                    
                })
        )
        .offset(x: offset.width + totalOffset.width)
    }
}

extension View {
    /**
     Labels for the X axis.
     
     The labels can either come from ChartData -->  xAxisLabels
     or ChartData --> DataSets --> DataPoints
     
     - Requires:
     Chart Data to conform to CTLineBarChartDataProtocol.
     
     - Requires:
     Chart Data to conform to CTLineBarChartDataProtocol.
     
     # Available for:
     - Line Chart
     - Multi Line Chart
     - Filled Line Chart
     - Ranged Line Chart
     - Bar Chart
     - Grouped Bar Chart
     - Stacked Bar Chart
     - Ranged Bar Chart
     
     # Unavailable for:
     - Pie Chart
     - Doughnut Chart
     
     - Parameter chartData: Chart data model.
     - Returns: A  new view containing the chart with labels marking the x axis.
     */
    public func xAxisLabels<T: CTLineBarChartDataProtocol>(chartData: T) -> some View {
        self.modifier(XAxisLabels(chartData: chartData))
    }
}
