@echo off
set num=20
set n=0
:str
set /a n=%n%+1

reg add "hkcu\control panel\desktop" /v Wallpaper /d "D:\bing_autowallpaper-master\bing_autowallpaper-master\cache\1.jpg" /f

reg add "hkcu\control panel\desktop" /v WallpaperStyle /t REG_DWORD /d 0 /f

RunDll32.exe USER32.DLL,UpdatePerUserSystemParameters

echo.已执行%n%次……
if "%n%"=="%num%" goto end
goto str

exit
