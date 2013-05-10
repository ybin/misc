'option explicit

'======================
' module statistics
'
' Author: syb(zte), hxh(zte)
' Date	: 2013.05.08
'
' Usage :
' 	0. ��ȷ��д vFileName, vSheetName_1, vSheetName_2 ����������ֵ
'	1. ˫��.vbs�ļ����У���ʼ����ʱ����ʾ��ȷ��֮��ʼ���У����н������ٴ���ʾ��
'	   ������ʾֱ��Ϊ�������н׶�
'======================
dim vFileName
dim vSheetName_1
dim vSheetName_2
vFileName = "D:\excel\CMACģ�黯.xlsx"
vSheetName_1 = "CMAC��һ�汾ģ�鸺���˺�SE"
vSheetName_2 = "CMAC�Ŷ�������Դ"

Msgbox "����ļ��� " & vFileName & " �Ѿ��򿪣��뽫��رգ�����"

set oExcel = CreateObject("Excel.Application")	'����Excel����
set oBook = oExcel.Workbooks.Open(vFileName)	'�򿪹�����
set oSheet_1 = oBook.Worksheets(vSheetName_1)	'��õ�һ��������
set oSheet_2 = oBook.Worksheets(vSheetName_2)	'��õڶ���������

Function fFindPersonIndex(personNameArray, personName)
	'���ú����ķ���ֵ
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

' row ��Ӧ��person array���У��������� ģ������
' col ��Ӧ�ڵڼ��������ˣ���һ��������������֮һ
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
		idx = InStr(txt, "��")
		if idx = 0 then
			' û��  "�������佨��" ���������
			personName = txt
			remainingStr = ""
		else
			' ���� "�������佨��" ���������
			personName = Left(txt, idx - 1)
			remainingStr = Right(txt, Len(txt) - idx)
		end if
		Call fModifyModuleArray(fFindPersonIndex(vPersonNameArray, personName), col, vModuleNameArray(row, 1))
		txt = remainingStr
	Wend
End Sub

'''''''''''''''''''' ������ʼ ''''''''''''''''''''''''
' vPersonArray ��Ӧ�ڵ�һ������е�������Ա����
' vModuleArray ��Ӧ�ڵڶ�������е�����ģ������
' vModuleNameArray ��Ӧ�ڵ�һ������е�ģ��������
' vPersonNameArray ��Ӧ�ڵڶ�������е���Ա������
dim vPersonArray
dim vModuleArray
dim vModuleNameArray
dim vPersonNameArray

vPersonArray = oSheet_1.Range("C4:E71").Value
vModuleArray = oSheet_2.Range("E2:G87").Value
vModuleNameArray = oSheet_1.Range("B4:B71").Value
vPersonNameArray = oSheet_2.Range("C2:C87").Value

'���ģ����Ϣ
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

'�����д��excel�����
oSheet_2.Range("E2:G87").Value = vModuleArray
'���沢�˳�
Call fSaveAndQuit()

Msgbox "���й����Ѿ���ɣ���鿴��� " & vSheetName_2
