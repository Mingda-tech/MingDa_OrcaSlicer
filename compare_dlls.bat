@echo off
setlocal enabledelayedexpansion

echo Comparing DLLs between Release and Package directories...
echo.

set "RELEASE_DIR=build\src\Release"
set "PACKAGE_DIR=build\_CPack_Packages\win64\NSIS\mingda-slicer_Windows_Installer_V2.2.7"

echo === DLLs in Release but NOT in Package ===
echo.

for %%f in ("%RELEASE_DIR%\*.dll") do (
    set "filename=%%~nxf"
    if not exist "%PACKAGE_DIR%\!filename!" (
        echo MISSING: !filename!
    )
)

echo.
echo === Checking specific important DLLs ===
echo.

for %%f in (
    "libcurl.dll"
    "zlib1.dll"
    "libpng16.dll"
    "jpeg62.dll"
    "tiff.dll"
    "lzma.dll"
    "openvdb.dll"
    "Half-2_5.dll"
    "tbb.dll"
    "tbbmalloc.dll"
    "blosc.dll"
    "boost_log-vc143-mt-x64-1_78.dll"
    "boost_locale-vc143-mt-x64-1_78.dll"
    "boost_chrono-vc143-mt-x64-1_78.dll"
    "boost_date_time-vc143-mt-x64-1_78.dll"
    "libssl-3-x64.dll"
    "libcrypto-3-x64.dll"
    "glew32.dll"
    "cairo.dll"
    "pixman-1-0.dll"
    "fontconfig.dll"
    "freetype.dll"
    "harfbuzz.dll"
    "libexpat.dll"
    "fribidi-0.dll"
    "gio-2.0-0.dll"
    "glib-2.0-0.dll"
    "gmodule-2.0-0.dll"
    "gobject-2.0-0.dll"
    "gtk-3-0.dll"
    "gdk-3-0.dll"
    "gdk_pixbuf-2.0-0.dll"
    "pango-1.0-0.dll"
    "pangocairo-1.0-0.dll"
    "pangoft2-1.0-0.dll"
    "pangowin32-1.0-0.dll"
    "atk-1.0-0.dll"
    "epoxy-0.dll"
) do (
    if exist "%RELEASE_DIR%\%%~f" (
        if exist "%PACKAGE_DIR%\%%~f" (
            echo [OK] %%~f
        ) else (
            echo [MISSING IN PACKAGE] %%~f
        )
    )
)

echo.
echo === Counting DLLs ===
set /a release_count=0
set /a package_count=0

for %%f in ("%RELEASE_DIR%\*.dll") do set /a release_count+=1
for %%f in ("%PACKAGE_DIR%\*.dll") do set /a package_count+=1

echo Release directory: !release_count! DLLs
echo Package directory: !package_count! DLLs

pause