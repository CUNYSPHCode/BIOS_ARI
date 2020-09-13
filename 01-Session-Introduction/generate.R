library(ari)
library(aws.polly)

## Part 1
rmarkdown::render("lecture_intro_1.Rmd")
# browseURL("lecture_intro_1.html")

ari_narrate(
  script = "lecture_intro_1_script.md",
  slides = "lecture_intro_1.html",
  output = "~/Documents/BIOS_ARI/01-Session-Introduction/Video/lecture_p1.mp4",
  voice = "Joanna",
  delay = 0.5,
  capture_method = "iterative"
)

## Part 2
rmarkdown::render("lecture_intro_p2.Rmd")
# browseURL("lecture_intro_p2.html")

ari_narrate(
  script = "lecture_intro_2_script.md",
  slides = "lecture_intro_p2.html",
  output = "~/Documents/BIOS_ARI/01-Session-Introduction/Video/lecture_p2.mp4",
  voice = "Joanna",
  delay = 1,
  capture_method = "iterative"
)

## Part 3
rmarkdown::render("lecture_intro_SLR.Rmd")

ari_narrate(
  script = "review_SLR_script.md",
  slides = "lecture_intro_SLR.html",
  output = "~/Documents/BIOS_ARI/01-Session-Introduction/Video/lecture_SLR.mp4",
  voice = "Joanna",
  delay = 1,
  capture_method = "iterative",
  subtitles = TRUE
)

paras <- Filter(nchar, readLines("review_SLR_script.txt"))
nslides <- seq_along(paras)
outvideo <- "~/Documents/BIOS_ARI/01-Session-Introduction/Video/lecture_SLR.mp4"
imgs <- paste0("lecture_intro_SLR_s", nslides, ".png")
for (i in nslides) {
    webshot::webshot(
        paste0("file://localhost/",
            normalizePath("lecture_intro_SLR.html"), "#", i
        ),
        file = imgs[i],
        delay = 1,
        debug = TRUE
    )
}

ari_spin(images = imgs, paragraphs = paras, output = outvideo, subtitles = TRUE)
