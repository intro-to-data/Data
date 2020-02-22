## This is unfinished.

## INIT ========================================================================
library(DBI)
library(feather)
library(RSQLite)
library(tidyverse)

## DATA ========================================================================
con <- dbConnect(RSQLite::SQLite(), dbname="~/Data/chinook.db")

tbls <- dbListTables(con)
## http://schemaspy.org/sample/relationships.html



extract_to_feather <- function(tbl_to_get){
    ## Extract the data, save to feather.
    ## Get it DONE!!!!
    Tmp <- dbReadTable(con, tbl_to_get)
    feather_path <- paste0("Chinook/",tbl_to_get,".feather")
    write_feather(x = Tmp, path = feather_path)

    ## Simple return stuffs.
    if (file.exists(feather_path)) {
        return(1)
    } else{
        return(0)
    }
}

sapply(tbls, extract_to_feather)
