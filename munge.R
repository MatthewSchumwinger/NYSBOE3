## script to process/parse data and save for load with global.R



## search on filer ID











## fix Contrib_Code_20 
# trans$CONTRIB_CODE_20 <- toupper(trans$CONTRIB_CODE_20)
# y <- table(trans$CONTRIB_CODE_20)
# y <- y[!names(y) %in% c('CAN','FAM','CORP','IND','PART','COM')]
# y <- rep("other", length(y))
# c('CAN','FAM','CORP','IND','PART','COM', y)

## prune mostly interest payments
# trans$AMOUNT_70 <- as.numeric(trans$AMOUNT_70)
# tt <- subset(trans, AMOUNT_70 > 0 & AMOUNT_70 < 2.5)

## prune interest  divident payments
# tt <- subset(trans, OTHER_RECPT_CODE_90 == "INT" | OTHER_RECPT_CODE_90 == "INT/DIV")

