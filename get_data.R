## functions to retrieve NYSBOE data and load as data frames.

# saveRDS(commcand, "data/commcand.Rds")
# saveRDS(allreports, "data/allreports2.Rds")

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
  
  commcand <- read_csv(paste0(path, "/COMMCAND.TXT"), col_names =  FALSE, 
                       col_types = "ccccccccccccc")
  
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
commcand <- get_commcand()


get_allreports <- function(){
  #transactions
  message("This retrieves a large compressed file (approximately 282 MB) and may
          take a while to download and transform into a data frame.")
  retrieved <- Sys.Date()
  allreports_url <- "http://www.elections.ny.gov/NYSBOE/download/ZipDataFiles/ALL_REPORTS.zip"
  
  mainDir <- getwd()
  subDir <- "data/data_docs"
  path <- paste(mainDir, subDir, sep = "/")
  temp <- tempfile()
  download.file(allreports_url, temp)
  dir.create(file.path(mainDir, subDir), showWarnings = FALSE)
  unzip(temp, exdir = path)
  
  allreports <- read_csv(paste0(path, "/ALL_REPORTS.out"), col_names =  FALSE, 
                       col_types = "cccccccccccccccccccccccccccccc")
  
  # message("Loading textfile as data frame . . .")
  # allreports <- read.delim(paste0(path, "/ALL_REPORTS.out"), header = FALSE, sep = ",")
  # message("Removing raw data . . .")
  # unlink(temp)
  # unlink(paste0(path, "/ALL_REPORTS.out"), recursive = T)
  allreports
}
allreports <- get_allreports()
