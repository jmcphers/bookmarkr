# Compute the path to the configuration file
config_file <- function() {
  home <- Sys.getenv("HOME", unset="~")

  # See if there's an XDG config home set
  config_home <- Sys.getenv("XDG_CONFIG_HOME")
  if (identical(config_home, "")) {
    # No explicit config home set, infer one based on OS
    sys_name <- Sys.info()[['sysname']]
    config_home <- if (identical(sys_name, "Windows")) {
      Sys.getenv("APPDATA")
    } else {
      file.path(home, ".config")
    }
  }

  file.path(config_home, "boormarkr", "bookmarks.Rdata")
}

# Save the current configuration to disk
save_config <- function() {
  # Compute path to config file
  config_path <- config_file()

  if (!file.exists(dirname(config_path))) {
    # Create the config folder if we need to
    dir.create(dirname(config_path), recursive = TRUE)
  }

  # Save the configuration to the file
  save(list = ls(.bookmarks),
       file = config_file(),
       envir = .bookmarks)
}

# Load the configuration from disk (if it exists)
load_config <- function() {
  config_path <- config_file()
  if (file.exists(config_path)) {
    load(file = config_path, envir = .bookmarks)
  }
}
