@echo off
Rscript -e "shiny::runApp('src/ui', launch.browser = TRUE);"
