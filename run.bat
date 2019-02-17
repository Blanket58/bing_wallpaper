SET SF="HKEY_LOCAL_MACHINE\SOFTWARE\R-core\R"
FOR /F "tokens=2,*" %%I IN ('REG QUERY %SF% /v InstallPath 2^>NUL^|FIND /I "InstallPath"') DO SET "APath=%%~J"
echo %APath% >> D:\bing_autowallpaper-master\bing_autowallpaper-master\configs\Rpath.txt
FOR /F "delims=:,tokens=1" %%i in (D:\bing_autowallpaper-master\bing_autowallpaper-master\configs\Rpath.txt) do %%i:
cd %APath%\bin
Rscript D:\bing_autowallpaper-master\bing_autowallpaper-master\bin\scratch.R
echo Now Run the fetchname
D:
cd D:\bing_autowallpaper-master\bing_autowallpaper-master\pictures
DIR *.* /B >D:\bing_autowallpaper-master\bing_autowallpaper-master\configs\list.txt
echo Now run the ChangeWallPaper
python D:\bing_autowallpaper-master\bing_autowallpaper-master\bin\setwallpaper.py
