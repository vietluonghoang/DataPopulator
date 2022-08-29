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
        var fileName = ""
        var path = ""
        
        if name.contains("/") {
            path = "data/\(name.components(separatedBy: "/")[0])"
            fileName = name.components(separatedBy: "/")[1]
        }else{
            fileName = name
            path = "data"
        }
        
        let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dpPath = docsDir.appendingPathComponent("\(fileName).txt")
        print("====== sourceDir: \(dpPath.path)")
        let file = FileManager.default
        let dpPathApp = Bundle.main.path(forResource: fileName, ofType: "txt", inDirectory: path)
        print("===== targetPath: \(dpPathApp ?? "")")
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
        print("sourceDir: \(dpPath.path)")
        let file = FileManager.default
        if(!file.fileExists(atPath: dpPath.path)) {
            let dpPathApp = Bundle.main.path(forResource: name, ofType: "txt", inDirectory: "data")
            print("targetPath: \(dpPathApp ?? "")")
            do {
                try file.copyItem(atPath: dpPathApp!, toPath: dpPath.path)
                print("copyItemAtPath success")
            } catch {
                print("copyItemAtPath fail")
            }
        }
        do {
            try fileContent.write(to: dpPath, atomically: false, encoding: .utf8)
            print("\n==============\nSuccessfully write to file: \(dpPath)\n------------\n")
            print(fileContent)   // "some text\n"
            print("\n==============\n")
        } catch {
            print("\n==============\nerror writing to file:", dpPath, error)
            print("\n==============\n")
        }
    }
}
