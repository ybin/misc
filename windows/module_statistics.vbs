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

vFileName = "D:\excel\CMAC模块化.xlsx"
vSheetName_1 = "CMAC合一版本模块负责人和SE"
vSheetName_2 = "CMAC团队人力资源"



Msgbox "如果文件： " & vFileName & " 已经打开，请将其关闭！！！"

set oExcel = CreateObject("Excel.Application") '创建Excel对象
set oBook = oExcel.Workbooks.Open(vFileName) '打开工作薄
set oSheet_1 = oBook.Worksheets(vSheetName_1) '获得第一个表格对象
set oSheet_2 = oBook.Worksheets(vSheetName_2) '获得第二个表格对象

Function fFindPersonIndex(personName)
	dim ret
	ret = -1
	'遍历第二个表格的第vPersonNameColumn列，寻找personName的index
	for idx = vSheet2RowStart to vSheet2RowEnd
		'msgbox "name: " & personName & "; cell: " & oSheet_2.Cells(idx, 1) & "; idx: " & idx & "; rows count: " & oSheet_2.UsedRange.Rows.Count
		if oSheet_2.Cells(idx, vPersonNameColumn) = personName then
			ret = idx - vSheet2RowStart
		end if
	next

	'返回personName的index
	fFindPersonIndex = ret
End Function

'修改第二个表格的内容：根据personName找到行索引，然后根据moduleIndex
'和moduleName修改响应的单元格的内容
Sub fModifyPersonModule(personName, moduleName, moduleIndex)
	dim personIndex
	personIndex = fFindPersonIndex(personName)
	'msgbox "persin inde: " & personIndex & "; person name: " & personName
	dim x
	dim y
	x = personIndex + vSheet2RowStart
	y = moduleIndex + vSheet2ColumnStart
	if oSheet_2.Cells(x, y).Value = "" then
		oSheet_2.Cells(x, y).Value = moduleName
	else
		oSheet_2.Cells(x, y).Value = oSheet_2.Cells(x, y).Value & vbLf & moduleName
	end if
End Sub

'先清空第二个表格的模块信息，但是保留姓名不变
Sub fClearModuleInfo()
	for vRow = vSheet2RowStart to vSheet2RowEnd
		for vColumn = vSheet2ColumnStart to vSheet2ColumnEnd
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

' moduleIndex 从 "0" 开始， 第一负责人对应为 0，第二负责人对应为 1， 第三负责人对应为2.
Sub fProcessText(text, moduleName, moduleIndex)
	dim idx
	dim txt
	dim leftStr
	dim rightStr
	txt = text
	
	While txt <> ""
	idx = InStr(txt, "、")
	if idx = 0 then
		leftStr = txt
		rightStr = ""
	else
		leftStr = Left(txt, idx - 1)
		rightStr = Right(txt, Len(txt) - idx)
	end if
	'msgbox "leftStr: " & leftStr & "; module name: " & moduleName & "; module index" & moduleIndex
	Call fModifyPersonModule(leftStr, moduleName, moduleIndex)
	txt = rightStr
	Wend
End Sub

'''''''''''''''''''' 主程序开始 ''''''''''''''''''''''''
dim vModuleNum
vModuleNum = 3
dim vPersonNameColumn
vPersonNameColumn = 3
dim vModuleNameColumn
vModuleNameColumn = 2

dim vSheet1RowStart
dim vSheet1RowEnd
dim vSheet1ColumnStart
dim vSheet1ColumnEnd
vSheet1RowStart = 4
vSheet1RowEnd = oSheet_1.UsedRange.Rows.Count
vSheet1ColumnStart = 3
vSheet1ColumnEnd = vSheet1ColumnStart + vModuleNum - 1

dim vSheet2RowStart
dim vSheet2RowEnd
dim vSheet2ColumnStart
dim vSheet2ColumnEnd
vSheet2RowStart = 2
vSheet2RowEnd = oSheet_2.UsedRange.Rows.Count
vSheet2ColumnStart = 5
vSheet2ColumnEnd = vSheet2ColumnStart + vModuleNum - 1


'清空模块信息
Call fClearModuleInfo()
'遍历第一个表格的所有人名，以此修改第二个表格的内容
dim vTmpModuleName
for vRow = vSheet1RowStart to vSheet1RowEnd
	vTmpModuleName = oSheet_1.Cells(vRow, vModuleNameColumn)
	for vColumn = vSheet1ColumnStart to vSheet1ColumnEnd
		'msgbox "cell: " & vRow & "," & vColumn & "; name: " & oSheet_1.Cells(vRow, vColumn) & "; module: " & vTmpModuleName
		'Call fModifyPersonModule(oSheet_1.Cells(vRow, vColumn), vTmpModuleName, vColumn)
		Call fProcessText(oSheet_1.Cells(vRow, vColumn), vTmpModuleName, vColumn - vSheet1ColumnStart)
	next
next
Call fCloseBook()

Msgbox "所有工作已经完成，请查看表格： " & vSheetName_2

