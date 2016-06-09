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


# saveRDS(allreports, "data/trans.Rds")
# trans.s.year <- allreports %>% filter(X4 %in% c(2008,2010,2012,2014,2016))
# saveRDS(trans.s.year, "data/trans.s.year.Rds")

# trans <- readRDS("data/trans.Rds")
trans <- readRDS("data/trans.s.year.Rds")

filers <- readRDS("data/filers.Rds") 
flaggedA <- readRDS("data/flaggedA.Rds")
flaggedB <- readRDS("data/flaggedB.Rds")

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

trans_cols <- c(trans_cols[ ,1], "tID")
names(trans) <- trans_cols

names(filers) <- filer_cols[ ,1]

# -- subset transaction data for easier handling
# s.trans <- subset(trans, E_YEAR %in% c("2008", "2010", "2012", "2014"))
# saveRDS(s.trans, "data/s.trans.Rds")
# s.trans1000 <- head(trans, 1000)
# saveRDS(s.trans1000, "data/s.trans1000.Rds")


######## munging

## add filer name to filer ID
filers <- data.table::as.data.table(filers)
data.table::setkey(filers, FILER_ID)

trans <- data.table::as.data.table(trans)
keycols <- c("FILER_ID", "FREPORT_ID", "TRANSACTION_CODE", "E_YEAR", "T3_TRID")  
data.table::setkey(trans, FILER_ID)

trans <- merge(trans, filers, by = "FILER_ID", all.x = TRUE)
trans <- trans[, !c(33:43), with=FALSE]
order <- c("tID", "FILER_NAME", names(trans))
order <- order[-c(33:34)]
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


