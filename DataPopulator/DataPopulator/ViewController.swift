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
        
    }
    
    @IBAction func actInitPlateAndVachkeReferences(_ sender: Any) {
        initPlateAndVachkeReferences()
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
        quickInit()
    }
    
    private func initReferenceData(tableName: String) {
        print("=====================================")
        print("Initializing \(tableName)......")
        //create new tables
        Queries.executeStatements(query: Utils.readFromFile(name: tableName))
        
        print("Succesfully initializing \(tableName)")
        print("=====================================")
    }
    
    private func initPlateReferences() {
        //init plate info for QC412019
        var fileName = "QC412019Bienbao"
        print("=====================================")
        print("Initializing \(fileName)......")
        //create new tables and insert data
        Queries.executeStatements(query: Utils.readFromFile(name: fileName))

        print("Succesfully initializing \(fileName)")
        print("=====================================")
        
        //init plate info for QC412024
        fileName = "QC412024Bienbao"
        print("=====================================")
        print("Initializing \(fileName)......")
        //create new tables and insert data
        Queries.executeStatements(query: Utils.readFromFile(name: fileName))

        print("Succesfully initializing \(fileName)")
        print("=====================================")
    }
    
    private func initVachKeferences() {
        //init line info for QC412019
        var fileName = "QC412019vachke"
        print("=====================================")
        print("Initializing \(fileName)......")
        //create new tables and insert data
        
        Queries.executeStatements(query: Utils.readFromFile(name: fileName))

        print("Succesfully initializing \(fileName)")
        print("=====================================")
        
        //init line info for QC412024
        fileName = "QC412024vachke"
        print("=====================================")
        print("Initializing \(fileName)......")
        //create new tables and insert data
        
        Queries.executeStatements(query: Utils.readFromFile(name: fileName))

        print("Succesfully initializing \(fileName)")
        print("=====================================")
    }
    
    private func initPlateAndVachkeReferences(){
        Queries.executeStatements(query: "DELETE FROM 'Alphanumerics';DELETE FROM 'Arrows';DELETE FROM 'Creatures';DELETE FROM 'Figures';DELETE FROM 'positions';DELETE FROM 'Signs';DELETE FROM 'Structures';DELETE FROM 'Vehicles';DELETE FROM 'tblPlateReferences';DELETE FROM 'tblPlateShapes';DELETE FROM 'tblShapeGroups';DELETE FROM 'tblVachGroups';DELETE FROM 'tblVachReferences';DELETE FROM 'tblVachShapes';")
        initPlateReferences()
        initVachKeferences()
    }
    
    private func quickInit() {
        transformData()
        initPlateAndVachkeReferences()
        DieukhoanParser().initRelatedDieukhoan()
        print("=====================================")
        print("-----------   All Done   ------------")
        print("=====================================")
    }
    
    private func transformData() {
        DatabaseInitializer().initDatabase()
        
    }
}

