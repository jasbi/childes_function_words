literature_file <- "dashboard/literature.yaml"

if (file.exists(literature_file)) {
  raw_lit <- yaml::yaml.load_file(literature_file)

  format_citation <- function(entry) {
    authors <- paste(entry$authors, collapse = ", ")
    sprintf(
      "%s (%s). %s. %s.",
      authors,
      entry$year,
      entry$description,
      entry$publication
    )
  }

  # Normalize entries: handle either top-level or nested under a key like 'example'
  entries <- lapply(raw_lit, function(e) {
    if (!is.null(e$focus_function_words)) e else e[[1]]
  })

  function_word_lit <- setNames(lapply(function_words, function(w) {
    matches <- Filter(function(e) w %in% e$focus_function_words, entries)
    if (length(matches) == 0) {
      ""
    } else {
      citations <- vapply(matches, format_citation, FUN.VALUE = character(1))
      paste(citations, collapse = "<br><br>")
    }
  }), function_words)
} else {
  warning("Literature YAML file not found at ", literature_file, ". Using empty summaries.")
  function_word_lit <- setNames(as.list(rep("", length(function_words))), function_words)
}

