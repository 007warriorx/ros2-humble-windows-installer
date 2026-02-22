@echo off
chcp 65001 >nul 2>&1
echo ============================================
echo ROS2 Humble 环境启动
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

echo [INFO] 正在配置ROS2环境...

REM Set environment variables
set "PATH=%ROS2_PATH%\bin;%ROS2_PATH%\Scripts;%PATH%"
set "PYTHONPATH=%ROS2_PATH%\Lib\site-packages"
set "AMENT_PREFIX_PATH=%ROS2_PATH%"
set "ROS_DISTRO=humble"
set "ROS_PYTHON_VERSION=3"
set "RCUTILS_COLORIZED_OUTPUT=1"

echo [OK] 环境配置完成
echo.

REM Auto-fix Python paths if needed
echo [INFO] 检查环境...
python -c "import sys; sys.exit(0)" >nul 2>&1
if %errorlevel% equ 0 (
    python -c "
import os, glob
ros_path = r'%ROS2_PATH%'
old_path = r'C:\pixi_ws\.pixi\envs\default\python.exe'
new_path = r'C:\Python310\python.exe'

if not os.path.exists(new_path):
    print('[WARNING] Python 3.10路径可能不正确')
    sys.exit(1)

fixed = 0
scripts_dirs = [
    os.path.join(ros_path, 'Scripts'),
    os.path.join(ros_path, 'Lib', 'demo_nodes_py'),
]

for scripts_dir in scripts_dirs:
    if os.path.exists(scripts_dir):
        for py_file in glob.glob(os.path.join(scripts_dir, '*.py')):
            try:
                with open(py_file, 'r', encoding='utf-8') as f:
                    content = f.read()
                if old_path in content:
                    with open(py_file, 'w', encoding='utf-8') as f:
                        f.write(content.replace(old_path, new_path))
                    fixed += 1
            except:
                pass
if fixed > 0:
    print(f'[INFO] 自动修复了 {fixed} 个脚本')
    " 2>nul
)

echo.
echo ============================================
echo ROS2 Humble 环境已激活
echo ============================================
echo.
echo 常用命令:
echo   ros2 --help              显示ROS2帮助
echo   ros2 topic list          列出话题
echo   ros2 node list           列出节点
echo   ros2 doctor              诊断ROS2状态
echo   ros2 run ^<包名^> ^<节点名^>  运行节点
echo.
echo 示例:
echo   ros2 run demo_nodes_py talker    (发布者)
echo   ros2 run demo_nodes_py listener  (订阅者)
echo.
echo 提示:
echo   - 同时打开两个窗口运行talker和listener可测试通信
echo   - 按Ctrl+C停止节点运行
echo ============================================

REM Launch new command prompt with environment
cmd /k "echo [READY] ROS2环境已就绪，可直接输入命令"
