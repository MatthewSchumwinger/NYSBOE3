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
# err_trans <- readr::problems(trans)
# eti <- err_trans[err_trans$expected == "30 columns", 1]   # index of errors that
# pruned_trans <- trans[unlist(eti), ]                      # result in shifted columns.
# saveRDS(pruned_trans, "data/pruned_trans.Rds")            # prune these errors from dataset
# trans <- trans[-unlist(eti), ]
# saveRDS(trans, "data/trans.Rds")

trans <- readRDS("data/s.trans.Rds")
# trans <- readRDS("data/s.trans1000.Rds")
filers <- readRDS("data/filers.Rds") 

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

# -- for TRANSACTIONS data
l_Contrib_Code_20 <- list_for_dropdown(trans$CONTRIB_CODE_20)
l_TRANSACTION_CODE <- list_for_dropdown(trans$TRANSACTION_CODE)
l_E_YEAR <- list_for_dropdown(trans$E_YEAR)

# data table fields
# cols <- c("INCIDENT_N", "ADDRESS", "group", "OFFENSE1", "OFFENSE2", 
#           # "OFFENSE3","OFFENSE4", "OFFENSE5", 
#           "datetime", "score") 

# cols <- names(allreports)


