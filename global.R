## load data
# use get_data() to retrieve these files
# trans <- readRDS("data/allreports.Rds")
# filers <- readRDS("data/commcand.Rds") 
# saveRDS(commcand, "data/commcand.Rds")
# filers <- commcand

# head_reports <- head(trans, 10000)
# head_reports <- droplevels(head_reports)
# saveRDS(head_reports, "data/head_reports.Rds")
# trans <- readRDS("data/head_reports.Rds")

# -- handle parsing errors in trans file (errors in filers file solved in get_data() function)
# trans <- allreports
# err_trans <- readr::problems(trans)
# eti <- err_trans[err_trans$expected == "30 columns", 1]   # index of errors that
# pruned_trans <- trans[unlist(eti), ]                      # result in shifted columns.
# saveRDS(pruned_trans, "data/pruned_trans.Rds")            # prune these errors from dataset
# trans <- trans[-unlist(eti), ]
# saveRDS(trans, "data/trans.Rds")

# trans <- readRDS("data/trans.Rds")
trans <- readRDS("data/s.trans.Rds")
filers <- readRDS("data/filers.Rds") 
flaggedA <- readRDS("data/flaggedA.Rds")

## remove bad characters
# trans$CORP_30 <- stringr::str_replace(trans$CORP_30, "[:punct:]", "-")
##

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

t <- function() {
  x <- read.fwf(file = "data/data_docs/EFSRECB.TXT",
                skip = 12,
                widths = (c(21,20,24)))
  x <- sapply(x, trimws)
  x <- x[1:30,]
  # View(x)
  x
}
trans_cols <- t()

names(trans) <- trans_cols[ ,1]
names(filers) <- filer_cols[ ,1]

# -- subset transaction data for easier handling
# s.trans <- subset(trans, E_YEAR %in% c("2008", "2010", "2012", "2014"))
# saveRDS(s.trans, "data/s.trans.Rds")
# s.trans1000 <- head(trans, 1000)
# saveRDS(s.trans1000, "data/s.trans1000.Rds")


######## mungin

## remove multibyte non-ASCII characters
trans$CORP_30 <- iconv(trans$CORP_30, "latin1", "ASCII", sub="~")
trans$FIRST_NAME_40 <- iconv(trans$FIRST_NAME_40, "latin1", "ASCII", sub="~")
trans$MID_INIT_42 <- iconv(trans$MID_INIT_42, "latin1", "ASCII", sub="~")
trans$LAST_NAME_44 <- iconv(trans$LAST_NAME_44, "latin1", "ASCII", sub="~")

## add transaction ID
trans$tID <- rownames(trans)

##  change amount to numeric
trans$AMOUNT_70 <- as.numeric(trans$AMOUNT_70)
trans$AMOUNT2_72 <- as.numeric(trans$AMOUNT2_72)

## change to date format
trans$DATE1_10 <- lubridate::mdy(trans$DATE1_10)

## add filer name to filer ID
filers <- data.table::as.data.table(filers)
data.table::setkey(filers, FILER_ID)

trans <- data.table::as.data.table(trans)
keycols <- c("FILER_ID", "FREPORT_ID", "TRANSACTION_CODE", "E_YEAR", "T3_TRID")  
data.table::setkey(trans, FILER_ID)

trans <- merge(trans, filers, by = "FILER_ID", all.x = TRUE)
trans <- trans[, !c(33:43), with=FALSE]
order <- c("FILER_NAME", names(trans))
order <- order[-33]
data.table::setcolorder(trans, neworder = order)

########## end mungin



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

# -- for FLAGGED data
l_IN_TRANSACTION_CODE <- list_for_dropdown(flaggedA$IN_TRANSACTION_CODE)
# l_E_YEAR <- list_for_dropdown(trans$E_YEAR)


# -- for TRANSACTIONS data
l_TRANSACTION_CODE <- list_for_dropdown(trans$TRANSACTION_CODE)
l_E_YEAR <- list_for_dropdown(trans$E_YEAR)
# l_Contrib_Code_20 <- list_for_dropdown(trans$CONTRIB_CODE_20)
trans$CONTRIB_CODE_20 <- toupper(trans$CONTRIB_CODE_20)
l_Contrib_Code_20 <- c('CAN','FAM','CORP','IND','PART','COM') # NOTE: this excludes 
                                                              # many non-standard entries

# drop data table fields
t_cols <- names(trans)
t_cols <- t_cols[-c(3,6,8,10,19,20,22:31)]


