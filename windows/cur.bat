@echo off
:: open named folder or current folder if no parameter.

:: setlocal��endlocal�������ֲ���
setlocal

set folder="."
:: %~1�� ���%1�����Ű�Χ�ţ���ȥ�����ţ�ȡ���������������
if not "x%~1"=="x" (set folder="%~1")
::echo %folder%
explorer.exe %folder%

endlocal