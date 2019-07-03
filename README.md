# bing_wallpaper

[R Version 3.5.2](https://www.r-project.org/) |
[Python Version 3.7.2](https://www.python.org/downloads/)

### 简介：

一键抓取必应壁纸图片并自动设置为桌面壁纸。

### 特性：

根目录下的文件'config.json'是配置项文件，以任意文本编辑器打开，按个人需求修改保存即可。

* current：是否同步当天的必应官网背景壁纸 [true/false]
* random：是否随机设置历史壁纸 [true/false]
* n_days_ago：手动指定只需要 N 天前的当日壁纸（请输入正整数，不使用此项时设置为null，否则报错）

注意：三个选项同时只能打开一个

### ==测试功能：==

新增UI界面，运行根目录下的文件"RUN_UI.bat"，UI功能与其它功能独立，互不影响，现在UI界面只开发了浏览功能，其它功能后续有时间再完善。

### 使用指南：

1. 配置好python与R解释器的系统环境变量；
2. 首次运行请先运行文件'check.bat'安装所有依赖库，只需首次执行一次即可；
3. 直接运行文件'RUN.bat'或'RUN_UI.bat'即可。

### 适用：

只适用于windows系统，且目前只在win10下测试通过。

### 感谢：

[xCss](https://github.com/xCss/bing) 的数据库存储了必应的历史壁纸。
