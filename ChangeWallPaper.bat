@echo off
set Num=20
set N=0
:str
set /a n=%n%+1

reg add "hkcu\control panel\desktop" /v Wallpaper /d "C:\Users\Administrator.20181116-143426\Desktop\Rscripts\AutoWallPaper\1.jpg" /f

reg add "hkcu\control panel\desktop" /v WallpaperStyle /t REG_DWORD /d 0 /f

RunDll32.exe USER32.DLL,UpdatePerUserSystemParameters

echo.ÒÑÖ´ÐÐ%N%´Î¡­¡­
if "%n%"=="%Num%" goto end
goto str

exit