@echo off
echo === MingDa OrcaSlicer Startup Debug ===
echo.

set "PACKAGE_DIR=build\_CPack_Packages\win64\NSIS\mingda-slicer_Windows_Installer_V2.2.7"

echo 1. Creating debug wrapper...
cd %PACKAGE_DIR%

REM Create a batch file to capture more info
echo @echo off > debug_run.bat
echo echo Starting mingda-slicer with debugging... >> debug_run.bat
echo echo Working directory: %%CD%% >> debug_run.bat
echo echo. >> debug_run.bat
echo echo Environment variables: >> debug_run.bat
echo set >> debug_run.bat
echo echo. >> debug_run.bat
echo echo Starting program... >> debug_run.bat
echo mingda-slicer.exe --loglevel=trace --datadir=. 2^>error.log >> debug_run.bat
echo echo Exit code: %%ERRORLEVEL%% >> debug_run.bat
echo if exist error.log type error.log >> debug_run.bat
echo pause >> debug_run.bat

echo.
echo 2. Running with console output...
start cmd /k debug_run.bat

echo.
echo 3. Alternative: Run with full path to resources
cd ..\..\..\..\
echo Running from root directory with explicit resource path...
"%CD%\%PACKAGE_DIR%\mingda-slicer.exe" --datadir="%CD%\resources"

echo.
echo 4. Check if it's an antivirus issue
echo Please temporarily disable Windows Defender or your antivirus and try again.
echo.
echo 5. Dependencies Walker Alternative
echo Download and run Dependencies.exe from:
echo https://github.com/lucasg/Dependencies
echo Drag mingda-slicer.exe into it to see missing dependencies.
echo.
pause