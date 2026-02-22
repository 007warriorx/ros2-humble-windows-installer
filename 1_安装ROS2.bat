@echo off
chcp 65001 >nul 2>&1
echo ============================================
echo ROS2 Humble 一键安装脚本 (Windows)
echo ============================================
echo.
echo 版本: 1.0
echo 发布日期: 2025年
echo.

set "ROS2_PATH=C:\dev\ros2_humble"
set "DOWNLOAD_DIR=%~dp0已下载软件"

REM Check for existing installation
if exist "%ROS2_PATH%\Scripts\ros2.exe" (
    echo [INFO] 检测到已存在的ROS2安装: %ROS2_PATH%
    echo [INFO] 如需重新安装，请先运行 "4_卸载ROS2.bat"
    pause
    exit /b 0
)

REM Check for Python 3.10
echo [1/7] 检查Python 3.10...
python --version 2>nul | findstr "3.10" >nul
if %errorlevel% neq 0 (
    echo [ERROR] 未检测到Python 3.10，请先安装Python 3.10.x
    echo [INFO] 下载地址: https://www.python.org/downloads/release/python-31011/
    echo [INFO] 安装时请勾选 "Add Python to PATH"
    pause
    exit /b 1
)
echo [OK] Python 3.10已安装

REM Check for pip
echo.
echo [2/7] 检查pip...
python -m pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] pip未安装
    echo [INFO] 请重新安装Python并确保勾选pip
    pause
    exit /b 1
)
echo [OK] pip已安装

REM Check for Visual C++ Redistributables
echo.
echo [3/7] 检查Visual C++ Redistributables...
reg query "HKLM\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64" /v Version >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] 可能缺少Visual C++ Redistributables
    echo [INFO] 建议下载安装: https://aka.ms/vs/17/release/vc_redist.x64.exe
    echo [INFO] 按任意键继续安装ROS2（可能会导致部分功能异常）...
    pause >nul
) else (
    echo [OK] Visual C++ Redistributables已安装
)

REM Check for downloaded package
echo.
echo [4/7] 检查ROS2安装包...
if exist "%DOWNLOAD_DIR%\ros2-humble-*-windows-release-amd64.zip" (
    for %%f in ("%DOWNLOAD_DIR%\ros2-humble-*-windows-release-amd64.zip") do (
        set "ROS2_ZIP=%%f"
        echo [OK] 找到安装包: %%~nxf
        goto :found_zip
    )
) else (
    echo [ERROR] 未找到ROS2安装包
    echo [INFO] 请下载ros2-humble-*-windows-release-amd64.zip
    echo [INFO] 下载地址: https://github.com/ros2/ros2/releases
    echo [INFO] 并将文件放入: %DOWNLOAD_DIR%
    pause
    exit /b 1
)

:found_zip
echo.
echo [5/7] 创建安装目录...
if not exist "%ROS2_PATH%" mkdir "%ROS2_PATH%"
echo [OK] 安装目录: %ROS2_PATH%

echo.
echo [6/7] 解压ROS2文件...
echo [INFO] 这可能需要几分钟，请耐心等待...
echo [INFO] 正在解压...
powershell -Command "Expand-Archive -Path '%ROS2_ZIP%' -DestinationPath '%ROS2_PATH%' -Force" 2>nul
if %errorlevel% neq 0 (
    echo [INFO] 尝试使用7z解压...
    7z x "%ROS2_ZIP%" -o"%ROS2_PATH%" -y >nul 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] 解压失败
        echo [INFO] 请手动解压到: %ROS2_PATH%
        pause
        exit /b 1
    )
)
echo [OK] 文件解压完成

REM Check if files were extracted to a subdirectory
if exist "%ROS2_PATH%\ros2-windows\bin" (
    echo [INFO] 整理文件结构...
    xcopy /E /Y "%ROS2_PATH%\ros2-windows\*" "%ROS2_PATH%\" >nul 2>&1
    rmdir /S /Q "%ROS2_PATH%\ros2-windows"
    echo [OK] 文件整理完成
)

echo.
echo [7/7] 安装依赖...
echo [INFO] 安装Python依赖...
python -m pip install --quiet packaging numpy netifaces pyyaml lxml 2>nul
if %errorlevel% neq 0 (
    echo [WARNING] Python依赖安装可能有问题，继续安装...
)

echo [INFO] 配置ROS2环境...
REM Fix Python paths in scripts
python -c "
import os, glob
ros_path = r'%ROS2_PATH%'
old_path = r'C:\pixi_ws\.pixi\envs\default\python.exe'
new_path = r'C:\Python310\python.exe'

fixed = 0
for root, dirs, files in os.walk(ros_path):
    for file in files:
        if file.endswith('.py'):
            filepath = os.path.join(root, file)
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                if old_path in content:
                    content = content.replace(old_path, new_path)
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(content)
                    fixed += 1
            except:
                pass
print(f'[INFO] 已修复 {fixed} 个脚本')
" 2>nul

echo.
echo ============================================
echo ROS2 Humble 安装完成!
echo ============================================
echo 安装路径: %ROS2_PATH%
echo.
echo 下一步:
echo   1. 运行 "2_启动ROS2环境.bat" 启动ROS2
echo   2. 运行 "3_测试ROS2.bat" 测试安装
echo   3. 查看 "README.md" 获取使用说明
echo ============================================
pause
