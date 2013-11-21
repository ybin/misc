@echo off
:: open named folder or current folder if no parameter.

:: setlocal、endlocal将变量局部化
setlocal

set folder="."
:: %~1： 如果%1被引号包围着，就去掉引号，取出引号里面的内容
if not "x%~1"=="x" (set folder="%~1")
::echo %folder%
explorer.exe %folder%

endlocal