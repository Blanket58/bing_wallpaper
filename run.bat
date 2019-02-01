SET SF="HKEY_LOCAL_MACHINE\SOFTWARE\R-core\R"
FOR /F "tokens=2,*" %%I IN ('REG QUERY %SF% /v InstallPath 2^>NUL^|FIND /I "InstallPath"') DO SET "APath=%%~J"
cd %APath%\bin
Rscript D:\bing_autowallpaper-master\bing_autowallpaper-master\bin\AutoWallPaper.R
echo Now Run the fetchname
cd D:\bing_autowallpaper-master\bing_autowallpaper-master\pictures
DIR *.* /B >D:\bing_autowallpaper-master\bing_autowallpaper-master\configs\list.txt
echo Now run the ChangeWallPaper
set Num=20
set N=0
:str
set /a n=%n%+1
reg add "hkcu\control panel\desktop" /v Wallpaper /d "D:\bing_autowallpaper-master\bing_autowallpaper-master\cache\1.jpg" /f
reg add "hkcu\control panel\desktop" /v WallpaperStyle /t REG_DWORD /d 0 /f
RunDll32.exe USER32.DLL,UpdatePerUserSystemParameters
if "%n%"=="%Num%" goto end
goto str
exit