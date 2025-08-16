# Markdown记事本

一个功能强大的Markdown笔记工具，支持实时预览、多标签页编辑和WebDAV云备份

## 界面示意图

程序主界面如下所示：

![程序主界面](Screenshot/Screenshot.jpg)

## 功能特点

- 📝 Markdown语法支持
- 👁️ 实时预览功能
- 📑 多标签页编辑
- ☁️ WebDAV云备份与恢复
- ⏱️ 自动保存（每30秒）
- 🎨 精美用户界面
- ⏲️ 备份文件自动添加时间戳
- 📁 配置和缓存存储在应用数据目录
- 💾 从WebDAV恢复的文件自动保存到缓存目录
- 🖼️ 支持自定义主题和样式

## 打包指南

直接双击运行 `build.bat` 脚本即可自动安装所需依赖并自动打包，打包后的可执行文件位于 `/dist` 目录中

## 数据目录

应用的所有配置和缓存文件存储在以下位置：

```bash
<应用所在目录>/MarkdownNotepadData/
├── webdav_config.json  # WebDAV配置
└── cache/              # 缓存文件目录（WebDAV恢复的文件存储位置）
```

## WebDAV配置

配置文件位于 MarkdownNotepadData/webdav_config.json，格式如下：

```bash
{
    "url": "WebDAV服务器地址",
    "username": "用户名",
    "password": "密码",
    "remote_dir": "目标目录(留空则代表默认上传到根目录)"
}
```

## 主题定制

您可以通过修改以下代码片段来自定义应用主题：
```bash
# 在 __main__ 部分修改调色板颜色
palette = QPalette()
palette.setColor(QPalette.Window, QColor(240, 240, 240))  # 背景色
palette.setColor(QPalette.WindowText, Qt.black)           # 文字颜色
palette.setColor(QPalette.Highlight, QColor(52, 152, 219)) # 高亮色
# ... 其他颜色设置
```
