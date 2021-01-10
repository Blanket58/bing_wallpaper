# bing_wallpaper

[R Version 3.6.3](https://www.r-project.org/) |
[Python Version 3.7.9](https://www.python.org/downloads/)

### Introduction：

Just one press, easily crawl down bing pictures and set it to be your desktop wallpaper.

### Features：

File `config.json` is the one does configuration purpose, edit it as you like.

So far, there are three modes you can choose:

* current: Crawls down exactly the picture on 'cn.bing.com' that day. [true/false]
* random: Randomly crawls down one picture from the history pictures database. [true/false]
* n_days_ago: Manually type in one positive integer N to get exactly the picture N days ago. [positive integer/false]

Notice: only one mode is allowed to be switched on at a time.

### UI：

Run file `RUN_UI.bat` to see it. You can only browse all the pictures by now, any other functionality will be added in the future when I'm available to time.

### Guidence：

1. Configure the environment variables for R and Python;
2. For the first time to use this program, please run `check.bat` to install all the dependency modules;
3. Each time you want to change your wallpaper, run `RUN.bat` and the program will does it for you.

### OS：

Only tested on win10。

### Other：

[xCss](https://github.com/xCss/bing) owns the history pictures database, very thankful to him。
