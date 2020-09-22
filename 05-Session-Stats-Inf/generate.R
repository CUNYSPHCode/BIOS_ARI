outDir <- "D:\\gh\\BIOS_ARI\\05-Session-Stats-Inf"
setwd(outDir)

partFolders <- Filter(function(x) nchar(x) > 1, list.dirs())

txtscripts <- list.files(pattern = ".txt", recursive = TRUE)

listpics <- lapply(partFolders, list.files, full.names = TRUE,
    pattern = "\\.[Pp][Nn][Gg]")

lapply(partFolders, function(fold) {
    lecfiles <- list.files(fold, pattern = "\\.[Pp][Nn][Gg]", full.names = TRUE)
    if (any(grepl("e[0-9]\\.[Pp][Nn][Gg]", lecfiles)))
        file.rename(
            from = lecfiles,
            to = gsub("Slide([0-9]).PNG", "Slide0\\1.PNG", lecfiles)
        )
})

# check scripts and correct

library(textreadr)

txtscripts <- list.files(
    "D:\\BIOS_ARI\\session-5 statistical inference\\audio-visual materials",
    pattern = "\\.rtf$",
    full.names = TRUE,
    recursive = FALSE
)
fname <- basename(txtscripts)
tonames <- paste0(
    gsub("\\.|\\s", "_", gsub("\\.[Rr][Tt][Ff]$", "", fname)),
    ".rtf"
)
file.rename(txtscripts, tonames)

txtscripts <- tonames

    lapply(txtscripts[[1]], function(x) {
        g <- read_rtf(x)
        indx <- grep("^[0-9]{1,2}\\.*$", g)
        unlist(lapply(split(g, Hmisc::cut2(seq_along(g), indx)), function(x)
            paste(Filter(nchar, gsub("^[0-9]{1,2}$", "", x)),
                  collapse = " ")), use.names = FALSE)
    })

MakeVideos <- function(imgFolders, scripts, outputDir) {

    lparas <- lapply(scripts, function(x) {
        g <- read_rtf(x)
        indx <- grep("^[0-9]{1,2}\\.*$", g)
        unlist(lapply(split(g, Hmisc::cut2(seq_along(g), indx)), function(x)
            paste(Filter(nchar, gsub("^[0-9]{1,2}$", "", x)),
                  collapse = " ")), use.names = FALSE)
    })

    lnslides <- lapply(lparas, seq_along)
    limages <- lapply(imgFolders, function(x) {
        list.files(x, pattern = "\\.[Pp][Nn][Gg]", full.names = TRUE)
    })
    stopifnot(identical(lengths(limages), lengths(lparas)))

    dirNames <- vapply(strsplit(scripts, "\\."), `[`, character(1L), 1L)
    movNames <- file.path(outputDir, paste0(dirNames, ".mp4"))

    mapply(function(imgs, scripts, movs) {
        ari::ari_spin(imgs, paragraphs = scripts, output = movs, subtitles = TRUE)
    }, limages, lparas, movNames)
}

MakeVideos(partFolders, txtscripts, outDir)
