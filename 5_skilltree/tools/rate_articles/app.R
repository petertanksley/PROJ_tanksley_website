# Rating app — work through 5_skilltree/data/articles.yml quickly: areas, role, contribution, effort, blurb,
# lineage. Auto-saves every change straight back to the YAML (judgement fields only; the
# bibliographic fields stay exactly as the extractor wrote them).
#
# Run from the site repo root:  Rscript -e 'shiny::runApp("5_skilltree/tools/rate_articles", launch.browser = TRUE)'
# Rebuild the tree after:       Rscript 5_skilltree/R/build_tree.R   (or press the button in the app)

suppressPackageStartupMessages({ library(shiny); library(bslib); library(here) })
source("helpers.R", local = TRUE)          # runApp() sets the working directory to this folder

yml_path <- here("5_skilltree", "data", "articles.yml")
if (!file.exists(yml_path)) stop("No 5_skilltree/data/articles.yml — run Rscript 5_skilltree/R/extract_cv.R first")

radio03 <- function(id, label, value = NULL, choices = 0:3) {
  radioButtons(id, label, choices = setNames(as.character(choices), choices), inline = TRUE,
               selected = if (is.null(value)) character(0) else as.character(value))
}

ui <- page_sidebar(
  title = "Skill tree · article ratings",
  theme = bs_theme(version = 5, bg = "#1C1B22", fg = "#FBFAF7", primary = "#3FBDB6", secondary = "#A47FE0",
                   base_font = font_google("Public Sans"), heading_font = font_google("Cormorant Garamond"), font_scale = 0.95),
  sidebar = sidebar(width = 340,
    uiOutput("progress"),
    selectInput("current", NULL, choices = NULL, size = 22, selectize = FALSE),
    div(class = "d-flex gap-2",
        actionButton("prev", "← Prev", class = "btn-secondary btn-sm flex-fill"),
        actionButton("nxt",  "Next →", class = "btn-secondary btn-sm flex-fill")),
    hr(),
    actionButton("rebuild", "Rebuild tree.json", class = "btn-outline-primary btn-sm w-100"),
    verbatimTextOutput("rebuild_out", placeholder = FALSE),
    div(class = "small text-secondary mt-2", textOutput("saved", inline = TRUE))
  ),
  div(style = "max-width: 1100px", uiOutput("article"))
)

server <- function(input, output, session) {
  st <- reactiveValues(header = NULL, entries = NULL, idx = 1L, saved = "")
  d <- read_articles(yml_path); st$header <- d$header; st$entries <- d$entries

  ids     <- reactive(vapply(st$entries, `[[`, "", "id"))
  choices <- reactive({
    e <- st$entries
    marks <- vapply(e, function(x) { c <- completeness(x); if (all(c)) "✓" else if (any(c)) "◐" else "○" }, "")
    setNames(ids(), sprintf("%s %s · %s", marks, vapply(e, function(x) x$year, 1L), vapply(e, function(x) short_title(x$title, 44), "")))
  })
  observe({ updateSelectInput(session, "current", choices = choices(), selected = ids()[st$idx]) })
  observeEvent(input$current, { i <- match(input$current, ids()); if (!is.na(i) && i != st$idx) st$idx <- i })
  observeEvent(input$prev, { st$idx <- max(1L, st$idx - 1L) })
  observeEvent(input$nxt,  { st$idx <- min(length(st$entries), st$idx + 1L) })

  output$progress <- renderUI({
    comp <- vapply(st$entries, function(x) all(completeness(x)), TRUE)
    tagList(div(class = "small", sprintf("%d of %d complete", sum(comp), length(comp))),
            div(class = "progress mb-2", style = "height:6px",
                div(class = "progress-bar", role = "progressbar", style = sprintf("width:%.0f%%", 100 * mean(comp)))))
  })

  output$article <- renderUI({
    e <- st$entries[[st$idx]]; isolate({
    authors <- lapply(e$authors, function(a) if (grepl("Tanksley", a)) tags$b(a) else a)
    authors <- do.call(tagList, Reduce(function(acc, x) c(acc, list(", "), list(x)), authors[-1], list(authors[[1]])))
    link <- if (!is.null(e$doi)) paste0("https://doi.org/", e$doi) else e$url
    others <- setdiff(ids(), e$id)
    other_labels <- vapply(st$entries[match(others, ids())], function(x) sprintf("%s · %s", x$year, short_title(x$title, 70)), "")
    tagList(
      card(fill = FALSE, class = "mb-3",
        card_header(class = "d-flex justify-content-between",
                    span(sprintf("%s · CV #%s · %s", e$year, e$cv_number %||% "preprint", e$status)),
                    span(sprintf("%d / %d", st$idx, length(st$entries)))),
        card_body(
          h3(if (!is.null(link)) a(e$title, href = link, target = "_blank") else e$title),
          p(class = "text-secondary mb-1", em(e$venue), if (!is.null(e$citation)) paste0(" · ", e$citation)),
          p(class = "small", authors, if (isTRUE(e$authors_n > 0)) sprintf(" (author %s of %s)", e$author_position, e$authors_n)
                                      else sprintf(" (author %s, et al.)", e$author_position)))),
      layout_columns(fill = FALSE, col_widths = c(6, 6),
        card(fill = FALSE, card_header("Areas · 0–3 each · sets the direction from the origin"),
             card_body(radio03("a_biosocial",   "Biosocial",        e$areas$biosocial),
                       radio03("a_criminology", "Criminology",      e$areas$criminology),
                       radio03("a_responders",  "First responders", e$areas$responders))),
        card(fill = FALSE, card_header("Role and tier"),
             card_body(radioButtons("role", "Role", choices = setNames(names(ROLES), ROLES), selected = e$role, inline = TRUE),
                       checkboxInput("featured", "Featured (unchecked = muted tier, visual only)", value = isTRUE(e$featured)),
                       radioButtons("effort", "Effort, whole project", choices = setNames(names(EFFORT), EFFORT),
                                    selected = if (is.null(e$effort)) character(0) else as.character(e$effort)),
                       textInput("effort_note", "Effort note (one sentence)", value = e$effort_note %||% "", width = "100%")))),
      card(fill = FALSE, class = "mt-3", card_header("Contribution · collapsed CRediT · 0 = none, 3 = mine"),
           card_body(layout_columns(fill = FALSE, col_widths = c(6, 6),
             tagList(radio03("c_conceptualization", CREDIT[["conceptualization"]], e$contribution$conceptualization),
                     radio03("c_data",     CREDIT[["data"]],     e$contribution$data),
                     radio03("c_analysis", CREDIT[["analysis"]], e$contribution$analysis)),
             tagList(radio03("c_methods",     CREDIT[["methods"]],     e$contribution$methods),
                     radio03("c_writing",     CREDIT[["writing"]],     e$contribution$writing),
                     radio03("c_supervision", CREDIT[["supervision"]], e$contribution$supervision))))),
      card(fill = FALSE, class = "mt-3", card_header("Blurb and lineage"),
           card_body(textAreaInput("blurb", "Blurb, site voice, one or two sentences", value = e$blurb %||% "", rows = 3, width = "100%"),
                     selectizeInput("builds_on", "Builds on (earlier articles this one grows from)", multiple = TRUE, width = "100%",
                                    choices = setNames(others, other_labels), selected = unlist(e$builds_on),
                                    options = list(placeholder = "type to search titles")))),
      div(class = "d-flex gap-2 mt-3 mb-4",
          actionButton("save_next", "Save & next →", class = "btn-primary"),
          span(class = "text-secondary small align-self-center", "Every change is saved automatically; this just moves on."))
    )})
  })

  collect <- function() list(
    areas = list(biosocial = input$a_biosocial, criminology = input$a_criminology, responders = input$a_responders),
    contribution = list(conceptualization = input$c_conceptualization, data = input$c_data, analysis = input$c_analysis,
                        methods = input$c_methods, writing = input$c_writing, supervision = input$c_supervision),
    role = input$role, featured = input$featured, effort = input$effort, effort_note = input$effort_note,
    blurb = input$blurb, builds_on = input$builds_on)

  # auto-save: any judgement input changes → write the YAML (debounced so typing a blurb is one write)
  pending <- reactive({ collect() }) |> debounce(700)
  observeEvent(pending(), {
    j <- pending(); if (is.null(j$role)) return()               # UI not rendered yet
    i <- isolate(st$idx)
    new <- apply_judgement(isolate(st$entries)[[i]], j)
    if (!identical(new, isolate(st$entries)[[i]])) {
      st$entries[[i]] <- new
      write_articles(yml_path, isolate(st$header), isolate(st$entries))
      st$saved <- format(Sys.time(), "saved %H:%M:%S")
    }
  }, ignoreInit = TRUE)
  output$saved <- renderText(st$saved)
  observeEvent(input$save_next, { st$idx <- min(length(st$entries), st$idx + 1L) })

  observeEvent(input$rebuild, {
    out <- suppressWarnings(system2("Rscript", shQuote(here("5_skilltree", "R", "build_tree.R")), stdout = TRUE, stderr = TRUE))
    output$rebuild_out <- renderText(paste(grep("built under|Warning message", out, value = TRUE, invert = TRUE), collapse = "\n"))
  })
}

shinyApp(ui, server)
