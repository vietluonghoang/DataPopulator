//
//  ViewController.swift
//  DataInitializer
//
//  Created by VietLH on 1/3/18.
//  Copyright © 2018 VietLH. All rights reserved.
//

import UIKit
import FMDB

class ViewController: UIViewController {
    //var children = [Dieukhoan]()
    var parentDieukhoan: Dieukhoan? = nil
    var rowCount = 0
    
    @IBOutlet var btnInitBienphapkhacphuc: UIButton!
    @IBOutlet var btnInitHinhphatbosung: UIButton!
    @IBOutlet var lblResult: UILabel!
    @IBOutlet var btnInitRawData: UIButton!
    @IBOutlet var btnInitLinhvuc: UIButton!
    @IBOutlet var btnInitPhuongtien: UIButton!
    @IBOutlet var btnInitMucphat: UIButton!
    @IBOutlet var btnInitKeywords: UIButton!
    
    @IBOutlet var btnQuickInit: UIButton!
    @IBOutlet var btnInitTables: UIButton!
    @IBOutlet var btnInitReleatedDieukhoan: UIButton!
    @IBOutlet var btnInitReferences: UIButton!
    @IBOutlet var btnInitVachReferences: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        if DataConnection.database == nil {
            DataConnection.databaseSetup()
        }
    }
    @IBAction func actTransformDataBtn(_ sender: Any) {
        transformData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func actInitBienphapkhacphuc(_ sender: Any) {

    }
    
    @IBAction func actInitHinhphatbosung(_ sender: Any) {

    }
    
    @IBAction func actInitBosungKhacphuc(_ sender: Any) {
        DieukhoanParser().initHinhphatbosungBienphapkhacphuc(hinhphatbosungFilename: "ND1002019hinhphatbosung", bienphapkhacphucFilename: "ND1002019bienphapkhacphuc")
    }
    
    @IBAction func actInsertDataByQueries(_ sender: Any) {
        initReferenceData(tableName: "ND1002019linhvuc")
        initReferenceData(tableName: "ND1002019phuongtien")
        initReferenceData(tableName: "ND1002019mucphat")
        initReferenceData(tableName: "ND1002019keywords")
    }
    
    @IBAction func actInitRelatedDieukhoan(_ sender: Any) {
        DieukhoanParser().initRelatedDieukhoan()
    }
    
    @IBAction func actInitLinhvuc(_ sender: Any) {
       
    }
    
    @IBAction func actInitPhuongtien(_ sender: Any) {
        
    }
    
    @IBAction func actInitMucphat(_ sender: Any) {
        
    }
    
    @IBAction func actInitKeywords(_ sender: Any) {
        
    }
    
    @IBAction func actInitPlateReferences(_ sender: Any) {
       
    }
    
    @IBAction func actInitVachReferences(_ sender: Any) {
      
    }
    
    @IBAction func actQuickInit(_ sender: Any) {
        print("=====================================")
        print("Quick Initializing......")
//        initTables()
//        initRawData()
//        initRelatedDieukhoan()
//        initDataForBienphapkhacphuchauqua()
//        initDataForHinhphatbosung()
//        initReferenceData(tableName: "ND462016linhvuc")
//        initReferenceData(tableName: "ND1002019linhvuc")
//        initReferenceData(tableName: "ND462016phuongtien")
//        initReferenceData(tableName: "ND1002019phuongtien")
//        initReferenceData(tableName: "ND462016mucphat")
//        initReferenceData(tableName: "ND1002019mucphat")
//        initReferenceData(tableName: "ND462016keywords")
//        initReferenceData(tableName: "ND1002019keywords")
//        initPlateReferences()
//        initVachReferences()
        print("Succesfully Quick Initializing")
        print("=====================================")
    }
    
//    func initTables() {
//        print("=====================================")
//        print("Creating new tables......")
//        //create new tables
//        Queries.executeStatements(query: Utils.readFromFile(name: "tables"))
//
//        print("Succesfully created tables")
//        print("=====================================")
//    }
    
   
    
    
    
//    func initRawData() {
//        print("================= Init Raw Data ====================")
//        let fileNames = ["QC412016","ND462016","TT012016","LGTDB2008","LXLVPHC2012"]
//        for fname in fileNames {
//            print("Init Raw Data for ...... \(fname)")
//            //init raw data
//            Queries.executeStatements(query: Utils.readFromFile(name: fname))
//
//            print("Succesfully init raw data for: \(fname)")
//        }
//        transformData()
//        print("================= Init Raw Data ==================== Done")
//    }
    
    func initReferenceData(tableName: String) {
        print("=====================================")
        print("Initializing \(tableName)......")
        //create new tables
        Queries.executeStatements(query: Utils.readFromFile(name: tableName))
        
        print("Succesfully initializing \(tableName)")
        print("=====================================")
    }
    
    func initPlateReferences() {
        let fileName = "QC412016Bienbao"
        print("=====================================")
        print("Initializing \(fileName)......")
        //create new tables and insert data
        Queries.executeStatements(query: Utils.readFromFile(name: fileName))
        
        print("Succesfully initializing \(fileName)")
        print("=====================================")
    }
    
    func initVachReferences() {
        let fileName = "QC412016Vachke"
        print("=====================================")
        print("Initializing \(fileName)......")
        //create new tables and insert data
        Queries.executeStatements(query: Utils.readFromFile(name: fileName))
        
        print("Succesfully initializing \(fileName)")
        print("=====================================")
    }
    
    func transformData() {
        DatabaseInitializer().initDatabase()
        
    }
//
//    func transformRawDataToSqlQuery(rawData: String) {
//        let rawDataLines = rawData.split(separator: "\n")
//        let vanban = Vanban(id: 6, ten: "", loai: Loaivanban(id: 2, ten: ""), so: "100", nam: "2019", ma: "100/2019/NĐ-CP", coquanbanhanh: Coquanbanhanh(id: 2, ten: ""), noidung: "")
//        let parentDieukhoan = Dieukhoan(id: 0, cha: 0, vanban: vanban)
//        var currentDieukhoan = Dieukhoan(id: 0, cha: 0, vanban: vanban)
//        var allDieukhoans = [Int64:Dieukhoan]()
//        let orderName = ["phần","chương","mục","điều","khoản","điểm"]
//        var orderDieukhoan = [String:Dieukhoan]()
//        var finalQuery = ""
//        var id = 0
//        for line in rawDataLines {
//            let strLine = line.trimmingCharacters(in: .whitespacesAndNewlines) //line is Substring while trimingCharacters returns String
//
//            let prefix = search.regexSearch(pattern: "^((chương\\s[A-Z]{1,3})|(mục\\s\\d{1,3})|(điều \\d{1,3})|(\\d{1,3})|(\\w{1,2}\\)\\s))", searchIn: strLine)
//            if prefix.count > 0 && prefix[0].count > 0 {
//                id += 1
//                var splittedStr = strLine.dropFirst(prefix[0].count).trimmingCharacters(in: .whitespacesAndNewlines)
//                if splittedStr.starts(with: ".") {
//                    splittedStr = splittedStr.dropFirst().trimmingCharacters(in: .whitespacesAndNewlines)
//                }
//                currentDieukhoan = Dieukhoan(id: Int64(id), so: strLine.prefix(prefix[0].count).trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ")", with: ""), tieude: splittedStr, noidung: "", minhhoa: "", cha: 0, vanban: vanban)
//                var isOrdered = false
//                parentDieukhoan.setId(id: 0)
//                for order in orderName {
//                    if !isOrdered {
//                        if prefix[0].lowercased().starts(with: order) {
//                            orderDieukhoan[order] = currentDieukhoan
//                            isOrdered = true
//                        } else {
//                            if order == "khoản" && search.regexSearch(pattern: "^(\\d{1,3})", searchIn: prefix[0]).count > 0 && search.regexSearch(pattern: "^(\\d{1,3})", searchIn: prefix[0])[0].count > 0{
//                                orderDieukhoan["khoản"] = currentDieukhoan
//                                isOrdered = true
//                            } else if order == "điểm" && search.regexSearch(pattern: "^\\w{1,2}\\)", searchIn: prefix[0]).count > 0 && search.regexSearch(pattern: "^\\w{1,2}\\)", searchIn: prefix[0])[0].count > 0{
//                                orderDieukhoan["điểm"] = currentDieukhoan
//                                isOrdered = true
//                            } else if orderDieukhoan[order] != nil {
//                                parentDieukhoan.setId(id: (orderDieukhoan[order]?.getId())!)
//                            }
//                        }
//                    } else {
//                        orderDieukhoan[order] = nil
//                    }
//                }
//                currentDieukhoan.setCha(cha: parentDieukhoan.getId())
//                allDieukhoans[Int64(id)] = currentDieukhoan
//            }else{
//                if currentDieukhoan.getTieude().count < 1 {
//                    currentDieukhoan.setTieude(tieude: "\(currentDieukhoan.getNoidung())\n\(strLine)")
//                } else {
//                    currentDieukhoan.setNoidung(noidung: "\(currentDieukhoan.getNoidung())\n\(strLine)")
//                }
//            }
//        }
//        for i in 1...allDieukhoans.count {
//            var dieukhoanTree = [Dieukhoan]()
//            currentDieukhoan = allDieukhoans[Int64(i)]!
//            print("\n #\(currentDieukhoan.getId()) - \(currentDieukhoan.getSo()): cha: \(currentDieukhoan.getCha()) ")
//            var relativeDieukhoan = allDieukhoans[Int64(i)]
//            while relativeDieukhoan!.getCha() != 0 {
//                let chaID = relativeDieukhoan?.getCha()
//                relativeDieukhoan = allDieukhoans[chaID!]
//                dieukhoanTree.append(relativeDieukhoan!)
//            }
//            let relative = generateDieukhoanRelationship(dieukhoanTree: dieukhoanTree)
//
//            let forsearch = "\(currentDieukhoan.getSo()) \(currentDieukhoan.getTieude()) \(currentDieukhoan.getNoidung()) \(currentDieukhoan.getMinhhoa())".lowercased()
//            let query = "INSERT INTO 'tblChitietvanban' ('So','tieude','noidung','minhhoa','cha','vanbanid','forSearch') VALUES ('\(currentDieukhoan.getSo())','\(currentDieukhoan.getTieude())','\(currentDieukhoan.getNoidung())','\(currentDieukhoan.getMinhhoa())',\(relative),\(currentDieukhoan.getVanban().getId()),'\(forsearch)');"
//
////            print("\n\(query)")
//            Queries.executeStatements(query: query)
//            finalQuery += query
//        }
//    }
//
//    func generateDieukhoanRelationship(dieukhoanTree:[Dieukhoan]) -> String {
//        var query = ""
//        if dieukhoanTree.count > 0 {
//            var treeCount = dieukhoanTree.count
//            while treeCount > 0 {
//                if treeCount == dieukhoanTree.count {
//                    query = "select id from tblChitietvanban where So = '\(dieukhoanTree[treeCount - 1].getSo())' and vanbanid = \(dieukhoanTree[treeCount - 1].getVanban().getId())"
//                }else{
//                    query = "select id from tblChitietvanban where So = '\(dieukhoanTree[treeCount - 1].getSo())' and cha in (\(query))"
//                }
//                treeCount -= 1
//            }
//            query = "(\(query))"
//        } else {
//            query = "null"
//        }
//
////        "(select id from tblChitietvanban where So = '1' and cha in (select id from tblChitietvanban where So = 'Điều 3' and cha in (select id from tblChitietvanban where So = 'Chương I' and vanbanid = 2)))"
//        return query
//    }
    
    
    
    
    
//    func getRelatedChildren(keyword:String) -> [Dieukhoan] {
//        if DataConnection.database == nil {
//            DataConnection.databaseSetup()
//        }
//        return Queries.searchDieukhoan(keyword: "\(keyword)", vanbanid: specificVanbanId)
//    }
    
    
    
    
    
    
    
//    func getParent(keyword:String) -> [Dieukhoan] {
//        if DataConnection.database == nil {
//            DataConnection.databaseSetup()
//        }
//        return Queries.searchDieukhoanByID(keyword: "\(keyword)", vanbanid: specificVanbanId)
//    }
    
    
}

