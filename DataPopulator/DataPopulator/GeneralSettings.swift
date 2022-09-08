//
//  GeneralSettings.swift
//  HieuLuat
//
//  Created by VietLH on 11/19/17.
//  Copyright © 2017 VietLH. All rights reserved.
//

import Foundation

class GeneralSettings {

    //temporarily keep these since we need them for checking the releatedDieukhoan
    let lgtId = "4"
    let lxlvphcId = "16"
    
    //temporarily keep these since we need them for checking the releatedDieukhoan
    func getLGTID() -> String {
        return lgtId
    }
    func getLXLVPHCID() -> String {
        return lxlvphcId
    }
    
    func getRecordCapByRam(ram: UInt64) -> Int16 {
        if ram <= 1 {
            return 250
        }
        if ram <= 2 {
            return 500
        }
        if ram <= 3 {
            return 750
        }
        if ram <= 4 {
            return 1000
        }
        
        //no cap if more than 4GB RAM
        return 0
    }
}
