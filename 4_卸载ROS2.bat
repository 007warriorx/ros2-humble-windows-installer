@echo off
chcp 65001 >nul 2>&1
echo ============================================
echo ROS2 Humble 卸载脚本
echo ============================================
echo.

set "ROS2_PATH=C:\dev\ros2_humble"

if not exist "%ROS2_PATH%" (
    echo [INFO] ROS2目录不存在: %ROS2_PATH%
    pause
    exit /b 0
)

echo [WARNING] 这将删除整个ROS2安装目录:
echo   %ROS2_PATH%
echo.
echo 是否继续?
choice /C YN /M "请确认"

if %errorlevel% equ 2 (
    echo [INFO] 已取消卸载
    pause
    exit /b 0
)

echo.
echo [INFO] 正在删除ROS2...
rmdir /S /Q "%ROS2_PATH%" 2>nul

if exist "%ROS2_PATH%" (
    echo [ERROR] 删除失败，可能某些文件正在使用中
    echo [INFO] 请手动删除: %ROS2_PATH%
) else (
    echo [OK] ROS2已成功卸载
)

echo.
pause
