//
//  Mucphat.swift
//  DataPopulator
//
//  Created by VietLH on 7/5/20.
//  Copyright © 2020 VietLH. All rights reserved.
//

import Foundation
class Mucphat{
    var dieukhoanId: Int64
    var canhanTu: String
    var canhanDen: String
    var tochucTu: String
    var tochucDen: String
    
    init(dieukhoanId: Int64, canhanTu: String, canhanDen: String, tochucTu: String, tochucDen: String) {
        self.dieukhoanId = dieukhoanId
        self.canhanTu = canhanTu
        self.canhanDen = canhanDen
        self.tochucTu = tochucTu
        self.tochucDen = tochucDen
    }
}
