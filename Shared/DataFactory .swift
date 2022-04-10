//
//  DataFactory .swift
//  YoungsModulus
//
//  Created by Daksh Patel on 4/10/22.
//

import Foundation
import Cocoa

struct ssData{

    var stress: Double
    var strain: Double
    
}

func loadCSV(from csvName: String) -> [ssData] {
    var csvToStruct = [ssData]()
    
    //locate the csv file
    guard let filepath = Bundle.main.path(forResource: csvName, ofType: "csv") else {
        return []
    }
    
    // convert the content into one long string
    var data = ""
    do {
        data = try String(contentsOfFile: filepath)
    } catch {
        print(error)
        return []
    }
    
    // split the long string into an array of rows of data. Each row is a string
    // detect "\n" carriage return , then split
    var rows = data.components(separatedBy: "\n")
    
    rows.removeLast()
    
    for row in rows{
        let columns = row.components(separatedBy: ", ")
        let stress = Double(columns[0]) ?? 0
        let strain = Double(columns[1]) ?? 0
        let aluminium = ssData(stress: stress, strain: strain)
        
        csvToStruct.append(aluminium)
    }
    
    return csvToStruct
}




