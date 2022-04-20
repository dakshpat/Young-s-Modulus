//
//  Youngs modulus.swift
//  YoungsModulus
//
//  Created by Daksh Patel on 4/17/22.
//

import Foundation

class youngsModulus: ObservableObject {

    @Published var dogBoneLength = 50.0 ///mm
    @Published var dogBoneWidth = 10.0 ///mm
    @Published var dogBoneThickness = 3.0 ///mm
    
    ///calculates the young's modulus of a material
    ///simple slope over two points
    func calculateYoungs(Stress: [Double], Strain: [Double]) -> Double{
        
        var E = 0.0

            let deltaStress = Stress[10] - Stress[0]
            let deltaStrain = Strain[10] - Strain[0]

             E += deltaStress/deltaStrain
        
        ///returns in Gpa unit
        return E/1000
    }

    ///Takes the stess amount and turns it into Force(Newtons)
    ///This value depends on the exact dimentions of the dog bone (150 mm^2 in our case)
    
    func getForceRequired(Stress: [Double]) -> [Double]{
        let area = dogBoneThickness*dogBoneWidth
        var forceArray = [Double]()
        
        for value in Stress{
            forceArray.append(value*area)
        }
        
        return forceArray
    }
    
    
    
}
