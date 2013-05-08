'option explicit

'======================
' module statistics
'
' Author: syb
' Date  : 2013.05.08
' 
'======================
dim vFileName
dim vSheetName_1
dim vSheetName_2
dim vRowCount
dim vColumnCount

vFileName = "D:\hxh\test.xlsx"
vSheetName_1 = "中兴1"
vSheetName_2 = "中兴2"


set oExcel = CreateObject("Excel.Application") '创建Excel对象
set oBook = oExcel.Workbooks.Open(vFileName) '打开工作薄
set oSheet_1 = oBook.Worksheets(vSheetName_1) '获得第一个表格对象
set oSheet_2 = oBook.Worksheets(vSheetName_2) '获得第二个表格对象
vRowCount = oSheet_1.UsedRange.Rows.Count
vColumnCount = oSheet_1.UsedRange.Columns.Count

Function fFindPersonIndex(personName)
	dim ret
	ret = 0
	'遍历第二个表格的第一列，寻找personName的index
	for idx = 1 to oSheet_2.UsedRange.Rows.Count
		if oSheet_2.Cells(idx, 1) = personName then
			ret = idx
		end if
	next

	'如果没有找到personName, 就创建一行并设置该行第一列为personName
	if ret = 0 then
		oSheet_2.Rows(idx).Insert
		oSheet_2.Cells(idx, 1) = personName
		ret = idx
	end if
	'返回personName的index
	fFindPersonIndex = ret
End Function

'修改第二个表格的内容：根据personName找到行索引，然后根据moduleIndex
'和moduleName修改响应的单元格的内容
Function fModifyPersonModule(personName, moduleName, moduleIndex)
	dim personIndex
	personIndex = fFindPersonIndex(personName)
	if oSheet_2.Cells(personIndex, moduleIndex).Value = "" then
		oSheet_2.Cells(personIndex, moduleIndex).Value = moduleName
	else
		oSheet_2.Cells(personIndex, moduleIndex).Value = oSheet_2.Cells(personIndex, moduleIndex + 1).Value & ", " & moduleName
	end if
End Function

'遍历第一个表格的所有人名，以此修改第二个表格的内容
dim xxx
for vRow = 2 to vRowCount
	for vColumn = 2 to vColumnCount
		msgbox vRow & " " & vColumn & " " & oSheet_1.Cells(vRow, vColumn)
		xxx = fModifyPersonModule(oSheet_1.Cells(vRow, vColumn), oSheet_1.Cells(vRow, 1), vColumn)
	next
next



'释放内存对象并退出
oBook.Save
set oSheet_1 = Nothing
set oSheet_2 = Nothing
oBook.Close
set oBook = Nothing
oExcel.Quit
set oExcel = Nothing
