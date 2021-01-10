@echo off
echo Installing packages...
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
Rscript -e "values <- c('RCurl', 'XML', 'stringr', 'jsonlite', 'yaml', 'shiny', 'shinyjs'); packages <- .packages(all.available = TRUE); invisible(sapply(values, function(x) if(!any(x == packages)) install.packages(x, repos = 'https://mirrors.tuna.tsinghua.edu.cn/CRAN/')))"
echo Done!
timeout 3 /nobreak
