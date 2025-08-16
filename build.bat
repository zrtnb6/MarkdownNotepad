@echo off
REM =====================================================================
REM Markdown���±�����ű�
REM ���ܣ��Զ���װ�������������Ӧ�ó���
REM =====================================================================

REM ����Ƿ��Թ���Ա�������
setlocal
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ���Թ���Ա������д˽ű���
    echo �Ҽ�����ű� -> "�Թ���Ա�������"
    pause
    exit /b
)

REM ���û�������
set "SCRIPT_DIR=%~dp0"
set "PYTHON_EXE=python"
set "PIP_EXE=pip"
set "BUILD_DIR=%SCRIPT_DIR%build"
set "DIST_DIR=%SCRIPT_DIR%dist"
set "ICON_PATH=%SCRIPT_DIR%icons\app_icon.ico"

REM ���Python�Ƿ�װ
echo ���ڼ��Python��װ...
%PYTHON_EXE% --version >nul 2>&1
if %errorLevel% neq 0 (
    echo δ��⵽Python�����ڳ��Բ���...
    where python >nul 2>&1
    if %errorLevel% neq 0 (
        echo δ�ҵ�Python��װ����� https://www.python.org/downloads/ ���ز���װ
        echo ��װʱ�빴ѡ "Add Python to PATH" ѡ��
        pause
        exit /b
    )
)

REM ���pip�Ƿ�װ
echo ���ڼ��pip��װ...
%PIP_EXE% --version >nul 2>&1
if %errorLevel% neq 0 (
    echo δ�ҵ�pip�����ڳ��԰�װ...
    %PYTHON_EXE% -m ensurepip --default-pip
    if %errorLevel% neq 0 (
        echo pip��װʧ�ܣ����ֶ���װpip
        pause
        exit /b
    )
)

REM ��װ/���±�Ҫ��
echo ���ڰ�װ/���±�Ҫ��...
%PIP_EXE% install --upgrade pip setuptools wheel
%PIP_EXE% install pyinstaller markdown requests PyQt5 xmltodict defusedxml

REM ���ͼ���ļ��Ƿ����
echo ���ڼ��ͼ���ļ�...
if not exist "%ICON_PATH%" (
    echo ����ͼ���ļ�δ�ҵ���
    echo ��ȷ���� %ICON_PATH% λ����app_icon.ico�ļ�
    pause
    exit /b
)

REM ����֮ǰ�Ĺ���
echo ��������֮ǰ�Ĺ���...
if exist "%BUILD_DIR%" rmdir /s /q "%BUILD_DIR%"
if exist "%DIST_DIR%" rmdir /s /q "%DIST_DIR%"
del /q "%SCRIPT_DIR%MarkdownNotepad.spec" 2>nul

REM �����������
set "BUILD_CMD=pyinstaller --onefile --windowed --icon="%ICON_PATH%" --name "MarkdownNotepad" --add-data "icons;icons" --hidden-import markdown.extensions.extra --hidden-import markdown.extensions.codehilite --hidden-import markdown.extensions.fenced_code --hidden-import markdown.extensions.tables --hidden-import xml.etree.ElementTree --hidden-import xml.etree.ElementPath main.py"

REM ��ʾ��������
echo ����ִ�д������:
echo %BUILD_CMD%

REM ִ�д��
call %BUILD_CMD%

REM ��������
if exist "%DIST_DIR%\MarkdownNotepad.exe" (
    echo.
    echo =====================================================
    echo ����ɹ���
    echo ��ִ���ļ�λ��: %DIST_DIR%\MarkdownNotepad.exe
    echo =====================================================
) else (
    echo.
    echo =====================================================
    echo ���ʧ�ܣ����������Ϣ
    echo =====================================================
)

REM ���README�ļ�
echo �������˵���ļ�...
(
echo Markdown���±� - ʹ��˵��
echo ===========================
echo.
echo ��Ӧ�ó�����ʹ��PyInstaller�����Markdown���±�
echo.
echo �����ص㣺
echo - Markdown�༭��ʵʱԤ��
echo - ���ǩҳ֧��
echo - WebDAV������ָ�����
echo - �Զ�����
echo.
echo ʹ��˵����
echo 1. ֱ������ MarkdownNotepad.exe
echo 2. ʹ��"�ļ�"�˵��򿪡������ļ�
echo 3. ʹ��"WebDAV"�˵������Ʊ���
echo 4. ʹ��"WebDAV"->"�ӱ��ݻָ�"�ָ��ļ�
echo.
echo ע�⣺�״�ʹ��WebDAV������Ҫ���÷�������Ϣ
echo.
echo �������: %date% %time%
) > "%DIST_DIR%\README.txt"

echo �Ѵ���˵���ļ�: %DIST_DIR%\README.txt

REM �����Ŀ¼
explorer "%DIST_DIR%"

pause