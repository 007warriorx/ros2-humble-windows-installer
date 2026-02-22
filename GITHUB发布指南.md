# GitHub 发布指南

## ⚠️ 安全提醒

**为了保护你的账号安全，请不要在任何脚本中直接写入密码！**

本指南提供安全的发布方式，使用 GitHub CLI 或 SSH 密钥进行身份验证。

---

## 方法一：一键发布脚本（推荐）

### 步骤

1. **双击运行** `发布到GitHub.bat`

2. **首次使用需要登录 GitHub**：
   - 脚本会自动安装 GitHub CLI (gh)
   - 按照提示选择登录方式
   - **推荐**：使用浏览器登录（最安全）
   - **备选**：使用 Personal Access Token

3. **脚本会自动完成**：
   - 初始化 Git 仓库
   - 配置用户信息
   - 创建 `.gitignore`
   - 提交所有文件
   - 创建 GitHub 仓库
   - 推送代码

### 登录方式详解

#### 方式A：浏览器登录（推荐）
```
? What account do you want to log into? GitHub.com
? What is your preferred protocol for Git operations? HTTPS
? Authenticate Git with your GitHub credentials? Yes
? How would you like to authenticate GitHub CLI? Login with a web browser
```
然后按提示在浏览器中完成登录。

#### 方式B：使用 Personal Access Token
如果你无法使用浏览器登录，可以使用 Token：

1. 访问 https://github.com/settings/tokens
2. 点击 "Generate new token (classic)"
3. 勾选权限：
   - ✅ `repo` (完整仓库访问)
   - ✅ `workflow` (可选，用于GitHub Actions)
4. 生成 Token 并复制

5. 运行 `gh auth login` 选择 Token 方式：
```
? How would you like to authenticate GitHub CLI? Paste an authentication token
? Paste your authentication token: [粘贴你的token]
```

---

## 方法二：手动发布步骤

### 步骤 1：安装 Git 和 GitHub CLI

1. **安装 Git**：
   - 下载：https://git-scm.com/download/win
   - 安装时勾选 "Git Bash Here" 和 "Add to PATH"

2. **安装 GitHub CLI**：
   - 下载：https://cli.github.com/
   - 或使用 `winget install --id GitHub.cli`

### 步骤 2：配置 Git

打开命令行（CMD 或 Git Bash）：

```bash
# 配置用户名和邮箱
git config --global user.name "Top Liu"
git config --global user.email "top1944@163.com"

# 验证配置
git config --list
```

### 步骤 3：登录 GitHub

```bash
gh auth login
```

按提示选择：
- 选择 `GitHub.com`
- 选择 `HTTPS`
- 选择 `Yes` 认证 Git
- 选择 `Login with a web browser`

浏览器会打开登录页面，完成授权即可。

### 步骤 4：创建并上传仓库

```bash
# 进入项目目录
cd "D:\2026\上海2026\AI地面站\windows+ros2"

# 初始化仓库
git init

# 创建 .gitignore
echo "已下载软件/*.zip" > .gitignore
echo "已下载软件/*.7z" >> .gitignore
echo "*.tmp" >> .gitignore
echo "*.log" >> .gitignore

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit: ROS2 Humble Windows Installer v1.0"

# 创建 GitHub 仓库（公开）
gh repo create ros2-humble-windows-installer --public --description "ROS2 Humble Hawksbill Windows 一键安装包" --source=. --remote=origin --push
```

---

## 方法三：使用 GitHub 网页手动创建

### 步骤 1：创建仓库

1. 访问 https://github.com/new
2. 填写信息：
   - Repository name: `ros2-humble-windows-installer`
   - Description: `ROS2 Humble Hawksbill Windows 一键安装包`
   - 选择 `Public`（公开）
   - ✅ 勾选 `Add a README file`
3. 点击 `Create repository`

### 步骤 2：上传文件

1. 在新仓库页面点击 `Add file` → `Upload files`
2. 拖放以下文件：
   - `1_安装ROS2.bat`
   - `2_启动ROS2环境.bat`
   - `3_测试ROS2.bat`
   - `4_卸载ROS2.bat`
   - `README.md`
   - `快速入门.md`
   - `VERSION.txt`
   - `打包清单.txt`
3. 点击 `Commit changes`

---

## 创建 Release 发布版本

为了让用户方便下载，建议创建 Release：

### 步骤

1. 在 GitHub 仓库页面，点击右侧的 `Create a new release`

2. 填写信息：
   - Tag version: `v1.0`
   - Release title: `ROS2 Humble Windows Installer v1.0`
   - Description:
```markdown
## ROS2 Humble Windows 一键安装包 v1.0

### 功能特性
- ✅ 一键自动安装 ROS2 Humble LTS
- ✅ 自动检测和修复环境
- ✅ 完整的测试脚本
- ✅ 支持 Python 节点开发
- ✅ 详细的文档说明

### 系统要求
- Windows 10/11 64位
- Python 3.10
- 5GB 磁盘空间

### 使用步骤
1. 运行 `1_安装ROS2.bat`
2. 运行 `2_启动ROS2环境.bat`
3. 运行 `3_测试ROS2.bat` 测试安装

### 文件说明
- 查看 `README.md` 获取详细说明
- 查看 `快速入门.md` 快速开始
```

3. **上传安装包**（可选但推荐）：
   - 点击 `Attach binaries by dropping them here or selecting them`
   - 上传 `ros2-humble-*-windows-release-amd64.zip`
   - 这样用户可以直接从 Release 下载完整包

4. 点击 `Publish release`

---

## 账号信息（仅参考，不在脚本中使用）

- **GitHub 邮箱**: top1944@163.com
- **GitHub 用户名**: top1944（由邮箱推断）

⚠️ **安全提示**：
1. 永远不要将密码写入任何脚本或代码
2. 使用 Personal Access Token 代替密码
3. 启用 GitHub 的双重认证（2FA）
4. 定期更换 Token

---

## 常见问题

### Q: 提示 "Authentication failed"
A: 运行 `gh auth login` 重新登录

### Q: 提示 "Permission denied"
A: 检查是否有仓库的写入权限，或使用 Token 时检查权限设置

### Q: 如何更新已发布的项目？
A: 修改文件后运行：
```bash
git add .
git commit -m "更新说明"
git push origin main
```

### Q: 如何删除仓库？
A: 访问仓库页面 → Settings → 最下方 Danger Zone → Delete this repository

---

## 推荐的工作流程

1. **开发/修改** → 在本地修改脚本
2. **测试** → 运行测试确保功能正常
3. **提交** → `git add . && git commit -m "说明"`
4. **推送** → `git push origin main`
5. **发布** → 在 GitHub 创建 Release

---

祝你发布顺利！🚀
