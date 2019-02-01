SET SF="HKEY_LOCAL_MACHINE\SOFTWARE\R-core\R"
FOR /F "tokens=2,*" %%I IN ('REG QUERY %SF% /v InstallPath 2^>NUL^|FIND /I "InstallPath"') DO SET "APath=%%~J"
cd %APath%\bin
Rscript D:\bing_autowallpaper-master\bing_autowallpaper-master\bin\AutoWallPaper.R