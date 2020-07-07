//
//  DieukhoanParser.swift
//  DataPopulator
//
//  Created by VietLH on 7/7/20.
//  Copyright © 2020 VietLH. All rights reserved.
//

import Foundation
class DieukhoanParser {
    private var specificVanbanId = [String]()
    private var dieukhoan: Dieukhoan? = nil
    private var relatedChildren = [Dieukhoan]()
    
    private var hinhphatbosungFilename = ""
    private var bienphapkhacphucFilename = ""
    
    
    
    private var search = SearchFor()
    private var settings = GeneralSettings()
    
    func initHinhphatbosungBienphapkhacphuc(hinhphatbosungFilename: String, bienphapkhacphucFilename: String) {
        self.hinhphatbosungFilename = hinhphatbosungFilename
        self.bienphapkhacphucFilename = bienphapkhacphucFilename
        initDataForBienphapkhacphuchauqua()
        initDataForHinhphatbosung()
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
    
    private func updateDetails(dieukhoan: Dieukhoan) {
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
    }
    
    private func getRelatedDieukhoan(noidung:String) -> [Dieukhoan] {
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
    
    private func parseRelatedDieukhoan(keyword: String) -> [Dieukhoan] {
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
            
            finalQuery = "(\(String(tempQuery[..<(tempQuery.index(tempQuery.endIndex, offsetBy: -4))]))) and vanbanid = \(specificVanbanId[0])"
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
                    
                    dieuQuery = "select distinct id from tblChitietvanban where (\(String(tempQuery[..<(tempQuery.index(tempQuery.endIndex, offsetBy: -4))]))) and vanbanid = \(specificVanbanId[0])"
                    
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
                                query = "select distinct id from tblChitietvanban where (\(String(tempQuery[..<(tempQuery.index(tempQuery.endIndex, offsetBy: -4))]))) and cha in (\(dieuQuery))"
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
//                                query = "select distinct id from tblChitietvanban where (\(tempQuery.substring(to: tempQuery.index(tempQuery.endIndex, offsetBy: -4)))) and cha in (\(query))"
                                
                                query = "select distinct id from tblChitietvanban where (\(String(tempQuery[..<(tempQuery.index(tempQuery.endIndex, offsetBy: -4))]))) and cha in (\(query))"
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
        finalQuery = Queries.rawSqlQuery + " \(String(finalQuery[..<(finalQuery.index(finalQuery.endIndex, offsetBy: -4))]))"
        
        relatedDieukhoan.append(contentsOf: Queries.searchDieukhoanByQuery(query: finalQuery, vanbanid: specificVanbanId))
        return relatedDieukhoan
    }
    
    private func getRelatedPlatKeywords(content:String) -> [String] {
        let input = content.lowercased()
        let pattern = "((([a-zA-Z]{1,2})(\\.|,)+)+(\\d)+(\\.\\d)*([a-zA-Z])*)|((vạch)(\\ssố)*\\s(\\d)+(\\.\\d)*(\\.)*)"
        return search.regexSearch(pattern: pattern, searchIn: input)
    }
    
    private func appendRelatedChild(child: Dieukhoan) {
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
    
    private func initDataForBienphapkhacphuchauqua() {
        print("Bienphapkhacphuc=====================================")
        // insert raw data for bien phap khac phuc
        //           Queries.executeStatements(query: Utils.readFromFile(name: "ND462016bienphapkhacphuc"))
        Queries.executeStatements(query: Utils.readFromFile(name: bienphapkhacphucFilename))
        // populate data
        insertDataForBosungKhacphuc(type: "bpkp")
        
        //remove raw data
        Queries.executeDeleteQuery(query: "delete from tblBienphapkhacphuc where dieukhoanId is null")
        print("Bienphapkhacphuc===================================== Done")
    }
    
    private func initDataForHinhphatbosung() {
        print("\n\n\nHinhphatbosung=====================================")
        // insert raw data for hinh phat bo sung
        //           Queries.executeStatements(query: Utils.readFromFile(name: "ND462016hinhphatbosung"))
        Queries.executeStatements(query: Utils.readFromFile(name: hinhphatbosungFilename))
        // populate data
        insertDataForBosungKhacphuc(type: "hpbs")
        
        // remove raw data
        Queries.executeDeleteQuery(query: "delete from tblHinhphatbosung where dieukhoanId is null")
        // remove redundant data
        Queries.executeDeleteQuery(query: "delete from tblhinhphatbosung where exists (select * from tblBienphapkhacphuc AS kp where  tblhinhphatbosung.dieukhoanid = kp.dieukhoanId and tblhinhphatbosung.dieukhoanquydinhid = kp.dieukhoanquydinhid)")
        print("\n\n\nHinhphatbosung===================================== Done")
    }
    
    private func insertDataForBosungKhacphuc(type: String) {
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
    
    private func getChildren(keyword:String) -> [Dieukhoan] {
        if DataConnection.database == nil {
            DataConnection.databaseSetup()
        }
        return Queries.searchChildren(keyword: "\(keyword)", vanbanid: specificVanbanId)
    }
}
