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
vSheetName_1 = "����1"
vSheetName_2 = "����2"

Msgbox "����ļ��� " & vFileName & " �Ѿ��򿪣��뽫��رգ�����"

set oExcel = CreateObject("Excel.Application") '����Excel����
set oBook = oExcel.Workbooks.Open(vFileName) '�򿪹�����
set oSheet_1 = oBook.Worksheets(vSheetName_1) '��õ�һ��������
set oSheet_2 = oBook.Worksheets(vSheetName_2) '��õڶ���������

dim vPersonCount
vPersonCount = oSheet_2.UsedRange.Rows.Count - 1
Function fFindPersonIndex(personName)
	dim ret
	ret = 0
	dim startIndex
	startIndex= 1
	'�����ڶ������ĵ�һ�У�Ѱ��personName��index
	for idx = startIndex to vPersonCount + startIndex
		'msgbox "name: " & personName & "; cell: " & oSheet_2.Cells(idx, 1) & "; idx: " & idx & "; rows count: " & oSheet_2.UsedRange.Rows.Count
		if oSheet_2.Cells(idx, 1) = personName then
			ret = idx
		end if
	next

	'���û���ҵ�personName, �ʹ���һ�в����ø��е�һ��ΪpersonName
	if ret = 0 then
		oSheet_2.Rows(idx).Insert
		oSheet_2.Cells(idx, 1) = personName
		vPersonCount = vPersonCount + 1
		ret = idx
		'msgbox "no found! idx: " & idx & "; name: " & personName
	end if
	'����personName��index
	fFindPersonIndex = ret
End Function

'�޸ĵڶ����������ݣ�����personName�ҵ���������Ȼ�����moduleIndex
'��moduleName�޸���Ӧ�ĵ�Ԫ�������
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

'����յڶ�������ģ����Ϣ�����Ǳ�����������
Sub fClearModuleInfo()
	for vRow = 2 to oSheet_2.UsedRange.Rows.Count
		for vColumn = 2 to oSheet_2.UsedRange.Columns.Count
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

'������ʼ
dim vRowCount
dim vColumnCount
vRowCount = oSheet_1.UsedRange.Rows.Count
vColumnCount = oSheet_1.UsedRange.Columns.Count
'���ģ����Ϣ
Call fClearModuleInfo()
'������һ�����������������Դ��޸ĵڶ�����������
dim vTmpModuleName
for vRow = 2 to vRowCount
	vTmpModuleName = oSheet_1.Cells(vRow, 1)
	for vColumn = 2 to vColumnCount
		'msgbox "cell: " & vRow & "," & vColumn & "; name: " & oSheet_1.Cells(vRow, vColumn) & "; module: " & oSheet_1.Cells(vRow, 1)
		Call fModifyPersonModule(oSheet_1.Cells(vRow, vColumn), vTmpModuleName, vColumn)
	next
next
Call fCloseBook()

Msgbox "���й����Ѿ���ɣ���鿴��� " & vSheetName_2

