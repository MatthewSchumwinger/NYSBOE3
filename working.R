# one off preprocssing to fix record
# message("preprocessing file ...")
# x <- readLines(paste0(path, "/ALL_REPORTS.out"))
# x <- gsub('', "", x)
# writeLines(x, paste0(path, "/ALL_REPORTS.out"))

path <- "/Users/matthewschumwinger/Dropbox/Analytics-Consulting/Clients/QRI/campaign_finance/ALL_REPORTS/ALL_REPORTS.txt"
x <- readLines(path)
x[87227] <- "\"A00243\",\"J\",\"E\",\"2009\",\"2675\",\"10/31/2008\",\"\",\"\",\"\",\"SOVERIGN BANK\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"88.62\",\"\",\"\",\"INT/DIV\",\"\",\"\",\"\",\"\",\"\",\"MO\",\"01/19/2009 22:15:33\""
x[87228] <- "\"A00243\",\"J\",\"E\",\"2009\",\"2676\",\"11/28/2008\",\"\",\"\",\"\",\"SOVERIGN BANK\",\"\",\"\",\"\",\"\",\"\",\"\",\"11372\",\"\",\"\",\"70.1\",\"\",\"\",\"INT/DIV\",\"\",\"\",\"\",\"\",\"\",\"MO\",\"01/19/2009 22:16:16\""

# x <- gsub('', "", x)
# writeLines(x, "~/Desktop/temp.txt")
# allreports <- data.table::fread("~/Desktop/temp.txt", header = FALSE)
# 
# allreports <- data.table::fread(path, sep = ",", 
#                                 header = FALSE, nrows = -1)


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