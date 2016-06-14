
filers$FILER_NAME <- iconv(filers$FILER_NAME, "latin1", "ASCII", sub="~")

i <- grepl("~", filers$FILER_NAME)
test <- filers$FILER_NAME[i]
test


trans[tID == 8144187] #ulster county
trans[tID == 2624822] #ulster county

View(allreports[8144187,]) #ulster county

trans.s.year[trans.s.year$tID == 8144187,] #ulster county


subTrans[tID == "8144187"] #ulster county 8144187 vs. 2624822
subTrans[tID == "2624822"]
View(subTrans[FILER_ID == "C22401"]) #ulster county















table(subTrans$E_YEAR)
