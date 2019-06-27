@echo off
rem
rem Script for building Curl as a DLL for win32 & x64
rem 
rem Based on https://medium.com/@chuy.max/compile-libcurl-on-windows-with-visual-studio-2017-x64-and-ssl-winssl-cff41ac7971d
rem 
rem Compilation time:  ~ 2 minutes
rem 
rem It downloads curl sources and compiles curl as a dll.
rem It has no support for compressed data but it can be added (by using zlib). It uses the SSL support from Windows.
rem At the end copies the DLLs along with the IMPLIBs, PDBs and header-includes in the Compiled folder
rem 
rem Requires Git and Visual Studio
rem
rem Because vcvarsall.bat cannot be ran twice in the same cmd we use a different console for actual setul devenv vars & compiling curl
rem 

set CURL_DIR=%~dp0
set VS=C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional
set VCVARSALL="%VS%\VC\Auxiliary\Build\vcvarsall.bat"
set COMPILED_FOLDER=%CURL_DIR%Compiled
set MARK=%~nx0 --------------------------------------------------------------


echo %MARK%
pushd %~dp0



echo Creating configuration
call buildconf.bat && cd %CURL_DIR%\winbuild || ( call :last_message "buildconf.bat failed with %ERRORLEVEL%" & exit /b 2 )
echo.


echo Building x86 config in a different window, please stand by ...
rem if you need to see something from the output just ad an ^&^& pause  after nmake command
start /wait cmd /c call %VCVARSALL% x86 ^&^& nmake /f Makefile.vc mode=dll GEN_PDB=yes MACHINE=x86 ^&^& pause || ( call :last_message "Cannot compile on x86" & exit /b 11 )


echo Building x64 config in a different window, please stand by ...
rem if you need to see something from the output just ad an ^&^& pause  after nmake command
start /wait cmd /c call %VCVARSALL% x64 ^&^& nmake /f Makefile.vc mode=dll GEN_PDB=yes MACHINE=x64 ^&^& pause || ( call :last_message "Cannot compile on x64" & exit /b 12 )

echo.
echo Populating Compiled folder
rmdir /s /q %COMPILED_FOLDER%\curl      > nul 2>&1
mkdir %COMPILED_FOLDER%\curl                   || ( call :last_message "cannot create curl inlcude dir" & exit /b 24 )

echo Populating Compiled folder --- 4 %COMPILED_FOLDER%\dll\win32
copy %CURL_DIR%builds\libcurl-vc-x86-release-dll-ipv6-sspi-winssl\bin\libcurl.* %COMPILED_FOLDER%         || ( call :last_message "cannot copy new curl" & exit /b 31 )
echo Populating Compiled folder --- 5
copy %CURL_DIR%builds\libcurl-vc-x86-release-dll-ipv6-sspi-winssl\lib\libcurl.* %COMPILED_FOLDER%         || ( call :last_message "cannot copy new curl" & exit /b 32 )
echo Populating Compiled folder --- 6
copy %CURL_DIR%builds\libcurl-vc-x64-release-dll-ipv6-sspi-winssl\bin\libcurl.* %COMPILED_FOLDER%         || ( call :last_message "cannot copy new curl" & exit /b 33 )
echo Populating Compiled folder --- 7
copy %CURL_DIR%builds\libcurl-vc-x64-release-dll-ipv6-sspi-winssl\lib\libcurl.* %COMPILED_FOLDER%         || ( call :last_message "cannot copy new curl" & exit /b 34 )
echo Populating Compiled folder --- 8
copy %CURL_DIR%builds\libcurl-vc-x86-release-dll-ipv6-sspi-winssl\include\curl\*.* %COMPILED_FOLDER%\curl   || ( call :last_message "cannot copy new curl includes" & exit /b 35 )
echo Populating Compiled folder --- 9





echo Compile script SUCCEEDED
call :cleanup
exit /b 0

:last_message
	SET RET=%ERRORLEVEL%
	echo *** ERROR: %~1  (error %RET%)
	echo Compile script FAILED (Compiled folder may contain partial compiled files)
	call :cleanup
	GOTO:eof

:cleanup
	echo %MARK%
	popd
	GOTO:eof
