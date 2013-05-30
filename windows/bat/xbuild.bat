@echo off
::setLocal EnableExtensions EnableDelayedExpansion
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
set xtmp=%1
set ARG1=%xtmp:--=%
if "%ARG1%"=="help" (
	call :help
) else if "%ARG1%"=="type" (
	set xtype=%2
) else if "%ARG1%"=="baseline" (
	set xbaseline=%2
) else if "%ARG1%"=="project" (
	set xproject=%2
) else if "%ARG1%"=="module" (
	set xmodule=%2
) else if "%ARG1%"=="signature" (
	set xsignature_file=%2
) else if "%ARG1%"=="output" (
	set output_dir=%2
) else if "%ARG1%"=="cached" (
	set is_cached=%2
) else if "%ARG1%"=="sdk" (
	set sdk_dir=%2
) else (
	echo 无效参数！ 请使用[ xbuild --help ]查看帮助信息。
)
set xtmp=
goto :EOF

:: help information
:help
echo 这里将显示为帮助信息
goto :EOF

:::::::::: main program ::::::::::
:main

:::: variable definition ::::
set LOGLEVEL=1
:: command line arguments
set xbaseline=
set xproject=
set xtype=
:: conf file arguments
set xmodule=
set xsignature_file=
set is_cached=
set output_dir=
set sdk_dir=
set root_dir=%USERPROFILE%\.xbuild

if not exist "%root_dir%" (
	mkdir "%root_dir%"
)
:: parse configuration file
for /F "usebackq eol=# tokens=1,2 delims==" %%a in ("%root_dir%\xbuild.conf") do (
	call :fProcessArgv %%a %%b
)

:: parse cmd line arguments
if "x%1"=="x" (
	echo 请使用[ xbuild --help ]查看帮助信息。
)
:begin_loop
if not "x%1"=="x" (
	call :fProcessArgv %1 %2
	shift /1
	shift /1
	goto :begin_loop
)
if not exist "%sdk_dir%\tools\android.bat" (
	echo android command "%sdk_dir%\tools\android.bat" is not exist.
	goto :EOF
)

:: construct svn urls
set base_url=https://10.89.34.5:8443/svn
if "%xmodule%"=="camera" (
	set trunk_url=%base_url%/Dept1_XA_Camera/%xbaseline%/trunk/Camera_1.9.3.4
) else if "%xmodule%"=="music" (
	set trunk_url=%base_url%/Dept1_XA_music/%xbaseline%/trunk/MusicPlayer
) else if "%xmodule%"=="video" (
	set trunk_url=%base_url%/Dept1_XA_music/%xbaseline%/trunk/VideoPlayer
) else if "%xmodule%"=="gallery" (
	set trunk_url=%base_url%/Dept1_XA_music/%xbaseline%/trunk/GalleryZte
) else (
	echo Wrong module name.
	goto :EOF
)
if "%xtype%"=="custom" (
	set branch_url=%trunk_url%/custom/%xproject%
) else (
	set branch_url=
	set trunk_url=%base_url%/Dept1_XA_%xmodule%/%xbaseline%/branchs/%xproject%
)

:: parpre building environment
set trunk_dir=%root_dir%\projects\trunk
if exist "%trunk_dir%" (
	rd /S /Q "%trunk_dir%"
	if exist "%trunk_dir%" (
		echo ###### delete "%trunk_dir%" failed.
		goto :EOF
	)
)
mkdir "%trunk_dir%"


set branch_dir=%root_dir%\projects\branch
if exist "%branch_dir%" (
	rd /S /Q "%branch_dir%
	if exist "%branch_dir%" (
		echo ###### delete "%branch_dir%" failed.
		goto :EOF
	)
)
 mkdir "%branch_dir%"

:: export source code and override trunk
svn info %trunk_url% > "%trunk_dir%\svn-info.properties"
if not %errorlevel%==0 (
	echo ###### SVN URL invalid.
	goto :EOF
)
svn export --force %trunk_url% "%trunk_dir%"
if not %errorlevel%==0 (
	echo ###### SVN operation failed.
	goto :EOF
)
if not "x%branch_url%"=="x" (
	svn export --force %branch_url% "%branch_dir%"
	if not %errorlevel%==0 (
		echo ###### SVN operation failed.
		goto :EOF
	)
	xcopy /Y /E /R /I "%branch_dir%" "%trunk_dir%"
)

:: building
echo [xbuild] update android project.
call "%sdk_dir%\tools\android.bat" update project --path "%trunk_dir%"
if "%xmodule%"=="camera" (
	echo out.dex.jar.input.ref= >> "%trunk_dir%\local.properties"
)

call ant -buildfile "%trunk_dir%\svn-revision.build.xml"
call ant -buildfile "%trunk_dir%\build.xml" release


:::::::::: EOF ::::::::::
:EOF