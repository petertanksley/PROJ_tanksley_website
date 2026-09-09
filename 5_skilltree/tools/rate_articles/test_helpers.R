# Round-trip test for helpers.R: apply judgement fields to a copy of articles.yml, write, re-read, compare.
suppressPackageStartupMessages(library(here))
source(here("5_skilltree", "tools", "rate_articles", "helpers.R"))
d <- read_articles(here("5_skilltree", "data", "articles.yml"))
e <- d$entries[[1]]
j <- list(areas = list(biosocial = 0, criminology = 1, responders = 3),
          contribution = list(conceptualization = 3, data = 3, analysis = 3, methods = 2, writing = 3, supervision = 1),
          role = "lead", featured = TRUE, effort = 4, effort_note = "Two years of NOMS wrangling.",
          blurb = "The first population-wide look.", builds_on = d$entries[[8]]$id)
new <- apply_judgement(e, j)
tmp <- tempfile(fileext = ".yml")
ents <- d$entries; ents[[1]] <- new
write_articles(tmp, d$header, ents)
back <- read_yaml(tmp)
stopifnot(identical(names(back[[1]]), names(e)),                       # field order preserved
          identical(back[[1]]$title, e$title), identical(back[[1]]$doi, e$doi),
          identical(unlist(back[[1]]$areas), c(biosocial = 0L, criminology = 1L, responders = 3L)),
          identical(back[[1]]$contribution$methods, 2L), identical(back[[1]]$effort, 4L),
          identical(back[[1]]$blurb, "The first population-wide look."),
          identical(unlist(back[[1]]$builds_on), d$entries[[8]]$id),
          isTRUE(all(completeness(back[[1]]))),
          # clearing fields keeps the keys with null values
          { blank <- apply_judgement(e, list(role = "lead", featured = TRUE)); wb <- tempfile(fileext = ".yml")
            write_articles(wb, d$header, list(blank)); rb <- read_yaml(wb)[[1]]
            is.null(rb$effort) && "effort" %in% names(rb) && "blurb" %in% names(rb) && !any(completeness(rb)) },
          identical(back[[1]]$featured, TRUE))
cat("helpers round-trip OK; header lines kept:", length(d$header), "\n")
