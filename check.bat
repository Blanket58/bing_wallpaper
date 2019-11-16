@echo off
pip list > configs/modules.txt
Rscript bin/check_packages.R
