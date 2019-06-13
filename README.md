# bing_wallpaper

[R Version 3.5.2](https://www.r-project.org/) |
[Python Version 3.7.2](https://www.python.org/downloads/)

### 简介：

一键自动抓取必应壁纸图片并设置为桌面壁纸。

### 特性：

根目录下的文件'options.json'是配置项文件，以任意文本编辑器打开，按个人需求修改保存即可。

* current：是否同步当天的必应官网背景壁纸
* random：是否随机设置历史壁纸
* n_days_ago：手动指定只需要 N 天前的当日壁纸（请输入正整数，不使用此项时设置为null，否则报错）

注意：三个选项同时只能打开一个

### ==测试功能：==

新增UI界面，运行根目录下的文件"RUN_UI.bat"，UI功能与其它功能独立，互不影响，现在UI界面只开发了浏览功能，其它功能后续有时间再完善。

### 建议：

建议使用前阅读Wiki及更新日志文件"PACKAGE_NEWS.txt"。

### 适用：

目前只在win10下测试通过。

### 感谢：

[xCss](https://github.com/xCss/bing) 的数据库存储了必应的历史壁纸。
