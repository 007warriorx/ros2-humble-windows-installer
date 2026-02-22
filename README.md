# ROS2 Humble Windows 完整安装包

作者：Top Liu

[![ROS2 Version](https://img.shields.io/badge/ROS2-Humble%20Hawksbill-blue.svg)](https://docs.ros.org/en/humble/)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%2F11-blue.svg)](https://www.microsoft.com/windows)
[![Python](https://img.shields.io/badge/Python-3.10-blue.svg)](https://www.python.org/)

本安装包提供了一键安装ROS2 Humble Hawksbill LTS版本的完整解决方案，包含所有必要的脚本和文档。

## 包内容说明

```
ROS2_Humble_Windows_安装包/
├── 1_安装ROS2.bat              # 一键安装脚本
├── 2_启动ROS2环境.bat          # 启动ROS2环境
├── 3_测试ROS2.bat              # 功能测试脚本
├── 4_卸载ROS2.bat              # 卸载脚本
├── README.md                   # 本说明文档
└── 已下载软件/                  # 存放安装包的目录
    └── ros2-humble-*-windows-release-amd64.zip
```

## 系统要求

| 项目 | 要求 |
|------|------|
| **操作系统** | Windows 10 或 Windows 11 (64位) |
| **Python** | 3.10.x (必须此版本) |
| **内存** | 建议4GB以上 |
| **磁盘空间** | 至少5GB可用空间 |
| **网络** | 安装时需要联网下载Python依赖 |

## 前置准备

### 1. 安装Python 3.10

**重要**: ROS2 Humble Windows版本需要Python 3.10，其他版本不兼容。

**下载地址**: https://www.python.org/downloads/release/python-31011/

**安装步骤**:
1. 运行安装程序
2. **必须勾选** "Add Python to PATH"
3. 选择 "Customize installation"
4. 确保勾选 "pip" 和 "Add Python to environment variables"
5. 完成安装

**验证安装**:
```batch
python --version
# 应显示 Python 3.10.x
```

### 2. 安装Visual C++ Redistributables

**下载地址**: https://aka.ms/vs/17/release/vc_redist.x64.exe

双击安装即可，这是运行ROS2 C++组件的必要依赖。

### 3. 下载ROS2安装包

**下载地址**: https://github.com/ros2/ros2/releases

找到最新的 `ros2-humble-*-windows-release-amd64.zip` 文件下载。

**存放位置**: 将下载的zip文件放入 `已下载软件` 文件夹（与脚本同一目录）

## 安装步骤

### 方法一：一键安装（强烈推荐）

1. **双击运行** `1_安装ROS2.bat`
2. 脚本会自动完成以下操作：
   - 检查Python 3.10
   - 检查pip
   - 检查Visual C++ Redistributables
   - 解压ROS2安装包
   - 安装Python依赖（packaging, numpy, netifaces, pyyaml, lxml）
   - 修复Python脚本路径
   - 配置环境
3. 等待安装完成（约5-10分钟，取决于电脑性能）

### 方法二：手动安装

如果自动安装遇到问题，可以手动安装：

```batch
# 1. 解压ROS2安装包到 C:\dev\ros2_humble

# 2. 安装Python依赖
python -m pip install packaging numpy netifaces pyyaml lxml

# 3. 修复Python脚本路径（在解压目录运行）
python -c "
import os, glob
ros_path = r'C:\dev\ros2_humble'
old_path = r'C:\pixi_ws\.pixi\envs\default\python.exe'
new_path = r'C:\Python310\python.exe'

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
            except:
                pass
print('Done')
"
```

## 使用ROS2

### 启动ROS2环境

**双击运行** `2_启动ROS2环境.bat`

这将打开一个命令行窗口，ROS2环境已自动配置好。在此窗口中可以直接使用所有ros2命令。

### 常用命令

```batch
# 查看ROS2帮助
ros2 --help

# 诊断ROS2状态
ros2 doctor

# 列出所有话题
ros2 topic list

# 列出所有节点
ros2 node list

# 列出所有包
ros2 pkg list

# 查看话题信息
ros2 topic info /topic_name

# 监听话题
ros2 topic echo /topic_name

# 发布话题
ros2 topic pub /topic_name std_msgs/msg/String "data: 'hello'"
```

### 运行示例节点

**测试通信**: 同时打开**两个命令行窗口**，都先运行 `2_启动ROS2环境.bat`

**窗口1 - 启动发布者：**
```batch
ros2 run demo_nodes_py talker
```
输出示例：
```
[INFO] [talker]: Publishing: "Hello World: 0"
[INFO] [talker]: Publishing: "Hello World: 1"
[INFO] [talker]: Publishing: "Hello World: 2"
```

**窗口2 - 启动订阅者：**
```batch
ros2 run demo_nodes_py listener
```
输出示例：
```
[INFO] [listener]: I heard: "Hello World: 0"
[INFO] [listener]: I heard: "Hello World: 1"
[INFO] [listener]: I heard: "Hello World: 2"
```

如果看到消息传递，说明ROS2工作正常！按 `Ctrl+C` 停止节点。

### 更多示例节点

```batch
# C++发布者
ros2 run demo_nodes_cpp talker

# C++订阅者
ros2 run demo_nodes_cpp listener

# 服务客户端
ros2 run demo_nodes_py add_two_ints_client

# 服务端
ros2 run demo_nodes_py add_two_ints_server
```

## 测试安装

运行 `3_测试ROS2.bat` 可以自动测试ROS2功能：

- ✓ ros2命令可用性
- ✓ ros2 doctor诊断
- ✓ rclpy Python导入
- ✓ topic/node/pkg列表
- ✓ Python节点启动测试
- ✓ 示例包检查
- ✓ 环境变量检查

## 卸载ROS2

运行 `4_卸载ROS2.bat` 可以完全删除ROS2安装。

**注意**: 卸载将删除整个 `C:\dev\ros2_humble` 目录，如有自定义文件请提前备份。

## 故障排除

### 问题1: "python: 命令未找到" 或 "python不是内部或外部命令"

**原因**: Python未添加到系统PATH

**解决**:
1. 重新安装Python 3.10，**必须勾选** "Add Python to PATH"
2. 或手动添加 `C:\Python310` 和 `C:\Python310\Scripts` 到系统环境变量PATH

### 问题2: "failed to create process"

**原因**: Python脚本的shebang路径不正确

**解决**:
1. 重新运行 `1_安装ROS2.bat`
2. 或运行 `2_启动ROS2环境.bat`（会自动修复）

### 问题3: "ImportError: DLL load failed"

**原因**: 缺少Visual C++ Redistributables

**解决**: 安装 https://aka.ms/vs/17/release/vc_redist.x64.exe

### 问题4: "ModuleNotFoundError: No module named 'packaging'"

**原因**: 缺少Python依赖

**解决**:
```batch
python -m pip install packaging numpy netifaces pyyaml lxml
```

### 问题5: 解压失败或找不到文件

**原因**: 安装包未放入正确位置或解压工具缺失

**解决**:
1. 确保下载的 `ros2-humble-*-windows-release-amd64.zip` 放在 `已下载软件` 文件夹
2. 如PowerShell解压失败，脚本会自动尝试7z
3. 可手动解压到 `C:\dev\ros2_humble`

### 问题6: ros2 run 命令找不到节点

**原因**: Python脚本路径需要修复

**解决**:
1. 重新运行 `2_启动ROS2环境.bat`
2. 脚本会自动修复Python路径

## Python节点开发

在ROS2环境中，可以开发自定义Python节点：

```python
#!/usr/bin/env python3
# my_node.py

import rclpy
from rclpy.node import Node
from std_msgs.msg import String

class MyPublisher(Node):
    def __init__(self):
        super().__init__('my_publisher')
        self.publisher = self.create_publisher(String, 'my_topic', 10)
        self.timer = self.create_timer(1.0, self.timer_callback)
        self.count = 0

    def timer_callback(self):
        msg = String()
        msg.data = f'Hello {self.count}'
        self.publisher.publish(msg)
        self.get_logger().info(f'Published: {msg.data}')
        self.count += 1

def main():
    rclpy.init()
    node = MyPublisher()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
```

**运行节点**:
```batch
# 在ROS2环境窗口中
python my_node.py
```

## 目录结构

安装后的ROS2目录结构：

```
C:\dev\ros2_humble
├── bin\                      # DLL文件和可执行文件
├── Lib\                      # Python库
│   ├── site-packages\        # Python包
│   ├── demo_nodes_py\        # Python示例节点
│   └── demo_nodes_cpp\       # C++示例节点
├── Scripts\                  # Python脚本（ros2等命令）
├── share\                    # 包数据和资源
├── include\                  # C++头文件
├── cmake\                    # CMake配置
├── local_setup.bat           # 环境配置脚本
├── setup.bat                 # 主配置脚本
└── .pixi\                    # 依赖环境（可选）
```

## 版本信息

- **ROS2版本**: Humble Hawksbill (LTS)
- **支持平台**: Windows 10/11 x64
- **Python版本**: 3.10
- **安装包版本**: 1.0
- **发布日期**: 2025年

## 相关链接

- **ROS2官方文档**: https://docs.ros.org/en/humble/
- **ROS2教程**: https://docs.ros.org/en/humble/Tutorials.html
- **ROS2包列表**: https://index.ros.org/packages/#humble
- **ROS2 GitHub**: https://github.com/ros2/ros2

## 许可

本安装包中的脚本遵循MIT许可证。ROS2本身遵循Apache 2.0许可证。

## 支持

如有问题：
1. 查看本文档的故障排除部分
2. 访问ROS2官方文档
3. 在GitHub提交Issue

---

**祝您使用愉快！**
