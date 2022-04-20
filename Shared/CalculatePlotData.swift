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
   
    @Published var stress: [Double] = []
    @Published var strain: [Double] = []
    
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
    
    func plotAluminium() async {
        yMax = 320.0
        yMin = 0.0
        xMax = 0.25
        xMin = -0.01
        
        theText = "Stress/Strain"
        
        await setThePlotParameters(color: "Red", xLabel: "Strain", yLabel: "Stress", title: "Aluminium")
        
        
        var plotData :[plotDataType] =  []
        self.stress.removeAll()
        self.strain.removeAll()
        
        for values in data{
            
            self.stress.append(values.stress)
            self.strain.append(values.strain)
            
            let dataPoint: plotDataType = [.X: values.strain, .Y: values.stress]
            plotData.append(contentsOf: [dataPoint])
        
        }

//            theText += "x = \(x), y = \(y)\n"
        
        
        await appendDataToPlot(plotData: plotData)
        
    }
    
    
    func plotCopper() async {
        //set plot parameters
        yMax = 600.0
        yMin = 0.0
        xMax = 1.0
        xMin = -0.01
                
        await setThePlotParameters(color: "Blue", xLabel: "Strain", yLabel: "Stress", title: "Copper")
        
        //plot data 
        var plotData :[plotDataType] =  []
        stress.removeAll()
        strain.removeAll()
      
        for values in data2{
            
            stress.append(values.stress)
            strain.append(values.strain)
            
            let dataPoint: plotDataType = [.X: values.strain, .Y: values.stress]
            plotData.append(contentsOf: [dataPoint])
        
        }
        
        await appendDataToPlot(plotData: plotData)
       
        
        return
    }
    
    
}



