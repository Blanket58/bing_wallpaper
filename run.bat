cd C:\Program Files\R\R-3.5.2\bin
Rscript D:\bing_autowallpaper\bing_autowallpaper\AutoWallPaper.R
echo Now Run the fetchname
cd D:\bing_autowallpaper\bing_autowallpaper\Pictures
DIR *.* /B >D:\bing_autowallpaper\bing_autowallpaper\list.txt
echo Now run the ChangeWallPaper
set Num=50
set N=0
:str
set /a n=%n%+1
reg add "hkcu\control panel\desktop" /v Wallpaper /d "D:\bing_autowallpaper\bing_autowallpaper\1.jpg" /f
reg add "hkcu\control panel\desktop" /v WallpaperStyle /t REG_DWORD /d 0 /f
RunDll32.exe USER32.DLL,UpdatePerUserSystemParameters
if "%n%"=="%Num%" goto end
goto str
exit
