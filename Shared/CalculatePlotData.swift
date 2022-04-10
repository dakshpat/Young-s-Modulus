//
//  CalculatePlotData.swift
//  SwiftUICorePlotExample
//
//  Created by Jeff Terry on 12/22/20.
//

import Foundation
import SwiftUI
import CorePlot

class CalculatePlotData: ObservableObject {
    
    var plotDataModel: PlotDataClass? = nil
    var theText = ""
    var data = loadCSV(from: "Aluminium")
    var data2 = loadCSV(from: "Copper706")
    
    var yMax = 80.0
    var yMin = 0.0
    var xMax = 0.25
    var xMin = -0.01
    

    @MainActor func setThePlotParameters(color: String, xLabel: String, yLabel: String, title: String) {
        //set the Plot Parameters
        plotDataModel!.changingPlotParameters.yMax = self.yMax
        plotDataModel!.changingPlotParameters.yMin = self.yMin
        plotDataModel!.changingPlotParameters.xMax = self.xMax
        plotDataModel!.changingPlotParameters.xMin = self.xMin
        plotDataModel!.changingPlotParameters.xLabel = xLabel
        plotDataModel!.changingPlotParameters.yLabel = yLabel
        
        if color == "Red"{
            plotDataModel!.changingPlotParameters.lineColor = .red()
        }
        else{
            
            plotDataModel!.changingPlotParameters.lineColor = .blue()
        }
        plotDataModel!.changingPlotParameters.title = title
        
        plotDataModel!.zeroData()
    }
    
    @MainActor func appendDataToPlot(plotData: [plotDataType]) {
        plotDataModel!.appendData(dataPoint: plotData)
    }
    
    func plotYEqualsX() async
    {
        
        theText = "Stress/Strain"
        
        await setThePlotParameters(color: "Red", xLabel: "stress", yLabel: "strain", title: "Aluminium")
        
        
        var plotData :[plotDataType] =  []
        
        for values in data{

            let dataPoint: plotDataType = [.X: values.stress, .Y: values.strain]
            plotData.append(contentsOf: [dataPoint])
        
        }
//            theText += "x = \(x), y = \(y)\n"
        
        
        await appendDataToPlot(plotData: plotData)
     
        
        
    }
    
    
    func ploteToTheMinusX() async {
        //set plot parameters
        yMax = 80.0
        yMin = 0.0
        xMax = 1.0
        xMin = -0.01
                
        await setThePlotParameters(color: "Blue", xLabel: "stress", yLabel: "strain", title: "Copper")
        
        //plot data 
        var plotData :[plotDataType] =  []
      
        for values in data2{

            let dataPoint: plotDataType = [.X: values.stress, .Y: values.strain]
            plotData.append(contentsOf: [dataPoint])
        
        }
        
        await appendDataToPlot(plotData: plotData)
       
        
        return
    }
    
    
}



