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
    var search = SearchFor()
    var rawData = ""
    var allDieukhoans = [Int64:Dieukhoan]()
    
    //let vanban = Vanban(id: 6, ten: "", loai: Loaivanban(id: 2, ten: ""), so: "100", nam: "2019", ma: "100/2019/NĐ-CP", coquanbanhanh: Coquanbanhanh(id: 2, ten: ""), noidung: "")
    
    init(fileName: String, vanban: Vanban) {
        self.fileName = fileName
        self.vanban = vanban
        transformData()
    }
    
    private func transformData() {
        print("\n================= Transforming Raw Data ====================\n")
        print("Transforming Raw Data for ...... \(fileName)")
        //transform raw data
        rawData = Utils.readFromFile(name: fileName)
        print("Succesfully transforming raw data for: \(fileName)")
        print("\n================= Transforming Raw Data ====================\n================= Done ==================== ")
        
        transformRawData()
    }
    
    func transformRawDataToSqlQuery() -> String{
        var currentDieukhoan = Dieukhoan(id: 0, cha: 0, vanban: vanban)
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
            
            let forsearch = "\(currentDieukhoan.getSo()) \(currentDieukhoan.getTieude()) \(currentDieukhoan.getNoidung()) \(currentDieukhoan.getMinhhoaInString())".lowercased()
            let query = "INSERT INTO 'tblChitietvanban' ('So','tieude','noidung','minhhoa','cha','vanbanid','forSearch') VALUES ('\(currentDieukhoan.getSo())','\(currentDieukhoan.getTieude())','\(currentDieukhoan.getNoidung())','\(currentDieukhoan.getMinhhoaInString())',\(relative),\(currentDieukhoan.getVanban().getId()),'\(forsearch)');"
            
            //            print("\n\(query)")
            finalQuery += query
        }
        return finalQuery
    }
    
    func transformRawDataToCsv() {
        var currentDieukhoan = Dieukhoan(id: 0, cha: 0, vanban: vanban)
        var finalContent = "\"dkId\",\"so\",\"tieude\",\"noidung\",\"chaId\""
        
        
        for i in allDieukhoans.keys {
            currentDieukhoan = allDieukhoans[Int64(i)]!
            print("\n #\(currentDieukhoan.getId()) - \(currentDieukhoan.getSo()): cha: \(currentDieukhoan.getCha()) ")
            let currentDieukhoanContent = "\n\"\(currentDieukhoan.getId())\",\"\(currentDieukhoan.getSo())\",\"\(currentDieukhoan.getTieude().replacingOccurrences(of: "\"", with: "\"\""))\",\"\(currentDieukhoan.getNoidung().replacingOccurrences(of: "\"", with: "\"\""))\",\"\(currentDieukhoan.getCha())\""
            finalContent += currentDieukhoanContent
        }
        Utils.writeToFile(name: "rawDataInCSV", fileContent: finalContent)
    }
    
    private func transformRawData() {
        let rawDataLines = rawData.split(separator: "\n")
        let parentDieukhoan = Dieukhoan(id: 0, cha: 0, vanban: vanban)
        var currentDieukhoan = Dieukhoan(id: 0, cha: 0, vanban: vanban)
        let orderName = ["phần", "phụ lục","chương","mục","điều","khoản","điểm"]
        var orderDieukhoan = [String:Dieukhoan]()
        var id = 0
        
        for line in rawDataLines {
            let strLine = line.trimmingCharacters(in: .whitespacesAndNewlines) //line is Substring while trimingCharacters returns String
            
            let prefix = search.regexSearch(pattern: "^((phần\\s+[0-9]{1,3}(\\p{L}*))|(phần\\s+thứ\\s+\\w+)|(phụ lục\\s+[A-Za-z]{1,3})|(chương\\s+([A-Za-z]|[0-9]){1,5}(\\p{L}*))|(mục\\s+\\d{1,3}(\\p{L}*))|(điều\\s+\\d{1,3}(\\p{L}*)\\.*\\s+)|([A-Za-z]\\.\\d{1,3}(\\p{L}*)\\b\\s+)|([A-Za-z]\\.\\d{1,3}\\.\\d{1,3}\\.*\\s+)|([A-Za-z]\\d{1,3}(\\p{L}*)\\.\\d{1,3}(\\p{L}*)\\.\\b\\s+)|([A-Za-z]\\.\\d{1,3}[A-Za-z]\\b\\s+)|((\\d{1,3}(\\p{L}*)\\.)+\\s+)|(\\w{1,2}(\\)|\\.)\\s+))", searchIn: strLine)
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
                            //check if the current dieukhoan is a điều of an appendix
                            if order == "điều" && search.regexSearch(pattern: "^([A-Za-z]\\.\\d{1,3}\\b)|([A-Za-z]\\.\\d{1,3}[A-Za-z]\\b)|([A-Za-z]\\d{1,3}\\.\\b)", searchIn: prefix[0]).count > 0 && search.regexSearch(pattern: "^([A-Za-z]\\.\\d{1,3}\\b)|([A-Za-z]\\.\\d{1,3}[A-Za-z]\\b)|([A-Za-z]\\d{1,3}\\.\\b)", searchIn: prefix[0])[0].count > 0 {
                                orderDieukhoan["điều"] = currentDieukhoan
                                isOrdered = true
                            }
                                //check if the current dieukhoan is a khoản
                            else if order == "khoản" && search.regexSearch(pattern: "^((\\d{1,3}\\.)|(\\d{1,3}\\.\\d{1,3}\\.)|([A-Za-z]\\.\\d{1,3}\\.\\d{1,3}\\.\\s+)|(([A-Za-z]\\d{1,3}\\.\\d{1,3}\\.\\b)))$", searchIn: prefix[0]).count > 0 && search.regexSearch(pattern: "^((\\d{1,3}\\.)|(\\d{1,3}\\.\\d{1,3}\\.)|([A-Za-z]\\.\\d{1,3}\\.\\d{1,3}\\.\\s+)|(([A-Za-z]\\d{1,3}\\.\\d{1,3}\\.\\b)))$", searchIn: prefix[0])[0].count > 0{
                                orderDieukhoan["khoản"] = currentDieukhoan
                                isOrdered = true
                            }
                                //check if the current dieukhoan is a điểm
                            else if order == "điểm" && search.regexSearch(pattern: "^((\\w{1,2}(\\)|\\.)\\s)|(\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.))$", searchIn: prefix[0]).count > 0 && search.regexSearch(pattern: "^((\\w{1,2}(\\)|\\.)\\s)|(\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.))$", searchIn: prefix[0])[0].count > 0 {
                                //if "điểm" is not nil, its name is a mix of numbers while the current under-checking dieukhoan has its name as an alphabet, it should be noidung of the current "điểm"
                                if orderDieukhoan["điểm"] != nil && (search.regexSearch(pattern: "^(\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.)$", searchIn: (orderDieukhoan["điểm"]!.getSo())).count > 0 &&  search.regexSearch(pattern: "^(\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.)$", searchIn: (orderDieukhoan["điểm"]!.getSo()))[0].count > 0) && (search.regexSearch(pattern: "^(\\w{1,2}\\))$", searchIn: prefix[0]).count > 0 &&  search.regexSearch(pattern: "^(\\w{1,2}\\))$", searchIn: prefix[0])[0].count > 0) {
                                    if orderDieukhoan["điểm"]!.getTieude().count < 1 {
                                        orderDieukhoan["điểm"]!.setTieude(tieude: "\(orderDieukhoan["điểm"]!.getNoidung())\n\(strLine)".trimmingCharacters(in: .whitespacesAndNewlines))
                                    } else {
                                        orderDieukhoan["điểm"]!.setNoidung(noidung: "\(orderDieukhoan["điểm"]!.getNoidung())\n\(strLine)".trimmingCharacters(in: .whitespacesAndNewlines))
                                    }
                                    currentDieukhoan = orderDieukhoan["điểm"]!
                                } else {
                                    orderDieukhoan["điểm"] = currentDieukhoan
                                }
                                isOrdered = true
                            } else if orderDieukhoan[order] != nil {
                                //set the lowest dieukhoan as the parent of the checking dieukhoan
                                parentDieukhoan.setId(id: (orderDieukhoan[order]?.getId())!)
                            }
                        }
                    } else {
                        //erase all children in the tree of ordered dieukhoan
                        orderDieukhoan[order] = nil
                    }
                }
                currentDieukhoan.setCha(cha: parentDieukhoan.getId())
                allDieukhoans[Int64(currentDieukhoan.getId())] = currentDieukhoan
            }else{
                //no prefix detected then it should be either noidung or tieude
                if currentDieukhoan.getTieude().count < 1 {
                    currentDieukhoan.setTieude(tieude: "\(currentDieukhoan.getNoidung())\n\(strLine)".trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    currentDieukhoan.setNoidung(noidung: "\(currentDieukhoan.getNoidung())\n\(strLine)".trimmingCharacters(in: .whitespacesAndNewlines))
                }
            }
        }
    }
    
    private func generateDieukhoanRelationship(dieukhoanTree:[Dieukhoan]) -> String {
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
    
    //This function is only used when a data dieukhoan have minhhoa. Minhhoa file must be prepared after the data file is set. The name of the minhhoa file must have the prefix as the same as the data file the surfix as "_minhhoa". Note that the id and minhhoa must be separated by "|"
    func updateDieukhoanWithMinhhoa() {
        let minhhoaFileName = "\(fileName)_minhhoa"
        print("\n================= Transforming Raw Data ====================\n")
        print("Transforming Raw Data for ...... \(minhhoaFileName)")
        //transform raw data
        rawData = Utils.readFromFile(name: minhhoaFileName)
        print("Succesfully transforming raw data for: \(minhhoaFileName)")
        print("\n================= Transforming Raw Data ====================\n================= Done ==================== ")
        let rawDataLines = rawData.split(separator: "\n")
        for line in rawDataLines {
            let data = line.split(separator: "|")
            print("===------ Line: \n\(line)")
            let id = Int64("\(data[0])")!
            print("---- id: \(id)")
            
            if data.count > 1 && allDieukhoans[id] != nil{
                let dk = allDieukhoans[id]!
                for minhhoa in data[1].split(separator: ";") {
                    dk.addMinhhoa(minhhoa: String(minhhoa))
                }
            }else if allDieukhoans[id] == nil{
                print("---- ERROR: Dieukhoan not found: \(id) - VanbanID: \(String(describing: allDieukhoans[id]?.getVanban().getId()))")
            }else{
                print("---- No minhhoa for \(id)")
            }
        }
    }
}
