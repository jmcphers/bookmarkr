# Environment to hold the current collection of bookmarks
.bookmarks <- new.env(parent = emptyenv())

addBookmark <- function() {
  # Determine the current line of code
  ctx <- rstudioapi::getActiveDocumentContext()

  if (is.null(ctx) ||
      is.null(ctx$path) ||
      identical(ctx$path, "")) {
    # No active document; take no action
    return(NULL)
  }

  # Extract the current line from the selection
  line <- ctx$selection[[1]]$range$start[[1]]

  # Get a note from the user
  note <- rstudioapi::showPrompt("Add Note", "Enter a note for this line:")
  if (is.null(note) || identical(note, "")) {
    # No note entered, abort
    return(NULL)
  }

  # If we have no bookmarks in our collection, load our collection of bookmarks
  # from disk
  if (length(.bookmarks) == 0) {
    load_config()
  }

  # Add this bookmark to our collection
  assign(paste0(basename(ctx$path), "_", line),
    list(
      type = "info",
      file = ctx$path,
      line = line,
      column = 1,
      message = note
    ),
    envir = .bookmarks)

  # Save the bookmark settings to disk
  save_config()

  # Create the source marker
  rstudioapi::sourceMarkers("BookmarkR",
    lapply(ls(.bookmarks),
           function(name) { get(name, envir = .bookmarks) }))
}
