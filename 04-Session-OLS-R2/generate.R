outDir <- "D:\\gh\\BIOS_ARI\\04-Session-OLS-R2\\"
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

.checkMatchLinesPics <- function(script, imageFolder, pat = "\\.[Pp][Nn][Gg]")
{
    lines <- Filter(nchar, readLines(script))
    imgs <- list.files(imageFolder, pattern = pat, full.names = TRUE)
    message("Checking ", script, " and ", imageFolder)
    if (!identical(length(lines), length(imgs)))
        c(length(lines), length(imgs))
    else
        TRUE
}

Map(.checkMatchLinesPics, txtscripts, partFolders)


MakeVideos <- function(imgFolders, scripts, outputDir) {

    stopifnot(all(mapply(.checkMatchLinesPics, scripts, imgFolders)))
    lparas <- lapply(scripts, function(x) Filter(nchar, readLines(x)))
    lnslides <- lapply(lparas, seq_along)
    limages <- lapply(imgFolders, function(x) {
        list.files(x, pattern = "\\.[Pp][Nn][Gg]", full.names = TRUE)
    })
    dirNames <- vapply(strsplit(scripts, "\\."), `[`, character(1L), 1L)
    movNames <- file.path(outputDir, paste0(dirNames, ".mp4"))

    mapply(function(imgs, scripts, movs) {
        ari::ari_spin(imgs, paragraphs = scripts, output = movs, subtitles = TRUE)
    }, limages, lparas, movNames)
}

MakeVideos(partFolders, txtscripts, outDir)
