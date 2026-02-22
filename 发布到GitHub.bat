@echo off
chcp 65001 >nul 2>&1
echo ============================================
echo 发布 ROS2 Humble Windows 安装包 到 GitHub
echo ============================================
echo.
echo 作者: Top Liu
echo 邮箱: top1944@163.com
echo.

REM 配置
set "GITHUB_USERNAME=top1944"
set "GITHUB_EMAIL=top1944@163.com"
set "REPO_NAME=ros2-humble-windows-installer"
set "REPO_DESCRIPTION=ROS2 Humble Hawksbill Windows 一键安装包 - 包含完整脚本和文档"
set "PROJECT_PATH=%~dp0"

echo [INFO] 项目路径: %PROJECT_PATH%
echo [INFO] GitHub 用户名: %GITHUB_USERNAME%
echo.

REM 检查 git
echo [1/8] 检查 Git 安装...
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Git 未安装
    echo [INFO] 请从 https://git-scm.com/download/win 下载安装
    pause
    exit /b 1
)
echo [OK] Git 已安装

REM 检查 GitHub CLI
echo.
echo [2/8] 检查 GitHub CLI...
gh --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] GitHub CLI 未安装，正在安装...
    echo [INFO] 下载 GitHub CLI...

    REM 下载 GitHub CLI
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/cli/cli/releases/download/v2.42.0/gh_2.42.0_windows_amd64.msi' -OutFile '%TEMP%\gh.msi'" 2>nul

    if exist "%TEMP%\gh.msi" (
        echo [INFO] 安装 GitHub CLI...
        msiexec /i "%TEMP%\gh.msi" /quiet /norestart
        del "%TEMP%\gh.msi" 2>nul
        echo [OK] GitHub CLI 安装完成
    ) else (
        echo [ERROR] GitHub CLI 下载失败
        echo [INFO] 请手动下载: https://cli.github.com/
        pause
        exit /b 1
    )
) else (
    echo [OK] GitHub CLI 已安装
)

REM 配置 git
echo.
echo [3/8] 配置 Git...
git config --global user.name "%GITHUB_USERNAME%" 2>nul
git config --global user.email "%GITHUB_EMAIL%" 2>nul
echo [OK] Git 配置完成

REM 登录 GitHub
echo.
echo [4/8] 登录 GitHub...
echo [INFO] 正在检查登录状态...
gh auth status >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] 需要登录 GitHub
    echo [INFO] 请在弹出的浏览器中完成登录，或使用以下方式：
    echo.
    echo   方式1: 浏览器登录（推荐）
    echo   方式2: 使用 Personal Access Token
    echo.
    echo 如果使用Token登录，请先访问：
    echo https://github.com/settings/tokens
echo 生成一个 token（勾选 repo 权限），然后运行：
    echo   gh auth login
    echo.
    pause
    gh auth login
) else (
    echo [OK] 已登录 GitHub
)

REM 进入项目目录
echo.
echo [5/8] 初始化 Git 仓库...
cd /d "%PROJECT_PATH%"

if exist ".git" (
    echo [INFO] Git 仓库已存在
) else (
    git init
    echo [OK] Git 仓库初始化完成
)

REM 创建 .gitignore
echo.
echo [6/8] 创建 .gitignore...
(
echo # 忽略下载的大型安装包
echo 已下载软件/*.zip
echo 已下载软件/*.7z
echo 已下载软件/*.msi
echo 已下载软件/*.exe
echo.
echo # 忽略临时文件
echo *.tmp
echo *.log
echo *.bak
echo.
echo # 忽略系统文件
echo .DS_Store
echo Thumbs.db
echo desktop.ini
echo.
echo # 忽略IDE配置
echo .vscode/
echo .idea/
echo *.swp
echo.
echo # 保持目录结构
echo !已下载软件/.gitkeep
) > .gitignore
echo [OK] .gitignore 创建完成

REM 创建 .gitkeep 保持目录结构
echo. > "已下载软件\.gitkeep"

REM 添加文件
echo.
echo [7/8] 添加文件到 Git...
git add .
git commit -m "Initial commit: ROS2 Humble Windows Installer v1.0" >nul 2>&1
if %errorlevel% neq 0 (
    git commit -m "Update: ROS2 Humble Windows Installer" >nul 2>&1
)
echo [OK] 文件已提交

REM 创建 GitHub 仓库
echo.
echo [8/8] 创建 GitHub 仓库...
gh repo view %GITHUB_USERNAME%/%REPO_NAME% >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] 创建新仓库: %REPO_NAME%
    gh repo create %REPO_NAME% --public --description "%REPO_DESCRIPTION%" --source=. --remote=origin --push
    if %errorlevel% neq 0 (
        echo [ERROR] 仓库创建失败
        echo [INFO] 尝试手动创建...
        gh repo create %REPO_NAME% --public --description "%REPO_DESCRIPTION%"
        echo [INFO] 请手动关联远程仓库并推送：
        echo   git remote add origin https://github.com/%GITHUB_USERNAME%/%REPO_NAME%.git
        echo   git push -u origin main
        pause
        exit /b 1
    )
) else (
    echo [INFO] 仓库已存在，推送更新...
    git remote remove origin 2>nul
    git remote add origin https://github.com/%GITHUB_USERNAME%/%REPO_NAME%.git
    git branch -M main
    git push -u origin main
)

echo.
echo ============================================
echo 发布完成!
echo ============================================
echo.
echo 仓库地址:
echo   https://github.com/%GITHUB_USERNAME%/%REPO_NAME%
echo.
echo 克隆地址:
echo   git clone https://github.com/%GITHUB_USERNAME%/%REPO_NAME%.git
echo.
echo 下一步:
echo   1. 访问仓库页面查看上传的文件
echo   2. 在 Releases 中创建发布版本
echo   3. 上传 ROS2 安装包到 Releases
echo.
pause
