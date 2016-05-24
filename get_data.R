## functions to retrieve NYSBOE data and load as data frames.

# saveRDS(commcand, "data/commcand.Rds")
# saveRDS(allreports, "data/allreports.Rds")

# filers
get_commcand <- function(){

  retrieved <- Sys.Date()
  commcand_url <- "http://www.elections.ny.gov/NYSBOE/download/ZipDataFiles/commcand.zip" 
  
  mainDir <- getwd()
  subDir <- "data/data_docs"
  path <- paste(mainDir, subDir, sep = "/")
  temp <- tempfile()
  download.file(commcand_url, temp)
  dir.create(file.path(mainDir, subDir), showWarnings = FALSE)
  unzip(temp, exdir = path)
  
  commcand <- readr::read_csv(paste0(path, "/COMMCAND.TXT"), col_names =  FALSE, 
                       col_types = "ccccccccccccc")
  commcand
}
commcand <- get_commcand()

# transactions
get_allreports <- function(){
  
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
  
  allreports <- readr::read_csv(paste0(path, "/ALL_REPORTS.out"), col_names =  FALSE, 
                       col_types = "cccccccccccccccccccccccccccccc")
  allreports
}
allreports <- get_allreports()
