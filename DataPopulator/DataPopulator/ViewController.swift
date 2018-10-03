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
    var children = [Dieukhoan]()
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        if DataConnection.database == nil {
            DataConnection.databaseSetup()
        }
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
        initReferenceData(tableName: "ND462016phuongtien")
        initReferenceData(tableName: "ND462016mucphat")
        initReferenceData(tableName: "ND462016keywords")
        initPlateReferences()
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
        //        for dk in Queries.searchDieukhoanByQuery(query: "\(Queries.rawSqlQuery) dkId = 1384", vanbanid: ["2"]) {
        for dk in Queries.selectAllDieukhoan() {
            specificVanbanId = []
            specificVanbanId.append( String(describing:dk.getVanban().getId()))
            print("--------- dkId: \(dk.getId())")
            updateDetails(dieukhoan: dk)
            for rel in relatedChildren{
                Queries.insertRelatedDieukhoan(dieukhoanId: dk.getId(), relatedDieukhoanId: rel.getId())
            }
            print("--------- Done")
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
        
        //        var pattern = "((điểm\\s+(((\\p{L}{1})|(\\d\\.*)+)(,|;)*\\s+(và)*\\s*)+)*(khoản\\s+(((này)|(\\d\\.*)+)(,|;)*\\s*(và)*\\s*)+)+)*((điều\\s+(((này)|(\\d\\.*)+)(,|;)*\\s*(và)*\\s*)+)+)+(((của)|(tại)|(theo))*\\s*((luật)|(nghị định)|(quy chuẩn)|(thông tư))\\s*((này)|(giao thông đường bộ)|(xử lý vi phạm hành chính)))"
        //        var pattern = "(\\s*điểm\\s+((\\p{L}{1})|(\\d\\.*))+((\\s*,)|(\\s+và))*)*(\\s*khoản\\s+((\\p{L}{1})|(\\d\\.*))+((\\s*,)|(\\s*;)|(\\s+và))*)*(\\s*điều\\s+(\\d\\.*)+((\\s*,)|(\\s*;)|(\\s+và))*)*(((của)|(tại)|(theo))*\\s*((luật)|(nghị định)|(quy chuẩn)|(thông tư))\\s*((này)|(giao thông đường bộ)|(xử lý vi phạm hành chính)))"
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
            
            pattern = "(((\\s*(các\\s)*điểm(\\s+((\\p{L}{1})|(\\d\\.*)+)\\b((\\s*,)|(\\s*và))*)+)*(\\s*(các\\s)*khoản(\\s+((\\p{L}{1})|(\\d\\.*)+|(này))\\b((\\s*,)|(\\s*;)|(\\s*và))*)+)+)*(\\s*và)*(\\s*(các\\s)*điều(\\s+((\\d\\.*)+|(này))\\b)+)+)"
            
            let longMatches = search.regexSearch(pattern: pattern, searchIn: fmatch)
            
            for match in longMatches{
                if(!search.isStringExisted(str: match.trimmingCharacters(in: .whitespacesAndNewlines), strArr: keywords)){
                    keywords.append(match.trimmingCharacters(in: .whitespacesAndNewlines))
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
        
        pattern = "(((\\s*(các\\s)*điểm(\\s+((\\p{L}{1})|(\\d\\.*)+)\\b((\\s*,)|(\\s*và))*)+)*(\\s*(các\\s)*khoản(\\s+((\\p{L}{1})|(\\d\\.*)+|(này))\\b((\\s*,)|(\\s*;)|(\\s*và))*)+)+)*(\\s*và)*(\\s*(các\\s)*điều(\\s+((\\d\\.*)+|(này))\\b)+)+)"
        
        let longMatches = search.regexSearch(pattern: pattern, searchIn: nd)
        
        for var lmatch in longMatches{
            nd = nd.replacingOccurrences(of: lmatch, with: "")
            if lmatch.contains("điều này") {
                lmatch = lmatch.replacingOccurrences(of: "điều này", with: search.getDieunay(currentDieukhoan: dieukhoan!, vanbanId: specificVanbanId).getSo()).trimmingCharacters(in: .whitespacesAndNewlines)
            }
            if(!search.isStringExisted(str: lmatch.trimmingCharacters(in: .whitespacesAndNewlines), strArr: keywords)){
                keywords.append(lmatch.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        
        //        pattern = "(điểm\\s+(((\\p{L}{1})|(\\d\\.*)+)(,|;)*\\s+(và)*\\s*)+)*(khoản\\s+(((này)|(\\d\\.*)+)(,|;)*\\s*(và)*\\s*)+)+"
        //        pattern = "(\\s*điểm\\s+((\\p{L}{1})|(\\d\\.*))+((\\s*,)|(\\s+và))*)*(\\s*khoản\\s+(((này)|\\p{L}{1})|(\\d\\.*))+)+"
        
        pattern = "((\\s*(các\\s)*điểm(\\s+((\\p{L}{1})|(\\d\\.*)+)\\b((\\s*,)|(\\s*và))*)+)*(\\s*(các\\s)*khoản(\\s+((\\p{L}{1})|(\\d\\.*)+|(này))\\b((\\s*,)|(\\s*;)|(\\s*và))*)+)+)"
        
        let shortMatches = search.regexSearch(pattern: pattern, searchIn: nd)
        
        for var smatch in shortMatches{
            var keywords = [String]()
            nd = nd.replacingOccurrences(of: smatch, with: "")
            
            if smatch.contains("điều này") {
                smatch = smatch.replacingOccurrences(of: "điều này", with: search.getDieunay(currentDieukhoan: dieukhoan!, vanbanId: specificVanbanId).getSo()).trimmingCharacters(in: .whitespacesAndNewlines)
            }else{
                smatch = smatch + " " + search.getDieunay(currentDieukhoan: dieukhoan!, vanbanId: specificVanbanId).getSo().trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            if smatch.contains("khoản này") {
                smatch = smatch.replacingOccurrences(of: "khoản này", with: search.getKhoannay(currentDieukhoan: dieukhoan!, vanbanId: specificVanbanId).getSo()).trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            if(!search.isStringExisted(str: smatch.trimmingCharacters(in: .whitespacesAndNewlines), strArr: keywords)){
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
//                let key = "Xe quy định tại các điểm a, b, c và d khoản 1 Điều này khi đi làm nhiệm vụ phải có tín hiệu còi, cờ, đèn theo quy định; không bị hạn chế tốc độ; được phép đi vào đường ngược chiều, các đường khác có thể đi được, kể cả khi có tín hiệu đèn đỏ và chỉ phải tuân theo chỉ dẫn của người điều khiển giao thông.".lowercased()
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
            
            var pattern = "điều\\s+(((này)|(\\d\\.*)+))"
            
            let dieuMatches = search.regexSearch(pattern: pattern, searchIn: key)
            
            for dm in dieuMatches{
                var convertedDieu = dm.replacingOccurrences(of: " và", with: ",")
                convertedDieu = convertedDieu.replacingOccurrences(of: ";", with: ",")
                var dieu = [String]()
                var dieuQuery = ""
                var tempQuery = ""
                if search.regexSearch(pattern: "(\\d+,\\s*\\d+)+", searchIn: convertedDieu).count > 0 {
                    convertedDieu = convertedDieu.replacingOccurrences(of: "điều", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    for var eachDm in convertedDieu.components(separatedBy: ","){
                        if(!search.isStringExisted(str: eachDm.trimmingCharacters(in: .whitespacesAndNewlines), strArr: dieu) && eachDm.count > 0){
                            dieu.append("điều "+eachDm.trimmingCharacters(in: .whitespacesAndNewlines))
                        }
                    }
                }else{
                    if(!search.isStringExisted(str: convertedDieu.trimmingCharacters(in: .whitespacesAndNewlines), strArr: dieu)){
                        convertedDieu = convertedDieu.replacingOccurrences(of: ",", with: "")
                        dieu.append(convertedDieu.trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                }
                
                for d  in dieu {
                    tempQuery += "forsearch like \"\(d) %\" or forsearch like \"\(d). %\" or "
                }
                
                dieuQuery = "select distinct id from tblChitietvanban where (\(tempQuery.substring(to: tempQuery.index(tempQuery.endIndex, offsetBy: -4)))) and vanbanid = \(specificVanbanId[0])"
                
                //TO DO: need to split only 1 "khoan" at a time
                //            pattern = "(điểm\\s+(((\\p{L}{1})|(\\d\\.*)+)(,|;)*\\s+(và)*\\s*)+)*(khoản\\s+(((này)|(\\d\\.*)+)(,|;)*\\s*(và)*\\s*)+)+"
                //pattern = "(\\s*điểm\\s+((\\p{L}{1})|(\\d\\.*))+((\\s*,)|(\\s+và))*)*(\\s*khoản\\s+(((này)|\\p{L}{1})|(\\d\\.*))+)+"
                pattern = "((\\s*(các\\s)*điểm(\\s+((\\p{L}{1})|(\\d\\.*)+)\\b((\\s*,)|(\\s*và))*)+)*(\\s*(các\\s)*khoản(\\s+((\\p{L}{1})|(\\d\\.*)+|(này))\\b((\\s*,)|(\\s*và))*)+)+)"
                let khoanMatches = search.regexSearch(pattern: pattern, searchIn: key)
                
                for km in khoanMatches{
                    var query = ""
                    var khoan = [String]()
                    var convertedKhoan = km.replacingOccurrences(of: " và", with: ",")
                    convertedKhoan = convertedKhoan.replacingOccurrences(of: ";", with: ",")
                    pattern = "khoản\\s+((\\d+\\.*(,|;)*\\s*)+)"
                    for matchKhoan in search.regexSearch(pattern: pattern, searchIn: convertedKhoan){
                        var mk = matchKhoan
                        if search.regexSearch(pattern: "(\\d+,\\s*\\d+)+", searchIn: mk).count > 0 {
                            mk = mk.replacingOccurrences(of: "các", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                            mk = mk.replacingOccurrences(of: "khoản", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                            for eachKm in mk.components(separatedBy: ","){
                                if(!search.isStringExisted(str: eachKm.trimmingCharacters(in: .whitespacesAndNewlines), strArr: khoan) && eachKm.count > 0){
                                    khoan.append(eachKm.trimmingCharacters(in: .whitespacesAndNewlines))
                                }
                            }
                        }else{
                            if(!search.isStringExisted(str: matchKhoan.trimmingCharacters(in: .whitespacesAndNewlines), strArr: khoan)){
                                mk = mk.replacingOccurrences(of: ",", with: "")
                                khoan.append(mk.replacingOccurrences(of: "khoản", with: "").trimmingCharacters(in: .whitespacesAndNewlines))
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
                        
                        let diemMatches = search.regexSearch(pattern: pattern, searchIn: convertedKhoan)
                        
                        var diem = [String]()
                        for d in diemMatches{
                            var convertedDiem = d.replacingOccurrences(of: " và", with: ",")
                            convertedDiem = convertedDiem.replacingOccurrences(of: ";", with: ",")
                            //                        pattern = "điểm\\s+(((\\p{L}{1})|(\\d\\.*)+)(,|;)*\\s+(và)*\\s*)+"
                            for matchDiem in search.regexSearch(pattern: pattern, searchIn: convertedDiem) {
                                var md = matchDiem
                                md = md.replacingOccurrences(of: "các", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                                md = md.replacingOccurrences(of: "điểm", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                                if search.regexSearch(pattern: "(((\\p{L}{1})|(\\d\\.*)+)(,\\s+)((\\p{L}{1})|(\\d\\.*)+))+", searchIn: md).count > 0 {
                                    for eachD in md.components(separatedBy: ","){
                                        if(!search.isStringExisted(str: eachD.trimmingCharacters(in: .whitespacesAndNewlines), strArr: diem) && eachD.count > 0){
                                            diem.append(eachD.trimmingCharacters(in: .whitespacesAndNewlines))
                                        }
                                    }
                                }else{
                                    if(!search.isStringExisted(str: md.trimmingCharacters(in: .whitespacesAndNewlines), strArr: diem)){
                                        md = md.replacingOccurrences(of: ",", with: "")
                                        diem.append(md.replacingOccurrences(of: "điểm", with: "").trimmingCharacters(in: .whitespacesAndNewlines))
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
        // (\p{L}{1,2}((\.|,)\p{L}{1,2})*)*([0-9]*)(\.|,)+[0-9]+.{0,1}
        //((([a-zA-Z]{1,2})(\.|,)+)+(\d)+(\.\d)*([a-zA-Z])*)|((vạch)(\ssố)*\s(\d)+(\.\d)*(\.)*)
        //(\\b(([a-zA-Z]{1,2})(\\.|,)+)+(\\d)+(\\.\\d)*([a-zA-Z])*\\b)|(\\b(vạch)(\\ssố)*\\s(\\d)+(\\.\\d)*(\\.)*\\b)
        let pattern = "((([a-zA-Z]{1,2})(\\.|,)+)+(\\d)+(\\.\\d)*([a-zA-Z])*)|((vạch)(\\ssố)*\\s(\\d)+(\\.\\d)*(\\.)*)"
        return search.regexSearch(pattern: pattern, searchIn: input)
    }
}

