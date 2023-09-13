@echo off
rem 
rem Script for building Driver dependencies directly from sources
rem 
rem At the end, each dependencie is copied in the Compiled folder and you should commit the dependencies by yourself.
rem 
rem The folder Compiled has the structure: include, dll, lib
rem In include, scripts put include files making a folder for each dep.
rem In the end you will put a vcxproj setting for C-include-dir Compiled\include and in the source code you will write something like #include <curl\curl.h>
rem In dll go dlls along with their implibs and pdbs, structured by platform
rem In lib go only static libs. This design permits that for a dependencie to build a dll and also a static libary.
rem 
rem 

cls
pushd %~dp0


call build_curl.cmd || ( call :inform_about "curl" & exit /b 1 )
rem add other script invokes here



echo.
echo.
echo All dependencies built, "git commit -a Compile" by yourself.
popd
exit /b 0

:inform_about
	SET RET=%ERRORLEVEL%
	echo *** ERROR: cannot build %~1  (error %RET%)
	popd
	GOTO:eof
