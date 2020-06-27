//
//  DatabaseInitializer.swift
//  DataPopulator
//
//  Created by VietLH on 6/23/20.
//  Copyright © 2020 VietLH. All rights reserved.
//

import Foundation
class DatabaseInitializer {
    let quochoi = Coquanbanhanh(
            id: 1
            , ten: "Quốc Hội")
    let chinhphu = Coquanbanhanh(
            id: 2
            , ten: "Chính Phủ")
    let bogiaothongvantai = Coquanbanhanh(
            id: 3
            , ten: "Bộ Giao Thông Vận Tải")
    let bocongan = Coquanbanhanh(
            id: 4
            , ten: "Bộ Công An")
    
    let luat = Loaivanban(
            id: 1
            , ten: "Luật")
    let nghidinh = Loaivanban(
            id: 2
            , ten: "Nghị Định")
    let thongtu = Loaivanban(
            id: 3
            , ten: "Thông Tư")
    let quychuan = Loaivanban(
            id: 4
            , ten: "Quy Chuẩn")

    var vanbans = [Vanban]()
    var coquanbanhanh = [Coquanbanhanh]()
    var loaivanban = [Loaivanban]()
    
    
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
    
    func initDatabase() {
        initCoquanbanhanh()
        initLoaivanban()
        initVanban()
        
        //Create tblCoquanbanhanh table
        Queries.executeStatements(query: "CREATE TABLE \"tblCoquanbanhanh\" (\"id\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, \"ten\" TEXT COLLATE NOCASE)")
        //insert data into tblCoquanbanhanh table
        for cqbh in coquanbanhanh {
            var query = "INSERT INTO \"tblCoquanbanhanh\" ( \"id\", \"ten\") VALUES ( \(cqbh.getId()),  \"\(cqbh.getTen())\")"
            Queries.executeStatements(query: query)
        }
        
        //Create tblLoaiVanban table
        Queries.executeStatements(query: "CREATE TABLE \"tblLoaiVanban\" (\"id\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, \"ten\" TEXT COLLATE NOCASE)")
        //insert data into tblLoaiVanban table
        for lvb in loaivanban {
            var query = "INSERT INTO \"tblLoaiVanban\" ( \"id\", \"ten\") VALUES ( \(lvb.getTen()), \"\(lvb.getTen())\" );"
            Queries.executeStatements(query: query)
        }
        
        //Create tblVanban table
        Queries.executeStatements(query: "CREATE TABLE \"tblVanban\" (\"id\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, \"ten\" TEXT COLLATE NOCASE, \"loai\" INTEGER COLLATE NOCASE REFERENCES \"tblLoaiVanban\" (\"id\"), \"so\" TEXT COLLATE NOCASE, \"nam\" TEXT COLLATE NOCASE, \"ma\" TEXT COLLATE NOCASE, \"coquanbanhanh\" INTEGER COLLATE NOCASE REFERENCES \"tblCoquanbanhanh\" (\"id\"), \"noidung\" TEXT COLLATE NOCASE)")
        //insert data into tblVanban table
        for vb in vanbans {
            var query = "INSERT INTO \"tblVanban\" ( \"coquanbanhanh\", \"id\", \"loai\", \"ma\", \"nam\", \"noidung\", \"so\", \"ten\") VALUES ( \(vb.getCoquanbanhanh().getId()), \(vb.getId()), \(vb.getLoai().getId()), \(vb.getMa()), \(vb.getNam()), \(vb.getNoidung()), \(vb.getSo()), \(vb.getTen()) );"
            Queries.executeStatements(query: query)
        }
    }
}
