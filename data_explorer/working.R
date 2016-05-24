library(readr)
get_commcand <- function(){
  #filers
  retrieved <- Sys.Date()
  commcand_url <- "http://www.elections.ny.gov/NYSBOE/download/ZipDataFiles/commcand.zip" 
  
  mainDir <- getwd()
  subDir <- "data/data_docs"
  path <- paste(mainDir, subDir, sep = "/")
  temp <- tempfile()
  download.file(commcand_url, temp)
  dir.create(file.path(mainDir, subDir), showWarnings = FALSE)
  unzip(temp, exdir = path)
  
  commcand <- read_csv(paste0(path, "/COMMCAND.TXT"), col_names =  FALSE)
  
  # message("preprocessing file ...")
  # x <- readLines(paste0(path, "/COMMCAND.TXT"))
  # x <- gsub(',+[^"]', "-", x)
  # writeLines(x, paste0(path, "/COMMCAND.TXT"))
  # 
  # message("Loading textfile as data frame . . .")
  # commcand <- read.csv(paste0(path, "/COMMCAND.TXT"), header = FALSE)
  # message("Removing raw data . . .")
  # unlink(temp)
  # unlink(paste0(path, "/COMMCAND.TXT"), recursive = T)
  commcand
}
filers <- get_commcand()

# --- field names
f <- function() {
  x <- read.fwf(file = "data/data_docs/FILEREC.TXT",
                skip = 9,
                widths = (c(31,20,20)))
  x <- sapply(x, trimws)
  x <- x[1:13,]
  # View(x)
  x
}
filer_cols <- f() 
names(filers) <- filer_cols[ ,1]

# -- drop down lists
list_for_dropdown <- function(column, add.choose.one = FALSE) {
  l <- levels(as.factor(column))
  names(l) <- l
  if (add.choose.one) {
    # message("adding 'Choose one' to dropdown list.")
    c1 <- as.character("")
    names(c1) <- "Choose one"
    l <- c(c1, l)
  }
  l
}

# -- for FILERS data
l_filer_type <- list_for_dropdown(filers$FILER_TYPE)
l_status <- list_for_dropdown(filers$STATUS)
l_COMMITTEE_TYPE <- list_for_dropdown(filers$COMMITTEE_TYPE)

table(nchar(as.character(trans$E_YEAR)))

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