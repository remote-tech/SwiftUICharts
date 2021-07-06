//
//  RangedBarDataSet.swift
//  
//
//  Created by Will Dale on 05/03/2021.
//

import SwiftUI

/**
 Data set for ranged bar charts.
 */
public struct RangedBarDataSet: CTRangedBarChartDataSet, DataFunctionsProtocol {
    
    public var id: UUID = UUID()
    public var dataPoints: [RangedBarDataPoint]
    public var legendTitle: String
    public var viewWindow: Int?
    
    /// Initialises a new data set for ranged bar chart.
    /// - Parameters:
    ///   - dataPoints: Array of elements.
    ///   - legendTitle: Label for the data in legend.
    public init(
        dataPoints: [RangedBarDataPoint],
        legendTitle: String = "",
        viewWindow: Int? = nil
    ) {
        self.dataPoints = dataPoints
        self.legendTitle = legendTitle
        self.viewWindow = viewWindow
    }
    
    public typealias ID = UUID
    public typealias DataPoint = RangedBarDataPoint
}
