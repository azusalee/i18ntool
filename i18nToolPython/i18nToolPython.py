#!/usr/bin/python

import sys
import os
import glob
import csv
import re
import xml.etree.ElementTree as ET
import xml.dom.minidom

def ParseStringsFile(_stringsfile):
    print("开始处理.strings文件")
    fp = open(_stringsfile, "r")
    filecontent = fp.read()
    fp.close()
    p1 = r"\"[^\"]*\" *= *\"[^\"]*\";"
    pattern1 = re.compile(p1)
    matcher1 = re.findall(pattern1, filecontent)

    p2 = r"\"[^\"]*\""
    pattern2 = re.compile(p2)

    keyarr = []
    for match in matcher1:
        matcher2 = re.findall(pattern2, match)
        keyname = matcher2[0]
        keyarr.append(keyname[1:len(keyname)-1])

    print("处理.strings文件完毕")
    return keyarr

def ParseXmlFile(_xmlfile):
    print("开始处理.xml")
    tree = xml.dom.minidom.parse(_xmlfile)
    collection = tree.documentElement
    
    keyarr = []
    tags = collection.getElementsByTagName("string")
    for tag in tags:
        if tag.hasAttribute("name"):
            name = tag.getAttribute("name")
            if "_" in name:
                key = name.split("_", 1)[1]
                keyarr.append(key)

    print("处理.xml完毕")
    return keyarr

def ParseCsvFile(_csvfile):
    if ".csv" not in _csvfile:
        print("未能处理:"+_csvfile)
        return []

    print("开始处理csv")
    csvobj = csv.reader(open(_csvfile, 'r'))
    csvheader = []
    for obj in csvobj :
        csvheader = obj
        break;
        
    outputDict = {}
    csvdict = csv.DictReader(open(_csvfile, 'r'))

    for i in range(len(csvheader)):
        if i != 0:
            headname = csvheader[i]
            tmpdict = {}
            outputDict[headname] = tmpdict

    for obj in csvdict:
          for headname, headDict in outputDict.items():
              headDict[obj["key"]] = obj[headname]

    print(outputDict)
    print("csv处理完毕")
    return outputDict

def outputFile(_outputDict, _keyarr, _outputType, _outputLan):
    if _outputType == 1:
        for headname, headDict in _outputDict.items():
            if _outputLan != "All" and _outputLan != headname:
                continue
            outputContent = ""
            for keyname in _keyarr:
                if keyname in headDict:
                    outputContent += "\""+keyname+"\""+" = "+"\""+headDict[keyname]+"\";\n"

            outputDirPath = os.getcwd()+"/strings/"+headname
            isexists = os.path.exists(outputDirPath)
            if not isexists:
                os.makedirs(outputDirPath)

            outputFilePath = outputDirPath+"/Localizable.strings"
            fpout = open(outputFilePath, "w")
            fpout.write(outputContent)
            fpout.close()
            print("写入文件"+outputFilePath)
    elif _outputType == 2:
        for headname, headDict in _outputDict.items():
            if _outputLan != "All" and _outputLan != headname:
                continue
            outputContent = ""
            outputContent += "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
            outputContent += "<resources>\n"
            for keyname in _keyarr:
                if keyname in headDict:
                    outputContent += "  <string name=\""+keyname+"\">"+headDict[keyname]+"</string>\n"

            outputContent += "</resources>\n"

            outputDirPath = os.getcwd()+"/xml/"+headname
            isexists = os.path.exists(outputDirPath)
            if not isexists:
                os.makedirs(outputDirPath)

            outputFilePath = outputDirPath+"/strings.xml"
            fpout = open(outputFilePath, "w")
            fpout.write(outputContent)
            fpout.close()
            print("写入文件"+outputFilePath)

def ParseFile(_csvfile, _keyfile):

    outputDict = ParseCsvFile(_csvfile)

    keyarr = []
    outputType = 0
    if ".strings" in _keyfile:
        keyarr = ParseStringsFile(_keyfile)
        outputType = 1
    elif ".xml" in _keyfile:
        keyarr = ParseXmlFile(_keyfile)
        outputType = 2
    else:
        print("未能解析文件:"+_keyfile)
        exit(1)

    outputFile(outputDict, keyarr, outputType, "All")

    print("执行完毕")


def main(args):

    if 2==len(args):
        ParseFile(args[0], args[1])
    else: 
        print("缺少文件路径")

if __name__ == "__main__":
    main(sys.argv[1:])