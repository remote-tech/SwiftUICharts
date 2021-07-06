//
//  XAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import Foundation
import SwiftUI

/**
 Labels for the X axis.
 */
internal struct XAxisLabels<T>: ViewModifier where T: CTLineBarChartDataProtocol {
    
    @ObservedObject private var chartData: T
    
    @State private var offset = CGSize.zero
    @State private var totalOffset = CGSize.zero
    
    @State private var isLoad = true
    
    internal init(chartData: T) {
        self.chartData = chartData
        self.chartData.viewData.hasXAxisLabels = true
    }
    
    func scaleFactor() -> CGFloat {
        if let chartData = chartData as? RangedBarChartData, let windowSize = chartData.windowSize, windowSize > 0 {
            let totalPoints = chartData.dataSets.dataPoints.count
            if totalPoints > 0, totalPoints < windowSize {
                let factor = CGFloat(totalPoints) / CGFloat(windowSize)
                return factor
            }
        }
        
        return 1
    }
    
    func contentWidth(geo: GeometryProxy) -> CGFloat {
        return geo.size.width * scaleFactor()
    }
    
    internal func body(content: Content) -> some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    Group {
                        switch chartData.chartStyle.xAxisLabelPosition {
                        case .bottom:
                            if chartData.isGreaterThanTwo() {
                                VStack {
                                    content
                                    chartData.getXAxisLabels().padding(.top, 2)
                                    chartData.getXAxisTitle()
                                }
                                .frame(width: contentWidth(geo: geo), height: geo.size.height)
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
                    
                }
                .onAppear {
//                    chartData.dataSets.dataPoints[0]
//                    if let chartData = chartData as? RangedBarChartData {
//                        let index = Int(chartData.dataSets.dataPoints.count/2) - 1
//                        if index < chartData.dataSets.dataPoints.count, index >= 0 {
//                            let id = chartData.dataSets.dataPoints[Int(chartData.dataSets.dataPoints.count/2) - 1].id
//                            proxy.scrollTo(id, anchor: .topLeading)
//                        }
//                    }
                }
            }
        }
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
