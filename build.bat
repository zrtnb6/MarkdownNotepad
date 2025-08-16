@echo off
REM =====================================================================
REM Markdown记事本打包脚本
REM 功能：自动安装所有依赖并打包应用程序
REM =====================================================================

REM 检查是否以管理员身份运行
setlocal
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 请以管理员身份运行此脚本！
    echo 右键点击脚本 -> "以管理员身份运行"
    pause
    exit /b
)

REM 设置环境变量
set "SCRIPT_DIR=%~dp0"
set "PYTHON_EXE=python"
set "PIP_EXE=pip"
set "BUILD_DIR=%SCRIPT_DIR%build"
set "DIST_DIR=%SCRIPT_DIR%dist"
set "ICON_PATH=%SCRIPT_DIR%icons\app_icon.ico"

REM 检查Python是否安装
echo 正在检查Python安装...
%PYTHON_EXE% --version >nul 2>&1
if %errorLevel% neq 0 (
    echo 未检测到Python，正在尝试查找...
    where python >nul 2>&1
    if %errorLevel% neq 0 (
        echo 未找到Python安装，请从 https://www.python.org/downloads/ 下载并安装
        echo 安装时请勾选 "Add Python to PATH" 选项
        pause
        exit /b
    )
)

REM 检查pip是否安装
echo 正在检查pip安装...
%PIP_EXE% --version >nul 2>&1
if %errorLevel% neq 0 (
    echo 未找到pip，正在尝试安装...
    %PYTHON_EXE% -m ensurepip --default-pip
    if %errorLevel% neq 0 (
        echo pip安装失败，请手动安装pip
        pause
        exit /b
    )
)

REM 安装/更新必要包
echo 正在安装/更新必要包...
%PIP_EXE% install --upgrade pip setuptools wheel
%PIP_EXE% install pyinstaller markdown requests PyQt5 xmltodict defusedxml

REM 检查图标文件是否存在
echo 正在检查图标文件...
if not exist "%ICON_PATH%" (
    echo 错误：图标文件未找到！
    echo 请确保在 %ICON_PATH% 位置有app_icon.ico文件
    pause
    exit /b
)

REM 清理之前的构建
echo 正在清理之前的构建...
if exist "%BUILD_DIR%" rmdir /s /q "%BUILD_DIR%"
if exist "%DIST_DIR%" rmdir /s /q "%DIST_DIR%"
del /q "%SCRIPT_DIR%MarkdownNotepad.spec" 2>nul

REM 创建打包命令
set "BUILD_CMD=pyinstaller --onefile --windowed --icon="%ICON_PATH%" --name "MarkdownNotepad" --add-data "icons;icons" --hidden-import markdown.extensions.extra --hidden-import markdown.extensions.codehilite --hidden-import markdown.extensions.fenced_code --hidden-import markdown.extensions.tables --hidden-import xml.etree.ElementTree --hidden-import xml.etree.ElementPath main.py"

REM 显示构建命令
echo 正在执行打包命令:
echo %BUILD_CMD%

REM 执行打包
call %BUILD_CMD%

REM 检查打包结果
if exist "%DIST_DIR%\MarkdownNotepad.exe" (
    echo.
    echo =====================================================
    echo 打包成功！
    echo 可执行文件位置: %DIST_DIR%\MarkdownNotepad.exe
    echo =====================================================
) else (
    echo.
    echo =====================================================
    echo 打包失败，请检查错误信息
    echo =====================================================
)

REM 添加README文件
echo 正在添加说明文件...
(
echo Markdown记事本 - 使用说明
echo ===========================
echo.
echo 此应用程序是使用PyInstaller打包的Markdown记事本
echo.
echo 功能特点：
echo - Markdown编辑与实时预览
echo - 多标签页支持
echo - WebDAV备份与恢复功能
echo - 自动保存
echo.
echo 使用说明：
echo 1. 直接运行 MarkdownNotepad.exe
echo 2. 使用"文件"菜单打开、保存文件
echo 3. 使用"WebDAV"菜单配置云备份
echo 4. 使用"WebDAV"->"从备份恢复"恢复文件
echo.
echo 注意：首次使用WebDAV功能需要配置服务器信息
echo.
echo 打包日期: %date% %time%
) > "%DIST_DIR%\README.txt"

echo 已创建说明文件: %DIST_DIR%\README.txt

REM 打开输出目录
explorer "%DIST_DIR%"

pause