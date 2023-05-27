# Nushell Config File

# STARSHIP
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
source ~/.cache/starship/init.nu

def prompt-pre-cmd [] {
  if "TERM_PROGRAM" in $env and $env.TERM_PROGRAM == 'WezTerm' {
    print ([(ansi title) (char nf_folder1) "  " (pwd) " | WeZterm" (ansi reset)] | str join)
  } else if $env.TERM == 'alacritty' {
    print ([(ansi title) (char nf_folder1) "  " (pwd) " | Alacritty" (ansi reset)] | str join)
  }

  if (".node-version" | path exists) or (".nvmrc" | path  exists) {
    fnm use --silent-if-unchanged
  }
}

# Use carapce as completer
let carapace_completer = {|spans|
    carapace $spans.0 nushell $spans | from json
}

# for more information on themes see
# https://github.com/nushell/nushell/blob/main/docs/How_To_Coloring_and_Theming.md
let default_theme = {
    # color for nushell primitives
    separator: white
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr non effectively turns this off
    header: green_bold
    empty: blue
    bool: white
    int: white
    filesize: white
    duration: white
    date: white
    range: white
    float: white
    string: white
    nothing: white
    binary: white
    cellpath: white
    row_index: green_bold
    record: white
    list: white
    block: white
    hints: dark_gray

    # shapes are used to change the cli syntax highlighting
    shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b}
    shape_binary: purple_bold
    shape_bool: light_cyan
    shape_int: purple_bold
    shape_float: purple_bold
    shape_range: yellow_bold
    shape_internalcall: cyan_bold
    shape_external: cyan
    shape_externalarg: green_bold
    shape_literal: blue
    shape_operator: yellow
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_datetime: cyan_bold
    shape_list: cyan_bold
    shape_table: blue_bold
    shape_record: cyan_bold
    shape_block: blue_bold
    shape_filepath: cyan
    shape_globpattern: cyan_bold
    shape_variable: purple
    shape_flag: blue_bold
    shape_custom: green
    shape_nothing: light_cyan
}

# The default config record. This is where much of your global configuration is setup.
let-env config = {
  color_config: $default_theme
  use_grid_icons: true
  footer_mode: "25" # always, never, number_of_rows, auto
  table: {
    mode: rounded
    trim: {
      methodology: wrapping # wrapping or truncating
      wrapping_try_keep_words: true # A strategy used by the 'wrapping' methodology
      truncating_suffix: "..." # A suffix used by the 'truncating' methodology
    }
  }
  ls: {
    use_ls_colors: true
    clickable_links: true
  }
  rm: {
    always_trash: false
  }
  hooks: {
    env_change: {
      PWD:{ prompt-pre-cmd }
    }
  }
  completions: {
    case_sensitive: false # set to true to enable case-sensitive completions
    quick: false  # set this to false to prevent auto-selecting completions when only one remains
    partial: true  # set this to false to prevent partial filling of the prompt
    algorithm: "fuzzy"  # prefix or fuzzy
    external: {
      enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up my be very slow
      max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
      completer: $carapace_completer # check 'carapace_completer' above as an example
    }
  }
  cursor_shape: {
    emacs: block # block, underscore, line (line is the default)
    vi_insert: line # block, underscore, line (block is the default)
    vi_normal: block # block, underscore, line  (underscore is the default)
  }
  filesize: {
    metric: true # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows standard)
    format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, zb, zib, auto
  }
  history: {
    max_size: 10000 # Session has to be reloaded for this to take effect
    sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
    file_format: "plaintext" # "sqlite" or "plaintext"
  }
  show_banner: false
  float_precision: 2
  use_ansi_coloring: true
  edit_mode: emacs # emacs, vi
  buffer_editor: vi
  # menu_config: {
  #   columns: 4
  #   col_width: 20   # Optional value. If missing all the screen width is used to calculate column width
  #   col_padding: 2
  #   text_style: green
  #   selected_text_style: green_reverse
  #   marker: "| "
  # }
  # history_config: {
  #   page_size: 10
  #   selector: "!"
  #   text_style: green
  #   selected_text_style: green_reverse
  #   marker: "? "
  # }
  keybindings: [
    {
      name: completion_menu
      modifier: none
      keycode: tab
      mode: emacs # Options: emacs vi_normal vi_insert
      event: {
        until: [
          { send: menu name: completion_menu }
          { send: menunext }
        ]
      }
    }
    {
      name: completion_previous
      modifier: shift
      keycode: backtab
      mode: emacs # Note: You can add the same keybinding to all modes by using a list
      event: { send: menuprevious }
    }
    {
      name: history_menu
      modifier: control
      keycode: char_r
      mode: emacs
      event: {
        until: [
          { send: menu name: history_menu }
          { send: menunext }
        ]
      }
    }
    {
      name: history_previous
      modifier: control
      keycode: char_s
      mode: emacs
      event: {
        until: [
          { send: menuprevious }
        ]
      }
    }
  ]
}

zoxide init nushell --hook prompt | save -f ~/.zoxide.nu
source ~/.zoxide.nu

source ~/scripts/jwt_decode.nu

