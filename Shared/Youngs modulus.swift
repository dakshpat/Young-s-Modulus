//
//  Youngs modulus.swift
//  YoungsModulus
//
//  Created by Daksh Patel on 4/17/22.
//

import Foundation

class youngsModulus: ObservableObject {

    func calculateYoungs(Stress: [Double], Strain: [Double]) -> Double{
        
        var E = 0.0

            let deltaStress = Stress[10] - Stress[0]
            let deltaStrain = Strain[10] - Strain[0]

             E += deltaStress/deltaStrain
        
        return E/1000
    }

}
