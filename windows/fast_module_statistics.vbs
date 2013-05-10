'option explicit

'======================
' module statistics
'
' Author: syb(zte), hxh(zte)
' Date	: 2013.05.08
'
' Usage :
' 	0. 正确填写 vFileName, vSheetName_1, vSheetName_2 三个变量的值
'	1. 双击.vbs文件运行，开始运行时有提示，确定之后开始运行，运行结束后再次提示，
'	   两次提示直接为程序运行阶段
'======================
dim vFileName
dim vSheetName_1
dim vSheetName_2
vFileName = "D:\excel\CMAC模块化.xlsx"
vSheetName_1 = "CMAC合一版本模块负责人和SE"
vSheetName_2 = "CMAC团队人力资源"

Msgbox "如果文件： " & vFileName & " 已经打开，请将其关闭！！！"

set oExcel = CreateObject("Excel.Application")	'创建Excel对象
set oBook = oExcel.Workbooks.Open(vFileName)	'打开工作薄
set oSheet_1 = oBook.Worksheets(vSheetName_1)	'获得第一个表格对象
set oSheet_2 = oBook.Worksheets(vSheetName_2)	'获得第二个表格对象

Function fFindPersonIndex(personNameArray, personName)
	'设置函数的返回值
	'yes, 42 is a magic number.
	fFindPersonIndex = -42
	dim idxMin
	dim idxMax
	idxMin = LBound(personNameArray)
	idxMax = UBound(personNameArray)
	for idx = idxMin to idxMax
		if personNameArray(idx, 1) = personName then
			fFindPersonIndex = idx
			exit Function
		end if
	next

End Function

Sub fModifyModuleArray(personIndex, column, moduleName)
	if vModuleArray(personIndex, column) = "" then
		vModuleArray(personIndex, column) = moduleName
	else
		vModuleArray(personIndex, column) = vModuleArray(personIndex, column) & vbLf & moduleName
	end if
End Sub

'initialize module array
Sub fClearModuleInfo()
	dim rMin
	dim rMax
	dim cMin
	dim cMax
	rMin = LBound(vModuleArray, 1)
	rMax = UBound(vModuleArray, 1)
	cMin = LBound(vModuleArray, 2)
	cMax = UBound(vModuleArray, 2)

	for row = rMin to rMax
		for col = cMin to cMax
			vModuleArray(row, col) = ""
		next
	next
End Sub

Sub fSaveAndQuit()
	'关闭提示后保存工作簿
	oExcel.DisplayAlerts = False
	oBook.Save
	oExcel.DisplayAlerts = True
	'释放内存对象并退出
	set oSheet_1 = Nothing
	set oSheet_2 = Nothing
	oBook.Close
	set oBook = Nothing
	oExcel.Quit
	set oExcel = Nothing
End Sub

' row 对应于person array的行，用于索引 模块名称
' col 对应于第几个负责人，第一、二、三负责人之一
Sub fProcessPersonInfo(personArray, row, col)
	dim idx
	dim txt
	dim personName
	dim remainingStr
	txt = personArray(row, col)
	if txt = "" then
		exit sub
	end if
	
	While txt <> ""
		idx = InStr(txt, "、")
		if idx = 0 then
			' 没有  "王虎、武建超" 这样的情况
			personName = txt
			remainingStr = ""
		else
			' 存在 "王虎、武建超" 这样的情况
			personName = Left(txt, idx - 1)
			remainingStr = Right(txt, Len(txt) - idx)
		end if
		Call fModifyModuleArray(fFindPersonIndex(vPersonNameArray, personName), col, vModuleNameArray(row, 1))
		txt = remainingStr
	Wend
End Sub

'''''''''''''''''''' 主程序开始 ''''''''''''''''''''''''
' vPersonArray 对应于第一个表格中的三列人员姓名
' vModuleArray 对应于第二个表格中的三列模块名称
' vModuleNameArray 对应于第一个表格中的模块名称列
' vPersonNameArray 对应于第二个表格中的人员姓名列
dim vPersonArray
dim vModuleArray
dim vModuleNameArray
dim vPersonNameArray

vPersonArray = oSheet_1.Range("C4:E71").Value
vModuleArray = oSheet_2.Range("E2:G87").Value
vModuleNameArray = oSheet_1.Range("B4:B71").Value
vPersonNameArray = oSheet_2.Range("C2:C87").Value

'清空模块信息
Call fClearModuleInfo()

dim rMin
dim rMax
dim cMin
dim cMax
rMin = LBound(vPersonArray, 1)
rMax = UBound(vPersonArray, 1)
cMin = LBound(vPersonArray, 2)
cMax = UBound(vPersonArray, 2)

for row = rMin to rMax
	for col = cMin to cMax
		Call fProcessPersonInfo(vPersonArray, row, col)
	next
next

'将结果写回excel表格中
oSheet_2.Range("E2:G87").Value = vModuleArray
'保存并退出
Call fSaveAndQuit()

Msgbox "所有工作已经完成，请查看表格： " & vSheetName_2
