@echo off
chcp 65001 >nul
title NÉN HỆ THỐNG WINDOWS - An Toàn Tiết Kiệm
setlocal EnableDelayedExpansion

:: ========================
:: KIỂM TRA ADMIN
:: ========================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ======================================================
    echo         :(  SCRIPT YÊU CẦU QUYỀN ADMINISTRATOR
    echo ------------------------------------------------------
    echo     Vui lòng bấm chuột phải vào file này và chọn:
    echo     		"Run as administrator"
    echo ------------------------------------------------------
    echo Không có quyền admin, không thể tiếp tục.
    echo ======================================================
    pause
    exit /b
)

:: ========================
:: THÔNG TIN VÀ LỰA CHỌN
:: ========================
cls
echo ======================================================
echo                  NEN HE THONG WINDOWS
echo ======================================================
echo Kiem tra cac thanh phan truoc khi nen...
echo ------------------------------------------------------

:: ========================
:: KIỂM TRA COMPACTOS
:: ========================
for /f "tokens=*" %%a in ('compact /compactos:query') do (
    echo %%a | findstr /i "enabled" >nul && (
        echo [OK] CompactOS da duoc bat.
        set skip_compactos=1
    )
    echo %%a | findstr /i "not enabled" >nul && (
        echo [TODO] CompactOS chua bat.
        set skip_compactos=0
    )
)

:: ========================
:: DANH SÁCH THƯ MỤC CẦN NÉN
:: ========================
set folders[0]=C:\Windows\WinSxS
set folders[1]=C:\Windows\System32\DriverStore\FileRepository
set folders[2]=C:\Windows\INF
set folders[3]=C:\Windows\Logs
set folders[4]=C:\Windows\Temp
set folders[5]=C:\Windows\SoftwareDistribution\Download
set folderCount=6

:: ========================
:: KIỂM TRA NÉN TỪ TRƯỚC
:: ========================
set /a foldersToCompress=0
for /L %%i in (0,1,%folderCount%) do (
    set folder=!folders[%%i]!
    if defined folder (
        for /f "tokens=4 delims= " %%a in ('compact "!folder!" ^| find /i "!folder!"') do (
            if /i "%%a"=="Compressed" (
                echo [OK] !folder! da duoc nen san.
            ) else (
                echo [TODO] !folder! chua duoc nen.
                set doCompress[!foldersToCompress!]=!folder!
                set /a foldersToCompress+=1
            )
        )
    )
)

:: ========================
:: HỎI NGƯỜI DÙNG
:: ========================
echo.
set /p run=Ban co muon bat dau nen cac thanh phan chua duoc nen? (Y/N): 
if /i not "%run%"=="Y" (
    echo Da huy thao tac.
    pause
    exit /b
)

:: ========================
:: CHỌN KIỂU NÉN
:: ========================
echo.
echo Chon che do nen:
echo   [1] XPRESS4K - Nhanh
echo   [2] XPRESS8K - Can bang (goi y)
echo   [3] LZX      - Nen manh
set /p choice=Nhap lua chon (1/2/3): 

if "%choice%"=="1" set mode=XPRESS4K
if "%choice%"=="2" set mode=XPRESS8K
if "%choice%"=="3" set mode=LZX
if not defined mode (
    echo Lua chon khong hop le.
    pause
    exit /b
)

:: ========================
:: ƯỚC TÍNH TRƯỚC KHI NÉN
:: ========================
echo.
echo Dang quet dung luong truoc khi nen...
set /a size_before=0
for /L %%i in (0,1,%foldersToCompress%) do (
    set folder=!doCompress[%%i]!
    if defined folder (
        for /f "usebackq tokens=3" %%S in (`dir /s /-c "!folder!" ^| findstr /C:"bytes"`) do (
            set /a size_before+=%%S
        )
    )
)
set /a size_before_mb=%size_before% / 1048576
echo Tong dung luong can xu ly: %size_before_mb% MB

if "%mode%"=="XPRESS4K" (
    set /a estimated_save=10
) else if "%mode%"=="XPRESS8K" (
    set /a estimated_save=15
) else (
    set /a estimated_save=20
)
set /a estimated_reduction=%size_before_mb% * %estimated_save% / 100
echo Uoc tinh co the giam: ~%estimated_reduction% MB (%estimated_save%%)
echo ------------------------------------------------------

:: ========================
:: THỰC THI NÉN
:: ========================
set start=%time%
echo Bat dau luc: %start%
echo.

if %skip_compactos%==0 (
    echo Nen CompactOS...
    compact /compactos:always >nul
)

for /L %%i in (0,1,%foldersToCompress%) do (
    set folder=!doCompress[%%i]!
    if defined folder (
        echo Nen !folder! voi che do: %mode%...
        compact /c /s:"!folder!" /i /q /exe:%mode%
        echo.
    )
)

:: ========================
:: BÁO CÁO SAU KHI NÉN
:: ========================
echo Dang quet lai dung luong sau khi nen...
set /a size_after=0
for /L %%i in (0,1,%foldersToCompress%) do (
    set folder=!doCompress[%%i]!
    if defined folder (
        for /f "usebackq tokens=3" %%S in (`dir /s /-c "!folder!" ^| findstr /C:"bytes"`) do (
            set /a size_after+=%%S
        )
    )
)

set /a size_after_mb=%size_after% / 1048576
set /a saved=%size_before_mb% - %size_after_mb%
set /a ratio=100 * %saved% / %size_before_mb%
set end=%time%

echo ------------------------------------------------------
echo Nen hoan tat luc: %end%
echo.
echo =================== BAO CAO CUOI ======================
echo Truoc khi nen:        %size_before_mb% MB
echo Sau khi nen:          %size_after_mb% MB
echo Da tiet kiem:         %saved% MB (%ratio%%)
echo ======================================================
pause
exit /b
