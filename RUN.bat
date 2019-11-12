@echo off
cd %cd%/pictures
DIR *.* /B > ../configs/list.txt
Rscript ../bin/main.R
