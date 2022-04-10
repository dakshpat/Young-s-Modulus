//
//  TextView.swift
//  Tab for Displaying and saving text
//
//  Created by Jeff Terry on 1/23/21.
//

import SwiftUI
import UniformTypeIdentifiers

struct TextView: View {
    
    var data = loadCSV(from: "Aluminium")
    
    var body: some View {
        
        Button("load data"){
            test()
        }
        
  
    
    }

    func test(){
        
        var stress = [Double]()
        var strain = [Double]()
        for values in data{
            stress.append(values.stress)
            strain.append(values.strain)
        }
        
        print("Stress", stress)
        print("strain", strain)

    }
    
struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView()
    }
}
}
