//
//  Linhvuc.swift
//  DataPopulator
//
//  Created by VietLH on 7/5/20.
//  Copyright © 2020 VietLH. All rights reserved.
//

import Foundation
class Linhvuc{
    var dieukhoanId: Int64
    var duongsat: Bool
    var duongbo: Bool
    
    init(dieukhoanId: Int64, duongsat: Bool, duongbo: Bool) {
        self.dieukhoanId = dieukhoanId
        self.duongbo = duongbo
        self.duongsat = duongsat
    }
    
    func getId() -> Int64 {
        return dieukhoanId
    }
    
    func setId(dieukhoanId: Int64) {
        self.dieukhoanId = dieukhoanId
    }
    
    func isDuongsat() -> Bool {
        return duongsat
    }
    
    func setDuongsat(duongsat: Bool) {
        self.duongsat = duongsat
    }
    
    func isDuongbo() -> Bool {
        return duongbo
    }
    
    func setDuongbo(duongbo: Bool) {
        self.duongbo = duongbo
    }
}
