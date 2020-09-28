outDir <- "D:\\gh\\BIOS_ARI\\06-Session-SelectionX/"
setwd(outDir)

partFolders <- Filter(function(x) nchar(x) > 1, list.dirs())

# check scripts and correct

library(textreadr)

txtscripts <- list.files(
    outDir,
    pattern = "\\.rtf$",
    full.names = TRUE,
    recursive = FALSE
)

if (rename.files) {
    fname <- basename(txtscripts)
    tonames <- paste0(
        gsub("\\.|\\s", "_", gsub("\\.[Rr][Tt][Ff]$", "", fname)),
        ".rtf"
    )
    # file.rename(txtscripts, tonames)
}

listpics <- lapply(partFolders, list.files, full.names = TRUE,
    pattern = "\\.[Pp][Nn][Gg]")

## rename slide pictures using 2 digit numbers
lapply(partFolders, function(fold) {
    lecfiles <- list.files(fold, pattern = "\\.[Pp][Nn][Gg]", full.names = TRUE)
    if (any(grepl("e[0-9]\\.[Pp][Nn][Gg]", lecfiles)))
        file.rename(
            from = lecfiles,
            to = gsub("Slide([0-9]).PNG", "Slide0\\1.PNG", lecfiles)
        )
})

## test to see if reading of RTF files is okay
scripts <- lapply(txtscripts, function(x) {
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

    movNames <- file.path(outputDir, paste0(basename(imgFolders), ".mp4"))

    mapply(function(imgs, scripts, movs) {
        ari::ari_spin(imgs, paragraphs = scripts, output = movs, subtitles = TRUE)
    }, limages, lparas, movNames)
}

## partFolders - image folders
## scripts - RTF script files
## outDir - output directory
MakeVideos(partFolders, txtscripts, outDir)
