'option explicit

'======================
' module statistics
'
' Author: syb
' Date	: 2013.05.08
' 
'======================
dim vFileName
dim vSheetName_1
dim vSheetName_2

vFileName = "D:\excel\test.xlsx"
vSheetName_1 = "中兴1"
vSheetName_2 = "中兴2"

Msgbox "如果文件： " & vFileName & " 已经打开，请将其关闭！！！"

set oExcel = CreateObject("Excel.Application") '创建Excel对象
set oBook = oExcel.Workbooks.Open(vFileName) '打开工作薄
set oSheet_1 = oBook.Worksheets(vSheetName_1) '获得第一个表格对象
set oSheet_2 = oBook.Worksheets(vSheetName_2) '获得第二个表格对象

dim vPersonCount
vPersonCount = oSheet_2.UsedRange.Rows.Count - 1
Function fFindPersonIndex(personName)
	dim ret
	ret = 0
	dim startIndex
	startIndex= 1
	'遍历第二个表格的第一列，寻找personName的index
	for idx = startIndex to vPersonCount + startIndex
		'msgbox "name: " & personName & "; cell: " & oSheet_2.Cells(idx, 1) & "; idx: " & idx & "; rows count: " & oSheet_2.UsedRange.Rows.Count
		if oSheet_2.Cells(idx, 1) = personName then
			ret = idx
		end if
	next

	'如果没有找到personName, 就创建一行并设置该行第一列为personName
	if ret = 0 then
		oSheet_2.Rows(idx).Insert
		oSheet_2.Cells(idx, 1) = personName
		vPersonCount = vPersonCount + 1
		ret = idx
		'msgbox "no found! idx: " & idx & "; name: " & personName
	end if
	'返回personName的index
	fFindPersonIndex = ret
End Function

'修改第二个表格的内容：根据personName找到行索引，然后根据moduleIndex
'和moduleName修改响应的单元格的内容
Sub fModifyPersonModule(personName, moduleName, moduleIndex)
	dim personIndex
	personIndex = fFindPersonIndex(personName)
	
	if oSheet_2.Cells(personIndex, moduleIndex).Value = "" then
		oSheet_2.Cells(personIndex, moduleIndex).Value = moduleName
		'msgbox "name: " & personName & "; index: " & personIndex & "; module name: " & moduleName
	else
		oSheet_2.Cells(personIndex, moduleIndex).Value = oSheet_2.Cells(personIndex, moduleIndex).Value & ", " & moduleName
		'msgbox "name: " & personName & "; index: " & personIndex & "; module name: " & oSheet_2.Cells(personIndex, moduleIndex).Value
	end if
End Sub

'先清空第二个表格的模块信息，但是保留姓名不变
Sub fClearModuleInfo()
	for vRow = 2 to oSheet_2.UsedRange.Rows.Count
		for vColumn = 2 to oSheet_2.UsedRange.Columns.Count
			oSheet_2.Cells(vRow, vColumn).Value = ""
		next
	next
End Sub

Sub fCloseBook()
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

'主程序开始
dim vRowCount
dim vColumnCount
vRowCount = oSheet_1.UsedRange.Rows.Count
vColumnCount = oSheet_1.UsedRange.Columns.Count
'清空模块信息
Call fClearModuleInfo()
'遍历第一个表格的所有人名，以此修改第二个表格的内容
dim vTmpModuleName
for vRow = 2 to vRowCount
	vTmpModuleName = oSheet_1.Cells(vRow, 1)
	for vColumn = 2 to vColumnCount
		'msgbox "cell: " & vRow & "," & vColumn & "; name: " & oSheet_1.Cells(vRow, vColumn) & "; module: " & oSheet_1.Cells(vRow, 1)
		Call fModifyPersonModule(oSheet_1.Cells(vRow, vColumn), vTmpModuleName, vColumn)
	next
next
Call fCloseBook()

Msgbox "所有工作已经完成，请查看表格： " & vSheetName_2

