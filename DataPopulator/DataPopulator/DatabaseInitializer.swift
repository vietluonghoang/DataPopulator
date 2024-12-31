//
//  DatabaseInitializer.swift
//  DataPopulator
//
//  Created by VietLH on 6/23/20.
//  Copyright © 2020 VietLH. All rights reserved.
//

import Foundation
class DatabaseInitializer {
    private let userVersion = 16
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
    private let vanbanhopnhat = Loaivanban(
        id: 5
        , ten: "Văn Bản Hợp Nhất")
    
    private var vanbans = [Vanban]()
    private var coquanbanhanh = [Coquanbanhanh]()
    private var loaivanban = [Loaivanban]()
    
    private func dropAllTables(){
        let query = "drop table if exists 'tblShapeGroups';drop table if exists 'tblPlateShapes';drop table if exists 'Alphanumerics';drop table if exists 'Vehicles';drop table if exists 'Arrows';drop table if exists 'Creatures';drop table if exists 'Figures';drop table if exists 'Signs';drop table if exists 'Structures';drop table if exists 'tblPlateReferences';drop table if exists 'tblBienphapkhacphuc';drop table if exists 'tblHinhphatbosung';drop table if exists 'tblKeywords';drop table if exists 'tblLinhvuc';drop table if exists 'tblMucphat';drop table if exists 'tblPhuongtien';drop table if exists 'tblRelatedDieukhoan';drop table if exists 'tblChitietvanban';drop table if exists 'tblVanban';drop table if exists 'tblLoaiVanban';drop table if exists 'tblCoquanbanhanh';drop table if exists 'phantich';drop table if exists 'phantich_details';drop table if exists 'positions';drop table if exists 'tblAppConfigs';drop table if exists 'tblVachShapes';drop table if exists 'tblVachReferences';drop table if exists 'tblVachGroups';"
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
        loaivanban.append(vanbanhopnhat)
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
            , hieuluc: "11/1/2016"
            , vanbanThaytheId: 0
            , tenRutgon: "Quy chuẩn 41/2016 về báo hiệu đường bộ"
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
            , hieuluc: "8/1/2016"
            , vanbanThaytheId: 0
            , tenRutgon: "Nghị định 46/2016 về xử phạt"
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
            , hieuluc: "2/15/2016"
            , vanbanThaytheId: 0
            , tenRutgon: "Thông tư 01/2016 về tuần tra kiểm soát"
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
            , hieuluc: "7/1/2009"
            , vanbanThaytheId: 0
            , tenRutgon: "Luật giao thông đường bộ 2008"
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
            , hieuluc: "7/1/2013"
            , vanbanThaytheId: 0
            , tenRutgon: "Luật xử lý vi phạm hành chính 2012"
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
            , hieuluc: "1/1/2020"
            , vanbanThaytheId: 2
            , tenRutgon: "Nghị định 100/2019 về xử phạt"
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
            , hieuluc: "7/1/2020"
            , vanbanThaytheId: 1
            , tenRutgon: "Quy chuẩn 41/2019 về báo hiệu đường bộ"
        )
        vanbans.append(qc412019)
        
        let tt652020 = Vanban(
            id: 8
            , ten: "QUY ĐỊNH NHIỆM VỤ, QUYỀN HẠN, HÌNH THỨC, NỘI DUNG VÀ QUY TRÌNH TUẦN TRA, KIỂM SOÁT, XỬ LÝ VI PHẠM HÀNH CHÍNH VỀ GIAO THÔNG ĐƯỜNG BỘ CỦA CẢNH SÁT GIAO THÔNG"
            , loai: thongtu
            , so: "65"
            , nam: "2020"
            , ma: "65/2020/TT-BCA"
            , coquanbanhanh: bocongan
            , noidung: "Căn cứ Luật Giao thông đường bộ ngày 13 tháng 11 năm 2008;\nCăn cứ Luật Xử lý vi phạm hành chính ngày 20 tháng 6 năm 2012;\nCăn cứ Luật Công an nhân dân ngày 20 tháng 11 năm 2018;\nCăn cứ Nghị định số 01/2018/NĐ-CP ngày 06 tháng 8 năm 2018 của Chính phủ quy định về chức năng, nhiệm vụ, quyền hạn và cơ cấu tổ chức của Bộ Công an;\nCăn cứ Nghị định số 100/2019/NĐ-CP ngày 30 tháng 12 năm 2019 của Chính phủ quy định xử phạt vi phạm hành chính trong lĩnh vực giao thông đường bộ và đường sắt;\nTheo đề nghị của Cục trưởng Cục Cảnh sát giao thông,\nBộ trưởng Bộ Công an ban hành Thông tư quy định nhiệm vụ, quyền hạn, hình thức, nội dung và quy trình tuần tra, kiểm soát, xử lý vi phạm hành chính về giao thông đường bộ của Cảnh sát giao thông."
            , hieuluc: "8/5/2020"
            , vanbanThaytheId: 3
            , tenRutgon: "Thông tư 65/2020 về tuần tra kiểm soát"
        )
        vanbans.append(tt652020)
        
        let tt632020 = Vanban(
            id: 9
            , ten: "QUY ĐỊNH QUY TRÌNH ĐIỀU TRA, GIẢI QUYẾT TAI NẠN GIAO THÔNG ĐƯỜNG BỘ CỦA LỰC LƯỢNG CẢNH SÁT GIAO THÔNG"
            , loai: thongtu
            , so: "63"
            , nam: "2020"
            , ma: "63/2020/TT-BCA"
            , coquanbanhanh: bocongan
            , noidung: "Căn cứ Luật Xử lý vi phạm hành chính ngày 20 tháng 6 năm 2012;\nCăn cứ Luật Giao thông đường bộ ngày 13 tháng 11 năm 2008;\nCăn cứ Bộ luật Hình sự ngày 27 tháng 11 năm 2015 (Luật sửa đổi, bổ sung một số điều của Bộ luật Hình sự ngày 20 tháng 6 năm 2017);\nCăn cứ Bộ luật Tố tụng hình sự ngày 27 tháng 11 năm 2015;\nCăn cứ Luật Tổ chức cơ quan điều tra hình sự ngày 26 tháng 11 năm 2015;\nCăn cứ Luật Công an nhân dân ngày 20 tháng 11 năm 2018;\nCăn cứ Luật trưng mua, trưng dụng tài sản ngày 03 tháng 6 năm 2008;\nCăn cứ Nghị định số 01/2018/NĐ-CP ngày 06 tháng 8 năm 2018 của Chính phủ quy định chức năng, nhiệm vụ, quyền hạn và cơ cấu tổ chức của Bộ Công an;\nTheo đề nghị của Cục trưởng Cục Cảnh sát giao thông;\nBộ trưởng Bộ Công an ban hành Thông tư quy định quy trình điều tra, giải quyết tai nạn giao thông đường bộ của lực lượng Cảnh sát giao thông."
            , hieuluc: "1/1/2021"
            , vanbanThaytheId: 0
            , tenRutgon: "Thông tư 63/2020 về xử lý tai nạn giao thông"
        )
        vanbans.append(tt632020)
        
        let tt312019 = Vanban(
            id: 10
            , ten: "QUY ĐỊNH VỀ TỐC ĐỘ VÀ KHOẢNG CÁCH AN TOÀN CỦA XE CƠ GIỚI, XE MÁY CHUYÊN DÙNG THAM GIA GIAO THÔNG ĐƯỜNG BỘ"
            , loai: thongtu
            , so: "31"
            , nam: "2019"
            , ma: "31/2019/TT-BGTVT"
            , coquanbanhanh: bogiaothongvantai
            , noidung: "Căn cứ Luật Giao thông đường bộ số 23/2008/QH12;\nCăn cứ Nghị định số 12/2017/NĐ-CP ngày 10 tháng 02 năm 2017 của Chính phủ quy định chức năng, nhiệm vụ, quyền hạn và cơ cấu tổ chức của Bộ Giao thông vận tải;\nTheo đề nghị của Vụ trưởng Vụ Kết cấu hạ tầng giao thông và Tổng cục trưởng Tổng cục Đường bộ Việt Nam;\nBộ trưởng Bộ Giao thông vận tải ban hành Thông tư quy định về tốc độ và khoảng cách an toàn của xe cơ giới, xe máy chuyên dùng tham gia giao thông trên đường bộ."
            , hieuluc: "10/15/2019"
            , vanbanThaytheId: 0
            , tenRutgon: "Thông tư 31/2019 về tốc độ và khoảng cách"
        )
        vanbans.append(tt312019)
        
        let tt672019 = Vanban(
            id: 11
            , ten: "QUY ĐỊNH VỀ THỰC HIỆN DÂN CHỦ TRONG CÔNG TÁC BẢO ĐẢM TRẬT TỰ, AN TOÀN GIAO THÔNG"
            , loai: thongtu
            , so: "67"
            , nam: "2019"
            , ma: "67/2019/TT-BCA"
            , coquanbanhanh: bocongan
            , noidung: "Căn cứ Luật Tiếp cận thông tin ngày 06 tháng 4 năm 2016;\nCăn cứ Luật Công an nhân dân ngày 20 tháng 11 năm 2018;\nCăn cứ Nghị quyết số 55/NQ-UBTVQH10 ngày 30 tháng 8 năm 1998 của Ủy ban Thường vụ Quốc hội về việc ban hành Quy chế thực hiện dân chủ trong hoạt động của cơ quan;\nCăn cứ Nghị định số 04/2015/NĐ-CP ngày 09 tháng 01 năm 2015 của Chính phủ về thực hiện dân chủ trong hoạt động của cơ quan hành chính nhà nước và đơn vị sự nghiệp công lập;\nCăn cứ Nghị định số 01/2018/NĐ-CP ngày 06 tháng 8 năm 2018 của Chính phủ quy định chức năng, nhiệm vụ, quyền hạn và cơ cấu tổ chức của Bộ Công an;\nTheo đề nghị của Cục trưởng Cục Cảnh sát giao thông;\nBộ trưởng Bộ Công an ban hành Thông tư quy định về thực hiện dân chủ trong công tác bảo đảm trật tự, an toàn giao thông."
            , hieuluc: "1/15/2020"
            , vanbanThaytheId: 0
            , tenRutgon: "Thông tư 67/2019 về thực hiện dân chủ"
        )
        vanbans.append(tt672019)
        
        let nd102020 = Vanban(
            id: 12
            , ten: "QUY ĐỊNH VỀ KINH DOANH VÀ ĐIỀU KIỆN KINH DOANH VẬN TẢI BẰNG XE Ô TÔ"
            , loai: nghidinh
            , so: "10"
            , nam: "2020"
            , ma: "10/2020/NĐ-CP"
            , coquanbanhanh: chinhphu
            , noidung: "Căn cứ Luật Tổ chức Chính phủ ngày 19 tháng 6 năm 2015;\nCăn cứ Luật Giao thông đường bộ ngày 13 tháng 11 năm 2008;\nCăn cứ Luật Đầu tư ngày 26 tháng 11 năm 2014 và Luật sửa đổi, bổ sung Điều 6 và Phụ lục 4 về Danh mục ngành, nghề đầu tư kinh doanh có điều kiện của Luật Đầu tư ngày 26 tháng 11 năm 2016;\nTheo đề nghị của Bộ trưởng Bộ Giao thông vận tải;\nChính phủ ban hành Nghị định quy định về kinh doanh và điều kiện kinh doanh vận tải bằng xe ô tô."
            , hieuluc: "4/1/2020"
            , vanbanThaytheId: 0
            , tenRutgon: "Nghị định 10/2020 về kinh doanh vận tải"
        )
        vanbans.append(nd102020)
        
        let nd1652013 = Vanban(
            id: 13
            , ten: "Quy định việc quản lý, sử dụng và danh mục các phương tiện, thiết bị kỹ thuật nghiệp vụ được sử dụng để phát hiện vi phạm hành chính về trật tự, an toàn giao thông và bảo vệ môi trường"
            , loai: nghidinh
            , so: "165"
            , nam: "2013"
            , ma: "165/2013/NĐ-CP"
            , coquanbanhanh: chinhphu
            , noidung: "Căn cứ Luật Tổ chức Chính phủ ngày 25 tháng 12 năm 2001;\nCăn cứ Luật Xử lý vi phạm hành chính ngày 20 tháng 6 năm 2012;\nCăn cứ Luật Quản lý, sử dụng tài sản nhà nước ngày 03 tháng 6 năm 2008;\nTheo đề nghị của Bộ trưởng Bộ Công an;\nChính phủ ban hành Nghị định quy định việc quản lý, sử dụng và danh mục các phương tiện, thiết bị kỹ thuật nghiệp vụ được sử dụng để phát hiện vi phạm hành chính về trật tự, an toàn giao thông và bảo vệ môi trường,"
            , hieuluc: "12/28/2013"
            , vanbanThaytheId: 0
            , tenRutgon: "Nghị định 165/2013 về thiết bị kỹ thuật nghiệp vụ"
        )
        vanbans.append(nd1652013)
        
        let tt402015 = Vanban(
            id: 14
            , ten: "Quy định về sử dụng phương tiện, thiết bị kỹ thuật nghiệp vụ trong Công an nhân dân để phát hiện vi phạm hành chính về trật tự, an toàn giao thông và bảo vệ môi trường"
            , loai: thongtu
            , so: "40"
            , nam: "2015"
            , ma: "40/2015/TT-BCA"
            , coquanbanhanh: bocongan
            , noidung: "Căn cứ Luật xử lý vi phạm hành chính năm 2012;\nCăn cứ Nghị định số 165/2013/NĐ-CP ngày 12 tháng 11 năm 2013 quy định việc quản lý, sử dụng và danh mục các phương tiện, thiết bị kỹ thuật nghiệp vụ được sử dụng để phát hiện vi phạm hành chính về trật tự, an toàn giao thông và bảo vệ môi trường;\nCăn cứ Nghị định số 106/2014/NĐ-CP ngày 17 tháng 11 năm 2014 quy định chức năng, nhiệm vụ, quyền hạn và cơ cấu tổ chức của Bộ Công an;\nTheo đề nghị của Tổng cục trưởng Tổng cục Cảnh sát;\nBộ trưởng Bộ Công an ban hành Thông tư quy định về sử dụng phương tiện, thiết bị kỹ thuật nghiệp vụ trong Công an nhân dân để phát hiện vi phạm hành chính về trật tự, an toàn giao thông và bảo vệ môi trường."
            , hieuluc: "10/15/2015"
            , vanbanThaytheId: 0
            , tenRutgon: "Thông tư 40/2015 về thiết bị kỹ thuật nghiệp vụ"
        )
        vanbans.append(tt402015)
        
        let tt582020 = Vanban(
            id: 15
            , ten: "QUY ĐỊNH QUY TRÌNH CẤP, THU HỒI ĐĂNG KÝ, BIỂN SỐ PHƯƠNG TIỆN GIAO THÔNG CƠ GIỚI ĐƯỜNG BỘ"
            , loai: thongtu
            , so: "58"
            , nam: "2020"
            , ma: "58/2020/TT-BCA"
            , coquanbanhanh: bocongan
            , noidung: "Căn cứ Luật Giao thông đường bộ ngày 13 tháng 11 năm 2008;\nCăn cứ Bộ luật Dân sự ngày 24 tháng 11 năm 2015;\nCăn cứ Nghị định số 01/2018/NĐ-CP ngày 06 tháng 8 năm 2018 của Chính phủ quy định chức năng, nhiệm vụ, quyền hạn và cơ cấu tổ chức của Bộ Công an;\nTheo đề nghị của Cục trưởng Cục Cảnh sát giao thông;\nBộ trưởng Bộ Công an ban hành Thông tư quy định về quy trình cấp, thu hồi đăng ký, biển số phương tiện giao thông cơ giới đường bộ."
            , hieuluc: "01/08/2020"
            , vanbanThaytheId: 0
            , tenRutgon: "Thông tư 58/2015 về cấp đổi biển số"
        )
        vanbans.append(tt582020)
        
        let luatxlvphc2020 = Vanban(
            id: 16
            , ten: "LUẬT XỬ LÝ VI PHẠM HÀNH CHÍNH"
            , loai: luat
            , so: "67"
            , nam: "2020"
            , ma: "67/2020/QH14"
            , coquanbanhanh: quochoi
            , noidung: "Luật Xử lý vi phạm hành chính số 15/2012/QH13 ngày 20 tháng 6 năm 2012 của Quốc hội, có hiệu lực kể từ ngày 01 tháng 7 năm 2013, được sửa đổi, bổ sung bởi:\n1. Luật Hải quan số 54/2014/QH13 ngày 23 tháng 6 năm 2014 của Quốc hội, có hiệu lực kể từ ngày 01 tháng 01 năm 2015;\n2. Luật Thủy sản số 18/2017/QH14 ngày 21 tháng 11 năm 2017 của Quốc hội, có hiệu lực kể từ ngày 01 tháng 01 năm 2019;\n3. Luật số 67/2020/QH14 ngày 13 tháng 11 năm 2020 của Quốc hội sửa đổi, bổ sung một số điều của Luật Xử lý vi phạm hành chính, có hiệu lực kể từ ngày 01 tháng 01 năm 2022.\nCăn cứ Hiến pháp nước Cộng hòa xã hội chủ nghĩa Việt Nam năm 1992 đã được sửa đổi, bổ sung một số điều theo Nghị quyết số 51/2001/QH10;\nQuốc hội ban hành Luật xử lý vi phạm hành chính"
            , hieuluc: "1/1/2022"
            , vanbanThaytheId: 5
            , tenRutgon: "Luật xử lý vi phạm hành chính 2020"
        )
        vanbans.append(luatxlvphc2020)
        
        let nd1232021 = Vanban(
            id: 17
            , ten: "NGHỊ ĐỊNH QUY ĐỊNH XỬ PHẠT VI PHẠM HÀNH CHÍNH TRONG LĨNH VỰC GIAO THÔNG ĐƯỜNG BỘ VÀ ĐƯỜNG SẮT"
            , loai: nghidinh
            , so: "123"
            , nam: "2021"
            , ma: "123/2021/NĐ-CP"
            , coquanbanhanh: chinhphu
            , noidung: "Căn cứ Luật Tổ chức Chính phủ ngày 19 tháng 6 năm 2015; Luật sửa đổi, bổ sung một số điều của Luật Tổ chức Chính phủ và Luật Tổ chức chính quyền địa phương ngày 22 tháng 11 năm 2019;\nCăn cứ Luật Xử lý vi phạm hành chính ngày 20 tháng 6 năm 2012 và Luật sửa đổi, bổ sung một số điều của Luật Xử lý vi phạm hành chính ngày 13 tháng 11 năm 2020;\nCăn cứ Bộ luật Hàng hải Việt Nam ngày 25 tháng 11 năm 2015;\nCăn cứ Luật Hàng không dân dụng Việt Nam ngày 29 tháng 6 năm 2006 và Luật sửa đổi, bổ sung một số điều của Luật Hàng không dân dụng Việt Nam ngày 21 tháng 11 năm 2014;\nCăn cứ Luật Giao thông đường bộ ngày 13 tháng 11 năm 2008;\nCăn cứ Luật Đường sắt ngày 16 tháng 6 năm 2017;\nTheo đề nghị của Bộ trưởng Bộ Giao thông vận tải;\nChính phủ ban hành Nghị định sửa đổi, bổ sung một số điều của các Nghị định quy định xử phạt vi phạm hành chính trong lĩnh vực hàng hải; giao thông đường bộ, đường sắt; hàng không dân dụng."
            , hieuluc: "1/1/2022"
            , vanbanThaytheId: 6
            , tenRutgon: "Nghị định 100+123/2019 về xử phạt"
        )
        vanbans.append(nd1232021)
        
        let luatttatgtdb2024 = Vanban(
            id: 18
            , ten: "Luật Trật tự, an toàn giao thông đường bộ"
            , loai: luat
            , so: "36"
            , nam: "2024"
            , ma: "36/2024/QH15"
            , coquanbanhanh: quochoi
            , noidung: "Căn cứ Hiến pháp nước Cộng hòa xã hội chủ nghĩa Việt Nam;\nQuốc hội ban hành Luật Trật tự, an toàn giao thông đường bộ."
            , hieuluc: "1/1/2025"
            , vanbanThaytheId: 4
            , tenRutgon: "Luật Giao thông 2024"
        )
        vanbans.append(luatttatgtdb2024)
        
        let tt722024 = Vanban(
            id: 19
            , ten: "Quy định quy trình điều tra, giải quyết tai nạn giao thông đường bộ của Cảnh sát giao thông"
            , loai: thongtu
            , so: "72"
            , nam: "2024"
            , ma: "72/2024/TT-BCA"
            , coquanbanhanh: bocongan
            , noidung: "Căn cứ Bộ luật Tố tụng hình sự ngày 27 tháng 11 năm 2015; Luật sửa đổi, bổ sung một số điều của Bộ luật Tố tụng hình sự ngày 12 tháng 11 năm 2021;\nCăn cứ Bộ luật hình sự ngày 27 tháng 11 năm 2015; Luật sửa đổi, bổ sung một số điều của Bộ luật hình sự ngày 20 tháng 6 năm 2017;\nCăn cứ Luật Trật tự an toàn giao thông đường bộ ngày 27 tháng 6 năm 2024;\nCăn cứ Luật Công an nhân dân ngày 20 tháng 11 năm 2018; Luật sửa đổi, bổ sung một số điều của Luật Công an nhân dân ngày 22 tháng 6 năm 2023;\nCăn cứ Luật Xử lý vi phạm hành chính ngày 20 tháng 6 năm 2012; Luật sửa đổi, bổ sung một số điều của Luật Xử lý vi phạm hành chính ngày 13 tháng 11 năm 2020;\nCăn cứ Luật Tổ chức cơ quan điều tra hình sự ngày 26 tháng 11 năm 2015;\nCăn cứ Nghị định số 01/2018/NĐ-CP ngày 06 tháng 8 năm 2018 của Chính phủ quy định chức năng, nhiệm vụ, quyền hạn và cơ cấu tổ chức của Bộ Công an;\nTheo đề nghị của Cục trưởng Cục Cảnh sát giao thông;\nBộ trưởng Bộ Công an ban hành Thông tư quy định quy trình điều tra, giải quyết tai nạn giao thông đường bộ của Cảnh sát giao thông."
            , hieuluc: "01/01/2025"
            , vanbanThaytheId: 9
            , tenRutgon: "Thông tư 72/2024 về xử lý tai nạn giao thông"
        )
        vanbans.append(tt722024)
        
        let tt732024 = Vanban(
            id: 20
            , ten: "Quy định công tác tuần tra, kiểm soát, xử lý vi phạm pháp luật về trật tự, an toàn giao thông đường bộ của Cảnh sát giao thông"
            , loai: thongtu
            , so: "73"
            , nam: "2024"
            , ma: "73/2024/TT-BCA"
            , coquanbanhanh: bocongan
            , noidung: "Căn cứ Luật Trật tự, an toàn giao thông đường bộ ngày 27 tháng 6 năm 2024;\nCăn cứ Luật Công an nhân dân ngày 20 tháng 11 năm 2018 và Luật sửa đổi, bổ sung một số điều của Luật Công an nhân dân ngày 22 tháng 6 năm 2023;\nCăn cứ Luật Xử lý vi phạm hành chính ngày 20 tháng 6 năm 2012 và Luật sửa đổi, bổ sung một số điều của Luật Xử lý vi phạm hành chính ngày 13 tháng 11 năm 2020;\nCăn cứ Nghị định số 118/2021/NĐ-CP ngày 23 tháng 12 năm 2021 của Chính phủ quy định chi tiết một số điều và biện pháp thi hành Luật Xử lý vi phạm hành chính;\nCăn cứ Nghị định số 135/2021/NĐ-CP ngày 31 tháng 12 năm 2021 của Chính phủ quy định về danh mục, việc quản lý, sử dụng phương tiện, thiết bị kỹ thuật nghiệp vụ và quy trình thu thập, sử dụng dữ liệu thu được từ phương tiện, thiết bị kỹ thuật do cá nhân, tổ chức cung cấp để phát hiện vi phạm hành chính;\nCăn cứ Nghị định số 01/2018/NĐ-CP ngày 06 tháng 8 năm 2018 của Chính phủ quy định chức năng, nhiệm vụ, quyền hạn và cơ cấu tổ chức của Bộ Công an;\nTheo đề nghị của Cục trưởng Cục Cảnh sát giao thông;\nBộ trưởng Bộ Công an ban hành Thông tư quy định công tác tuần tra, kiểm soát, xử lý vi phạm pháp luật về trật tự, an toàn giao thông đường bộ của Cảnh sát giao thông."
            , hieuluc: "01/01/2025"
            , vanbanThaytheId: 8
            , tenRutgon: "Thông tư 73/2024 về tuần tra kiểm soát"
        )
        vanbans.append(tt732024)
        
        let tt382024 = Vanban(
            id: 21
            , ten: "Quy định về tốc độ và khoảng cách an toàn của xe cơ giới, xe máy chuyên dùng tham gia giao thông trên đường bộ"
            , loai: thongtu
            , so: "38"
            , nam: "2024"
            , ma: "38/2024/TT-BGTVT"
            , coquanbanhanh: bogiaothongvantai
            , noidung: "Căn cứ Luật Trật tự, an toàn giao thông đường bộ ngày 27 tháng 6 năm 2024;\nCăn cứ Luật Đường bộ ngày 27 tháng 6 năm 2024;\nCăn cứ Nghị định số 56/2022/NĐ-CP ngày 24 tháng 8 năm 2022 của Chính phủ quy định chức năng, nhiệm vụ, quyền hạn và cơ cấu tổ chức của Bộ Giao thông vận tải;\nTheo đề nghị của Vụ trưởng Vụ Kết cấu hạ tầng giao thông và Cục trưởng Cục đường bộ Việt Nam;\nBộ trưởng Bộ Giao thông vận tải ban hành Thông tư quy định về tốc độ và khoảng cách an toàn của xe cơ giới, xe máy chuyên dùng tham gia giao thông trên đường bộ."
            , hieuluc: "01/01/2025"
            , vanbanThaytheId: 10
            , tenRutgon: "Thông tư 38/2024 về tốc độ và khoảng cách"
        )
        vanbans.append(tt382024)
        
        let qc412024 = Vanban(
            id: 22
            , ten: "QUY CHUẨN KỸ THUẬT QUỐC GIA VỀ BÁO HIỆU ĐƯỜNG BỘ"
            , loai: quychuan
            , so: "41"
            , nam: "2024"
            , ma: "QCVN 41:2024/BGTVT"
            , coquanbanhanh: bogiaothongvantai
            , noidung: "QCVN 41:2024/BGTVT thay thế QCVN 41:2019/BGTVT.\nQuy chuẩn kỹ thuật Quốc gia về báo hiệu đường bộ QCVN 41:2024/BGTVT do Cục Đường bộ Việt Nam biên soạn, Bộ Khoa học và Công nghệ thẩm định, Bộ trưởng Bộ Giao thông vận tải ban hành theo Thông tư số /2024/TT-BGTVT ngày 15 tháng 11 năm 2024."
            , hieuluc: "1/1/2025"
            , vanbanThaytheId: 7
            , tenRutgon: "Quy chuẩn 41/2019 về báo hiệu đường bộ"
        )
        vanbans.append(qc412024)
        let nd1682024 = Vanban(
            id: 23
            , ten: "QUY ĐỊNH XỬ PHẠT VI PHẠM HÀNH CHÍNH VỀ TRẬT TỰ, AN TOÀN GIAO THÔNG TRONG LĨNH VỰC GIAO THÔNG ĐƯỜNG BỘ; TRỪ ĐIỂM, PHỤC HỒI ĐIỂM GIẤY PHÉP LÁI XE"
            , loai: nghidinh
            , so: "168"
            , nam: "2024"
            , ma: "168/2024/NĐ-CP"
            , coquanbanhanh: chinhphu
            , noidung: "Căn cứ Luật Tổ chức Chính phủ ngày 19 tháng 6 năm 2015; Luật sửa đổi, bổ sung một số điều của Luật Tổ chức Chính phủ và Luật Tổ chức chính quyền địa phương ngày 22 tháng 11 năm 2019;\nCăn cứ Luật Xử lý vi phạm hành chính ngày 20 tháng 6 năm 2012; Luật sửa đổi, bổ sung một số điều của Luật Xử lý vi phạm hành chính ngày 15 tháng 11 năm 2020;\nCăn cứ Luật Trật tự, an toàn giao thông đường bộ ngày 27 tháng 6 năm 2024;\nTheo đề nghị của Bộ trưởng Bộ Công an;\nChính phủ ban hành Nghị định quy định xử phạt vi phạm hành chính về trật tự, an toàn giao thông trong lĩnh vực giao thông đường bộ; trừ điểm, phục hồi điểm giấy phép lái xe."
            , hieuluc: "1/1/2025"
            , vanbanThaytheId: 17
            , tenRutgon: "Nghị định 168/2024 về xử phạt"
        )
        vanbans.append(nd1682024)
    }
    
    private func initInitialData() {
        print("\n================= Inserting Raw Data To Database ====================\n")
        //insert QC412016 data, vanbanid is 1
        print("\n==== Inserting Raw Data To Database: QC412016_queries")
        Queries.executeStatements(query: Utils.readFromFile(name: "QC412016_queries"))
        //insert ND462016 data, vanbanid is 2
        print("\n==== Inserting Raw Data To Database: ND462016_queries")
        Queries.executeStatements(query: Utils.readFromFile(name: "ND462016_queries"))
        Queries.executeStatements(query: Utils.readFromFile(name: "ND462016linhvuc"))
        Queries.executeStatements(query: Utils.readFromFile(name: "ND462016phuongtien"))
        Queries.executeStatements(query: Utils.readFromFile(name: "ND462016mucphat"))
        Queries.executeStatements(query: Utils.readFromFile(name: "ND462016keywords"))
        DieukhoanParser().initHinhphatbosungBienphapkhacphuc(hinhphatbosungFilename: "ND462016hinhphatbosung", bienphapkhacphucFilename: "ND462016bienphapkhacphuc")
        
        print("\n==== Inserting Raw Data To Database: TT012016")
        let tt012016 = RawDataInitializer(fileName: "TT012016", vanban: getVanbanById(id: 3))
        insertDataByQuery(queries: tt012016.transformRawDataToSqlQuery())
        
        print("\n==== Inserting Raw Data To Database: LGTDB2008")
        let lgtdb2008 = RawDataInitializer(fileName: "LGTDB2008", vanban: getVanbanById(id: 4))
        insertDataByQuery(queries: lgtdb2008.transformRawDataToSqlQuery())
        
        print("\n==== Inserting Raw Data To Database: LXLVPHC2012")
        let lxlvphc2012 = RawDataInitializer(fileName: "LXLVPHC2012", vanban: getVanbanById(id: 5))
        insertDataByQuery(queries: lxlvphc2012.transformRawDataToSqlQuery())
        
        print("\n==== Inserting Raw Data To Database: ND1002019")
        let nd1002019 = RawDataInitializer(fileName: "ND1002019", vanban: getVanbanById(id: 6))
        insertDataByQuery(queries: nd1002019.transformRawDataToSqlQuery())
        Queries.executeStatements(query: Utils.readFromFile(name: "ND1002019linhvuc"))
        Queries.executeStatements(query: Utils.readFromFile(name: "ND1002019phuongtien"))
        Queries.executeStatements(query: Utils.readFromFile(name: "ND1002019mucphat"))
        Queries.executeStatements(query: Utils.readFromFile(name: "ND1002019keywords"))
        DieukhoanParser().initHinhphatbosungBienphapkhacphuc(hinhphatbosungFilename: "ND1002019hinhphatbosung", bienphapkhacphucFilename: "ND1002019bienphapkhacphuc")
        
        //insert QC412019
        print("\n==== Inserting Raw Data To Database: QC412019")
        let qc412019 = RawDataInitializer(fileName: "QC412019", vanban: getVanbanById(id: 7))
        qc412019.transformRawDataToCsv()
        qc412019.updateDieukhoanWithMinhhoa()
        insertDataByQuery(queries: qc412019.transformRawDataToSqlQuery())
        let qc412019PL = RawDataInitializer(fileName: "QC412019-PL", vanban: getVanbanById(id: 7))
        qc412019PL.transformRawDataToCsv()
        qc412019PL.updateDieukhoanWithMinhhoa()
        insertDataByQuery(queries: qc412019PL.transformRawDataToSqlQuery())
        
        //insert TT652020
        print("\n==== Inserting Raw Data To Database: TT652020")
        Queries.executeStatements(query: RawDataInitializer(fileName: "TT652020", vanban: getVanbanById(id: 8)).transformRawDataToSqlQuery())
        
        //insert TT632020
        print("\n==== Inserting Raw Data To Database: TT632020")
        Queries.executeStatements(query: RawDataInitializer(fileName: "TT632020", vanban: getVanbanById(id: 9)).transformRawDataToSqlQuery())
        
        //insert TT312019
        print("\n==== Inserting Raw Data To Database: TT312019")
        let tt312019 = RawDataInitializer(fileName: "TT312019", vanban: getVanbanById(id: 10))
        tt312019.transformRawDataToCsv()
        tt312019.updateDieukhoanWithMinhhoa()
        insertDataByQuery(queries: tt312019.transformRawDataToSqlQuery())
        
        //insert TT672019
        print("\n==== Inserting Raw Data To Database: TT672019")
        Queries.executeStatements(query: RawDataInitializer(fileName: "TT672019", vanban: getVanbanById(id: 11)).transformRawDataToSqlQuery())
        
        //insert ND102020
        print("\n==== Inserting Raw Data To Database: ND102020")
        Queries.executeStatements(query: RawDataInitializer(fileName: "ND102020", vanban: getVanbanById(id: 12)).transformRawDataToSqlQuery())
        
        //insert ND1652013
        print("\n==== Inserting Raw Data To Database: ND1652013")
        Queries.executeStatements(query: RawDataInitializer(fileName: "ND1652013", vanban: getVanbanById(id: 13)).transformRawDataToSqlQuery())
        
        //insert TT402015
        print("\n==== Inserting Raw Data To Database: TT402015")
        Queries.executeStatements(query: RawDataInitializer(fileName: "TT402015", vanban: getVanbanById(id: 14)).transformRawDataToSqlQuery())
        
        //insert Luat XLVPHC 2020
        print("\n==== Inserting Raw Data To Database: TT582020")
        Queries.executeStatements(query: RawDataInitializer(fileName: "TT582020", vanban: getVanbanById(id: 15)).transformRawDataToSqlQuery())
        
        //insert Luat XLVPHC 2020
        print("\n==== Inserting Raw Data To Database: LuatXLVPHC-2020")
        Queries.executeStatements(query: RawDataInitializer(fileName: "31_VBHN-VPQH-LuatXLVPHC-2012-2020", vanban: getVanbanById(id: 16)).transformRawDataToSqlQuery())
        
        //insert nd1232021
        print("\n==== Inserting Raw Data To Database: ND1232022")
        let nd1232021 = RawDataInitializer(fileName: "VBHN-03-2022-BGTVT", vanban: getVanbanById(id: 17))
        insertDataByQuery(queries: nd1232021.transformRawDataToSqlQuery())
        Queries.executeStatements(query: Utils.readFromFile(name: "VBHN-03-2022-BGTVTlinhvuc"))
        Queries.executeStatements(query: Utils.readFromFile(name: "VBHN-03-2022-BGTVTphuongtien"))
        Queries.executeStatements(query: Utils.readFromFile(name: "VBHN-03-2022-BGTVTmucphat"))
        Queries.executeStatements(query: Utils.readFromFile(name: "VBHN-03-2022-BGTVTkeywords"))
        DieukhoanParser().initHinhphatbosungBienphapkhacphuc(hinhphatbosungFilename: "VBHN-03-2022-BGTVThinhphatbosung", bienphapkhacphucFilename: "VBHN-03-2022-BGTVTbienphapkhacphuc")
        
        //insert LGTDB2024
        print("\n==== Inserting Raw Data To Database: luatttatgtdb2024")
        let lttatgtdb2024 = RawDataInitializer(fileName: "luatttatgtdb2024", vanban: getVanbanById(id: 18))
        insertDataByQuery(queries: lttatgtdb2024.transformRawDataToSqlQuery())
        
        //insert TT722024
        print("\n==== Inserting Raw Data To Database: TT722024")
        let tt722024 = RawDataInitializer(fileName: "TT722024", vanban: getVanbanById(id: 19))
        insertDataByQuery(queries: tt722024.transformRawDataToSqlQuery())
        
        //insert TT732024
        print("\n==== Inserting Raw Data To Database: TT732024")
        let tt732024 = RawDataInitializer(fileName: "TT732024", vanban: getVanbanById(id: 20))
        insertDataByQuery(queries: tt732024.transformRawDataToSqlQuery())
        
        //insert TT382024
        print("\n==== Inserting Raw Data To Database: TT382024")
        let tt382024 = RawDataInitializer(fileName: "TT382024", vanban: getVanbanById(id: 21))
        tt382024.transformRawDataToCsv()
        tt382024.updateDieukhoanWithMinhhoa()
        insertDataByQuery(queries: tt382024.transformRawDataToSqlQuery())
        
        //insert QC412024
        print("\n==== Inserting Raw Data To Database: QC412024")
        let qc412024 = RawDataInitializer(fileName: "QC412024", vanban: getVanbanById(id: 22))
        qc412024.transformRawDataToCsv()
        qc412024.updateDieukhoanWithMinhhoa()
        insertDataByQuery(queries: qc412024.transformRawDataToSqlQuery())
        let qc412024PL = RawDataInitializer(fileName: "QC412024-PL", vanban: getVanbanById(id: 22))
        qc412024PL.transformRawDataToCsv()
        qc412024PL.updateDieukhoanWithMinhhoa()
        insertDataByQuery(queries: qc412024PL.transformRawDataToSqlQuery())
        
        //insert ND1682024
        print("\n==== Inserting Raw Data To Database: ND1682024")
        let ND1682024 = RawDataInitializer(fileName: "ND1682024", vanban: getVanbanById(id: 23))
        insertDataByQuery(queries: ND1682024.transformRawDataToSqlQuery())
//        Queries.executeStatements(query: Utils.readFromFile(name: "VBHN-03-2022-BGTVTlinhvuc"))
//        Queries.executeStatements(query: Utils.readFromFile(name: "VBHN-03-2022-BGTVTphuongtien"))
//        Queries.executeStatements(query: Utils.readFromFile(name: "VBHN-03-2022-BGTVTmucphat"))
//        Queries.executeStatements(query: Utils.readFromFile(name: "VBHN-03-2022-BGTVTkeywords"))
//        DieukhoanParser().initHinhphatbosungBienphapkhacphuc(hinhphatbosungFilename: "VBHN-03-2022-BGTVThinhphatbosung", bienphapkhacphucFilename: "VBHN-03-2022-BGTVTbienphapkhacphuc")
        
        print("\n================= Finished Inserting Raw Data To Database ====================\n")
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
        
        print("=====================================")
        print("Set user version to: \(userVersion)......")
        Queries.executeStatements(query: "pragma user_version = \(userVersion)")
        print("Creating new tables......")
        print("-----Creating tblCoquanbanhanh")
        //Create tblCoquanbanhanh table
        Queries.executeStatements(query: "CREATE TABLE \"tblCoquanbanhanh\" (\"id\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, \"ten\" TEXT COLLATE NOCASE)")
        //insert data into tblCoquanbanhanh table
        for cqbh in coquanbanhanh {
            let query = "INSERT INTO \"tblCoquanbanhanh\" ( \"id\", \"ten\") VALUES ( \(cqbh.getId()),  \"\(cqbh.getTen())\")"
            Queries.executeStatements(query: query)
        }
        
        //Create tblLoaiVanban table
        print("-----Creating tblLoaiVanban")
        Queries.executeStatements(query: "CREATE TABLE \"tblLoaiVanban\" (\"id\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, \"ten\" TEXT COLLATE NOCASE)")
        //insert data into tblLoaiVanban table
        for lvb in loaivanban {
            let query = "INSERT INTO \"tblLoaiVanban\" ( \"id\", \"ten\") VALUES ( \(lvb.getId()), \"\(lvb.getTen())\" );"
            Queries.executeStatements(query: query)
        }
        
        //Create tblVanban table
        print("-----Creating tblVanban")
        Queries.executeStatements(query: "CREATE TABLE \"tblVanban\" (\"id\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, \"ten\" TEXT COLLATE NOCASE, \"loai\" INTEGER COLLATE NOCASE REFERENCES \"tblLoaiVanban\" (\"id\"), \"so\" TEXT COLLATE NOCASE, \"nam\" TEXT COLLATE NOCASE, \"ma\" TEXT COLLATE NOCASE, \"coquanbanhanh\" INTEGER COLLATE NOCASE REFERENCES \"tblCoquanbanhanh\" (\"id\"), \"noidung\" TEXT COLLATE NOCASE,\"hieuluc\" Text COLLATE NOCASE,\"vanbanThaytheId\" Integer,\"tenRutgon\" Text COLLATE NOCASE)")
        //insert data into tblVanban table
        for vb in vanbans {
            let query = "INSERT INTO 'tblVanban' ( 'coquanbanhanh', 'hieuluc', 'id', 'loai', 'ma', 'nam', 'noidung', 'so', 'ten', 'tenRutgon', 'vanbanThaytheId') VALUES ( '\(vb.getCoquanbanhanh().getId())', '\(vb.getHieuluc())', '\(vb.getId())', '\(vb.getLoai().getId())', '\(vb.getMa())', '\(vb.getNam())', '\(vb.getNoidung())', '\(vb.getSo())', '\(vb.getTen())', '\(vb.getTenRutgon())', '\(vb.getVanbanThaytheId())' );"
            Queries.executeStatements(query: query)
        }
        
        
        //create tblChitietvanban table
        print("-----Creating tblChitietvanban")
        Queries.executeStatements(query: "CREATE TABLE \"tblChitietvanban\" (\"id\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, \"So\" TEXT COLLATE NOCASE, \"tieude\" TEXT COLLATE NOCASE, \"noidung\" TEXT COLLATE NOCASE, \"minhhoa\" TEXT COLLATE NOCASE, \"cha\" INTEGER COLLATE NOCASE, \"vanbanid\" INTEGER COLLATE NOCASE REFERENCES \"tblVanban\" (\"id\"), \"forSearch\" TEXT COLLATE NOCASE);")
        
        //create tblRelatedDieukhoan table
        print("-----Creating tblRelatedDieukhoan")
        Queries.executeStatements(query: "CREATE TABLE tblRelatedDieukhoan (dieukhoanId integer, relatedDieukhoanId integer);")
        
        //create tblPhuongtien table
        print("-----Creating tblPhuongtien")
        Queries.executeStatements(query: "CREATE TABLE \"tblPhuongtien\" (\"dieukhoanID\" INTEGER UNIQUE,\"oto\" BOOLEAN,\"otoTai\" BOOLEAN,\"maykeo\" BOOLEAN,\"xechuyendung\" BOOLEAN,\"tau\" BOOLEAN,\"moto\" BOOLEAN,\"xeganmay\" BOOLEAN,\"xemaydien\" BOOLEAN,\"xedapmay\" BOOLEAN,\"xedap\" BOOLEAN,\"xedapdien\" BOOLEAN,\"xethoso\" BOOLEAN,\"sucvat\" BOOLEAN,\"xichlo\" BOOLEAN,\"dibo\" BOOLEAN);")
        
        //create tblMucphat table
        print("-----Creating tblMucphat")
        Queries.executeStatements(query: "CREATE TABLE \"tblMucphat\" (\"dieukhoanID\" INTEGER UNIQUE,\"canhanTu\" TEXT,\"canhanDen\" TEXT,\"tochucTu\" TEXT,\"tochucDen\" TEXT);")
        
        //create tblLinhvuc table
        print("-----Creating tblLinhvuc")
        Queries.executeStatements(query: "CREATE TABLE \"tblLinhvuc\" (\"dieukhoanID\" INTEGER UNIQUE,\"duongbo\" BOOLEAN,\"duongsat\" BOOLEAN);")
        
        //create tblKeywords table
        print("-----Creating tblKeywords")
        Queries.executeStatements(query: "CREATE TABLE \"tblKeywords\" (\"dieukhoanID\" INTEGER UNIQUE,\"canhan\" BOOLEAN,\"tochuc\" BOOLEAN,\"doanhnghiep\" BOOLEAN,\"trungtam\" BOOLEAN,\"daotao\" BOOLEAN,\"nguoidieukhien\" BOOLEAN,\"nguoingoitrenxe\" BOOLEAN,\"nguoiduoctro\" BOOLEAN,\"giaovien\" BOOLEAN,\"ga\" BOOLEAN,\"chuphuongtien\" BOOLEAN,\"nhanvien\" BOOLEAN,\"dangkiemvien\" BOOLEAN,\"laitau\" BOOLEAN,\"truongdon\" BOOLEAN,\"truongtau\" BOOLEAN,\"dieukhienmaydon\" BOOLEAN,\"trucban\" BOOLEAN,\"duaxe\" BOOLEAN,\"kinhdoanh\" BOOLEAN,\"vanchuyen\" BOOLEAN,\"vantai\" BOOLEAN,\"hanhkhach\" BOOLEAN,\"hanghoa\" BOOLEAN,\"ketcau\" BOOLEAN,\"hatang\" BOOLEAN,\"luukho\" BOOLEAN,\"laprap\" BOOLEAN,\"xepdo\" BOOLEAN,\"quanly\" BOOLEAN,\"thuphi\" BOOLEAN,\"dangkiem\" BOOLEAN,\"sathach\" BOOLEAN,\"dichvu\" BOOLEAN,\"hotro\" BOOLEAN,\"ghepnoi\" BOOLEAN,\"gacchan\" BOOLEAN,\"khamxe\" BOOLEAN,\"thuham\" BOOLEAN,\"phucvu\" BOOLEAN,\"baoquan\" BOOLEAN,\"sanxuat\" BOOLEAN,\"hoancai\" BOOLEAN,\"phuchoi\" BOOLEAN,\"khaithac\" BOOLEAN,\"baotri\" BOOLEAN);")
        
        //create tblHinhphatbosung table
        print("-----Creating tblHinhphatbosung")
        Queries.executeStatements(query: "CREATE TABLE tblHinhphatbosung (dieukhoanId integer, dieukhoanQuydinhId integer, noidung text);")
        
        //create tblBienphapkhacphuc table
        print("-----Creating tblBienphapkhacphuc")
        Queries.executeStatements(query: "CREATE TABLE tblBienphapkhacphuc (dieukhoanId integer, dieukhoanQuydinhId integer, noidung text);")
        
        //create Alphanumerics table
        print("-----Creating Alphanumerics")
        Queries.executeStatements(query: "CREATE TABLE 'Alphanumerics' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'ten' TEXT COLLATE NOCASE);")
        
        //create Arrows table
        print("-----Creating Arrows")
        Queries.executeStatements(query: "CREATE TABLE 'Arrows' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'ten' TEXT COLLATE NOCASE);")
        
        //create Creatures table
        print("-----Creating Creatures")
        Queries.executeStatements(query: "CREATE TABLE 'Creatures' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'ten' TEXT COLLATE NOCASE);")
        
        //create Figures table
        print("-----Creating Figures")
        Queries.executeStatements(query: "CREATE TABLE 'Figures' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'ten' TEXT COLLATE NOCASE);")
        
        //create Signs table
        print("-----Creating Signs")
        Queries.executeStatements(query: "CREATE TABLE 'Signs' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'ten' TEXT COLLATE NOCASE);")
        
        //create Structures table
        print("-----Creating Structures")
        Queries.executeStatements(query: "CREATE TABLE 'Structures' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'ten' TEXT COLLATE NOCASE);")
        
        //create Vehicles table
        print("-----Creating Vehicles")
        Queries.executeStatements(query: "CREATE TABLE 'Vehicles' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'ten' TEXT COLLATE NOCASE);")
        
        //create tblShapeGroups table
        print("-----Creating tblShapeGroups")
        Queries.executeStatements(query: "CREATE TABLE 'tblShapeGroups' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'ten' TEXT COLLATE NOCASE);")
        
        //create tblPlateShapes table
        print("-----Creating tblPlateShapes")
        Queries.executeStatements(query: "CREATE TABLE 'tblPlateShapes' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'ten' TEXT COLLATE NOCASE, 'type' INTEGER);")
        
        //create tblPlateReferences table
        print("-----Creating tblPlateReferences")
        Queries.executeStatements(query: "CREATE TABLE 'tblPlateReferences' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'plateId' INTEGER, 'type' TEXT COLLATE NOCASE, 'name' TEXT COLLATE NOCASE,'refId' INTEGER);")
        
        //create tblAppConfigs table
        print("-----Creating tblAppConfigs")
        Queries.executeStatements(query: "CREATE TABLE \"tblAppConfigs\" (\"configKey\" TEXT, \"configValue\" TEXT);")
        
        //create phantich table
        print("-----Creating phantich")
        Queries.executeStatements(query: "CREATE TABLE \"phantich\" (\"id_key\" TEXT, \"author\" TEXT, \"title\" TEXT, \"source\" TEXT, \"source_inapp\" TEXT, \"revision\" INTEGER, \"shortdescription\" TEXT);")
        
        //create phantich_details table
        print("-----Creating phantich_details")
        Queries.executeStatements(query: "CREATE TABLE \"phantich_details\" (\"id_key\" TEXT, \"contentOrder\" TEXT, \"content\" TEXT, \"minhhoa\" TEXT, \"minhhoaType\" TEXT, \"forsearch\" TEXT);")
        
        //create positions table
        print("-----Creating positions")
        Queries.executeStatements(query: "CREATE TABLE 'positions' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'ten' TEXT COLLATE NOCASE, 'displayName' TEXT COLLATE NOCASE);")
        
        //create tblVachReferences table
        print("-----Creating tblVachReferences")
        Queries.executeStatements(query: "CREATE TABLE 'tblVachReferences' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'plateId' INTEGER, 'type' TEXT COLLATE NOCASE, 'name' TEXT COLLATE NOCASE,'refId' INTEGER);")
        
        //create tblVachGroups table
        print("-----Creating tblVachGroups")
        Queries.executeStatements(query: "CREATE TABLE 'tblVachGroups' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'ten' TEXT COLLATE NOCASE, 'displayName' TEXT COLLATE NOCASE);")
        
        //create tblVachShapes table
        print("-----Creating tblVachShapes")
        Queries.executeStatements(query: "CREATE TABLE 'tblVachShapes' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL COLLATE NOCASE, 'ten' TEXT COLLATE NOCASE, 'type' INTEGER);")
        
        print("Succesfully created tables")
        print("=====================================")
        //init raw data
        initInitialData()
    }
    
    private func insertDataByQuery(queries: String) {
        Queries.executeStatements(query: queries)
    }
}
