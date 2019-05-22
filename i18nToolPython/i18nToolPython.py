#!/usr/bin/python

import sys
import os
import glob
import csv
import re

def ParseFile(_csvfile, _keyfile):
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

    print("开始处理.strings文件")
    fp = open(_keyfile, "r")
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

    for headname, headDict in outputDict.items():
        outputContent = ""
        for keyname in keyarr:
            if keyname in headDict:
                outputContent += "\""+keyname+"\""+" = "+"\""+headDict[keyname]+"\";\n"

        print(outputContent)
        print(os.getcwd())
        outputDirPath = os.getcwd()+"/strings/"+headname
        isexists = os.path.exists(outputDirPath)
        if not isexists:
            os.makedirs(outputDirPath)

        outputFilePath = outputDirPath+"/Localizable.strings"
        fpout = open(outputFilePath, "w")
        fpout.write(outputContent)
        fpout.close()
        print("写入文件"+outputFilePath)

    print("执行完毕")




def main(args):
    #global lastseq

    if 2==len(args):
        ParseFile(args[0], args[1])
    else: 
        print("缺少文件路径")

if __name__ == "__main__":
    main(sys.argv[1:])