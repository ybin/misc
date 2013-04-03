@echo off
goto :program

::
:: export android source files.
::

:::: function declaration ::::
:export
	:: %1 - folder name, e.g. kernel
	:: %2 - repository name, e.g. kernel/msm
	:: %3 - branch, e.g. android-msm-sony-cm-jb-3.0
	setlocal
	echo Export folder: %1.
	if not exist %1 (
		mkdir %1 & cd %1
	) else (
		goto :func_end
	)
	git init
	git remote add -t %3 origin %base_url%/%2
	git fetch --depth=1 & git merge origin/%3
	cd ..
:func_end
	endlocal & goto :EOF
	
:::: program area ::::
:program
set base_url=https://android.googlesource.com
:: set content=hardware:branch:repo kernel:branch:repo system:branch:repo

::for %%i in (%content%) do (
::	for /f "tokens=1,2,3 delims=:" %%a in ("%%i") do (
::		call :export %%a %%b %%c
::	)
::)

for /f "eol=#" %%i in (source_dir.txt) do (
	for /f "tokens=1,2,3 delims=:" %%a in ("%%i") do (
		call :export %%a %%b %%c
	)
)
