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

vFileName = "D:\excel\CMACģ�黯.xlsx"
vSheetName_1 = "CMAC��һ�汾ģ�鸺���˺�SE"
vSheetName_2 = "CMAC�Ŷ�������Դ"



Msgbox "����ļ��� " & vFileName & " �Ѿ��򿪣��뽫��رգ�����"

set oExcel = CreateObject("Excel.Application") '����Excel����
set oBook = oExcel.Workbooks.Open(vFileName) '�򿪹�����
set oSheet_1 = oBook.Worksheets(vSheetName_1) '��õ�һ��������
set oSheet_2 = oBook.Worksheets(vSheetName_2) '��õڶ���������

Function fFindPersonIndex(personName)
	dim ret
	ret = -1
	'�����ڶ������ĵ�vPersonNameColumn�У�Ѱ��personName��index
	for idx = vSheet2RowStart to vSheet2RowEnd
		'msgbox "name: " & personName & "; cell: " & oSheet_2.Cells(idx, 1) & "; idx: " & idx & "; rows count: " & oSheet_2.UsedRange.Rows.Count
		if oSheet_2.Cells(idx, vPersonNameColumn) = personName then
			ret = idx - vSheet2RowStart
		end if
	next

	'����personName��index
	fFindPersonIndex = ret
End Function

'�޸ĵڶ����������ݣ�����personName�ҵ���������Ȼ�����moduleIndex
'��moduleName�޸���Ӧ�ĵ�Ԫ�������
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

'����յڶ�������ģ����Ϣ�����Ǳ�����������
Sub fClearModuleInfo()
	for vRow = vSheet2RowStart to vSheet2RowEnd
		for vColumn = vSheet2ColumnStart to vSheet2ColumnEnd
			oSheet_2.Cells(vRow, vColumn).Value = ""
		next
	next
End Sub

Sub fCloseBook()
	'�ر���ʾ�󱣴湤����
	oExcel.DisplayAlerts = False
	oBook.Save
	oExcel.DisplayAlerts = True
	'�ͷ��ڴ�����˳�
	set oSheet_1 = Nothing
	set oSheet_2 = Nothing
	oBook.Close
	set oBook = Nothing
	oExcel.Quit
	set oExcel = Nothing
End Sub

' moduleIndex �� "0" ��ʼ�� ��һ�����˶�ӦΪ 0���ڶ������˶�ӦΪ 1�� ���������˶�ӦΪ2.
Sub fProcessText(text, moduleName, moduleIndex)
	dim idx
	dim txt
	dim leftStr
	dim rightStr
	txt = text
	
	While txt <> ""
	idx = InStr(txt, "��")
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

'''''''''''''''''''' ������ʼ ''''''''''''''''''''''''
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


'���ģ����Ϣ
Call fClearModuleInfo()
'������һ�����������������Դ��޸ĵڶ�����������
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

Msgbox "���й����Ѿ���ɣ���鿴��� " & vSheetName_2

