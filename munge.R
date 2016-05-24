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

# -- handle parsing errors
# err_filers <- readr::problems(filers)
# err_trans <- readr::problems(trans)
# # index of errors that result in shifted columns
# efi <- err_filers[err_filers$expected == "13 columns", 1]
# eti <- err_trans[err_trans$expected == "30 columns", 1]
# # prune these errors from datasets
# pruned_filers <- filers[unlist(efi), ]
# saveRDS(pruned_filers, "data/pruned_filers.Rds")
# saveRDS(filers, "data/filers.Rds")
# filers <- filers[-unlist(efi), ]
# pruned_trans <- trans[unlist(eti), ]
# saveRDS(pruned_trans, "data/pruned_trans.Rds")
# trans <- trans[-unlist(eti), ]
# saveRDS(trans, "data/trans.Rds")

trans <- readRDS("data/s.trans.Rds")
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


