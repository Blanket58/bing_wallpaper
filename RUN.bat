@echo off
cd %cd%/pictures
DIR *.* /B > ../configs/list.txt
pip list > ../configs/modules.txt
Rscript ../bin/main.R
