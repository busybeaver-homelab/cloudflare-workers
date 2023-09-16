set shell := ["bash", "-uc"]

additional_tools := "bun"

# lists all available commands
@default:
  just --list

alias init := initialize
alias fmt := format
alias cm := commit

# internal helper command to easier run commands from the shared justfile
_run_shared cmd *args:
  @just -f {{justfile_directory()}}/.github/justfile.shared -d {{justfile_directory()}} {{cmd}} {{args}}

# install all required tooling for development (osx only)
install:
  if [[ "{{os()}}" != "macos" ]]; then
    echo "This command currently only works on macOS. On other systems, please install the following tools manually: {{default_tools}} {{additional_tools}}"
    exit -1
  fi

  brew tap oven-sh/bun
  @just _run_shared install {{additional_tools}}

# uninstall all required tooling for development (osx only)
uninstall:
  @just _run_shared uninstall {{additional_tools}}
  brew untap oven-sh/bun

# initializes the tooling for working with this repository
initialize:
  @just _run_shared initialize

# formats files according to the used standards and rules; if the optional files parameter is provided, only the specified files are formatted; else all files are formatted
format *files:
  @just _run_shared format {{files}}

# checks if the files comply to the used standards and rules; if the optional files parameter is provided, only the specified files are checked; else all files are checked
check *files:
  @just _run_shared check {{files}}

# assisted conventional commits with git
commit *args:
  @just _run_shared commit {{args}}

# runs the CI workflows locally; the optional args parameter allows to add additional optional arguments
ci *args:
  @just _run_shared ci {{args}}
