@echo off
echo Deep diagnosis for MingDa OrcaSlicer...
echo.

set "RELEASE_DIR=build\src\Release"
set "PACKAGE_DIR=build\_CPack_Packages\win64\NSIS\mingda-slicer_Windows_Installer_V2.2.7"

echo === 1. Testing in Release directory ===
cd %RELEASE_DIR%
echo Current directory: %CD%
mingda-slicer.exe --help
echo Exit code: %ERRORLEVEL%
cd ..\..\..

echo.
echo === 2. Testing in Package directory ===
cd %PACKAGE_DIR%
echo Current directory: %CD%
mingda-slicer.exe --help
echo Exit code: %ERRORLEVEL%
cd ..\..\..\..

echo.
echo === 3. Checking working directory dependencies ===
echo.

REM Check for config files
echo Checking for configuration files...
if exist "%RELEASE_DIR%\config" (
    echo [Found] config directory in Release
    dir /B "%RELEASE_DIR%\config"
)

if exist "%RELEASE_DIR%\*.ini" (
    echo [Found] INI files in Release:
    dir /B "%RELEASE_DIR%\*.ini"
)

if exist "%RELEASE_DIR%\*.json" (
    echo [Found] JSON files in Release:
    dir /B "%RELEASE_DIR%\*.json"
)

echo.
echo === 4. Checking resources directory ===
if exist "%RELEASE_DIR%\resources" (
    echo [OK] Resources in Release
) else (
    echo [MISSING] Resources in Release
)

if exist "%PACKAGE_DIR%\resources" (
    echo [OK] Resources in Package
) else (
    echo [MISSING] Resources in Package
)

echo.
echo === 5. Using Process Monitor to trace ===
echo.
echo Please download Process Monitor from Microsoft:
echo https://docs.microsoft.com/en-us/sysinternals/downloads/procmon
echo.
echo 1. Run Process Monitor
echo 2. Set filter: Process Name is mingda-slicer.exe
echo 3. Run mingda-slicer.exe from package directory
echo 4. Look for "NAME NOT FOUND" or "PATH NOT FOUND" results
echo.

echo === 6. Enable Windows Error Reporting ===
echo Checking Windows Event Viewer for crash reports...
wevtutil qe Application /q:"*[System[Provider[@Name='Application Error'] and (EventID=1000)]]" /f:text /c:5

echo.
echo === 7. Testing with explicit paths ===
echo.
cd %PACKAGE_DIR%
set PATH=%CD%;%PATH%
echo PATH updated with: %CD%
echo Running with updated PATH...
mingda-slicer.exe
echo Exit code: %ERRORLEVEL%

pause