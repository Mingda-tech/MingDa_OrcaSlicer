@echo off
echo Checking Visual C++ Redistributable...
echo.

REM Check if vcredist is installed
reg query "HKLM\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64" 2>nul
if %ERRORLEVEL% EQU 0 (
    echo [OK] Visual C++ 2015-2022 x64 Runtime found in registry
) else (
    echo [WARNING] Visual C++ 2015-2022 x64 Runtime NOT found
    echo Please install from: https://aka.ms/vs/17/release/vc_redist.x64.exe
)

echo.
echo Checking for debug vs release mismatch...
echo.

set "PACKAGE_DIR=build\_CPack_Packages\win64\NSIS\mingda-slicer_Windows_Installer_V2.2.7"

REM Use dumpbin to check if any DLL is debug version
where dumpbin >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Using dumpbin to check DLLs...
    for %%f in ("%PACKAGE_DIR%\*.dll") do (
        echo Checking %%~nxf
        dumpbin /DEPENDENTS "%%f" | findstr /i "debug"
        if %ERRORLEVEL% EQU 0 (
            echo [WARNING] %%~nxf may have debug dependencies!
        )
    )
) else (
    echo dumpbin not found. Install Visual Studio Build Tools.
)

echo.
echo Checking CRT DLLs specifically...
dir "%PACKAGE_DIR%\*140*.dll" /b 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] No Visual C++ Runtime DLLs found!
)

pause