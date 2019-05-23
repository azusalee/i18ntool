#!/usr/bin/python
# -*- coding: UTF-8 -*-
 
import tkinter
from tkinter import filedialog
import i18nToolPython

outputDict = {}
keyarr = []
outputType = 0

def openCsvFile():
    global outputDict
    path = filedialog.askopenfilename(title='select file', filetypes=[('csv', '*.csv'),('All Files', '*')])
    print(path)
    csvent.delete(0, tkinter.END)
    csvent.insert(0, path)
    outputDict = i18nToolPython.ParseCsvFile(path)
    lanArr = ['All']
    for headname, headDict in outputDict.items():
        lanArr.append(headname)
    
    outputmenu = tkinter.OptionMenu(window, v, *lanArr)
    outputmenu.place(x=10 ,y=100, anchor='nw')


def openKeyFile():
    global keyarr
    global outputType
    path = filedialog.askopenfilename(title='select file', filetypes=[('strings', '*.strings'),('xml', '*.xml'),('All Files', '*')])
    print(path)
    keyent.delete(0, tkinter.END)
    keyent.insert(0, path)
    if ".strings" in path:
        keyarr = i18nToolPython.ParseStringsFile(path)
        outputType = 1
    elif ".xml" in path:
        keyarr = i18nToolPython.ParseXmlFile(path)
        outputType = 2
    else:
        print("未能解析文件:"+path)

def outputFile():
    global outputDict
    global keyarr
    global outputType
    print("输出文件")
    outputLan = v.get()
    print(outputLan)
    i18nToolPython.outputFile(outputDict, keyarr, outputType, outputLan)

window = tkinter.Tk()
window.title('i18nTool')
window.geometry('600x300')

csvent = tkinter.Entry(window, show=None, font=('Arial', 14))
csvent.place(x=5, y=10, width=300, anchor='nw')

csvbtn = tkinter.Button(window, text='选择csv文件', command=openCsvFile)
csvbtn.place(x=320, y=10, anchor='nw')

keyent = tkinter.Entry(window, show=None, font=('Arial', 14))
keyent.place(x=5, y=45, width=300, anchor='nw')

keybtn = tkinter.Button(window, text='选择key文件', command=openKeyFile)
keybtn.place(x=320, y=45, anchor='nw')


outputbtn = tkinter.Button(window, text='输出文件', command=outputFile)
outputbtn.place(x=150, y=100, anchor='nw')


v = tkinter.StringVar(window)
#创建一个OptionMenu控件
v.set('All')
outputmenu = tkinter.OptionMenu(window, v, 'All')
outputmenu.place(x=10 ,y=100, anchor='nw')

# 进入消息循环
window.mainloop()

