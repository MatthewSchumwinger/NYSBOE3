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

  # commcand <- readr::read_csv(paste0(path, "/COMMCAND.TXT"), col_names =  FALSE, 
  #                      col_types = "ccccccccccccc")
  
  # one off preprocssing to fix record
  message("preprocessing file ...")
  x <- readLines(paste0(path, "/COMMCAND.TXT"))
  x <- gsub('O"NEIL', "O'NEIL", x)
  writeLines(x, paste0(path, "/COMMCAND.TXT"))
  
  commcand <- data.table::fread(paste0(path, "/COMMCAND.TXT"), sep = ",", 
                                header = FALSE)
  
  commcand
}
commcand <- get_commcand()

# transactions
get_allreports <- function(){
  
  ## URL retrieveal is blocked as us of 5/25/16, 
    # message("This retrieves a large compressed file (approximately 282 MB) and may
    #         take a while to download and transform into a data frame.")
    # retrieved <- Sys.Date()
    # allreports_url <- "http://www.elections.ny.gov/NYSBOE/download/ZipDataFiles/ALL_REPORTS.zip"
    # mainDir <- getwd()
    # subDir <- "data/data_docs"
    # path <- paste(mainDir, subDir, sep = "/")
    # temp <- tempfile()
    # download.file(allreports_url, temp)
    # dir.create(file.path(mainDir, subDir), showWarnings = FALSE)
    # unzip(temp, exdir = path)
  
    # allreports <- readr::read_csv(paste0(path, "/ALL_REPORTS.out"), col_names =  FALSE,
    #                               col_types = "cccccccccccccccccccccccccccccc")
  
  ## so load data from previously retrieved file
  path <-
    "~/Dropbox/Analytics-Consulting/Clients/QRI/campaign_finance/raw_data/ALL_REPORTS/ALL_REPORTS.out"
  allreports <- readr::read_delim(path, col_names = FALSE, escape_backslash = TRUE,
                                  delim = ",", escape_double = FALSE,
                                col_types = "cccccccccccccccccccccccccccccc")
  
  ## remove multibyte non-ASCII characters
  allreports$X10 <- iconv(allreports$X10, "latin1", "ASCII", sub="~")
  allreports$X11 <- iconv(allreports$X11, "latin1", "ASCII", sub="~")
  allreports$X12 <- iconv(allreports$X12, "latin1", "ASCII", sub="~")
  allreports$X13 <- iconv(allreports$X13, "latin1", "ASCII", sub="~")
  allreports$X14 <- iconv(allreports$X14, "latin1", "ASCII", sub="~")
  allreports$X15 <- iconv(allreports$X15, "latin1", "ASCII", sub="~")
  
  ##  change amount to numeric
  allreports$X20 <- as.numeric(allreports$X20)
  allreports$X21 <- as.numeric(allreports$X21)
  
  ## change to date format¬
  allreports$X6 <- lubridate::mdy(allreports$X6)
  
  ## add transaction ID
  allreports$tID <- rownames(allreports)
  
  allreports
}
allreports <- get_allreports()
