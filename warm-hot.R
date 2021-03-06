## for the warm/hot method

# create table of just county or party committees
cmtes <- subset(filers, FILER_TYPE == "COMMITTEE" 
                & COMMITTEE_TYPE %in% c("3","3H", "6", "6H"))
table(cmtes$COMMITTEE_TYPE)
# subset transactions matching just filers in committees table
trans1 <- trans[cmtes] 
# prune "empty" rows added from join
trans1 <- filter(trans1, !is.na(FILER_NAME))
trans1 <- trans1[, c(1:32), with=FALSE]
outCodes <- c("F", "H")  # outgoing contribution codes


# --- parameters ----
targetID <- "4670170"      # ID of target "warm" transaction
amount_range <- .2   # +/- range of amount
date_range <- 30      # range of days
# --- ----------- ----

warmID <- trans %>% filter(tID == targetID) %>% select(FILER_ID)
max <- trans %>% filter(tID == targetID) %>% select(AMOUNT_70) * (1+amount_range)
min <- trans %>% filter(tID == targetID) %>% select(AMOUNT_70) * (1-amount_range)
start <- trans %>% filter(tID == targetID) %>% select(DATE1_10)
end <- trans %>% filter(tID == targetID) %>% select(DATE1_10) + days(30)
int <- interval(start[[1]], end[[1]])

hot <- trans %>% filter(
  FILER_ID == warmID[[1]] &
  TRANSACTION_CODE %in% outCodes &
  DATE1_10 %within% int &
    AMOUNT_70 <= max[[1]] &
    AMOUNT_70 >= min[[1]] )
