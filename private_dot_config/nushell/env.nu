# Nushell Environment Config File

def-env pathvar-add [path] {
  let-env PATH = ($env.PATH | prepend ($path | path expand))
}

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str collect (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str collect (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
let-env NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

let-env LS_COLORS = (vivid generate molokai | first)
let-env FZF_BASE = "~/.fzf"
let-env FZF_DEFAULT_COMMAND = "rg --files --hidden --glob \"!.git/*\""
let-env FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT = 1
let-env VISUAL = "nvim"
let-env EDITOR = "nvim"
let-env USE_EDITOR = "nvim"

# # let-env PATH = ($env.PATH | prepend '/some/path')
# Path vars
pathvar-add [
  "~/.local/bin",
  "~/.fzf/bin"
]
