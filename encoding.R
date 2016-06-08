# ecoding problem

x <- head(trans$CORP_30, 10000)

i <- grepl("BLACKBIRD", trans$CORP_30)
test <- trans$CORP_30[i]
write.csv(test[2:4], "data/temp.csv")
readr::guess_encoding("data/temp.csv")

stringi::stri_trans_general(test, "latin-ascii")
stringi::stri_trans_general(test, "Any-latin")

# this is solution
iconv(test, "latin1", "ASCII", sub="~")

x <- head(trans)
trans$CORP_30 <- iconv(trans$CORP_30, "latin1", "ASCII", sub="~")
trans$FIRST_NAME_40 <- iconv(trans$FIRST_NAME_40, "latin1", "ASCII", sub="~")
trans$MID_INIT_42 <- iconv(trans$MID_INIT_42, "latin1", "ASCII", sub="~")
trans$LAST_NAME_44 <- iconv(trans$LAST_NAME_44, "latin1", "ASCII", sub="~")


trans$CORP_30
trans$FIRST_NAME_40
trans$MID_INIT_42
trans$LAST_NAME_44

## remove multibyte non-ASCII characters
trans$CORP_30 <- iconv(trans$CORP_30, "latin1", "ASCII", sub="~")
trans$FIRST_NAME_40 <- iconv(trans$FIRST_NAME_40, "latin1", "ASCII", sub="~")
trans$MID_INIT_42 <- iconv(trans$MID_INIT_42, "latin1", "ASCII", sub="~")
trans$LAST_NAME_44 <- iconv(trans$LAST_NAME_44, "latin1", "ASCII", sub="~")
