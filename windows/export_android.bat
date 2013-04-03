@echo off
goto :program

::
:: export android source files.
::

:::: function declaration ::::
:export
	:: %1 - folder name, e.g. kernel
	:: %2 - branch
	:: %3 - repository name, e.g. kernel/msm
	setlocal
	echo Export folder: %1.
	if not exist %1 (mkdir %1 & cd %1)
	git init
	git remote add -t %2 origin %base_url%/%3
	git fetch --depth=1 & git merge origin/%2
	endlocal & goto :EOF
	
:::: program area ::::
:program
set base_url=https://android.googlesource.com
set content=hardware:branch:repo kernel:branch:repo system:branch:repo

for %%i in (%content%) do (
	for /f "tokens=1,2,3 delims=:" %%a in ("%%i") do (
		call :export %%a %%b %%c
	)
)

