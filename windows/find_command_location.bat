@echo off

::
setlocal enabledelayedexpansion
set current_path=%path%
set cmd="%~1"
set result=
set tmp=

:: 将<abc;def>转换为<"abc" "def">的形式，因为find命令中多个路径用空格分隔
:begin
for /f "tokens=1,* delims=;" %%a in ("%current_path%") do (
	set tmp=%%a
	if "!%tmp:~-1,1!"=="\" (
		:: 如果字符串以"\"结尾，需要去掉它，否则<\">将会干扰find命令
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