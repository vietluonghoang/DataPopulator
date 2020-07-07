//
//  Phuongtien.swift
//  DataPopulator
//
//  Created by VietLH on 7/5/20.
//  Copyright © 2020 VietLH. All rights reserved.
//

import Foundation
class Phuongtien{
    var dieukhoanId: Int64
    var oto: Bool
    var otoTai: Bool
    var maykeo: Bool
    var xechuyendung: Bool
    var tau: Bool
    var moto: Bool
    var xeganmay: Bool
    var xedapdien: Bool
    var xedapmay: Bool
    var xedap: Bool
    var xemaydien: Bool
    var xethoso: Bool
    var sucvat: Bool
    var xichlo: Bool
    var dibo: Bool
    
    init(dieukhoanId: Int64, oto: Bool, otoTai: Bool, maykeo: Bool, xechuyendung: Bool, tau: Bool, moto: Bool, xeganmay: Bool, xemaydien: Bool, xedapmay: Bool, xedap: Bool, xedapdien: Bool, xethoso: Bool, sucvat: Bool, xichlo: Bool, dibo: Bool){
        self.dieukhoanId = dieukhoanId
        self.oto = oto
        self.otoTai = otoTai
        self.maykeo = maykeo
        self.xechuyendung = xechuyendung
        self.tau = tau
        self.moto = moto
        self.xeganmay = xeganmay
        self.xemaydien = xemaydien
        self.xedapmay = xedapmay
        self.xedap = xedap
        self.xedapdien = xedapdien
        self.xethoso = xethoso
        self.sucvat = sucvat
        self.xichlo = xichlo
        self.dibo = dibo
    }
    
    func getId() -> Int64 {
        return dieukhoanId
    }
    
    func setId(dieukhoanId: Int64) {
        self.dieukhoanId = dieukhoanId
    }
    
    func isOto() -> Bool {
        return oto
    }
    
    func setOto(oto: Bool) {
        self.oto = oto
    }
    
    func isOtoTai() -> Bool {
        return otoTai
    }
    
    func setOtoTai(otoTai: Bool) {
        self.otoTai = otoTai
    }

    func isMaykeo() -> Bool {
        return maykeo
    }
    
    func setMaykeo(maykeo: Bool) {
        self.maykeo = maykeo
    }
    
    func isXechuyendung() -> Bool {
        return xechuyendung
    }
    
    func setXechuyendung(xechuyendung: Bool) {
        self.xechuyendung = xechuyendung
    }
    
    func isTau() -> Bool {
        return tau
    }
    
    func setTau(tau: Bool) {
        self.tau = tau
    }
    
    func isMoto() -> Bool {
        return moto
    }
    
    func setMoto(moto: Bool) {
        self.moto = moto
    }
    
    func isXeganmay() -> Bool {
        return xeganmay
    }
    
    func setXeganmay(xeganmay: Bool) {
        self.xeganmay = xeganmay
    }
    
    func isXemaydien() -> Bool {
        return xemaydien
    }
    
    func setXemaydien(xemaydien: Bool) {
        self.xemaydien = xemaydien
    }
    
    func isXedapmay() -> Bool {
        return xedapmay
    }
    
    func setXedapmay(xedapmay: Bool) {
        self.xedapmay = xedapmay
    }
    
    func isXedap() -> Bool {
        return xedap
    }
    
    func setXedap(xedap: Bool) {
        self.xedap = xedap
    }
    
    func isXedapdien() -> Bool {
        return xedapdien
    }
    
    func setXedapdien(xedapdien: Bool) {
        self.xedapdien = xedapdien
    }
    
    func isXethoso() -> Bool {
        return xethoso
    }
    
    func setXethoso(xethoso: Bool) {
        self.xethoso = xethoso
    }
    
    func isSucvat() -> Bool {
        return sucvat
    }
    
    func setSucvat(sucvat: Bool) {
        self.sucvat = sucvat
    }
    
    func isXichlo() -> Bool {
        return xichlo
    }
    
    func setXichlo(xichlo: Bool) {
        self.xichlo = xichlo
    }
    
    func isDibo() -> Bool {
        return dibo
    }
    
    func setDibo(dibo: Bool) {
        self.dibo = dibo
    }
    
}
