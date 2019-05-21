//
//  MainViewController.swift
//  i18nTool
//
//  Created by yangming on 2019/5/20.
//  Copyright © 2019 AL. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    @IBOutlet weak var csvFilePathTextFiled: NSTextField!
    @IBOutlet weak var keyFilePathTextField: NSTextField!
    @IBOutlet weak var outputPathTextField: NSTextField!
    
    @IBOutlet var hintTextView: NSTextView!
    
    
    var keyList:[String] = []
    
    var curCSV:CSV?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        if let lastPath = UserDefaults.standard.object(forKey: "LastOuputPath") as? String {
            self.outputPathTextField.stringValue = lastPath
        }
    }
    
    @IBAction func csvParseDidTap(_ sender: Any) {
        let csvPath:String = self.csvFilePathTextFiled.stringValue
        if csvPath.count == 0 {
            self.appendHintString(string: "请填写csv的路径")
            return
        }
        self.parseCsvFile(csvPath: csvPath)
    }
    
    @IBAction func keyParseDidTap(_ sender: Any) {
        //strings
        let stringsPath:String = self.keyFilePathTextField.stringValue
        let url = URL.init(fileURLWithPath: stringsPath)
        let ext = url.pathExtension
        
        if ext == "strings" {
            self.parseStringsFile(stringsPath: stringsPath)
        }else{
            self.appendHintString(string: "解析key文件失败，未能识别文件格式"+ext)
        }
    }
    
    @IBAction func outputDidTap(_ sender: Any) {
        let stringsPath:String = self.keyFilePathTextField.stringValue
        let url = URL.init(fileURLWithPath: stringsPath)
        let ext = url.pathExtension
        
        UserDefaults.standard.set(self.outputPathTextField.stringValue, forKey: "LastOuputPath")
        if ext == "strings" {
            self.outputStringsFile()
        }else{
            self.appendHintString(string: "解析key文件失败，未能识别文件格式"+ext)
        }
        
    }
    
    func parseCsvFile(csvPath:String) {
        let csv = try! CSV(name: csvPath)
        
        self.curCSV = csv
        self.appendHintString(string: "解释csv完成")
        
//        do {
//            // From a file (with errors)
//            let csv = try CSV(name: csvPath)
//            
//        } catch parseError as CSVParseError {
//            // Catch errors from parsing invalid formed CSV
//        } catch {
//            // Catch errors from trying to load files
//        }
    }
    
//    func parseStringsFile2(stringsPath:String) {
//        self.keyList.removeAll()
//    
//        if var stringsContent:String = try? String.init(contentsOfFile: stringsPath, encoding: String.Encoding.utf8) {
//            let regularExpression:NSRegularExpression = try! NSRegularExpression.init(pattern: "(/[*]([^[*]^/]*|[[*]^[/]*]*|[^[*]*/]*)*[*]/)|(//[^\n]*)", options: []) 
//            let matchs:[NSTextCheckingResult] = regularExpression.matches(in: stringsContent, options: [], range: NSRange.init(location: 0, length: stringsContent.count))
//            //stringsContent.removeSubrange(stringsContent.startIndex..<stringsContent.endIndex)
//            //去除文件内容的注释
//            for i in 0..<matchs.count {
//                let match = matchs[matchs.count-1-i]
//                let startIndex = stringsContent.index(stringsContent.startIndex, offsetBy: match.range.location)
//                let endIndex = stringsContent.index(stringsContent.startIndex, offsetBy: match.range.location+match.range.length)
//                stringsContent.removeSubrange(startIndex..<endIndex)
//            }
//            
//            if matchs.count > 0 {
//                
//                let equalRegEx:NSRegularExpression = try! NSRegularExpression.init(pattern: " *= *", options: [])
//                for match in matchs {
//                    let startIndex = stringsContent.index(stringsContent.startIndex, offsetBy: match.range.location)
//                    let endIndex = stringsContent.index(stringsContent.startIndex, offsetBy: match.range.location+match.range.length)
//                    let subStr = String(stringsContent[startIndex..<endIndex])
//                    
//                    //print(subStr)
//                    
//                    if let euqalMatch = equalRegEx.firstMatch(in: subStr, options: [], range: NSRange.init(location: 0, length: subStr.count)) {
//                        let keyStartIndex = subStr.index(subStr.startIndex, offsetBy: 1)
//                        let keyEndIndex = subStr.index(subStr.startIndex, offsetBy: euqalMatch.range.location-1)
//                        let keyString = String(subStr[keyStartIndex..<keyEndIndex]) 
//                        
//                        let valueStartIndex = subStr.index(subStr.startIndex, offsetBy: euqalMatch.range.location+euqalMatch.range.length+1)
//                        let valueEndIndex = subStr.index(subStr.startIndex, offsetBy: subStr.count-2)
//                        //let valueString = String(subStr[valueStartIndex..<valueEndIndex])
//                        
//                        //print(keyString)
//                        //print(valueString)
//                        
//                        self.keyList.append(keyString)
//                    }
//                    
//                }
//            }
//            
//        }
//        
//        self.appendHintString(string: "解析key文件完成")
//    }
    
    func parseStringsFile(stringsPath:String) {
    
        self.keyList.removeAll()
        
        if let stringsContent:String = try? String.init(contentsOfFile: stringsPath, encoding: String.Encoding.utf8) {
            if let regularExpression:NSRegularExpression = try? NSRegularExpression.init(pattern: "\"[^\"]*\" *= *\"[^\"]*\";", options: []) {
                let matchs:[NSTextCheckingResult] = regularExpression.matches(in: stringsContent, options: [], range: NSRange.init(location: 0, length: stringsContent.count))
                //stringsContent.removeSubrange(stringsContent.startIndex..<stringsContent.endIndex)
                if matchs.count > 0 {
                
                    let equalRegEx:NSRegularExpression = try! NSRegularExpression.init(pattern: " *= *", options: [])
                    for match in matchs {
                        let startIndex = stringsContent.index(stringsContent.startIndex, offsetBy: match.range.location)
                        let endIndex = stringsContent.index(stringsContent.startIndex, offsetBy: match.range.location+match.range.length)
                        let subStr = String(stringsContent[startIndex..<endIndex])
                        
                        //print(subStr)
                        
                        if let euqalMatch = equalRegEx.firstMatch(in: subStr, options: [], range: NSRange.init(location: 0, length: subStr.count)) {
                            let keyStartIndex = subStr.index(subStr.startIndex, offsetBy: 1)
                            let keyEndIndex = subStr.index(subStr.startIndex, offsetBy: euqalMatch.range.location-1)
                            let keyString = String(subStr[keyStartIndex..<keyEndIndex]) 
                            
                            //let valueStartIndex = subStr.index(subStr.startIndex, offsetBy: euqalMatch.range.location+euqalMatch.range.length+1)
                            //let valueEndIndex = subStr.index(subStr.startIndex, offsetBy: subStr.count-2)
                            //let valueString = String(subStr[valueStartIndex..<valueEndIndex])
                            
                            //print(keyString)
                            //print(valueString)
                            
                            self.keyList.append(keyString)
                        }
                        
                    }
                }
            }
        }
        
        self.appendHintString(string: "解析key文件完成")
    }
    
    
    func outputStringsFile() {
        if self.curCSV == nil {
            self.csvParseDidTap("")
//            self.appendHintString(string: "csv文件未解析")
//            return
        }
        if self.keyList.count == 0 {
            self.keyParseDidTap("")
//            self.appendHintString(string: "key文件未解析")
//            return
        }
        if self.curCSV == nil {
            self.appendHintString(string: "csv文件未解析")
            return
        }
        if self.keyList.count == 0 {
            self.appendHintString(string: "key文件未解析")
            return
        }
        let outputPath = self.outputPathTextField.stringValue
        if outputPath.count == 0 {
            self.appendHintString(string: "请填入输出文件夹路径")
            return
        }
        
        let csv:CSV = self.curCSV!
        let nameRows = csv.namedRows
        let headers = csv.header
        var outputDict:[String:[String:String]] = [:]
        for header in headers {
            if header != "key" {
                outputDict[header] = [:]
            }
        }
        
        for key in self.keyList {
            for rowDict in nameRows {
                if key == rowDict["key"] {
                    for header in headers {
                        if header != "key" {
                            outputDict[header]![key] = rowDict[header]
                        }
                    }
                    break;
                }
            }
        }
        
        let manager = FileManager.default
        if manager.fileExists(atPath: outputPath) == false {
            try! manager.createDirectory(atPath: outputPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        let stringsFolderPath = outputPath+"/strings"
        if manager.fileExists(atPath: stringsFolderPath) == false {
            try! manager.createDirectory(atPath: stringsFolderPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        for (header, dict) in outputDict {
            let headerFolderPath = stringsFolderPath+"/\(header)"
            if manager.fileExists(atPath: headerFolderPath) == false {
                try! manager.createDirectory(atPath: headerFolderPath, withIntermediateDirectories: true, attributes: nil)
            }
            var fileContens:String = ""
            for (key, value) in dict {
                fileContens.append(contentsOf: "\"\(key)\" = \"\(value)\";\n")
            }
            let fileUrlPath = headerFolderPath+"/Localizable.strings"
            try! fileContens.write(toFile: fileUrlPath, atomically: true, encoding: String.Encoding.utf8)
            self.appendHintString(string: "输出文件:\(fileUrlPath)")
        }
        self.appendHintString(string: "输出完成")
    }
    
    func appendHintString(string:String) {
        self.hintTextView.string.append(string+"\n")
    }
    
}
