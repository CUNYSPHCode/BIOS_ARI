partFolders <- Filter(function(x) nchar(x) > 1, list.dirs())

txtscripts <- list.files(pattern = ".txt")

outDir <- "~/Documents/BIOS_ARI/02-Session-Reg-Coeff"

listpics <- lapply(partFolders, list.files, full.names = TRUE)

.checkMatchLinesPics <- function(script, imageFolder, pat = "\\.[Pp][Nn][Gg]") {
    lines <- Filter(nchar, readLines(script))
    imgs <- list.files(imageFolder, pattern = pat, full.names = TRUE)
    message("Checking ", script, " and ", imageFolder)
    stopifnot(identical(length(lines), length(imgs)))
    TRUE
}




MakeVideos <- function(imgFolders, scripts, outputDir) {

    stopifnot(all(mapply(.checkMatchLinesPics, scripts, imgFolders)))
    lparas <- lapply(scripts, function(x) Filter(nchar, readLines(x)))
    lnslides <- lapply(lparas, seq_along)
    limages <- lapply(imgFolders, function(x) {
        list.files(x, pattern = "\\.[Pp][Nn][Gg]", full.names = TRUE)
    })
    dirNames <- vapply(strsplit(scripts, "\\."), `[`, character(1L), 1L)
    dirs <- file.path(outputDir, dirNames)
    lapply(dirs, function(d) { if (!dir.exists(d)) dir.create(d) })
    movNames <- file.path(dirs, paste0(dirNames, ".mp4"))

    mapply(function(imgs, scripts, movs) {
        ari::ari_spin(imgs, paragraphs = scripts, output = movs, subtitles = TRUE)
    }, limages, lparas, movNames)
}

MakeVideos(partFolders, txtscripts, outDir)


cdir <- "E:/Windows/Documents/Courses/BIOS620_F20/02-Session-Reg-Coeff"
setwd(cdir)

ari::ari_narrate(
    script = "LBM_MLR_P2.Rmd",
    slides = "LBM_MLR_P2.html",
    output = "BM_2_script/BM_2_script.mp4",
    voice = "Joanna",
    capture_method = "iterative",
    subtitles = TRUE
)

images <- file.path(cdir, paste0("LBM_MLR_snap", c(paste0("0", 1:9), 10:18), ".png"))

# file.rename(from = paste0("LBM_MLR_snap", 1:9, ".png"), to = paste0("LBM_MLR_snap0", 1:9, ".png"))

for (i in 1:18) {
    webshot::webshot(url =
    paste0("file:///E:/Windows/Documents/Courses/BIOS620_F20/02-Session-Reg-Coeff/LBM_MLR_P2.html#", i),
    file = images[i], delay = 1, debug = TRUE)
}
paras <- Filter(nchar, readLines("BM_2_script.txt"))

ari::ari_spin(
    images = images,
    paragraphs = paras,
    output = "BM_2_script/BM_2_script.mp4",
    voice = "Joanna",
    subtitles = TRUE
)


ari::ari_narrate(
    script = "LBM_MLR_P2.Rmd",
    slides = "LBM_MLR_P2.html",
    output = "BM_2_script/BM_2_script.mp4",
    voice = "Joanna",
    capture_method = "iterative",
    delay = 1,
    subtitles = TRUE
)
ari::ari_narrate(
    script = "LBM_MLR_P3.Rmd",
    slides = "LBM_MLR_P3.html",
    output = "BM_3_script/BM_3_script.mp4",
    voice = "Joanna",
    capture_method = "iterative",
    delay = 1,
    subtitles = TRUE
)
