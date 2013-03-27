@echo off
::
:: Copy a file to multiple places.
::
:: Usage: copy_to_multiple_dir.bat src_file dir0+dir1+dir2+...
:: 			destination dirs separated by '+'
::

set src_file=%1
set dst_dirs=%2

:: M$ provide such a f**king language syntax.
if "%dst_dirs%"=="" (
	echo Nothing to copy, just end myself.
	goto end
)

:fuck
for /f "tokens=1,* delims=+" %%p in ("%dst_dirs%") do (
	if exist %%p (
		echo [%0] %src_file% ==^> %%p
		copy /Y %src_file% %%p\CameraZte.apk
	) else (
		echo [%0] Directory: %%p is NOT exist.
	)
	set dst_dirs=%%q
)
if "%dst_dirs%" NEQ "" (
	goto fuck
) else (
	echo Copy finish.
)

:end