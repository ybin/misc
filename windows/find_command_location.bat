@echo off

::
setlocal enabledelayedexpansion
set current_path=%path%
set cmd="%~1"
set result=
set tmp=

:: ��<abc;def>ת��Ϊ<"abc" "def">����ʽ����Ϊfind�����ж��·���ÿո�ָ�
:begin
for /f "tokens=1,* delims=;" %%a in ("%current_path%") do (
	set tmp=%%a
	if "!%tmp:~-1,1!"=="\" (
		:: ����ַ�����"\"��β����Ҫȥ����������<\">�������find����
		set tmp=!tmp:~0,-1!
	)
	set "result=%result% "!tmp!""
	set current_path=%%b
)

if not "x%current_path%"=="x" (
	goto begin
)

2>nul find %result%  -maxdepth 1 -type f -iname %cmd%

endlocal