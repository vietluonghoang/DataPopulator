//
//  Utils.swift
//  DataInitializer
//
//  Created by VietLH on 1/5/18.
//  Copyright © 2018 VietLH. All rights reserved.
//

import Foundation

class Utils {
    class func readFromFile(name: String) -> String {
        var fileContent = ""
        
        let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dpPath = docsDir.appendingPathComponent("\(name).txt")
        print("====== docDir: \(dpPath.path)")
        let file = FileManager.default
        let dpPathApp = Bundle.main.path(forResource: name, ofType: "txt", inDirectory: "data")
        print("===== resPath: \(String(describing: dpPathApp))")
        do {
            if(file.fileExists(atPath: dpPath.path)) {
                try file.removeItem(at: dpPath)
            }
            try file.copyItem(atPath: dpPathApp!, toPath: dpPath.path)
            print("copyItemAtPath success")
        } catch {
            print("copyItemAtPath fail")
        }
        do {
            fileContent = try String(contentsOf: dpPath)
//            print(fileContent)   // "some text\n"
        } catch {
            print("error loading contents of:", dpPath, error)
        }
        return fileContent
    }
    
    class func writeToFile(name: String, fileContent: String) {
        
        let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dpPath = docsDir.appendingPathComponent("\(name).txt")
        print("docDir: \(dpPath.path)")
        let file = FileManager.default
        if(!file.fileExists(atPath: dpPath.path)) {
            let dpPathApp = Bundle.main.path(forResource: name, ofType: "txt")
            print("resPath: "+String(describing: dpPathApp))
            do {
                try file.copyItem(atPath: dpPathApp!, toPath: dpPath.path)
                print("copyItemAtPath success")
            } catch {
                print("copyItemAtPath fail")
            }
        }
        do {
            try fileContent.write(to: dpPath, atomically: false, encoding: .utf8)
            print(fileContent)   // "some text\n"
        } catch {
            print("error writing to file:", dpPath, error)
        }
    }
}
