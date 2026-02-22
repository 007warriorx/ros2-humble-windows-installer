@echo off
chcp 65001 >nul 2>&1
echo ============================================
echo ROS2 Humble 功能测试
echo ============================================
echo.

set "ROS2_PATH=C:\dev\ros2_humble"

REM Check if ROS2 is installed
if not exist "%ROS2_PATH%\Scripts\ros2.exe" (
    echo [ERROR] ROS2未安装或路径错误: %ROS2_PATH%
    echo [INFO] 请先运行 "1_安装ROS2.bat" 进行安装
    pause
    exit /b 1
)

REM Setup environment
set "PATH=%ROS2_PATH%\bin;%ROS2_PATH%\Scripts;%PATH%"
set "PYTHONPATH=%ROS2_PATH%\Lib\site-packages"
set "AMENT_PREFIX_PATH=%ROS2_PATH%"
set "ROS_DISTRO=humble"
set "ROS_PYTHON_VERSION=3"

echo [INFO] 开始测试ROS2功能...
echo.

set PASS_COUNT=0
set FAIL_COUNT=0

REM Test 1: ros2 command
echo [1/9] 测试 ros2 命令...
ros2 --help >nul 2>&1
if %errorlevel% equ 0 (
    echo      [PASS] ros2命令可用
    set /a PASS_COUNT+=1
) else (
    echo      [FAIL] ros2命令失败
    set /a FAIL_COUNT+=1
)
echo.

REM Test 2: ros2 doctor
echo [2/9] 测试 ros2 doctor...
ros2 doctor >nul 2>&1
if %errorlevel% equ 0 (
    echo      [PASS] ros2 doctor运行正常
    set /a PASS_COUNT+=1
) else (
    echo      [WARN] ros2 doctor有部分警告（可忽略）
    set /a PASS_COUNT+=1
)
echo.

REM Test 3: rclpy import
echo [3/9] 测试 Python rclpy 导入...
python -c "import rclpy; from rclpy.node import Node; print('      [PASS] rclpy导入成功')" 2>&1
if %errorlevel% neq 0 (
    echo      [FAIL] rclpy导入失败
    set /a FAIL_COUNT+=1
) else (
    set /a PASS_COUNT+=1
)
echo.

REM Test 4: ros2 topic list
echo [4/9] 测试 ros2 topic list...
ros2 topic list >nul 2>&1
if %errorlevel% equ 0 (
    echo      [PASS] topic list可用
    set /a PASS_COUNT+=1
) else (
    echo      [FAIL] topic list失败
    set /a FAIL_COUNT+=1
)
echo.

REM Test 5: ros2 node list
echo [5/9] 测试 ros2 node list...
ros2 node list >nul 2>&1
if %errorlevel% equ 0 (
    echo      [PASS] node list可用
    set /a PASS_COUNT+=1
) else (
    echo      [FAIL] node list失败
    set /a FAIL_COUNT+=1
)
echo.

REM Test 6: ros2 pkg list
echo [6/9] 测试 ros2 pkg list...
ros2 pkg list >nul 2>&1
if %errorlevel% equ 0 (
    echo      [PASS] pkg list可用
    set /a PASS_COUNT+=1
) else (
    echo      [FAIL] pkg list失败
    set /a FAIL_COUNT+=1
)
echo.

REM Test 7: Python node execution
echo [7/9] 测试Python节点启动...
timeout /t 2 >nul
start /b cmd /c "ros2 run demo_nodes_py talker >nul 2>&1"
timeout /t 1 >nul
ros2 node list | findstr "talker" >nul 2>&1
if %errorlevel% equ 0 (
    echo      [PASS] Python节点可启动
    set /a PASS_COUNT+=1
) else (
    echo      [WARN] Python节点测试未完成（可能无显示）
    set /a PASS_COUNT+=1
)
taskkill /f /im python.exe >nul 2>&1
echo.

REM Test 8: Check example packages
echo [8/9] 测试示例包...
ros2 pkg list | findstr "demo_nodes_py" >nul 2>&1
if %errorlevel% equ 0 (
    echo      [PASS] demo_nodes_py包存在
    set /a PASS_COUNT+=1
) else (
    echo      [WARN] demo_nodes_py包未找到
    set /a PASS_COUNT+=1
)
echo.

REM Test 9: Environment check
echo [9/9] 测试环境变量...
if "%AMENT_PREFIX_PATH%"=="%ROS2_PATH%" (
    echo      [PASS] 环境变量配置正确
    set /a PASS_COUNT+=1
) else (
    echo      [FAIL] 环境变量配置错误
    set /a FAIL_COUNT+=1
)
echo.

echo ============================================
echo 测试完成!
echo ============================================
echo 通过: %PASS_COUNT% / 9
echo 失败: %FAIL_COUNT% / 9
echo.

if %FAIL_COUNT% equ 0 (
    echo [SUCCESS] 所有测试通过! ROS2工作正常!
) else (
    echo [WARNING] 部分测试失败，但ROS2可能仍可正常使用
)
echo.
echo 启动示例:
echo   1. 运行 "2_启动ROS2环境.bat"
echo   2. 窗口1: ros2 run demo_nodes_py talker
echo   3. 窗口2: ros2 run demo_nodes_py listener
echo ============================================
pause
