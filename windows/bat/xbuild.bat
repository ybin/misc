@echo off
setLocal EnableDelayedExpansion
goto :main

:: 
::	Building tool for ZTE multimedia applications.
::
::	Author	: ybsolar
::	Email	: sun.yanbin@zte.com.cn
::

:::::::::: function definitions ::::::::::
:: log function
:log
if %LOGLEVEL%==1 (
	echo %*
)
goto :EOF

:: process arguments, like: call :fProcessArgv arg0 arg1
:fProcessArgv
set tmp=%1
if "%tmp:--=%"=="type" (
	set vType=%2
	call :log type: !vType!
) else if "%tmp:--=%"=="baseline" (
	set vBaseLine=%2
	call :log baseline: !vBaseLine!
) else if "%tmp:--=%"=="project" (
	set vProject=%2
	call :log project: !vProject!
) else if "%tmp:--=%"=="module" (
	set vModule=%2
	call :log module: !vModule!
) else if "%tmp:--=%"=="signature" (
	set vSignatureFile=%2
	call :log signature: !vSignatureFile!
) else if "%tmp:--=%"=="output" (
	set vApkOutputDir=%2
	call :log output: !vApkOutputDir!
) else if "%tmp:--=%"=="cached" (
	set vCached=%2
	call :log cached: !vCached!
)
goto :EOF



:::::::::: main program ::::::::::
:main

:::: variable definition ::::
set LOGLEVEL=1
:: command line arguments
set vBaseLine=mifavor1.9
set vProject=P940F01
set vType=branch
:: conf file arguments
set vModule=camera
set vSignatureFile=
set vCached=true
set vApkOutputDir=
set rootDir=%USERPROFILE%\.xbuild

if not exist "%rootDir%" (
	mkdir "%rootDir%"
	call :log "%rootDir%" is not exist, mkdir it.
)
:: parse configuration file
for /F "usebackq eol=# tokens=1,2 delims==" %%a in ("%rootDir%\xbuild.conf") do (
	call :fProcessArgv %%a %%b
)
echo cacheddddddddddddddddd: !vCached!
:: parse command line arguments
for /L %%i in (1,2,8) do (
	echo %%i
)

:: construct svn urls

:::::::::: EOF ::::::::::
:EOF