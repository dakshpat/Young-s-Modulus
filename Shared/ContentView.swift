//
//  ContentView.swift
//  Shared
//
//  Created by Jeff Terry on 1/25/21.
//

import SwiftUI
import CorePlot

typealias plotDataType = [CPTScatterPlotField : Double]

struct ContentView: View {
    @EnvironmentObject var plotData :PlotClass
    
    @ObservedObject var youngsMod = youngsModulus()
    @StateObject var calculator = CalculatePlotData()
    var data = loadCSV(from: "Aluminium")
    var data2 = loadCSV(from: "Copper706")
    
    @State var E = 0.0
    
    @State var isChecked:Bool = false
    @State var tempInput = ""
    
    @State var selector = 0

    var body: some View {
        
        VStack{
      
            CorePlot(dataForPlot: $plotData.plotArray[selector].plotData, changingPlotParameters: $plotData.plotArray[selector].changingPlotParameters)
                .setPlotPadding(left: 10)
                .setPlotPadding(right: 10)
                .setPlotPadding(top: 10)
                .setPlotPadding(bottom: 10)
                .padding()
            
            Divider()
            
        HStack{

            VStack{
                Button("Aluminium", action: {
                    
                    Task.init{
                    
                    self.selector = 0
                    await self.calculate()
                    }
                    
                }
                )
        
                
                Button("Copper", action: { Task.init{
                    
                    self.selector = 1
                    
                    await self.calculate2()
                    
                    
                    }
                }
                )
                .padding()
            }
            
            VStack{
                Text("Youngs's Modulus(GPa): \(E, specifier: "%.3f")")
            }
            
            }
  
            
            
            
        }
        
    }
    
    @MainActor func setupPlotDataModel(selector: Int){
        
        calculator.plotDataModel = self.plotData.plotArray[selector]
    }
    
    
    /// calculate
    /// Function accepts the command to start the calculation from the GUI
    func calculate() async {
        
        //pass the plotDataModel to the Calculator
       // calculator.plotDataModel = self.plotData.plotArray[0]
        
        setupPlotDataModel(selector: 0)
        
     //   Task{
            
            
        let _ = await withTaskGroup(of:  Void.self) { taskGroup in

                taskGroup.addTask {
        
        
        //Calculate the new plotting data and place in the plotDataModel
        await calculator.plotAluminium()
        
                    // This forces a SwiftUI update. Force a SwiftUI update.
        await self.plotData.objectWillChange.send()
                    
                }

            }
        
        E = youngsMod.calculateYoungs(Stress: calculator.stress, Strain: calculator.strain)
        
    }
    
    /// calculate
    /// Function accepts the command to start the calculation from the GUI
    func calculate2() async {
        
        
        //pass the plotDataModel to the Calculator
       // calculator.plotDataModel = self.plotData.plotArray[0]
        
        setupPlotDataModel(selector: 1)
        
            
        let _ = await withTaskGroup(of:  Void.self) { taskGroup in



                taskGroup.addTask {

        //Calculate the new plotting data and place in the plotDataModel
        await calculator.plotCopper()
                  
        // This forces a SwiftUI update. Force a SwiftUI update.
        await self.plotData.objectWillChange.send()
                    
                }
                
            }
    
        E = youngsMod.calculateYoungs(Stress: calculator.stress, Strain: calculator.strain)
        
    }
    
    
    
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
