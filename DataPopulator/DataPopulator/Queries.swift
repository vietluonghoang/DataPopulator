//
//  Queries.swift
//  HieuLuat
//
//  Created by VietLH on 8/26/17.
//  Copyright © 2017 VietLH. All rights reserved.
//

import UIKit
import FMDB

class Queries: NSObject {
    
    static var physicalMemorySize: UInt64 {
        get{
            return self.physicalMemorySize
        }
        set(v){
            self.physicalMemorySize = getPhysicalMemorySize();
        }
    }
    
    static var rawSqlQuery: String {
        get {
            return "select distinct dk.id as dkId, dk.so as dkSo, tieude as dkTieude, dk.noidung as dkNoidung, minhhoa as dkMinhhoa, cha as dkCha, vb.loai as lvbID, lvb.ten as lvbTen, vb.so as vbSo, vanbanid as vbId, vb.ten as vbTen, nam as vbNam, ma as vbMa, vb.noidung as vbNoidung, coquanbanhanh as vbCoquanbanhanhId, cq.ten as cqTen, dk.forSearch as dkSearch from tblChitietvanban as dk join tblVanban as vb on dk.vanbanid=vb.id join tblLoaivanban as lvb on vb.loai=lvb.id join tblCoquanbanhanh as cq on vb.coquanbanhanh=cq.id where "
        }
        set(v) {
            self.rawSqlQuery = v
        }
    }
    
    class func insert(dieukhoan:Dieukhoan) {
        //        Utils.database!.open()
        //        let sql = "INSERT INTO Person (id, name, age) VALUES (?, ?, ?)"
        //        Utils.database!.executeUpdate(sql, withArgumentsIn: [person.id!,person.name!, person.age!])
        //        Utils.database!.close()
    }
    
    class func update(dieukhoan:Dieukhoan) {
        //        Utils.database!.open()
        //        let sql = "UPDATE Person SET name = ?, age = ? WHERE id = ?"
        //        Utils.database!.executeUpdate(sql,  withArgumentsIn: [person.name!, person.age!, person.id!])
        //        Utils.database!.close()
    }
    
    class func delete(dieukhoan:Dieukhoan) {
        //        Utils.database!.open()
        //        let sql = "DELETE FROM Person WHERE id = ?"
        //        Utils.database!.executeUpdate(sql, withArgumentsIn: [person.id!])
        //        Utils.database!.close()
    }
    
    class func deleteAll() {
        //        Utils.database!.open()
        //        let sql = "DELETE FROM Person"
        //        Utils.database!.executeUpdate(sql, withArgumentsIn: nil)
        //        Utils.database!.close()
    }
    
    class func selectAllDieukhoan() -> [Dieukhoan] {
        DataConnection.database!.open()
        let sql = rawSqlQuery.substring(to: rawSqlQuery.index(rawSqlQuery.endIndex, offsetBy: -6))
        let resultSet: FMResultSet! = DataConnection.database!.executeQuery(setRecordsCap(query: sql), withArgumentsIn: [])!
        var dieukhoanArray = Array<Dieukhoan>()
        if resultSet != nil {
            dieukhoanArray = generateDieukhoanList(resultSet: resultSet)
        }
        DataConnection.database!.close()
        return dieukhoanArray
    }
    
    class func executeSelectQuery(query: String) -> FMResultSet {
        DataConnection.database!.open()
        let resultSet: FMResultSet! = DataConnection.database!.executeQuery(query, withArgumentsIn: [])!
        
        return resultSet
    }
    class func executeDeleteQuery(query: String) {
        DataConnection.database!.open()
        //        let sql = "DELETE FROM Person WHERE id = ?"
        DataConnection.database!.executeUpdate(query, withArgumentsIn: [])
        DataConnection.database!.close()
    }
    
    class func executeStatements(query: String){
        DataConnection.database!.open()
        //        let sql = "DELETE FROM Person WHERE id = ?"
        var result = DataConnection.database!.executeStatements(query)
        if !result{
            result = DataConnection.database!.executeStatements(Utils.escapeQuote(string: query))
        }
        if !result{
            print("--- SQL ERROR\n\t\t\(query)")
        }
        
        DataConnection.database!.close()
    }
    
    class func searchDieukhoan(keyword:String, vanbanid: [String]) -> [Dieukhoan] {
        DataConnection.database!.open()
        
        let specificVanban = generateWhereClauseForVanbanid(vanbanid: vanbanid, vanbanIdColumnName: "vbId")
        let appendString = generateWhereClauseForKeywordsWithDifferentAccentType(keyword: keyword, targetColumn: "dkSearch")
        let appendKeyword = [String]()
        
        let sql = "\(rawSqlQuery) (\(appendString)) \(specificVanban)"
        
        let resultSet: FMResultSet! = DataConnection.database!.executeQuery(setRecordsCap(query: sql), withArgumentsIn: appendKeyword)!
        
        var dieukhoanArray = Array<Dieukhoan>()
        
        if resultSet != nil {
            dieukhoanArray = generateDieukhoanList(resultSet: resultSet)
        }
        
        DataConnection.database!.close()
        
        return dieukhoanArray
    }
    
    class func searchDieukhoanByQuery(query:String, vanbanid: [String]) -> [Dieukhoan] {
        DataConnection.database!.open()
        var specificVanban = generateWhereClauseForVanbanid(vanbanid: vanbanid, vanbanIdColumnName: "vbId")
        if (String(query.trimmingCharacters(in: .whitespacesAndNewlines).suffix(5)).compare("where") == .orderedSame){
            specificVanban = Utils.substring(string: specificVanban, from: 4, to: specificVanban.count).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        let appendKeyword = [String]()
        let sql = query.lowercased() + specificVanban
        
        let resultSet: FMResultSet! = DataConnection.database!.executeQuery(setRecordsCap(query: sql), withArgumentsIn: appendKeyword)!
        
        var dieukhoanArray = Array<Dieukhoan>()
        
        if resultSet != nil {
            dieukhoanArray = generateDieukhoanList(resultSet: resultSet)
        }
        
        DataConnection.database!.close()
        
        return dieukhoanArray
    }
    
    class func updateBienphapkhacphucAndHinhphatbosung(dieukhoan: Dieukhoan) -> Dieukhoan {
        DataConnection.database!.open()
        //        let specificVanban = generateWhereClauseForVanbanid(vanbanid: [GeneralSettings().getND46ID()], vanbanIdColumnName: "vbId")
        let appendKeyword = [String]()
        var sql = "select noidung from tblHinhphatbosung where dieukhoanId = \(dieukhoan.getId())"
        
        var resultSet: FMResultSet! = DataConnection.database!.executeQuery(setRecordsCap(query: sql), withArgumentsIn: appendKeyword)!
        
        if resultSet != nil {
            dieukhoan.setHinhphatbosung(hinhphatbosung: resultSet.string(forColumn: "noidung")!)
        }
        
        sql = "select noidung from tblBienphapkhacphuc where dieukhoanId = \(dieukhoan.getId())"
        
        resultSet = DataConnection.database!.executeQuery(setRecordsCap(query: sql), withArgumentsIn: appendKeyword)!
        
        if resultSet != nil {
            dieukhoan.setBienphapkhacphuc(bienphapkhacphuc: resultSet.string(forColumn: "noidung")!)
        }
        
        DataConnection.database!.close()
        
        return dieukhoan
    }
    
    class func insertBienphapkhacphucAndHinhphatbosung(type: String, dieukhoanId: Int64, dieukhoanQuydinhId: Int64, noidung: String) {
        DataConnection.database!.open()
        
        let appendKeyword = [String]()
        var targetTable = ""
        if type == "hpbs" {
            targetTable = "tblHinhphatbosung"
        }
        
        if type == "bpkp" {
            targetTable = "tblBienphapkhacphuc"
        }
        
        let sql = "insert into \(targetTable) ('dieukhoanId', 'dieukhoanQuydinhId', 'noidung') values (\(dieukhoanId),\(dieukhoanQuydinhId),'\(noidung)')"
        let reslut = DataConnection.database!.executeUpdate(sql, withArgumentsIn: appendKeyword)
        print("Bienphapkhacphuc/Hinhphatbosung Inserted: \(dieukhoanId) - \(dieukhoanQuydinhId)?... \(reslut)")
        if !reslut {
            print("update failed: \(DataConnection.database!.lastErrorMessage())")
        }
        DataConnection.database!.close()
    }
    
    class func getBienphapkhacphucAndHinhphatbosungByDieukhoanQuydinh(type: String, dieukhoanQuydinhId: Int64) -> [Dieukhoan] {
        DataConnection.database!.open()
        //        let specificVanban = generateWhereClauseForVanbanid(vanbanid: [GeneralSettings().getND46ID()], vanbanIdColumnName: "vbId")
        let appendKeyword = [String]()
        var targetTable = ""
        if type == "hpbs" {
            targetTable = "tblHinhphatbosung"
        }
        
        if type == "bpkp" {
            targetTable = "tblBienphapkhacphuc"
        }
        
        let sql = "select dk.id as dkId, dk.so as dkSo, tieude as dkTieude, dk.noidung as dkNoidung, minhhoa as dkMinhhoa, cha as dkCha, vb.loai as lvbID, lvb.ten as lvbTen, vb.so as vbSo, vanbanid as vbId, vb.ten as vbTen, nam as vbNam, ma as vbMa, vb.noidung as vbNoidung, coquanbanhanh as vbCoquanbanhanhId, cq.ten as cqTen, dk.forSearch as dkSearch, tg.noidung as tgNoidung from tblChitietvanban as dk join tblVanban as vb on dk.vanbanid=vb.id join tblLoaivanban as lvb on vb.loai=lvb.id join tblCoquanbanhanh as cq on vb.coquanbanhanh=cq.id join \(targetTable) AS tg on tg.dieukhoanQuydinhId = dk.id where tg.dieukhoanQuydinhId = \(dieukhoanQuydinhId)"
        
        print("\(sql)")
        let resultSet: FMResultSet! = DataConnection.database!.executeQuery(sql, withArgumentsIn: appendKeyword)!
        print(DataConnection.database?.lastError() ?? "no value")
        var dieukhoanArray = Array<Dieukhoan>()
        if resultSet != nil {
            while resultSet.next() {
                var cha = resultSet.string(forColumn: "dkCha")
                if(cha==nil){
                    cha="0"
                }
                let lvb = Loaivanban(id: Int64(resultSet.string(forColumn: "lvbId")!)!, ten: resultSet.string(forColumn: "lvbTen")!)
                let cq = Coquanbanhanh(id: Int64(resultSet.string(forColumn: "vbCoquanbanhanhid")!)!, ten: resultSet.string(forColumn: "cqTen")!)
                let vb = Vanban(id: Int64(resultSet.string(forColumn: "vbId")!)!, ten: resultSet.string(forColumn: "vbTen")!, loai: lvb, so: resultSet.string(forColumn: "vbSo")!, nam: resultSet.string(forColumn: "vbNam")!, ma: resultSet.string(forColumn: "vbMa")!, coquanbanhanh: cq, noidung: resultSet.string(forColumn: "vbNoidung")!)
                let dieukhoan = Dieukhoan(id: Int64(resultSet.string(forColumn: "dkId")!)!, so: resultSet.string(forColumn: "dkSo")!, tieude: resultSet.string(forColumn: "tgNoidung")!.components(separatedBy: "|")[0], noidung: resultSet.string(forColumn: "tgNoidung")!.components(separatedBy: "|")[1], minhhoa: resultSet.string(forColumn: "dkMinhhoa")!, cha: Int64(cha!)!, vanban: vb)
                dieukhoanArray.append(dieukhoan)
            }
        }
        DataConnection.database!.close()
        return dieukhoanArray
    }
    
    class func getAllBienphapkhacphucAndHinhphatbosung(type: String) -> [Dieukhoan] {
        DataConnection.database!.open()
        //        let specificVanban = generateWhereClauseForVanbanid(vanbanid: [GeneralSettings().getND46ID()], vanbanIdColumnName: "vbId")
        let appendKeyword = [""]
        var targetTable = ""
        if type == "hpbs" {
            targetTable = "tblHinhphatbosung"
        }
        
        if type == "bpkp" {
            targetTable = "tblBienphapkhacphuc"
        }
        
        let sql = "select dk.id as dkId, dk.so as dkSo, tieude as dkTieude, dk.noidung as dkNoidung, minhhoa as dkMinhhoa, cha as dkCha, vb.loai as lvbID, lvb.ten as lvbTen, vb.so as vbSo, vanbanid as vbId, vb.ten as vbTen, nam as vbNam, ma as vbMa, vb.noidung as vbNoidung, coquanbanhanh as vbCoquanbanhanhId, cq.ten as cqTen, dk.forSearch as dkSearch, tg.noidung as tgNoidung from tblChitietvanban as dk join tblVanban as vb on dk.vanbanid=vb.id join tblLoaivanban as lvb on vb.loai=lvb.id join tblCoquanbanhanh as cq on vb.coquanbanhanh=cq.id join \(targetTable) AS tg on tg.dieukhoanQuydinhId = dk.id where tgNoidung like '%|%'"
        let resultSet: FMResultSet! = DataConnection.database!.executeQuery(sql, withArgumentsIn: appendKeyword)!
        var dieukhoanArray = Array<Dieukhoan>()
        if resultSet != nil {
            while resultSet.next() {
                var cha = resultSet.string(forColumn: "dkCha")
                if(cha==nil){
                    cha="0"
                }
                let lvb = Loaivanban(id: Int64(resultSet.string(forColumn: "lvbId")!)!, ten: resultSet.string(forColumn: "lvbTen")!)
                let cq = Coquanbanhanh(id: Int64(resultSet.string(forColumn: "vbCoquanbanhanhid")!)!, ten: resultSet.string(forColumn: "cqTen")!)
                let vb = Vanban(id: Int64(resultSet.string(forColumn: "vbId")!)!, ten: resultSet.string(forColumn: "vbTen")!, loai: lvb, so: resultSet.string(forColumn: "vbSo")!, nam: resultSet.string(forColumn: "vbNam")!, ma: resultSet.string(forColumn: "vbMa")!, coquanbanhanh: cq, noidung: resultSet.string(forColumn: "vbNoidung")!)
                let noidung = resultSet.string(forColumn: "tgNoidung")!.components(separatedBy: "|")[1]
                let tieude = resultSet.string(forColumn: "tgNoidung")!.components(separatedBy: "|")[0]
                let dieukhoan = Dieukhoan(id: Int64(resultSet.string(forColumn: "dkId")!)!, so: resultSet.string(forColumn: "dkSo")!, tieude: tieude, noidung: noidung, minhhoa: resultSet.string(forColumn: "dkMinhhoa")!, cha: Int64(cha!)!, vanban: vb)
                
                dieukhoanArray.append(dieukhoan)
            }
        }
        DataConnection.database!.close()
        return dieukhoanArray
    }
    
    class func insertRelatedDieukhoan(dieukhoanId: Int64, relatedDieukhoanId: Int64) {
        DataConnection.database!.open()
        
        let appendKeyword = [String]()
        let sql = "insert into tblRelatedDieukhoan ('dieukhoanId', 'relatedDieukhoanId') values (\(dieukhoanId),\(relatedDieukhoanId))"
        let reslut = DataConnection.database!.executeUpdate(sql, withArgumentsIn: appendKeyword)
        print("Related Dieukhoan Inserted: \(dieukhoanId) - \(relatedDieukhoanId)?... \(reslut)")
        if !reslut {
            print("update failed: \(DataConnection.database!.lastErrorMessage())")
        }
        
        // since redundant checking of existing key pair would lead to redundant related dieukhoan when viewing, we should accept redundancy of data in database
        
        //        var sql = "select count(dieukhoanId) as count from tblRelatedDieukhoan where (dieukhoanId = \(dieukhoanId) and relatedDieukhoanId = \(relatedDieukhoanId)) or (dieukhoanId = \(relatedDieukhoanId) and relatedDieukhoanId = \(dieukhoanId))"
        //        let resultSet: FMResultSet! = DataConnection.database!.executeQuery(sql, withArgumentsIn: [])!
        //        if resultSet != nil {
        //            var count: Int64 = 0
        //            while resultSet.next() {
        //                count = Int64(resultSet.string(forColumn: "count")!)!
        //            }
        //            if count < 1 && dieukhoanId != relatedDieukhoanId {
        //                sql = "insert into tblRelatedDieukhoan ('dieukhoanId', 'relatedDieukhoanId') values (\(dieukhoanId),\(relatedDieukhoanId))"
        //                let reslut = DataConnection.database!.executeUpdate(sql, withArgumentsIn: appendKeyword)
        //                print("Done: \(reslut)")
        //                if !reslut {
        //                    print("update failed: \(DataConnection.database!.lastErrorMessage())")
        //                }
        //            }
        //        }
        
        DataConnection.database!.close()
    }
    
    class func searchDieukhoanByID(keyword:String,vanbanid:[String]) -> [Dieukhoan] {
        DataConnection.database!.open()
        let specificVanban = generateWhereClauseForVanbanid(vanbanid: vanbanid, vanbanIdColumnName: "vbId")
        let sql = rawSqlQuery + " dkId = ? "+specificVanban
        
        let resultSet: FMResultSet! = DataConnection.database!.executeQuery(setRecordsCap(query: sql), withArgumentsIn: [keyword,keyword,keyword,keyword])!
        
        var dieukhoanArray = Array<Dieukhoan>()
        
        if resultSet != nil {
            dieukhoanArray = generateDieukhoanList(resultSet: resultSet)
        }
        
        DataConnection.database!.close()
        
        return dieukhoanArray
    }
    
    class func searchDieukhoanBySo(keyword:String,vanbanid:[String]) -> [Dieukhoan] {
        DataConnection.database!.open()
        let specificVanban = generateWhereClauseForVanbanid(vanbanid: vanbanid, vanbanIdColumnName: "vbId")
        let sql = rawSqlQuery + "(dkSo = ? or dk.forsearch like ? or dk.forsearch like ?)" + specificVanban
        
        let resultSet: FMResultSet! = DataConnection.database!.executeQuery(setRecordsCap(query: sql), withArgumentsIn: [keyword,"\(keyword) %","\(keyword). %"])!
        
        var dieukhoanArray = Array<Dieukhoan>()
        
        if resultSet != nil {
            dieukhoanArray = generateDieukhoanList(resultSet: resultSet)
        }
        
        DataConnection.database!.close()
        
        return dieukhoanArray
    }
    
    class func searchChildren(keyword:String,vanbanid:[String]) -> [Dieukhoan] {
        DataConnection.database!.open()
        let specificVanban = generateWhereClauseForVanbanid(vanbanid: vanbanid, vanbanIdColumnName: "vbId")
        var searchArgurment = ""
        var searchKeyword = ""
        searchKeyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(searchKeyword.count == 0){
            searchArgurment = "is null"
        }else{
            searchArgurment = "= ?"
        }
        
        let sql = rawSqlQuery + "dkCha "+searchArgurment+specificVanban
        
        let resultSet: FMResultSet! = DataConnection.database!.executeQuery(setRecordsCap(query: sql), withArgumentsIn: [keyword,keyword,keyword,keyword])!
        
        var dieukhoanArray = Array<Dieukhoan>()
        
        if resultSet != nil {
            dieukhoanArray = generateDieukhoanList(resultSet: resultSet)
        }
        
        DataConnection.database!.close()
        
        return dieukhoanArray
    }
    
    class func searchMucphatInfo(id: String) -> String {
        DataConnection.database!.open()
        
        let sql = "select distinct canhanTu, canhanDen, tochucTu, tochucDen from tblMucphat where dieukhoanId = ?"
        
        let resultSet: FMResultSet! = DataConnection.database!.executeQuery(sql, withArgumentsIn: [id])!
        var result = ""
        if resultSet != nil {
            while resultSet.next() {
                let cnTu = resultSet.string(forColumn: "canhanTu")!
                let cnDen = resultSet.string(forColumn: "canhanDen")!
                let tcTu = resultSet.string(forColumn: "tochucTu")!
                let tcDen = resultSet.string(forColumn: "tochucDen")!
                if tcTu != "" && tcDen != "" {
                    result = "cá nhân: \(cnTu) - \(cnDen)\ntổ chức: \(tcTu) - \(tcDen)"
                }else{
                    if cnDen != "" {
                        if cnTu != "" {
                            result = "\(cnTu) - \(cnDen)"
                        }else{
                            result = "đến \(cnDen)"
                        }
                    }
                }
            }
        }
        
        DataConnection.database!.close()
        
        return result
        
    }
    
    class func searchPhuongtienInfo(id: String) -> String {
        DataConnection.database!.open()
        
        let sql = "select distinct oto, otoTai, maykeo, xechuyendung, tau, moto, xeganmay, xemaydien, xedapmay, xedap, xedapdien, xethoso, sucvat, xichlo, dibo from tblPhuongtien where dieukhoanId = ?"
        
        let resultSet: FMResultSet! = DataConnection.database!.executeQuery(sql, withArgumentsIn: [id])!
        var result = ""
        if resultSet != nil {
            while resultSet.next() {
                let oto = resultSet.string(forColumn: "oto")!
                let otoTai = resultSet.string(forColumn: "otoTai")!
                let maykeo = resultSet.string(forColumn: "maykeo")!
                let xechuyendung = resultSet.string(forColumn: "xechuyendung")!
                let tau = resultSet.string(forColumn: "tau")!
                let moto = resultSet.string(forColumn: "moto")!
                let xeganmay = resultSet.string(forColumn: "xeganmay")!
                let xemaydien = resultSet.string(forColumn: "xemaydien")!
                let xedapmay = resultSet.string(forColumn: "xedapmay")!
                let xedap = resultSet.string(forColumn: "xedap")!
                let xedapdien = resultSet.string(forColumn: "xedapdien")!
                let xethoso = resultSet.string(forColumn: "xethoso")!
                let sucvat = resultSet.string(forColumn: "sucvat")!
                let xichlo = resultSet.string(forColumn: "xichlo")!
                let dibo = resultSet.string(forColumn: "dibo")!
                if oto != "0" || otoTai != "0" {
                    result += "Ô tô (ô tô tải, rơ moóc), "
                }
                if maykeo != "0" || xechuyendung != "0" {
                    result += "Máy kéo (xe chuyên dùng), "
                }
                if moto != "0" || xeganmay != "0" || xemaydien != "0" {
                    result += "Xe máy, "
                }
                if xedapmay != "0" || xedap != "0" || xedapdien != "0" || xethoso != "0" || sucvat != "0" || xichlo != "0" {
                    result += "Xe thô sơ (xe súc vật kéo), "
                }
                if tau != "0" {
                    result += "Tàu hoả, "
                }
                if dibo != "0" {
                    result += "Người đi bộ, "
                }
            }
        }
        
        DataConnection.database!.close()
        if result.count >= 2 {
            result = result.substring(to: result.index(result.endIndex, offsetBy: -2))
        }
        return result
    }
    
    class func searchLinhvucInfo(id: String) -> String {
        DataConnection.database!.open()
        
        let sql = "select distinct duongbo, duongsat from tblLinhvuc where dieukhoanId = ?"
        
        let resultSet: FMResultSet! = DataConnection.database!.executeQuery(sql, withArgumentsIn: [id])!
        var result = ""
        if resultSet != nil {
            while resultSet.next() {
                let duongbo = resultSet.string(forColumn: "duongbo")!
                let duongsat = resultSet.string(forColumn: "duongsat")!
                if duongbo != "0"  && duongsat != "0"{
                    result = "Đường bộ, Đường sắt"
                }else{
                    if duongsat != "0" {
                        result = "Đường sắt"
                    }
                    if duongbo != "0" {
                        result = "Đường bộ"
                    }
                }
            }
        }
        
        DataConnection.database!.close()
        
        return result
    }
    
    //TODO: implement doituong info
    class func searchDoituongInfo(id: String) -> String {
        DataConnection.database!.open()
        
        let sql = "select distinct canhan, tochuc, doanhnghiep, trungtam, daotao, nguoidieukhien, nguoingoitrenxe, nguoiduoctro, giaovien, ga, chuphuongtien, nhanvien, dangkiemvien, laitau, truongdon, truongtau, dieukhienmaydon, trucban, duaxe, kinhdoanh, vanchuyen, vantai, hanhkhach, hanghoa, ketcau, hatang, luukho, laprap, xepdo, quanly, thuphi, dangkiem, sathach, dichvu, hotro, ghepnoi, gacchan, khamxe, thuham, phucvu, baoquan, sanxuat, hoancai, phuchoi, khaithac, baotri from tblKeywords where dieukhoanId = ?"
        
        let resultSet: FMResultSet! = DataConnection.database!.executeQuery(sql, withArgumentsIn: [id])!
        var result = ""
        if resultSet != nil {
            while resultSet.next() {
                let canhan = resultSet.string(forColumn: "canhan")!
                let tochuc = resultSet.string(forColumn: "tochuc")!
                let doanhnghiep = resultSet.string(forColumn: "doanhnghiep")!
                let trungtam = resultSet.string(forColumn: "trungtam")!
                let daotao = resultSet.string(forColumn: "daotao")!
                let nguoidieukhien = resultSet.string(forColumn: "nguoidieukhien")!
                let nguoingoitrenxe = resultSet.string(forColumn: "nguoingoitrenxe")!
                let nguoiduoctro = resultSet.string(forColumn: "nguoiduoctro")!
                let giaovien = resultSet.string(forColumn: "giaovien")!
                let ga = resultSet.string(forColumn: "ga")!
                let chuphuongtien = resultSet.string(forColumn: "chuphuongtien")!
                let nhanvien = resultSet.string(forColumn: "nhanvien")!
                let dangkiemvien = resultSet.string(forColumn: "dangkiemvien")!
                let laitau = resultSet.string(forColumn: "laitau")!
                let truongdon = resultSet.string(forColumn: "truongdon")!
                let truongtau = resultSet.string(forColumn: "truongtau")!
                let dieukhienmaydon = resultSet.string(forColumn: "dieukhienmaydon")!
                let trucban = resultSet.string(forColumn: "trucban")!
                let duaxe = resultSet.string(forColumn: "duaxe")!
                let kinhdoanh = resultSet.string(forColumn: "kinhdoanh")!
                let vantai = resultSet.string(forColumn: "vantai")!
                let hanghoa = resultSet.string(forColumn: "hanghoa")!
                let ketcau = resultSet.string(forColumn: "ketcau")!
                let hatang = resultSet.string(forColumn: "hatang")!
                let laprap = resultSet.string(forColumn: "laprap")!
                let xepdo = resultSet.string(forColumn: "xepdo")!
                let quanly = resultSet.string(forColumn: "quanly")!
                let thuphi = resultSet.string(forColumn: "thuphi")!
                let dangkiem = resultSet.string(forColumn: "dangkiem")!
                let sathach = resultSet.string(forColumn: "sathach")!
                let hotro = resultSet.string(forColumn: "hotro")!
                let ghepnoi = resultSet.string(forColumn: "ghepnoi")!
                let gacchan = resultSet.string(forColumn: "gacchan")!
                let khamxe = resultSet.string(forColumn: "khamxe")!
                let thuham = resultSet.string(forColumn: "thuham")!
                let phucvu = resultSet.string(forColumn: "phucvu")!
                let baoquan = resultSet.string(forColumn: "baoquan")!
                let sanxuat = resultSet.string(forColumn: "sanxuat")!
                let luukho = resultSet.string(forColumn: "luukho")!
                let hoancai = resultSet.string(forColumn: "hoancai")!
                let phuchoi = resultSet.string(forColumn: "phuchoi")!
                let khaithac = resultSet.string(forColumn: "khaithac")!
                let baotri = resultSet.string(forColumn: "baotri")!
                let hanhkhach = resultSet.string(forColumn: "hanhkhach")!
                let vanchuyen = resultSet.string(forColumn: "vanchuyen")!
                let dichvu = resultSet.string(forColumn: "dichvu")!
                
                if ga != "0" {
                    result += "Ga, "
                }
                if daotao != "0" {
                    result += "Cơ sở đào tạo Lái xe, "
                }
                if nhanvien != "0" && ghepnoi != "0" {
                    result += "Nhân viên ghép nối đầu máy, toa xe, "
                }
                if nhanvien != "0" && gacchan != "0" {
                    result += "Nhân viên gác chắn, "
                }
                if nhanvien != "0" && khamxe != "0" {
                    result += "NNhân viên khám xe, "
                }
                if nhanvien != "0" && khamxe != "0" && thuham != "0" {
                    result += "Nhân viên khám xe Phụ trách thử hãm, "
                }
                if nhanvien != "0" && phucvu != "0" {
                    result += "Nhân viên Phục vụ, "
                }
                //                if nhanvien != "0" && dieudo != "0" {
                //                    result += "Nhân viên điều độ chạy tàu, "
                //                }
                //                if nhanvien != "0" && ghepnoi != "0" {
                //                    result += "Nhân viên đường sắt, "
                //                }
                
                //                if dibo != "0" {
                //                    result += "Người đi bộ, "
                //                }
                if dangkiemvien != "0" {
                    result += "Đăng kiểm viên, "
                }
                if nhanvien != "0" && trungtam != "0" && dangkiem != "0" {
                    result += "Nhân viên nghiệp vụ của Trung tâm Đăng kiểm, "
                }
                if laitau != "0"{
                    result += "Lái tàu (Phụ Lái tàu), "
                }
                if truongdon != "0" {
                    result += "Trưởng dồn, "
                }
                if truongtau != "0" {
                    result += "Trưởng tàu, "
                }
                if dieukhienmaydon != "0" {
                    result += "Điều khiển máy dồn, "
                }
                if trucban != "0" {
                    result += "Trực ban chạy tàu ga, "
                }
                if canhan != "0" {
                    result += "Cá nhân, "
                }
                if chuphuongtien != "0" {
                    result += "Chủ phương tiện, "
                }
                if canhan != "0" && (kinhdoanh != "0" || hotro != "0") && vantai != "0" {
                    result += "Cá nhân kinh doanh vận tải, dịch vụ hỗ trợ vận tải, "
                }
                if giaovien != "0" {
                    result += "Giáo viên dạy Lái xe, "
                }
                if duaxe != "0" {
                    result += "Người đua xe, "
                }
                if nguoidieukhien != "0" {
                    result += "Người Điều khiển phương tiện, "
                }
                if nguoiduoctro != "0" || nguoingoitrenxe != "0" {
                    result += "Người được chở (người ngồi trên xe), "
                }
                if doanhnghiep != "0" && kinhdoanh != "0" && ketcau != "0" && hatang != "0"{
                    result += "Doanh nghiệp kinh doanh kết cấu hạ tầng đường sắt (đường bộ), "
                }
                if doanhnghiep != "0" && (luukho != "0" || baoquan != "0") && kinhdoanh != "0" && hanghoa != "0" {
                    result += "Doanh nghiệp kinh doanh lưu kho, bảo quản hàng hóa, "
                }
                if doanhnghiep != "0" && kinhdoanh != "0" && (sanxuat != "0" || laprap != "0" || hoancai != "0" || phuchoi != "0") {
                    result += "Doanh nghiệp kinh doanh sản xuất, lắp ráp, hoán cải, Phục hồi phương tiện giao thông, "
                }
                if doanhnghiep != "0" && kinhdoanh != "0" && vantai != "0" {
                    result += "Doanh nghiệp kinh doanh vận tải đường sắt, "
                }
                if doanhnghiep != "0" && kinhdoanh != "0" && xepdo != "0" && hanghoa != "0" {
                    result += "Doanh nghiệp kinh doanh xếp, dỡ hàng hóa, "
                }
                if trungtam != "0" && sathach != "0" {
                    result += "Trung tâm sát hạch Lái xe, "
                }
                if trungtam != "0" && dangkiem != "0" {
                    result += "Trung tâm Đăng kiểm, "
                }
                if tochuc != "0" && (kinhdoanh != "0" || hotro != "0") && vantai != "0" {
                    result += "Tổ chức kinh doanh vận tải, dịch vụ hỗ trợ vận tải, "
                }
                if tochuc != "0" && quanly != "0" && kinhdoanh != "0" {
                    result += "Tổ chức quản lý, kinh doanh đường sắt, "
                }
                if tochuc != "0" && thuphi != "0" {
                    result += "Tổ chức thu phí đường bộ, "
                }
                if tochuc != "0" && quanly != "0" && khaithac != "0" {
                    result += "Tổ chức Trực tiếp quản lý, khai thác phương tiện giao thông đường sắt, "
                }
                if tochuc != "0" && quanly != "0" && khaithac != "0" && baotri != "0" && ketcau != "0" && hatang != "0" {
                    result += "Tổ chức được giao quản lý, khai thác, bảo trì kết cấu hạ tầng giao thông đường bộ (đường sắt), "
                }
            }
        }
        
        DataConnection.database!.close()
        
        if result.count >= 2 {
            result = result.substring(to: result.index(result.endIndex, offsetBy: -2))
        }
        
        return result
    }
    
    class func appendDieukhoan(dieukhoan: Dieukhoan, dkArr: [Dieukhoan]) -> [Dieukhoan] {
        var dieukhoanArray = dkArr
        for dk in dieukhoanArray {
            if dieukhoan.getId() == dk.getId() {
                return dieukhoanArray
            }
        }
        dieukhoanArray.append(dieukhoan)
        return dieukhoanArray
    }
    class func getPhysicalMemorySize() -> UInt64 {
        return ProcessInfo.processInfo.physicalMemory / UInt64(1024.0 * 1024.0 * 1024.0)
    }
    
    class func setRecordsCap(query: String) -> String {
        //        let cap = GeneralSettings().getRecordCapByRam(ram: getPhysicalMemorySize())
        //
        //        //if cap equals 0, it means no cap
        //        if cap == 0 {
        return query
        //        }
        //        return  "\(query) limit \(cap)"
    }
    
    class func convertKeywordsForDifferentAccentType(keyword: String) -> [String] {
        var convertedKeyword = ""
        
        var vnChars = ["á", "à", "ả", "ã", "ạ", "a", "ấ", "ầ", "ẩ", "ẫ", "ậ", "â", "ắ", "ằ", "ẳ", "ẵ", "ặ", "ă", "é", "è", "ẻ", "ẽ", "ẹ", "e", "ế", "ề", "ể", "ễ", "ệ", "ê", "í", "ì", "ỉ", "ĩ", "ị", "i", "ó", "ò", "ỏ", "õ", "ọ", "o", "ố", "ồ", "ổ", "ỗ", "ộ", "ô", "ớ", "ờ", "ở", "ỡ", "ợ", "ơ", "ú", "ù", "ủ", "ũ", "ụ", "u", "ứ", "ừ", "ử", "ữ", "ự", "ư", "ý", "ỳ", "ỷ", "ỹ", "ỵ", "y"]
        
        let splittedStr = keyword.components(separatedBy: " ")
        
        for sStr in splittedStr {
            var matchChars = [Int16]()
            var matchAccents = [Int16]()
            for char in sStr {
                var count = 0
                for vnC in vnChars {
                    if char == vnC.first {
                        matchChars.append(Int16(count/6))
                        matchAccents.append(Int16(count%6))
                    }
                    count += 1
                }
            }
            var index = 0
            var newKeyword = sStr
            for chr in matchChars {
                newKeyword = newKeyword.replacingOccurrences(of: vnChars[Int((chr*6)+matchAccents[index])], with: vnChars[Int((chr*6)+(matchAccents[matchAccents.count - (index + 1)]))])
                index += 1
            }
            convertedKeyword += "\(newKeyword) "
        }
        var newKeys = [String]()
        newKeys.append(keyword)
        newKeys.append(convertedKeyword)
        return newKeys
    }
    
    class func generateWhereClauseForKeywordsWithDifferentAccentType(keyword: String, targetColumn: String) -> String {
        var appendString = ""
        let kw = convertKeywordsForDifferentAccentType(keyword: keyword.lowercased())
        for k in kw {
            var str = ""
            for key in k.components(separatedBy: " ") {
                str += "\(targetColumn) like '%\(key)%' and "
            }
            str = str.substring(to: str.index(str.endIndex, offsetBy: -5))
            appendString += "(\(str)) or "
        }
        appendString = appendString.substring(to: appendString.index(appendString.endIndex, offsetBy: -4))
        return appendString
    }
    
    class func generateWhereClauseForVanbanid(vanbanid: [String], vanbanIdColumnName: String) -> String {
        var specificVanban = ""
        if vanbanid.count > 0 {
            specificVanban = " and ("
            for id in vanbanid {
                if id.count > 0 {
                    specificVanban = specificVanban + "\(vanbanIdColumnName) = "+id.trimmingCharacters(in: .whitespacesAndNewlines) + " or "
                }
            }
            specificVanban = specificVanban.substring(to: specificVanban.index(specificVanban.endIndex, offsetBy: -4)) + ")"
        }
        return specificVanban
    }
    
    class func generateDieukhoanList(resultSet: FMResultSet) -> [Dieukhoan] {
        var dieukhoanArray = Array<Dieukhoan>()
        
        while resultSet.next() {
            var cha = resultSet.string(forColumn: "dkCha")
            if(cha==nil){
                cha="0"
            }
            let lvb = Loaivanban(id: Int64(resultSet.string(forColumn: "lvbId")!)!, ten: resultSet.string(forColumn: "lvbTen")!)
            let cq = Coquanbanhanh(id: Int64(resultSet.string(forColumn: "vbCoquanbanhanhid")!)!, ten: resultSet.string(forColumn: "cqTen")!)
            let vb = Vanban(id: Int64(resultSet.string(forColumn: "vbId")!)!, ten: resultSet.string(forColumn: "vbTen")!, loai: lvb, so: resultSet.string(forColumn: "vbSo")!, nam: resultSet.string(forColumn: "vbNam")!, ma: resultSet.string(forColumn: "vbMa")!, coquanbanhanh: cq, noidung: resultSet.string(forColumn: "vbNoidung")!)
            let dieukhoan = Dieukhoan(id: Int64(resultSet.string(forColumn: "dkId")!)!, so: resultSet.string(forColumn: "dkSo")!, tieude: resultSet.string(forColumn: "dkTieude")!, noidung: resultSet.string(forColumn: "dkNoidung")!, minhhoa: resultSet.string(forColumn: "dkMinhhoa")!, cha: Int64(cha!)!, vanban: vb)
            dieukhoanArray.append(dieukhoan)
        }
        
        return dieukhoanArray
    }
}

