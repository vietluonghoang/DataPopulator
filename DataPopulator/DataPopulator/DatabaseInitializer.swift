//
//  DatabaseInitializer.swift
//  DataPopulator
//
//  Created by VietLH on 6/23/20.
//  Copyright © 2020 VietLH. All rights reserved.
//

import Foundation
class DatabaseInitializer {
    private let quochoi = Coquanbanhanh(
            id: 1
            , ten: "Quốc Hội")
    private let chinhphu = Coquanbanhanh(
            id: 2
            , ten: "Chính Phủ")
    private let bogiaothongvantai = Coquanbanhanh(
            id: 3
            , ten: "Bộ Giao Thông Vận Tải")
    private let bocongan = Coquanbanhanh(
            id: 4
            , ten: "Bộ Công An")
    
    private let luat = Loaivanban(
            id: 1
            , ten: "Luật")
    private let nghidinh = Loaivanban(
            id: 2
            , ten: "Nghị Định")
    private let thongtu = Loaivanban(
            id: 3
            , ten: "Thông Tư")
    private let quychuan = Loaivanban(
            id: 4
            , ten: "Quy Chuẩn")

    private var vanbans = [Vanban]()
    private var coquanbanhanh = [Coquanbanhanh]()
    private var loaivanban = [Loaivanban]()
    
    private func dropAllTables(){
        let query = "drop table if exists 'tblPlateReferences';drop table if exists 'tblPlateShapes';drop table if exists 'tblShapeGroups';drop table if exists 'Vehicles';drop table if exists 'Structures';drop table if exists 'Signs';drop table if exists 'Figures';drop table if exists 'Creatures';drop table if exists 'Arrows';drop table if exists 'Alphanumerics';drop table if exists \"tblBienphapkhacphuc\";drop table if exists \"tblHinhphatbosung\";drop table if exists \"tblKeywords\";drop table if exists \"tblLinhvuc\";drop table if exists \"tblMucphat\";drop table if exists \"tblPhuongtien\";drop table if exists \"tblRelatedDieukhoan\";drop table if exists \"tblChitietvanban\";drop table if exists \"tblVanban\";drop table if exists \"tblLoaiVanban\";drop table if exists \"tblCoquanbanhanh\";"
        Queries.executeStatements(query: query)
    }
    
    private func initCoquanbanhanh() {
        coquanbanhanh.append(quochoi)
        coquanbanhanh.append(chinhphu)
        coquanbanhanh.append(bogiaothongvantai)
        coquanbanhanh.append(bocongan)
    }
    
    private func initLoaivanban() {
        loaivanban.append(luat)
        loaivanban.append(nghidinh)
        loaivanban.append(thongtu)
        loaivanban.append(quychuan)
    }
    
    private func initVanban() {
        let qc412016 = Vanban(
                id: 1
                , ten: "QUY CHUẨN KỸ THUẬT QUỐC GIA VỀ BÁO HIỆU ĐƯỜNG BỘ"
                , loai: quychuan
                , so: "41"
                , nam: "2016"
                , ma: "QCVN 41:2016/BGTVT"
                , coquanbanhanh: bogiaothongvantai
                , noidung: "QCVN 41:2016/BGTVT do Tổng cục Đường bộ Việt Nam biên soạn, Bộ Khoa học và Công nghệ thẩm định, Bộ trưởng Bộ Giao thông vận tải ban hành theo Thông tư số 06/2016/TT-BGTVT ngày 08 tháng 4 năm 2016."
        )
        vanbans.append(qc412016)
        let nd462016 = Vanban(
                id: 2
                , ten: "QUY ĐỊNH XỬ PHẠT VI PHẠM HÀNH CHÍNH TRONG LĨNH VỰC GIAO THÔNG ĐƯỜNG BỘ VÀ ĐƯỜNG SẮT"
                , loai: nghidinh
                , so: "46"
                , nam: "2016"
                , ma: "46/2016/NĐ-CP"
                , coquanbanhanh: chinhphu
                , noidung: "Căn cứ Luật Tổ chức Chính phủ ngày 19 tháng 6 năm 2015;\nCăn cứ Luật Xử lý vi phạm hành chính ngày 20 tháng 6 năm 2012;\nCăn cứ Luật Giao thông đường bộ ngày 13 tháng 11 năm 2008;\nCăn cứ Luật Đường sắt ngày 14 tháng 6 năm 2005;\nTheo đề nghị của Bộ trưởng Bộ Giao thông vận tải;\nChính phủ ban hành Nghị định quy định xử phạt vi phạm hành chính trong lĩnh vực giao thông đường bộ và đường sắt."
        )
        vanbans.append(nd462016)
        let tt012016 = Vanban(
                id: 3
                , ten: "QUY ĐỊNH NHIỆM VỤ, QUYỀN HẠN, HÌNH THỨC, NỘI DUNG TUẦN TRA, KIỂM SOÁT GIAO THÔNG ĐƯỜNG BỘ CỦA CẢNH SÁT GIAO THÔNG"
                , loai: thongtu
                , so: "01"
                , nam: "2016"
                , ma: "01/2016/TT-BCA"
                , coquanbanhanh: bocongan
                , noidung: "Căn cứ Luật Công an nhân dân năm 2014;\nCăn cứ Luật Giao thông đường bộ năm 2008;\nCăn cứ Luật Xử lý vi phạm hành chính năm 2012;\nCăn cứ Nghị định số 106/2014/NĐ-CP ngày 17 tháng 11 năm 2014 của Chính phủ quy định chức năng, nhiệm vụ, quyền hạn và cơ cấu tổ chức của Bộ Công an;\nTheo đề nghị của Cục trưởng Cục Cảnh sát giao thông;\nBộ trưởng Bộ Công an ban hành Thông tư quy định nhiệm vụ, quyền hạn, hình thức, nội dung tuần tra, kiểm soát giao thông đường bộ của Cảnh sát giao thông."
        )
        vanbans.append(tt012016)
        let luatgtdb2008 = Vanban(
                id: 4
                , ten: "LUẬT GIAO THÔNG ĐƯỜNG BỘ"
                , loai: luat
                , so: "23"
                , nam: "2008"
                , ma: "23/2008/QH12"
                , coquanbanhanh: quochoi
                , noidung: "Căn cứ Hiến pháp nước Cộng hòa xã hội chủ nghĩa Việt Nam năm 1992 đã được sửa đổi, bổ sung một số điều theo Nghị quyết số 51/2001/QH10;\n\nQuốc hội ban hành Luật giao thông đường bộ."
        )
        vanbans.append(luatgtdb2008)
        let luatxlvphc2012 = Vanban(
                id: 5
                , ten: "LUẬT XỬ LÝ VI PHẠM HÀNH CHÍNH"
                , loai: luat
                , so: "15"
                , nam: "2012"
                , ma: "15/2012/QH13"
                , coquanbanhanh: quochoi
                , noidung: "Căn cứ Hiến pháp nước Cộng hòa xã hội chủ nghĩa Việt Nam năm 1992 đã được sửa đổi, bổ sung một số điều theo Nghị quyết số 51/2001/QH10;\n\nQuốc hội ban hành Luật xử lý vi phạm hành chính."
        )
        vanbans.append(luatxlvphc2012)
        let nd1002019 = Vanban(
                id: 6
                , ten: "NGHỊ ĐỊNH QUY ĐỊNH XỬ PHẠT VI PHẠM HÀNH CHÍNH TRONG LĨNH VỰC GIAO THÔNG ĐƯỜNG BỘ VÀ ĐƯỜNG SẮT"
                , loai: nghidinh
                , so: "100"
                , nam: "2019"
                , ma: "100/2019/NĐ-CP"
                , coquanbanhanh: chinhphu
                , noidung: "Căn cứ Luật Tổ chức Chính phủ ngày 19 tháng 6 năm 2015;\nCăn cứ Luật Xử lý vi phạm hành chính ngày 20 tháng 6 năm 2012;\nCăn cứ Luật Giao thông đường bộ ngày 13 tháng 11 năm 2008;\nCăn cứ Luật Đường sắt ngày 16 tháng 6 năm 2017;\nTheo đề nghị của Bộ trưởng Bộ Giao thông vận tải;\nChính phủ ban hành Nghị định quy định xử phạt vi phạm hành chính trong lĩnh vực giao thông đường bộ và đường sắt."
        )
        vanbans.append(nd1002019)
        let qc412019 = Vanban(
                id: 7
                , ten: "QUY CHUẨN KỸ THUẬT QUỐC GIA VỀ BÁO HIỆU ĐƯỜNG BỘ"
                , loai: quychuan
                , so: "41"
                , nam: "2019"
                , ma: "QCVN 41:2019/BGTVT"
                , coquanbanhanh: bogiaothongvantai
                , noidung: "Quy chuẩn kỹ thuật Quốc gia QCVN 41:2019/BGTVT do Tổng cục Đường bộ Việt Nam biên soạn, Bộ Khoa học và Công nghệ thẩm định, Bộ trưởng Bộ Giao thông vận tải ban hành theo Thông tư số 54/2019/TT-BGTVT ngày 31 tháng 12 năm 2019. Quy chuẩn kỹ thuật Quốc gia QCVN 41:2019/BGTVT thay thế QCVN 41:2016/BGTVT."
        )
        vanbans.append(qc412019)
    }
    
    func getAllVanban() -> [Vanban] {
        return vanbans
    }
    private func getVanbanById(id: Int64) -> Vanban{
        for vb in vanbans {
            if vb.getId() == id {
                return vb
            }
        }
        return Vanban(id: 0, ten: "", loai: Loaivanban(id: 0, ten: ""), so: "", nam: "", ma: "", coquanbanhanh: Coquanbanhanh(id: 0, ten: ""), noidung: "")
    }
    
    func initDatabase() {
        dropAllTables()
        initCoquanbanhanh()
        initLoaivanban()
        initVanban()
        
        //Create tblCoquanbanhanh table
        Queries.executeStatements(query: "CREATE TABLE \"tblCoquanbanhanh\" (\"id\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, \"ten\" TEXT COLLATE NOCASE)")
        //insert data into tblCoquanbanhanh table
        for cqbh in coquanbanhanh {
            let query = "INSERT INTO \"tblCoquanbanhanh\" ( \"id\", \"ten\") VALUES ( \(cqbh.getId()),  \"\(cqbh.getTen())\")"
            Queries.executeStatements(query: query)
        }
        
        //Create tblLoaiVanban table
        Queries.executeStatements(query: "CREATE TABLE \"tblLoaiVanban\" (\"id\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, \"ten\" TEXT COLLATE NOCASE)")
        //insert data into tblLoaiVanban table
        for lvb in loaivanban {
            let query = "INSERT INTO \"tblLoaiVanban\" ( \"id\", \"ten\") VALUES ( \(lvb.getId()), \"\(lvb.getTen())\" );"
            Queries.executeStatements(query: query)
        }
        
        //Create tblVanban table
        Queries.executeStatements(query: "CREATE TABLE \"tblVanban\" (\"id\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, \"ten\" TEXT COLLATE NOCASE, \"loai\" INTEGER COLLATE NOCASE REFERENCES \"tblLoaiVanban\" (\"id\"), \"so\" TEXT COLLATE NOCASE, \"nam\" TEXT COLLATE NOCASE, \"ma\" TEXT COLLATE NOCASE, \"coquanbanhanh\" INTEGER COLLATE NOCASE REFERENCES \"tblCoquanbanhanh\" (\"id\"), \"noidung\" TEXT COLLATE NOCASE)")
        //insert data into tblVanban table
        for vb in vanbans {
            let query = "INSERT INTO \"tblVanban\" ( \"coquanbanhanh\", \"id\", \"loai\", \"ma\", \"nam\", \"noidung\", \"so\", \"ten\") VALUES ( \"\(vb.getCoquanbanhanh().getId())\", \"\(vb.getId())\", \"\(vb.getLoai().getId())\", \"\(vb.getMa())\", \"\(vb.getNam())\", \"\(vb.getNoidung())\", \"\(vb.getSo())\", \"\(vb.getTen())\" );"
            Queries.executeStatements(query: query)
        }
        
        //create tblChitietvanban table
        Queries.executeStatements(query: "CREATE TABLE \"tblChitietvanban\" (\"id\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, \"So\" TEXT COLLATE NOCASE, \"tieude\" TEXT COLLATE NOCASE, \"noidung\" TEXT COLLATE NOCASE, \"minhhoa\" TEXT COLLATE NOCASE, \"cha\" INTEGER COLLATE NOCASE, \"vanbanid\" INTEGER COLLATE NOCASE REFERENCES \"tblVanban\" (\"id\"), \"forSearch\" TEXT COLLATE NOCASE);")
        
        //create tblRelatedDieukhoan table
        Queries.executeStatements(query: "CREATE TABLE tblRelatedDieukhoan (dieukhoanId integer, relatedDieukhoanId integer);")
        
        //create tblPhuongtien table
        Queries.executeStatements(query: "CREATE TABLE \"tblPhuongtien\" (\"dieukhoanID\" INTEGER UNIQUE,\"oto\" BOOLEAN,\"otoTai\" BOOLEAN,\"maykeo\" BOOLEAN,\"xechuyendung\" BOOLEAN,\"tau\" BOOLEAN,\"moto\" BOOLEAN,\"xeganmay\" BOOLEAN,\"xemaydien\" BOOLEAN,\"xedapmay\" BOOLEAN,\"xedap\" BOOLEAN,\"xedapdien\" BOOLEAN,\"xethoso\" BOOLEAN,\"sucvat\" BOOLEAN,\"xichlo\" BOOLEAN,\"dibo\" BOOLEAN);")
        
        //create tblMucphat table
        Queries.executeStatements(query: "CREATE TABLE \"tblMucphat\" (\"dieukhoanID\" INTEGER UNIQUE,\"canhanTu\" TEXT,\"canhanDen\" TEXT,\"tochucTu\" TEXT,\"tochucDen\" TEXT);")
        
        //create tblMucphat table
        Queries.executeStatements(query: "CREATE TABLE \"tblLinhvuc\" (\"dieukhoanID\" INTEGER UNIQUE,\"duongbo\" BOOLEAN,\"duongsat\" BOOLEAN);")
        
        //create tblKeywords table
        Queries.executeStatements(query: "CREATE TABLE \"tblKeywords\" (\"dieukhoanID\" INTEGER UNIQUE,\"canhan\" BOOLEAN,\"tochuc\" BOOLEAN,\"doanhnghiep\" BOOLEAN,\"trungtam\" BOOLEAN,\"daotao\" BOOLEAN,\"nguoidieukhien\" BOOLEAN,\"nguoingoitrenxe\" BOOLEAN,\"nguoiduoctro\" BOOLEAN,\"giaovien\" BOOLEAN,\"ga\" BOOLEAN,\"chuphuongtien\" BOOLEAN,\"nhanvien\" BOOLEAN,\"dangkiemvien\" BOOLEAN,\"laitau\" BOOLEAN,\"truongdon\" BOOLEAN,\"truongtau\" BOOLEAN,\"dieukhienmaydon\" BOOLEAN,\"trucban\" BOOLEAN,\"duaxe\" BOOLEAN,\"kinhdoanh\" BOOLEAN,\"vanchuyen\" BOOLEAN,\"vantai\" BOOLEAN,\"hanhkhach\" BOOLEAN,\"hanghoa\" BOOLEAN,\"ketcau\" BOOLEAN,\"hatang\" BOOLEAN,\"luukho\" BOOLEAN,\"laprap\" BOOLEAN,\"xepdo\" BOOLEAN,\"quanly\" BOOLEAN,\"thuphi\" BOOLEAN,\"dangkiem\" BOOLEAN,\"sathach\" BOOLEAN,\"dichvu\" BOOLEAN,\"hotro\" BOOLEAN,\"ghepnoi\" BOOLEAN,\"gacchan\" BOOLEAN,\"khamxe\" BOOLEAN,\"thuham\" BOOLEAN,\"phucvu\" BOOLEAN,\"baoquan\" BOOLEAN,\"sanxuat\" BOOLEAN,\"hoancai\" BOOLEAN,\"phuchoi\" BOOLEAN,\"khaithac\" BOOLEAN,\"baotri\" BOOLEAN);")
        
        //create tblHinhphatbosung table
        Queries.executeStatements(query: "CREATE TABLE tblHinhphatbosung (dieukhoanId integer, dieukhoanQuydinhId integer, noidung text);")
        
        //create tblBienphapkhacphuc table
        Queries.executeStatements(query: "CREATE TABLE tblBienphapkhacphuc (dieukhoanId integer, dieukhoanQuydinhId integer, noidung text);")
        
        //create Alphanumerics table
        Queries.executeStatements(query: "CREATE TABLE 'Alphanumerics' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'ten' TEXT COLLATE NOCASE);")
        
        //create Arrows table
        Queries.executeStatements(query: "CREATE TABLE 'Arrows' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'ten' TEXT COLLATE NOCASE);")
        
        //create Creatures table
        Queries.executeStatements(query: "CREATE TABLE 'Creatures' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'ten' TEXT COLLATE NOCASE);")
        
        //create Figures table
        Queries.executeStatements(query: "CREATE TABLE 'Figures' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'ten' TEXT COLLATE NOCASE);")
        
        //create Signs table
        Queries.executeStatements(query: "CREATE TABLE 'Signs' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'ten' TEXT COLLATE NOCASE);")
        
        //create Structures table
        Queries.executeStatements(query: "CREATE TABLE 'Structures' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'ten' TEXT COLLATE NOCASE);")
        
        //create Vehicles table
        Queries.executeStatements(query: "CREATE TABLE 'Vehicles' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'ten' TEXT COLLATE NOCASE);")
        
        //create tblShapeGroups table
        Queries.executeStatements(query: "CREATE TABLE 'tblShapeGroups' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'ten' TEXT COLLATE NOCASE);")
        
        //create tblPlateShapes table
        Queries.executeStatements(query: "CREATE TABLE 'tblPlateShapes' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'ten' TEXT COLLATE NOCASE, 'type' INTEGER);")
        
        //create tblPlateReferences table
        Queries.executeStatements(query: "CREATE TABLE 'tblPlateReferences' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'plateId' INTEGER, 'type' TEXT COLLATE NOCASE, 'name' TEXT COLLATE NOCASE,'refId' INTEGER);")
        
        //init raw data
        initQC412019()
    }
    
    private func initQC412019() {
        print("\n================= Inserting Raw Data To Database ====================\n")
        //insert QC412016 data, vanbanid is 1
        Queries.executeStatements(query: Utils.readFromFile(name: "QC412016_queries"))
        //insert ND462016 data, vanbanid is 2
        Queries.executeStatements(query: Utils.readFromFile(name: "ND462016_queries"))
        
        let tt012016 = RawDataInitializer(fileName: "TT012016", vanban: getVanbanById(id: 3))
        tt012016.insertDataByQuery(queries: tt012016.transformRawDataToSqlQuery())
        
        let lgtdb2008 = RawDataInitializer(fileName: "LGTDB2008", vanban: getVanbanById(id: 4))
        lgtdb2008.insertDataByQuery(queries: lgtdb2008.transformRawDataToSqlQuery())
        
        let lxlvphc2012 = RawDataInitializer(fileName: "LXLVPHC2012", vanban: getVanbanById(id: 5))
        lxlvphc2012.insertDataByQuery(queries: lxlvphc2012.transformRawDataToSqlQuery())
        
        let nd1002019 = RawDataInitializer(fileName: "ND1002019", vanban: getVanbanById(id: 6))
        nd1002019.insertDataByQuery(queries: nd1002019.transformRawDataToSqlQuery())
        
        //insert QC412019
        let qc412019 = RawDataInitializer(fileName: "QC412019", vanban: getVanbanById(id: 7))
        qc412019.transformRawDataToCsv()
        qc412019.updateDieukhoanWithMinhhoa()
        qc412019.insertDataByQuery(queries: qc412019.transformRawDataToSqlQuery())
        let qc412019PL = RawDataInitializer(fileName: "QC412019-PL", vanban: getVanbanById(id: 7))
        qc412019PL.transformRawDataToCsv()
        qc412019PL.updateDieukhoanWithMinhhoa()
        qc412019PL.insertDataByQuery(queries: qc412019PL.transformRawDataToSqlQuery())
        
        print("\n================= Finished Inserting Raw Data To Database ====================\n")
        
//        RawDataInitializer(fileName: "QC412019", vanban: getVanbanById(id: 7)).transformRawDataToCsv()
//        RawDataInitializer(fileName: "QC412019-PL", vanban: getVanbanById(id: 7)).transformRawDataToCsv()
//        RawDataInitializer(fileName: "QC412019-PLA", vanban: getVanbanById(id: 7)).transformRawDataToCsv()
//        RawDataInitializer(fileName: "QC412019-PLB", vanban: getVanbanById(id: 7)).transformRawDataToCsv()
//        RawDataInitializer(fileName: "QC412019-PLC", vanban: getVanbanById(id: 7)).transformRawDataToCsv()
//        RawDataInitializer(fileName: "QC412019-PLD", vanban: getVanbanById(id: 7)).transformRawDataToCsv()
//        RawDataInitializer(fileName: "QC412019-PLE", vanban: getVanbanById(id: 7)).transformRawDataToCsv()
//        RawDataInitializer(fileName: "QC412019-PLF", vanban: getVanbanById(id: 7)).transformRawDataToCsv()
//        RawDataInitializer(fileName: "QC412019-PLG", vanban: getVanbanById(id: 7)).transformRawDataToCsv()
//        RawDataInitializer(fileName: "QC412019-PLI", vanban: getVanbanById(id: 7)).transformRawDataToCsv()
//        RawDataInitializer(fileName: "QC412019-PLK", vanban: getVanbanById(id: 7)).transformRawDataToCsv()
//        RawDataInitializer(fileName: "QC412019-PLM", vanban: getVanbanById(id: 7)).transformRawDataToCsv()
//        RawDataInitializer(fileName: "QC412019-PLN", vanban: getVanbanById(id: 7)).transformRawDataToCsv()
//        RawDataInitializer(fileName: "QC412019-PLO", vanban: getVanbanById(id: 7)).transformRawDataToCsv()
//        RawDataInitializer(fileName: "QC412019-PLP", vanban: getVanbanById(id: 7)).transformRawDataToCsv()
//        RawDataInitializer(fileName: "test", vanban: getVanbanById(id: 7)).transformRawDataToCsv()
        
    }
}
