# bing_wallpaper
Randomly crawls down bing daily picture from a third party database website (thanks to xCss , https://github.com/xCss/bing).

具体使用方法见wiki。

Detailed usage of this app is illustrated in wiki.


<h2>紧急：2019/03/07，目标服务器故障，此app暂时不可用</h2>

----

<h2>2019/02/19更新：</h2>

<h3>V 1.2</h3>

解决路径限定至D盘根目录的问题，现在文件夹命名及路径都可以由用户自由指定。

<br></br>

----

<br></br>

<h2>2019/02/17更新：</h2>

<h3>V 1.1</h3>

1.解决之前提到的有概率不能即时响应问题，现在可以做到即时响应；

2.解决有一定概率抓到相同两张图片的问题，保证壁纸从不重复；

3.测试R版本3.5.2，python3.7.2；

4.python.exe所在目录必须加入系统环境变量中；

5.Rscript.exe所在目录必须加入系统环境变量中。

<br></br>

----

<br></br>

<h3>V 1.0</h3>

1.在作者xCss工程的启发下完成桌面自动壁纸的开发；

2.随机从xCss提供的Bing每日壁纸数据库中抓取一张图片作为桌面壁纸；

3.只适用于Windows系统；

4.测试R版本3.5.2；

5.将压缩包解压至D盘根目录，不要对文件夹命名做任何更改，运行run.bat;

6.WinXP即时响应，Win7、10 经测试有可能不能即时响应，可以多运行几遍文件ChangeWallPaper.bat或重启计算机即可，此问题在后续版本中会做更新。
