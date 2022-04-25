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
    
    @State var materials = ["Aluminium", "Copper"]
    @State var selectedMaterial = ""
    @State var E = 0.0
    @State var sliderValue: Double = 0.0
    @State var forceArray = [1.0, 2.0]
    @State var lengthArray = [1.0, 2.0]
    
   
    @State var isChecked:Bool = false
    @State var tempInput = ""
    
    @State var selector = 0

    var body: some View {
        
        HStack{
            
            VStack{
                Text("Youngs's Modulus(GPa): \(E, specifier: "%.3f")")
                
                Picker("Material", selection: $selectedMaterial){
                    ForEach(materials, id: \.self){
                        Text($0)
                    }
                }
                .onChange(of: selectedMaterial, perform: {value in Task{await self.selectMaterial(materialType: selectedMaterial)}})
                .padding()
                
                VStack{
               
                    Text("Force Applied(N): \(forceArray[Int(sliderValue)], specifier: "%.2f")")
                            
                        Slider(
                            value: $sliderValue,
                            in: 0...(Double(forceArray.count-1)),
                            step: 1
                        )
                        .padding()
                    
                    Text("Change in Length(mm): \(lengthArray[Int(sliderValue)], specifier: "%.2f")")

                    }
            }
            .padding()
            .frame(width: 300)
            
            
            
           
            Divider()

            CorePlot(dataForPlot: $plotData.plotArray[selector].plotData, changingPlotParameters: $plotData.plotArray[selector].changingPlotParameters)
                .setPlotPadding(left: 10)
                .setPlotPadding(right: 10)
                .setPlotPadding(top: 10)
                .setPlotPadding(bottom: 10)
                .padding()
         
        }
        
    }
    
    @MainActor func setupPlotDataModel(selector: Int){
        
        calculator.plotDataModel = self.plotData.plotArray[selector]
    }
    
    func selectMaterial(materialType: String) async {
        
        switch materialType {
            
            case "Aluminium":
            Task.init{
            
            self.selector = 0
            await self.calculate()
            }
        
            case "Copper":
            
            Task.init{
                self.selector = 1
                await self.calculate2()
                }
        
            default:
            Task.init{
            
            self.selector = 0
            await self.calculate()
            }
        }
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
        forceArray.removeAll()
        lengthArray.removeAll()
        forceArray = youngsMod.getForceRequired(Stress: calculator.stress)
        lengthArray = youngsMod.getLengthChange(Strain: calculator.strain)

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
        forceArray.removeAll()
        lengthArray.removeAll()
        forceArray = youngsMod.getForceRequired(Stress: calculator.stress)
        lengthArray = youngsMod.getLengthChange(Strain: calculator.strain)
    }
    
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
