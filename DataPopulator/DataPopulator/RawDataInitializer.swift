//
//  RawDataInitializer.swift
//  DataPopulator
//
//  Created by VietLH on 6/15/20.
//  Copyright © 2020 VietLH. All rights reserved.
//

import Foundation
class RawDataInitializer {
    private var fileName: String
    private var vanban: Vanban
    
    //let vanban = Vanban(id: 6, ten: "", loai: Loaivanban(id: 2, ten: ""), so: "100", nam: "2019", ma: "100/2019/NĐ-CP", coquanbanhanh: Coquanbanhanh(id: 2, ten: ""), noidung: "")
    
    init(fileName: String, vanban: Vanban) {
        self.fileName = fileName
        self.vanban = vanban
    }
    
    func transformData() {
        print("\n================= Transforming Raw Data ====================\n")
        print("Transforming Raw Data for ...... \(fileName)")
        //transform raw data
        transformRawDataToSqlQuery(rawData: Utils.readFromFile(name: fileName))
        
        print("Succesfully transforming raw data for: \(fileName)")
        print("\n================= Transforming Raw Data ====================\n================= Done ==================== ")
    }
    
    func transformRawDataToSqlQuery(rawData: String) {
        var currentDieukhoan = Dieukhoan(id: 0, cha: 0, vanban: vanban)
        var allDieukhoans = transformRawData(rawData: rawData)
        var finalQuery = ""
        
        
        for i in 1...allDieukhoans.count {
            var dieukhoanTree = [Dieukhoan]()
            currentDieukhoan = allDieukhoans[Int64(i)]!
            print("\n #\(currentDieukhoan.getId()) - \(currentDieukhoan.getSo()): cha: \(currentDieukhoan.getCha()) ")
            var relativeDieukhoan = allDieukhoans[Int64(i)]
            while relativeDieukhoan!.getCha() != 0 {
                let chaID = relativeDieukhoan?.getCha()
                relativeDieukhoan = allDieukhoans[chaID!]
                dieukhoanTree.append(relativeDieukhoan!)
            }
            let relative = generateDieukhoanRelationship(dieukhoanTree: dieukhoanTree)
            
            let forsearch = "\(currentDieukhoan.getSo()) \(currentDieukhoan.getTieude()) \(currentDieukhoan.getNoidung()) \(currentDieukhoan.getMinhhoa())".lowercased()
            let query = "INSERT INTO 'tblChitietvanban' ('So','tieude','noidung','minhhoa','cha','vanbanid','forSearch') VALUES ('\(currentDieukhoan.getSo())','\(currentDieukhoan.getTieude())','\(currentDieukhoan.getNoidung())','\(currentDieukhoan.getMinhhoa())',\(relative),\(currentDieukhoan.getVanban().getId()),'\(forsearch)');"
            
            //            print("\n\(query)")
            Queries.executeStatements(query: query)
            finalQuery += query
        }
    }
    
    func transformRawDataToCsv(rawData: String) {
        var currentDieukhoan = Dieukhoan(id: 0, cha: 0, vanban: vanban)
        var allDieukhoans = transformRawData(rawData: rawData)
        
        for i in 1...allDieukhoans.count {
            currentDieukhoan = allDieukhoans[Int64(i)]!
            print("\n #\(currentDieukhoan.getId()) - \(currentDieukhoan.getSo()): cha: \(currentDieukhoan.getCha()) ")
            let currentDieukhoanContent = "\n\"\(currentDieukhoan.getId())\",\"\(currentDieukhoan.getSo())\",\"\(currentDieukhoan.getTieude())\",\"\(currentDieukhoan.getNoidung())\",\"\(currentDieukhoan.getCha())\""
            Utils.writeToFile(name: "rawDataInCSV", fileContent: currentDieukhoanContent)
        }
    }
    
    func transformRawData(rawData: String) -> [Int64:Dieukhoan] {
        let rawDataLines = rawData.split(separator: "\n")
        let parentDieukhoan = Dieukhoan(id: 0, cha: 0, vanban: vanban)
        var currentDieukhoan = Dieukhoan(id: 0, cha: 0, vanban: vanban)
        let orderName = ["phần", "phụ lục","chương","mục","điều","khoản","điểm"]
        var orderDieukhoan = [String:Dieukhoan]()
        var allDieukhoans = [Int64:Dieukhoan]()
        var id = 0
        
        for line in rawDataLines {
            let strLine = line.trimmingCharacters(in: .whitespacesAndNewlines) //line is Substring while trimingCharacters returns String
            
            let prefix = search.regexSearch(pattern: "^((phần\\s[0-9]{1,3})|(phần\\sthứ\\s\\w+)|(phụ lục\\s[A-Za-z]{1,3})|(chương\\s([A-Za-z]|[0-9]){1,3})|(mục\\s\\d{1,3})|(điều \\d{1,3})|((\\d{1,3}\\.)+)|(\\w{1,2}\\)\\s))", searchIn: strLine)
            if prefix.count > 0 && prefix[0].count > 0 {
                id += 1
                var splittedStr = strLine.dropFirst(prefix[0].count).trimmingCharacters(in: .whitespacesAndNewlines)
                if splittedStr.starts(with: ".") {
                    splittedStr = splittedStr.dropFirst().trimmingCharacters(in: .whitespacesAndNewlines)
                }
                currentDieukhoan = Dieukhoan(id: Int64(id), so: strLine.prefix(prefix[0].count).trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ")", with: ""), tieude: splittedStr, noidung: "", minhhoa: "", cha: 0, vanban: vanban)
                var isOrdered = false
                parentDieukhoan.setId(id: 0)
                for order in orderName {
                    if !isOrdered {
                        if prefix[0].lowercased().starts(with: order) {
                            orderDieukhoan[order] = currentDieukhoan
                            isOrdered = true
                        } else {
                            if order == "khoản" && search.regexSearch(pattern: "^(\\d{1,3})", searchIn: prefix[0]).count > 0 && search.regexSearch(pattern: "^(\\d{1,3})", searchIn: prefix[0])[0].count > 0{
                                orderDieukhoan["khoản"] = currentDieukhoan
                                isOrdered = true
                            } else if order == "điểm" && search.regexSearch(pattern: "^\\w{1,2}\\)", searchIn: prefix[0]).count > 0 && search.regexSearch(pattern: "^\\w{1,2}\\)", searchIn: prefix[0])[0].count > 0{
                                orderDieukhoan["điểm"] = currentDieukhoan
                                isOrdered = true
                            } else if orderDieukhoan[order] != nil {
                                parentDieukhoan.setId(id: (orderDieukhoan[order]?.getId())!)
                            }
                        }
                    } else {
                        orderDieukhoan[order] = nil
                    }
                }
                currentDieukhoan.setCha(cha: parentDieukhoan.getId())
                allDieukhoans[Int64(id)] = currentDieukhoan
            }else{
                if currentDieukhoan.getTieude().count < 1 {
                    currentDieukhoan.setTieude(tieude: "\(currentDieukhoan.getNoidung())\n\(strLine)")
                } else {
                    currentDieukhoan.setNoidung(noidung: "\(currentDieukhoan.getNoidung())\n\(strLine)")
                }
            }
        }
        return allDieukhoans
    }
    
    func generateDieukhoanRelationship(dieukhoanTree:[Dieukhoan]) -> String {
        var query = ""
        if dieukhoanTree.count > 0 {
            var treeCount = dieukhoanTree.count
            while treeCount > 0 {
                if treeCount == dieukhoanTree.count {
                    query = "select id from tblChitietvanban where So = '\(dieukhoanTree[treeCount - 1].getSo())' and vanbanid = \(dieukhoanTree[treeCount - 1].getVanban().getId())"
                }else{
                    query = "select id from tblChitietvanban where So = '\(dieukhoanTree[treeCount - 1].getSo())' and cha in (\(query))"
                }
                treeCount -= 1
            }
            query = "(\(query))"
        } else {
            query = "null"
        }
        
        //        "(select id from tblChitietvanban where So = '1' and cha in (select id from tblChitietvanban where So = 'Điều 3' and cha in (select id from tblChitietvanban where So = 'Chương I' and vanbanid = 2)))"
        return query
    }
}
