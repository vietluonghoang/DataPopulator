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
    var specificVanbanId = [String]()
    var dieukhoan: Dieukhoan? = nil
    //var children = [Dieukhoan]()
    var relatedChildren = [Dieukhoan]()
    var settings = GeneralSettings()
    var parentDieukhoan: Dieukhoan? = nil
    var search = SearchFor()
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
        initDataForBienphapkhacphuchauqua()
    }
    
    @IBAction func actInitHinhphatbosung(_ sender: Any) {
        initDataForHinhphatbosung()
    }
    
    @IBAction func actInitRelatedDieukhoan(_ sender: Any) {
        initRelatedDieukhoan()
    }
    
    @IBAction func actInitTables(_ sender: Any) {
        initTables()
    }
    
    @IBAction func actInitRawData(_ sender: Any) {
        initRawData()
    }
    
    @IBAction func actInitLinhvuc(_ sender: Any) {
        initReferenceData(tableName: "ND462016linhvuc")
    }
    
    @IBAction func actInitPhuongtien(_ sender: Any) {
        initReferenceData(tableName: "ND462016phuongtien")
    }
    
    @IBAction func actInitMucphat(_ sender: Any) {
        initReferenceData(tableName: "ND462016mucphat")
    }
    
    @IBAction func actInitKeywords(_ sender: Any) {
        initReferenceData(tableName: "ND462016keywords")
    }
    
    @IBAction func actInitPlateReferences(_ sender: Any) {
        initPlateReferences()
    }
    
    @IBAction func actInitVachReferences(_ sender: Any) {
        initVachReferences()
    }
    
    @IBAction func actQuickInit(_ sender: Any) {
        print("=====================================")
        print("Quick Initializing......")
        initTables()
        initRawData()
        initRelatedDieukhoan()
        initDataForBienphapkhacphuchauqua()
        initDataForHinhphatbosung()
        initReferenceData(tableName: "ND462016linhvuc")
        initReferenceData(tableName: "ND1002019linhvuc")
        initReferenceData(tableName: "ND462016phuongtien")
        initReferenceData(tableName: "ND1002019phuongtien")
        initReferenceData(tableName: "ND462016mucphat")
        initReferenceData(tableName: "ND1002019mucphat")
        initReferenceData(tableName: "ND462016keywords")
        initReferenceData(tableName: "ND1002019keywords")
        initPlateReferences()
        initVachReferences()
        print("Succesfully Quick Initializing")
        print("=====================================")
    }
    
    func initTables() {
        print("=====================================")
        print("Creating new tables......")
        //create new tables
        Queries.executeStatements(query: Utils.readFromFile(name: "tables"))
        
        print("Succesfully created tables")
        print("=====================================")
    }
    
    func initDataForBienphapkhacphuchauqua() {
        print("Bienphapkhacphuc=====================================")
        // insert raw data for bien phap khac phuc
        Queries.executeStatements(query: Utils.readFromFile(name: "ND462016bienphapkhacphuc"))
        Queries.executeStatements(query: Utils.readFromFile(name: "ND1002019bienphapkhacphuc"))
        // populate data
        insertDataForBosungKhacphuc(type: "bpkp")
        
        //remove raw data
        Queries.executeDeleteQuery(query: "delete from tblBienphapkhacphuc where dieukhoanId is null")
        print("Bienphapkhacphuc===================================== Done")
    }
    
    func initDataForHinhphatbosung() {
        print("\n\n\nHinhphatbosung=====================================")
        // insert raw data for hinh phat bo sung
        Queries.executeStatements(query: Utils.readFromFile(name: "ND462016hinhphatbosung"))
        Queries.executeStatements(query: Utils.readFromFile(name: "ND1002019hinhphatbosung"))
        // populate data
        insertDataForBosungKhacphuc(type: "hpbs")
        
        // remove raw data
        Queries.executeDeleteQuery(query: "delete from tblHinhphatbosung where dieukhoanId is null")
        // remove redundant data
        Queries.executeDeleteQuery(query: "delete from tblhinhphatbosung where exists (select * from tblBienphapkhacphuc AS kp where  tblhinhphatbosung.dieukhoanid = kp.dieukhoanId and tblhinhphatbosung.dieukhoanquydinhid = kp.dieukhoanquydinhid)")
        print("\n\n\nHinhphatbosung===================================== Done")
    }
    
    func insertDataForBosungKhacphuc(type: String) {
        for dk in Queries.getAllBienphapkhacphucAndHinhphatbosung(type: type) {
            specificVanbanId = []
            specificVanbanId.append( String(describing:dk.getVanban().getId()))
            
            updateDetails(dieukhoan: dk)
            for rel in relatedChildren{
                let childrenList = getChildren(keyword: "\(rel.getId())")
                Queries.insertBienphapkhacphucAndHinhphatbosung(type: type, dieukhoanId: rel.getId(), dieukhoanQuydinhId: dk.getId(), noidung: dk.getNoidung())
                for child in childrenList {
                    let grandChildrenList = getChildren(keyword: "\(child.getId())")
                    for grandChild in grandChildrenList {
                        Queries.insertBienphapkhacphucAndHinhphatbosung(type: type, dieukhoanId: grandChild.getId(), dieukhoanQuydinhId: dk.getId(), noidung: dk.getNoidung())
                    }
                    Queries.insertBienphapkhacphucAndHinhphatbosung(type: type, dieukhoanId: child.getId(), dieukhoanQuydinhId: dk.getId(), noidung: dk.getNoidung())
                }
            }
        }
    }
    
    func initRelatedDieukhoan() {
        print("=============== Related Dieukhoan ======================")
        //                for dk in Queries.searchDieukhoanByQuery(query: "\(Queries.rawSqlQuery) dkId = 1379", vanbanid: ["1","2","3","4","5"]) {
        for dk in Queries.selectAllDieukhoan() {
            specificVanbanId = []
            specificVanbanId.append( String(describing:dk.getVanban().getId()))
            //            print("--------- dkId: \(dk.getId())")
            updateDetails(dieukhoan: dk)
            for rel in relatedChildren{
                Queries.insertRelatedDieukhoan(dieukhoanId: dk.getId(), relatedDieukhoanId: rel.getId())
            }
            print("\(dk.getId()) --------- Done")
        }
        print("=============== Related Dieukhoan ====================== Done")
    }
    
    func initRawData() {
        print("================= Init Raw Data ====================")
        let fileNames = ["QC412016","ND462016","TT012016","LGTDB2008","LXLVPHC2012"]
        for fname in fileNames {
            print("Init Raw Data for ...... \(fname)")
            //init raw data
            Queries.executeStatements(query: Utils.readFromFile(name: fname))
            
            print("Succesfully init raw data for: \(fname)")
        }
        transformData()
        print("================= Init Raw Data ==================== Done")
    }
    
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
        print("\n================= Transforming Raw Data ====================\n")
        let nd1002019 = Vanban(
                        id: 6
                        , ten: ""
                        , loai: Loaivanban(id: 2, ten: "")
                        , so: "100"
                        , nam: "2019"
                        , ma: "100/2019/NĐ-CP"
                        , coquanbanhanh: Coquanbanhanh(id: 2, ten: "")
                        , noidung: ""
                    )
        let fileNames = ["ND1002019_raw_parser"]
        let vanbans = [nd1002019]
        
        for i in 0...fileNames.count {
            print("Transforming Raw Data for ...... \(fname)")
            //transform raw data
//            transformRawDataToSqlQuery(rawData: Utils.readFromFile(name: fname))
            RawDataInitializer(fileName: fileNames[i], vanban: vanbans[i]).transformData()
            print("Succesfully transforming raw data for: \(fname)")
        }
        print("\n================= Transforming Raw Data ====================\n================= Done ==================== ")
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
    
    func updateDetails(dieukhoan: Dieukhoan) {
        relatedChildren = [Dieukhoan]()
        self.dieukhoan = dieukhoan
        specificVanbanId.append( String(describing:dieukhoan.getVanban().getId()))
        let noidung = "\(String(describing: dieukhoan.getTieude())) \n \(String(describing: dieukhoan.getNoidung()))"
        
        for child in getRelatedDieukhoan(noidung: noidung) {
            relatedChildren.append(child)
        }
        let relatedPlateKeywords = getRelatedPlatKeywords(content: noidung)
        var sortedRelatedPlat = [Dieukhoan]()
        let sortIt = SortUtil()
        
        for k in relatedPlateKeywords {
            let key = k.lowercased()
            var finalQuery = ""
            if key.count > 0 {
                finalQuery = Queries.rawSqlQuery + " (dkCha in (select id from tblChitietvanban where forsearch like 'phụ lục%') or dkCha in (select id from tblchitietvanban where cha in (select id from tblChitietvanban where forsearch like 'phụ lục%')) or dkCha in (select id from tblchitietvanban where cha in (select id from tblchitietvanban where cha in (select id from tblChitietvanban where forsearch like 'phụ lục%')))) and (forsearch like '% \(key) %' or forsearch like '% \(key)%' or forsearch like '% \(key)_ %')"
                let relatedChild = Queries.searchDieukhoanByQuery(query: finalQuery, vanbanid: ["\(settings.getQC41ID())"])
                var sortedRelatedChild = [Dieukhoan]();
                let keyPatern = "(\\b\(key)\\b)|(\\b\(key)\\p{L})"
                
                for rChild in relatedChild {
                    if search.regexSearch(pattern: keyPatern, searchIn: "\(rChild.getTieude()) \(rChild.getNoidung())" ).count > 0 {
                        sortedRelatedChild.append(rChild)
                    }
                }
                sortedRelatedPlat.append(contentsOf: sortIt.sortByBestMatch(listDieukhoan: sortedRelatedChild, keyword: key))
            }
        }
        
        for relatedPlateItem in sortIt.sortBySortPoint(listDieukhoan: sortedRelatedPlat,isAscending: true) {
            appendRelatedChild(child: relatedPlateItem)
        }
        
        //        for parent in getParent(keyword: String(describing: dieukhoan.cha)) {
        //            parentDieukhoan = parent
        //        }
        
    }
    
    func appendRelatedChild(child: Dieukhoan) {
        if child.id != self.dieukhoan?.id {
            var isExisted = false
            for c in relatedChildren {
                if c.getId() == child.getId(){
                    isExisted = true
                    break
                }
            }
            if !isExisted {
                relatedChildren.append(child)
            }
        }
    }
    
    func getRelatedChildren(keyword:String) -> [Dieukhoan] {
        if DataConnection.database == nil {
            DataConnection.databaseSetup()
        }
        return Queries.searchDieukhoan(keyword: "\(keyword)", vanbanid: specificVanbanId)
    }
    
    func getRelatedDieukhoan(noidung:String) -> [Dieukhoan] {
        //                var nd = "Xe quy định tại các điểm a, b, c và d khoản 1 Điều này khi đi làm nhiệm vụ phải có tín hiệu còi, cờ, đèn theo quy định; không bị hạn chế tốc độ; được phép đi vào đường ngược chiều, các đường khác có thể đi được, kể cả khi có tín hiệu đèn đỏ và chỉ phải tuân theo chỉ dẫn của người điều khiển giao thông.".lowercased()
        
        var nd = noidung.lowercased()
        var keywords = [String]()
        var relatedDieukhoan = [Dieukhoan]()
        var pattern = "(((\\s*(các\\s)*điểm(\\s+((\\p{L}{1})|(\\d\\.*)+)\\b((\\s*,)|(\\s*và))*)+)*(\\s*(các\\s)*khoản(\\s+((\\p{L}{1})|(\\d\\.*)+|(này))\\b((\\s*,)|(\\s*;)|(\\s*và))*)+)+)*(\\s*và)*(\\s*(các\\s)*điều(\\s+((\\d\\.*)+|(này))\\b((\\s*,)|(\\s*;)|(\\s*và))*)+)+)*(\\s*và)*((\\s*(các\\s)*(phụ lục)(\\s+((\\d\\.*)+|(\\p{L}{1,4})|(này))\\b((\\s*,)|(\\s*;)|(\\s*và))*)+)+)*\\s*(((của)|(tại)|(theo))*\\s*((luật)|(nghị định)|(quy chuẩn)|(thông tư))\\s*((này)|(giao thông đường bộ)|(xử lý vi phạm hành chính)))"
        let vanbanPattern = "(((của)|(tại)|(theo))*\\s*((luật)|(nghị định)|(quy chuẩn)|(thông tư))\\s*((này)|(giao thông đường bộ)|(xử lý vi phạm hành chính)))"
        
        let fullMatches = search.regexSearch(pattern: pattern, searchIn: nd)
        
        for var fmatch in fullMatches {
            for vbMatch in search.regexSearch(pattern: vanbanPattern, searchIn: fmatch) {
                if vbMatch.contains("này") {
                    specificVanbanId = [String(describing: dieukhoan!.getVanban().getId())]
                }
                if vbMatch.contains("luật giao thông") {
                    specificVanbanId = [settings.getLGTID()]
                }
                if vbMatch.contains("luật xử lý vi phạm hành chính") {
                    specificVanbanId = [settings.getLXLVPHCID()]
                }
                if vbMatch.contains("nghị định 46") {
                    specificVanbanId = [settings.getND46ID()]
                }
                if vbMatch.contains("thông tư 01") {
                    specificVanbanId = [settings.getTT01ID()]
                }
                if vbMatch.contains("quy chuẩn 41") {
                    specificVanbanId = [settings.getQC41ID()]
                }
            }
            //remove matches found
            nd = nd.replacingOccurrences(of: fmatch, with: "")
            
            pattern = "(\\s*(các\\s)*(phụ lục)(\\s+((\\d\\.*)+|(\\p{L}{1})|(này))\\b((\\s*,)|(\\s*;)|(\\s*và))*)+)"
            
            let phulucMatches = search.regexSearch(pattern: pattern, searchIn: fmatch)
            
            for pl in phulucMatches {
                if(!search.isStringExisted(str: pl.trimmingCharacters(in: .whitespacesAndNewlines), strArr: keywords)){
                    keywords.append(pl.trimmingCharacters(in: .whitespacesAndNewlines))
                }
                fmatch = fmatch.replacingOccurrences(of: pl, with: "")
            }
            
            //            pattern = "((điểm\\s+(((\\p{L}{1})|(\\d\\.*)+)(,|;)*\\s+(và)*\\s*)+)*(khoản\\s+(((này)|(\\d\\.*)+)(,|;)*\\s*(và)*\\s*)+)+)*((điều\\s+(((này)|(\\d\\.*)+)(,|;)*\\s*(và)*\\s*)+)+)+"
            
            pattern = "(((\\s*(các\\s)*điểm(\\s+((\\p{L}{1})|(\\d\\.*)+)\\b((\\s*,)|(\\s*và))*)+)*(\\s*(các\\s)*khoản(\\s+((\\p{L}{1})|(\\d\\.*)+|(này))\\b((\\s*,)|(\\s*;)|(\\s*và))*)+)+)*(\\s*và)*(\\s*(các\\s)*điều(\\s+((\\d\\.*)+|(này))\\b((\\s*,)|(\\s*;)|(\\s*và))*)+)+)"
            
            let longMatches = search.regexSearch(pattern: pattern, searchIn: fmatch)
            
            for match in longMatches{
                if(!search.isStringExisted(str: match.trimmingCharacters(in: .whitespacesAndNewlines), strArr: keywords)){
                    keywords.append(match.trimmingCharacters(in: .whitespacesAndNewlines))
                }
            }
            //add all full-matched dieukhoan
            for key in keywords {
                let dk = parseRelatedDieukhoan(keyword: key)
                if dk.count > 0{
                    for dkh in dk {
                        relatedDieukhoan.append(dkh)
                    }
                }
            }
        }
        
        keywords = [String]()
        
        specificVanbanId = [String(describing: dieukhoan!.getVanban().getId())]
        
        pattern = "(\\s*(các\\s)*(phụ lục)(\\s+((\\d\\.*)+|(\\p{L}{1})|(này))\\b((\\s*,)|(\\s*;)|(\\s*và))*)+)"
        
        let phulucMatches = search.regexSearch(pattern: pattern, searchIn: nd)
        
        for pl in phulucMatches {
            if(!search.isStringExisted(str: pl.trimmingCharacters(in: .whitespacesAndNewlines), strArr: keywords)){
                keywords.append(pl.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            nd = nd.replacingOccurrences(of: pl, with: "")
        }
        
        //        pattern = "((điểm\\s+(((\\p{L}{1})|(\\d\\.*)+)(,|;)*\\s+(và)*\\s*)+)*(khoản\\s+(((này)|(\\d\\.*)+)(,|;)*\\s*(và)*\\s*)+)+)+((điều\\s+(((này)|(\\d\\.*)+)(,|;)*\\s*(và)*\\s*)+)+)+"
        
        pattern = "(((\\s*(các\\s)*điểm(\\s+((\\p{L}{1})|(\\d\\.*)+)\\b((\\s*,)|(\\s*và))*)+)*(\\s*(các\\s)*khoản(\\s+((\\p{L}{1})|(\\d\\.*)+|(này))\\b((\\s*,)|(\\s*;)|(\\s*và))*)+)+)*(\\s*và)*(\\s*(các\\s)*điều(\\s+((\\d\\.*)+|(này))\\b((\\s*,)|(\\s*;)|(\\s*và))*)+)+)"
        
        let longMatches = search.regexSearch(pattern: pattern, searchIn: nd)
        
        for var lmatch in longMatches{
            nd = nd.replacingOccurrences(of: lmatch, with: "")
            if lmatch.contains("điều này") {
                if lmatch.replacingOccurrences(of: "điều này", with: "").count > 0 {
                    lmatch = lmatch.replacingOccurrences(of: "điều này", with: search.getDieunay(currentDieukhoan: dieukhoan!, vanbanId: specificVanbanId).getSo()).trimmingCharacters(in: .whitespacesAndNewlines)
                }else {
                    lmatch = "" // if there are no khoan indicated, this is not a valid reference.
                }
            }
            if(lmatch.count > 0 && !search.isStringExisted(str: lmatch.trimmingCharacters(in: .whitespacesAndNewlines), strArr: keywords)){
                keywords.append(lmatch.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        
        pattern = "((\\s*(các\\s)*điểm(\\s+((\\p{L}{1})|(\\d\\.*)+)\\b((\\s*,)|(\\s*và))*)+)*(\\s*(các\\s)*khoản(\\s+((\\p{L}{1})|(\\d\\.*)+|(này))\\b((\\s*,)|(\\s*;)|(\\s*và))*)+)+)"
        
        let shortMatches = search.regexSearch(pattern: pattern, searchIn: nd)
        
        for var smatch in shortMatches{
            nd = nd.replacingOccurrences(of: smatch, with: "")
            
            if smatch.contains("điều này") {
                if smatch.replacingOccurrences(of: "điều này", with: "").count > 0 {
                    smatch = smatch.replacingOccurrences(of: "điều này", with: search.getDieunay(currentDieukhoan: dieukhoan!, vanbanId: specificVanbanId).getSo()).trimmingCharacters(in: .whitespacesAndNewlines)
                }else {
                    smatch = "" // if there are no khoan indicated, this is not a valid reference.
                }
            }else{
                smatch = smatch + " " + search.getDieunay(currentDieukhoan: dieukhoan!, vanbanId: specificVanbanId).getSo().trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            if smatch.contains("khoản này") {
                smatch = smatch.replacingOccurrences(of: "khoản này", with: search.getKhoannay(currentDieukhoan: dieukhoan!, vanbanId: specificVanbanId).getSo()).trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            if(smatch.count > 0 && !search.isStringExisted(str: smatch.trimmingCharacters(in: .whitespacesAndNewlines), strArr: keywords)){
                keywords.append(smatch.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        
        for key in keywords {
            let dk = parseRelatedDieukhoan(keyword: key)
            if dk.count > 0{
                for dkh in dk {
                    relatedDieukhoan.append(dkh)
                }
            }
        }
        
        return relatedDieukhoan
    }
    
    func parseRelatedDieukhoan(keyword: String) -> [Dieukhoan] {
        let key = keyword.lowercased()
        //                        let key = "điều 9, điều 10, điều 11, điều 12;".lowercased()
        var relatedDieukhoan = [Dieukhoan]()
        var finalQuery = ""
        
        if key.contains("phụ lục") {
            var convertedPhuluc = key.replacingOccurrences(of: " và", with: ",")
            convertedPhuluc = convertedPhuluc.replacingOccurrences(of: ";", with: ",")
            var phuluc = [String]()
            var tempQuery = ""
            if search.regexSearch(pattern: "(((\\d\\.*)+|(\\p{L}{1}))+,\\s*((\\d\\.*)+|(\\p{L}{1}))+)+", searchIn: convertedPhuluc).count > 0 {
                convertedPhuluc = convertedPhuluc.replacingOccurrences(of: "phụ lục", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                for eachPl in convertedPhuluc.components(separatedBy: ","){
                    if(!search.isStringExisted(str: eachPl.trimmingCharacters(in: .whitespacesAndNewlines), strArr: phuluc) && eachPl.count > 0){
                        phuluc.append("phụ lục "+eachPl.trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                }
            }else{
                for var pl in search.regexSearch(pattern: "(phụ lục)(\\s+((\\d\\.*)+|(\\p{L}{1})|(này))\\b)", searchIn: convertedPhuluc) {
                    pl = pl.replacingOccurrences(of: ",", with: "")
                    if(!search.isStringExisted(str: pl.trimmingCharacters(in: .whitespacesAndNewlines), strArr: phuluc)){
                        phuluc.append(pl.trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                }
                
            }
            
            for pl in phuluc {
                tempQuery += "forsearch like \"\(pl) %\" or forsearch like \"\(pl). %\" or "
            }
            
            finalQuery = "(\(tempQuery.substring(to: tempQuery.index(tempQuery.endIndex, offsetBy: -4)))) and vanbanid = \(specificVanbanId[0])"
        }else{
            
            var pattern = "(((\\s*(các\\s)*điểm(\\s+((\\p{L}{1})|(\\d\\.*)+)\\b((\\s*,)|(\\s*và))*)+)*(\\s*(các\\s)*khoản(\\s+((\\p{L}{1})|(\\d\\.*)+|(này))\\b((\\s*,)|(\\s*;)|(\\s*và))*)+)+)*(\\s*và)*(\\s*(các\\s)*điều(\\s+((\\d\\.*)+|(này))\\b((\\s*,)|(\\s*và))*)+)+)"
            
            let dieukhoanForm = search.regexSearch(pattern: pattern, searchIn: key)
            
            for dkForm in dieukhoanForm {
                pattern = "(\\s*(các\\s)*điều(\\s+((\\d\\.*)+|(này))\\b((\\s*,)|(\\s*và))*)+)+"
                let dieuMatches = search.regexSearch(pattern: pattern, searchIn: dkForm)
                for var dm in dieuMatches{
                    dm = dm.replacingOccurrences(of: "các", with: "")
                    dm = dm.replacingOccurrences(of: " và", with: ",")
                    dm = dm.replacingOccurrences(of: ";", with: ",")
                    var dieu = [String]()
                    var dieuQuery = ""
                    var tempQuery = ""
                    if search.regexSearch(pattern: "(\\d+,\\s*\\d+)+", searchIn: dm).count > 0 {
                        dm = dm.replacingOccurrences(of: "điều", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                        for var eachDm in dm.components(separatedBy: ","){
                            eachDm = "điều " + eachDm.trimmingCharacters(in: .whitespacesAndNewlines)
                            if(!search.isStringExisted(str: eachDm, strArr: dieu) && eachDm.count > 0){
                                dieu.append(eachDm)
                            }
                        }
                    }else{
                        //                        dm = dm.replacingOccurrences(of: ",", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                        let dmList = dm.split(separator: ",")
                        for dl in dmList {
                            if(!search.isStringExisted(str: dl.trimmingCharacters(in: .whitespacesAndNewlines), strArr: dieu)){
                                dieu.append(String(dl.trimmingCharacters(in: .whitespacesAndNewlines)))
                            }
                        }
                    }
                    
                    for d  in dieu {
                        tempQuery += "forsearch like \"\(d) %\" or forsearch like \"\(d). %\" or "
                    }
                    
                    dieuQuery = "select distinct id from tblChitietvanban where (\(tempQuery.substring(to: tempQuery.index(tempQuery.endIndex, offsetBy: -4)))) and vanbanid = \(specificVanbanId[0])"
                    
                    pattern = "(\\s*(các\\s)*điểm(\\s+((\\p{L}{1})|(\\d\\.*)+)\\b((\\s*,)|(\\s*và))*)+)*(\\s*(các\\s)*khoản(\\s+((\\p{L}{1})|(\\d\\.*)+|(này))\\b((\\s*,)|(\\s*và))*)+)"
                    let khoanMatches = search.regexSearch(pattern: pattern, searchIn: dkForm)
                    
                    for var km in khoanMatches{
                        var query = ""
                        var khoan = [String]()
                        km = km.replacingOccurrences(of: "các", with: "")
                        km = km.replacingOccurrences(of: " và", with: ",")
                        km = km.replacingOccurrences(of: ";", with: ",")
                        pattern = "khoản\\s+((\\d+\\.*(,|;)*\\s*)+)"
                        let matchK = search.regexSearch(pattern: pattern, searchIn: km)
                        for var matchKhoan in matchK{
                            matchKhoan = matchKhoan.trimmingCharacters(in: .whitespacesAndNewlines)
                            if search.regexSearch(pattern: "(\\d+,\\s*\\d+)+", searchIn: matchKhoan).count > 0 {
                                matchKhoan = matchKhoan.replacingOccurrences(of: "khoản", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                                for var eachKm in matchKhoan.components(separatedBy: ","){
                                    eachKm = eachKm.trimmingCharacters(in: .whitespacesAndNewlines)
                                    if(!search.isStringExisted(str: eachKm, strArr: khoan) && eachKm.count > 0){
                                        khoan.append(eachKm)
                                    }
                                }
                            }else{
                                matchKhoan = matchKhoan.replacingOccurrences(of: ",", with: "")
                                matchKhoan = matchKhoan.replacingOccurrences(of: "khoản", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                                if(!search.isStringExisted(str: matchKhoan, strArr: khoan)){
                                    khoan.append(matchKhoan)
                                }
                            }
                            
                            tempQuery = ""
                            for d in khoan {
                                tempQuery += "forsearch like \"\(d) %\" or forsearch like \"\(d). %\" or "
                            }
                            if khoan.count > 0 {
                                query = "select distinct id from tblChitietvanban where (\(tempQuery.substring(to: tempQuery.index(tempQuery.endIndex, offsetBy: -4)))) and cha in (\(dieuQuery))"
                            }
                            
                            //pattern = "điểm\\s+(((\\p{L}{1})|(\\d\\.*)+)(,|;)*\\s+(và)*\\s*)+"
                            pattern = "(\\s*(các\\s)*điểm(\\s+((\\p{L}{1})|(\\d\\.*)+)\\b((\\s*,)|(\\s*và))*)+)"
                            
                            let diemMatches = search.regexSearch(pattern: pattern, searchIn: km)
                            
                            var diem = [String]()
                            for var d in diemMatches{
                                d = d.replacingOccurrences(of: "các", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                                d = d.replacingOccurrences(of: " và", with: ",")
                                d = d.replacingOccurrences(of: ";", with: ",")
                                pattern = "điểm\\s+(((\\p{L}{1})|(\\d\\.*)+)(,|;)*(\\s+và)*\\s*)+"
                                let matchD = search.regexSearch(pattern: pattern, searchIn: d)
                                for var matchDiem in matchD {
                                    matchDiem = matchDiem.replacingOccurrences(of: "điểm", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                                    if search.regexSearch(pattern: "(((\\p{L}{1})|(\\d\\.*)+)(,\\s+)((\\p{L}{1})|(\\d\\.*)+))+", searchIn: matchDiem).count > 0 {
                                        for var eachD in matchDiem.components(separatedBy: ","){
                                            eachD = eachD.trimmingCharacters(in: .whitespacesAndNewlines)
                                            if(!search.isStringExisted(str: eachD, strArr: diem) && eachD.count > 0){
                                                diem.append(eachD)
                                            }
                                        }
                                    }else{
                                        matchDiem = matchDiem.replacingOccurrences(of: ",", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                                        if(!search.isStringExisted(str: matchDiem, strArr: diem)){
                                            diem.append(matchDiem)
                                        }
                                    }
                                }
                                tempQuery = ""
                                for d in diem {
                                    tempQuery += "forsearch like \"\(d) %\" or forsearch like \"\(d). %\" or "
                                }
                            }
                            if diem.count > 0{
                                query = "select distinct id from tblChitietvanban where (\(tempQuery.substring(to: tempQuery.index(tempQuery.endIndex, offsetBy: -4)))) and cha in (\(query))"
                            }
                        }
                        finalQuery += "dkid in (\(query)) or "
                    }
                    
                    if finalQuery.count < 1 {
                        //in case no 'khoan' and 'diem' available, the query should be initialized (' or ' is added because it will be removed when initializing final query
                        finalQuery = "dkid in (\(dieuQuery)) or "
                        
                        //TODO:still in making decision of showing children dieukhoan or not
                        //finalQuery = "dkid in (\(dieuQuery)) or dkCha in \(dieuQuery) or "
                    }
                }
            }
        }
        finalQuery = Queries.rawSqlQuery + " \(finalQuery.substring(to: finalQuery.index(finalQuery.endIndex, offsetBy: -4)))"
        
        relatedDieukhoan.append(contentsOf: Queries.searchDieukhoanByQuery(query: finalQuery, vanbanid: specificVanbanId))
        return relatedDieukhoan
    }
    
    func getChildren(keyword:String) -> [Dieukhoan] {
        if DataConnection.database == nil {
            DataConnection.databaseSetup()
        }
        return Queries.searchChildren(keyword: "\(keyword)", vanbanid: specificVanbanId)
    }
    
    func getParent(keyword:String) -> [Dieukhoan] {
        if DataConnection.database == nil {
            DataConnection.databaseSetup()
        }
        return Queries.searchDieukhoanByID(keyword: "\(keyword)", vanbanid: specificVanbanId)
    }
    
    func getRelatedPlatKeywords(content:String) -> [String] {
        let input = content.lowercased()
        let pattern = "((([a-zA-Z]{1,2})(\\.|,)+)+(\\d)+(\\.\\d)*([a-zA-Z])*)|((vạch)(\\ssố)*\\s(\\d)+(\\.\\d)*(\\.)*)"
        return search.regexSearch(pattern: pattern, searchIn: input)
    }
}

