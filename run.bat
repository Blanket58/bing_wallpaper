@echo off
D:
cd D:\bing_wallpaper-master\bing_wallpaper-master\pictures
DIR *.* /B >D:\bing_wallpaper-master\bing_wallpaper-master\configs\list.txt

pip list >> D:\bing_wallpaper-master\bing_wallpaper-master\configs\modules.txt

Rscript D:\bing_wallpaper-master\bing_wallpaper-master\bin\scratch.R

python D:\bing_wallpaper-master\bing_wallpaper-master\bin\setwallpaper.py
