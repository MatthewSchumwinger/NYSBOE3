
table(nchar(as.character(trans$E_YEAR)))
table(trans$FREPORT_ID)
str(filers)


table(err_trans$expected)


trans[nchar(trans$E_YEAR) > 4, ] # "," in text is throwing the data importer.
# 
# 
# 
# filers <- read.csv("/Users/matthewschumwinger/Documents/GitHub_projects/NYSBOE/data/commcand.Rds",
#                    header = F)
# 
# sample <- c("BARROW","76 EAST 51ST STREET, APT. 2F","BROOKLYN","NY","11203")
# 
# ,+[^"]
# 
# gsub(',+[^"]', "-", sample[2])
# 
# 
# 
# path <- "/Users/matthewschumwinger/Downloads/commcand/COMMCAND.txt"
# x <- readLines(path)
# x <- gsub(',+[^"]', "-", x)
# writeLines(x, "/Users/matthewschumwinger/Downloads/commcand/test.txt")
# 
# 
# BUG: C42215,EDWARD ROSADO 