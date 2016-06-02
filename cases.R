
source("global.R") # make sure global.R is set to pick up the full file trans.Rds
library(stringr)
library(data.table)
library(stringr)
library(lubridate)

## criteria
# 1 The recipient is a county committee or party committee;
# 2 The contribution amounted to at least two times the average annual amount of contributions received by the recipient county committee in the five years prior to the contribution;
# 3 The contributor had given to the recipient committee no more than twice in the past; and
# 4 No more than one month after receiving the contribution(s), the county committee transferred a similar amount of money directly to a candidate's campaign (i.e.not independent expenditures).

filers <- data.table(filers, key = "FILER_ID")
trans <- data.table(trans, key = "FILER_ID")
# drop bad dates
trans <- trans[DATE1_10 >= lubridate::ymd(19990101) 
                 & DATE1_10 < lubridate::ymd(20170101) ,]

# ----- helpers -----
ante5yrs <- function(date) {
  date - lubridate::years(5)
}
inCodes <- c("A","B","C","D","E","G")  # incoming contribution codes

# ---- criterion #1 ----
# create table of just county or party committees
cmtes <- subset(filers, FILER_TYPE == "COMMITTEE" 
                  & !COMMITTEE_TYPE %in% c("1", "2", "9", "9B", "9U"))
table(cmtes$COMMITTEE_TYPE)
# subset transactions matching just filers in committees table
trans1 <- trans[cmtes]
trans1 <- trans1[, c(1:31), with=FALSE]

# ---- criterion #2 ----

# subet trans by only incoming contribution codes
trans2 <- trans1 %>% filter(TRANSACTION_CODE %in% inCodes)

# ---- criterion #3 ----
# one-off name fix
trans2[FILER_NAME == "*PHELPS DEMOCRATIC COMMITTEE", FILER_NAME := "PHELPS DEMOCRATIC COMMITTEE"]

# create "oppositeParty" field
# TODO: condition this on time before contribution like in criterion 2
trans3 <- trans2 %>%
  mutate(opp_party = paste(CORP_30, FIRST_NAME_40, MID_INIT_42, LAST_NAME_44)) 
count_by_opp_part <- trans3 %>%
  group_by(FILER_NAME, opp_party) %>% 
  summarise(tot_from_opp_party = n())
trans3 <- left_join(trans3, count_by_opp_part, by = c("FILER_NAME", "opp_party")) #TODO: work on warning message
trans3 <- trans3 %>% mutate(reg_opp_party = tot_from_opp_party > 3)
# table(trans3$reg_opp_party)  


# ---- criterion #2 (cont.) ----

# ---- TODO: convert to lapply and move back before criterion 3
add5yrAvg <- function(dt){
  start <- Sys.time()
  for (i in 1:nrow(dt)) {
    filer <- dt$FILER_NAME[i]
    date <- dt$DATE1_10[i]
    yrs5 <- interval(ante5yrs(date), date)
    
    # append preceding 5-yr contribution average by filer
    tt <- subset(dt, DATE1_10 %within% yrs5 & FILER_NAME == filer, select = AMOUNT_70)
    avg <- mean(tt$AMOUNT_70)
    dt$pre5yrAvg[i] <- avg
    # is AMOUNT 2x more than that year's average?
    dt$bigTrans[i] <- dt$AMOUNT_70[i] > 2*avg
  }
  end <- Sys.time()
  print(end - start)
  dt
}

trans3F <- trans3 %>% filter(!reg_opp_party)
trans3F2 <- add5yrAvg(trans3F)
test <- trans3F2 %>% filter(bigTrans)









# ---- Promise PAC case -----
# PROMISE PAC FILER_ID A84336, 2
promise_pac <- "A84336"
# NEW YORK STATE DEMOCRATIC COMMITTEE FILER_ID A00188, 5H
nysdc <- "A00188"
# FRIENDS OF BOB DOUGHERTY, C84790, 1
# C84392	HELEN HUDSON, committee type " "
# C84391	FRIENDS OF HELEN HUDSON, 1
# C32113	MARTIN D. MASTERPOLE, committee type " "
# C84288	MARTIN D. MASTERPOLE, committee type " "

# str_subset(trans$FILER_ID, promise_pac)
promsise_trans <- subset(trans, FILER_ID == promise_pac)
nysdc_trans <- subset(trans, FILER_ID == nysdc)

# 30K transfer from PROMISE PAC to NYSDC is TRANS ID 5866
View(subset(promsise_trans, T3_TRID == "5866"))
View(subset(nysdc_trans, T3_TRID == "5866")) # wrong transaction
View(subset(nysdc_trans, AMOUNT_70 == "30000"))

View(subset(nysdc_trans, CHECK_NO_60 == "1030")) # same check No. within 7 days?



# ---- Bloomberg case ----
bloomberg05FID <- "C20810"
bloomberg05_trans <- subset(trans, FILER_ID == bloomberg05FID)
bloomberg09FID <- "C43295"
bloomberg09_trans <- subset(trans, FILER_ID == bloomberg09FID)

nyssrcc <- "A00193"
nyssrcc_trans <- subset(trans, FILER_ID == nyssrcc)

oconnel <- "A29301" # note there are 7 other filers related to her
oconnel_trans <- subset(trans, FILER_ID == oconnel)


# --- old code


## using lapply
# test2 <- lapply(trans2, function(dt){
#   start <- Sys.time()
#   for (i in 1:nrow(dt)) {
#     filer <- dt$FILER_NAME[i]
#     date <- dt$DATE1_10[i]
#     yrs5 <- interval(ante5yrs(date), date)
#     
#     # append preceding 5-yr contribution average by filer
#     tt <- subset(dt, DATE1_10 %within% yrs5 & FILER_NAME == filer, select = AMOUNT_70)
#     avg <- mean(tt$AMOUNT_70)
#     dt$pre5yrAvg[i] <- avg
#     # is AMOUNT 2x more than that year's average?
#     dt$bigTrans[i] <- dt$AMOUNT_70[i] > 2*avg
#   }
#   end <- Sys.time()
#   print(end - start)
#   dt
# })


# # calculate avg by calander year for each entitiy
# trans2 <- trans1 %>% mutate(t_year = year(DATE1_10))
# 
# avg_by_filer_year <- trans2 %>% 
#   group_by(FILER_NAME, t_year) %>%
#   summarise(average = mean(AMOUNT_70))
# 
# # append average by filer by year amount
# trans2 <- left_join(trans2, avg_by_filer_year, by = c("FILER_NAME", "t_year"))
# 
# # is AMOUNT 2x more than that year's average?
# trans2 <- trans2 %>% mutate(big1yr = AMOUNT_70 > 2*average)
