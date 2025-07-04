# PowerShell script to check DLL architectures
Write-Host "Checking DLL architectures..." -ForegroundColor Yellow

$packageDir = "build\_CPack_Packages\win64\NSIS\mingda-slicer_Windows_Installer_V2.2.7"

# Check main executable
$exePath = Join-Path $packageDir "mingda-slicer.exe"
if (Test-Path $exePath) {
    try {
        $bytes = [System.IO.File]::ReadAllBytes($exePath)
        $peOffset = [BitConverter]::ToInt32($bytes, 0x3C)
        $machine = [BitConverter]::ToUInt16($bytes, $peOffset + 4)
        
        if ($machine -eq 0x8664) {
            Write-Host "[OK] mingda-slicer.exe is 64-bit (x64)" -ForegroundColor Green
        } elseif ($machine -eq 0x014C) {
            Write-Host "[ERROR] mingda-slicer.exe is 32-bit (x86)" -ForegroundColor Red
        } else {
            Write-Host "[?] mingda-slicer.exe architecture unknown: $machine" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "[ERROR] Failed to check mingda-slicer.exe" -ForegroundColor Red
    }
}

# Check all DLLs
$dlls = Get-ChildItem -Path $packageDir -Filter "*.dll"
$x86Count = 0
$x64Count = 0

foreach ($dll in $dlls) {
    try {
        $bytes = [System.IO.File]::ReadAllBytes($dll.FullName)
        $peOffset = [BitConverter]::ToInt32($bytes, 0x3C)
        $machine = [BitConverter]::ToUInt16($bytes, $peOffset + 4)
        
        if ($machine -eq 0x8664) {
            $x64Count++
        } elseif ($machine -eq 0x014C) {
            $x86Count++
            Write-Host "[WARNING] 32-bit DLL found: $($dll.Name)" -ForegroundColor Yellow
        }
    } catch {
        # Skip if can't read
    }
}

Write-Host "`nSummary:" -ForegroundColor Cyan
Write-Host "64-bit DLLs: $x64Count"
Write-Host "32-bit DLLs: $x86Count"

if ($x86Count -gt 0) {
    Write-Host "`n[ERROR] Mixed architectures detected! This will cause startup failures." -ForegroundColor Red
}

Write-Host "`nPress any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")