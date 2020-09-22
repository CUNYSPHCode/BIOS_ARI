library(textreadr)

scripts <- list.files(
    "D:\\BIOS_ARI\\session-5 statistical inference\\audio-visual materials",
    pattern = "\\.rtf$",
    full.names = TRUE,
    recursive = FALSE
)

listscripts <- lapply(scripts, function(x) {
    g <- read_rtf(x)
    indx <- grep("^[0-9]{1,2}\\.*$", g)
    unlist(lapply(split(g, Hmisc::cut2(seq_along(g), indx)), function(x)
        paste(Filter(nchar, gsub("^[0-9]{1,2}$", "", x)),
              collapse = " ")), use.names = FALSE)
})

identical(lengths(listpics), lengths(listscripts))
