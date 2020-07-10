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
    @IBAction func actInitBaseData(_ sender: Any) {
        transformData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func actInsertMoreVanban(_ sender: Any) {
        let thongtu = Loaivanban(id: 3, ten: "Thông Tư")
        let bocongan = Coquanbanhanh(id: 4, ten: "Bộ Công An")
        
        //init vanban tt652020
//        let tt652020 = Vanban(
//            id: 8
//            , ten: "QUY ĐỊNH NHIỆM VỤ, QUYỀN HẠN, HÌNH THỨC, NỘI DUNG VÀ QUY TRÌNH TUẦN TRA, KIỂM SOÁT, XỬ LÝ VI PHẠM HÀNH CHÍNH VỀ GIAO THÔNG ĐƯỜNG BỘ CỦA CẢNH SÁT GIAO THÔNG"
//            , loai: thongtu
//            , so: "65"
//            , nam: "2020"
//            , ma: "65/2020/TT-BCA"
//            , coquanbanhanh: bocongan
//            , noidung: "Căn cứ Luật Giao thông đường bộ ngày 13 tháng 11 năm 2008;\nCăn cứ Luật Xử lý vi phạm hành chính ngày 20 tháng 6 năm 2012;\nCăn cứ Luật Công an nhân dân ngày 20 tháng 11 năm 2018;\nCăn cứ Nghị định số 01/2018/NĐ-CP ngày 06 tháng 8 năm 2018 của Chính phủ quy định về chức năng, nhiệm vụ, quyền hạn và cơ cấu tổ chức của Bộ Công an;\nCăn cứ Nghị định số 100/2019/NĐ-CP ngày 30 tháng 12 năm 2019 của Chính phủ quy định xử phạt vi phạm hành chính trong lĩnh vực giao thông đường bộ và đường sắt;\nTheo đề nghị của Cục trưởng Cục Cảnh sát giao thông,\nBộ trưởng Bộ Công an ban hành Thông tư quy định nhiệm vụ, quyền hạn, hình thức, nội dung và quy trình tuần tra, kiểm soát, xử lý vi phạm hành chính về giao thông đường bộ của Cảnh sát giao thông."
//        )
        //insert tt652020
//        var query = "INSERT INTO \"tblVanban\" ( \"coquanbanhanh\", \"id\", \"loai\", \"ma\", \"nam\", \"noidung\", \"so\", \"ten\") VALUES ( \"\(tt652020.getCoquanbanhanh().getId())\", \"\(tt652020.getId())\", \"\(tt652020.getLoai().getId())\", \"\(tt652020.getMa())\", \"\(tt652020.getNam())\", \"\(tt652020.getNoidung())\", \"\(tt652020.getSo())\", \"\(tt652020.getTen())\" );"
//        Queries.executeStatements(query: query)
//        //insert content tt652020
//        //remove all existing content if any
//        Queries.executeStatements(query: "DELETE from tblChitietvanban where vanbanid = \(tt652020.getId())")
//        Queries.executeStatements(query: RawDataInitializer(fileName: "TT652020", vanban: tt652020).transformRawDataToSqlQuery())
        
//        //init vanban tt582020
//        let tt582020 = Vanban(
//            id: 8
//            , ten: "QUY ĐỊNH QUY TRÌNH CẤP, THU HỒI ĐĂNG KÝ, BIỂN SỐ PHƯƠNG TIỆN GIAO THÔNG CƠ GIỚI ĐƯỜNG BỘ"
//            , loai: thongtu
//            , so: "58"
//            , nam: "2020"
//            , ma: "58/2020/TT-BCA"
//            , coquanbanhanh: bocongan
//            , noidung: "Căn cứ Luật Giao thông đường bộ ngày 13 tháng 11 năm 2008;\nCăn cứ Bộ luật Dân sự ngày 24 tháng 11 năm 2015;\nCăn cứ Nghị định số 01/2018/NĐ-CP ngày 06 tháng 8 năm 2018 của Chính phủ quy định chức năng, nhiệm vụ, quyền hạn và cơ cấu tổ chức của Bộ Công an;\nTheo đề nghị của Cục trưởng Cục Cảnh sát giao thông;\nBộ trưởng Bộ Công an ban hành Thông tư quy định về quy trình cấp, thu hồi đăng ký, biển số phương tiện giao thông cơ giới đường bộ."
//        )
//        //insert tt582020
//        query = "INSERT INTO \"tblVanban\" ( \"coquanbanhanh\", \"id\", \"loai\", \"ma\", \"nam\", \"noidung\", \"so\", \"ten\") VALUES ( \"\(tt582020.getCoquanbanhanh().getId())\", \"\(tt582020.getId())\", \"\(tt582020.getLoai().getId())\", \"\(tt582020.getMa())\", \"\(tt582020.getNam())\", \"\(tt582020.getNoidung())\", \"\(tt582020.getSo())\", \"\(tt582020.getTen())\" );"
//        Queries.executeStatements(query: query)
//        //insert content tt652020
//        Queries.executeStatements(query: RawDataInitializer(fileName: "TT582020", vanban: tt582020).transformRawDataToSqlQuery())
        
        
    }
    
    @IBAction func actInitHinhphatbosung(_ sender: Any) {
        
    }
    
    @IBAction func actInitBosungKhacphuc(_ sender: Any) {
        
    }
    
    @IBAction func actInsertDataByQueries(_ sender: Any) {
//        initReferenceData(tableName: "ND1002019linhvuc")
//        initReferenceData(tableName: "ND1002019phuongtien")
//        initReferenceData(tableName: "ND1002019mucphat")
//        initReferenceData(tableName: "ND1002019keywords")
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
//        let fileName = "QC412016Bienbao"
//        print("=====================================")
//        print("Initializing \(fileName)......")
//        //create new tables and insert data
//        Queries.executeStatements(query: Utils.readFromFile(name: fileName))
//
//        print("Succesfully initializing \(fileName)")
//        print("=====================================")
    }
    
    func initVachReferences() {
//        let fileName = "QC412016Vachke"
//        print("=====================================")
//        print("Initializing \(fileName)......")
//        //create new tables and insert data
//        Queries.executeStatements(query: Utils.readFromFile(name: fileName))
//
//        print("Succesfully initializing \(fileName)")
//        print("=====================================")
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

