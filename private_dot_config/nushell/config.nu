# Nushell Config File

alias la = ls -a
alias ll = ls -l

# STARSHIP
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
source ~/.cache/starship/init.nu

let old_prompt_command = $env.PROMPT_COMMAND
def prompt-pre-cmd [] {
  if $env.TERM == 'alacritty' {
    ansi -o '0'; (char nf_folder1) + "  " + (pwd) + " | Alacritty"
    if (".node-version" | path exists) or (".nvmrc" | path  exists) {
      fnm use --silent-if-unchanged
    }
    ""
  }
}
let-env PROMPT_COMMAND = {
  prompt-pre-cmd
  do $old_prompt_command
}


module completions {
  # Custom completions for external commands (those outside of Nushell)
  # Each completions has two parts: the form of the external command, including its flags and parameters
  # and a helper command that knows how to complete values for those flags and parameters
  #
  # This is a simplified version of completions for git branches and git remotes
  def "nu-complete git branches" [] {
    ^git branch | lines | each { |line| $line | str replace '\* ' '' | str trim }
  }

  def "nu-complete git remotes" [] {
    ^git remote | lines | each { |line| $line | str trim }
  }

  export extern "git checkout" [
    branch?: string@"nu-complete git branches" # name of the branch to checkout
    -b: string                                 # create and checkout a new branch
    -B: string                                 # create/reset and checkout a branch
    -l                                         # create reflog for new branch
    --guess                                    # second guess 'git checkout <no-such-branch>' (default)
    --overlay                                  # use overlay mode (default)
    --quiet(-q)                                # suppress progress reporting
    --recurse-submodules: string               # control recursive updating of submodules
    --progress                                 # force progress reporting
    --merge(-m)                                # perform a 3-way merge with the new branch
    --conflict: string                         # conflict style (merge or diff3)
    --detach(-d)                               # detach HEAD at named commit
    --track(-t)                                # set upstream info for new branch
    --force(-f)                                # force checkout (throw away local modifications)
    --orphan: string                           # new unparented branch
    --overwrite-ignore                         # update ignored files (default)
    --ignore-other-worktrees                   # do not check if another worktree is holding the given ref
    --ours(-2)                                 # checkout our version for unmerged files
    --theirs(-3)                               # checkout their version for unmerged files
    --patch(-p)                                # select hunks interactively
    --ignore-skip-worktree-bits                # do not limit pathspecs to sparse entries only
    --pathspec-from-file: string               # read pathspec from file
  ]

  export extern "git push" [
    remote?: string@"nu-complete git remotes", # the name of the remote
    refspec?: string@"nu-complete git branches"# the branch / refspec
    --verbose(-v)                              # be more verbose
    --quiet(-q)                                # be more quiet
    --repo: string                             # repository
    --all                                      # push all refs
    --mirror                                   # mirror all refs
    --delete(-d)                               # delete refs
    --tags                                     # push tags (can't be used with --all or --mirror)
    --dry-run(-n)                              # dry run
    --porcelain                                # machine-readable output
    --force(-f)                                # force updates
    --force-with-lease: string                 # require old value of ref to be at this value
    --recurse-submodules: string               # control recursive pushing of submodules
    --thin                                     # use thin pack
    --receive-pack: string                     # receive pack program
    --exec: string                             # receive pack program
    --set-upstream(-u)                         # set upstream for git pull/status
    --progress                                 # force progress reporting
    --prune                                    # prune locally removed refs
    --no-verify                                # bypass pre-push hook
    --follow-tags                              # push missing but relevant tags
    --signed: string                           # GPG sign the push
    --atomic                                   # request atomic transaction on remote side
    --push-option(-o): string                  # option to transmit
    --ipv4(-4)                                 # use IPv4 addresses only
    --ipv6(-6)                                 # use IPv6 addresses only
  ]

  # def "nu-complete pnpm run" [] {
  #  open package.json | get scripts | columns
  # }

  # export extern "pnpm" [
  #   script?: string@"nu-complete pnpm run"     # the name of the script to run
  #   --version(-v): string                      # print version and exit
  #   --help(-h): string                         # print help and exit
  # ]

  # export extern "npm" [
  #   --version(-v): string                      # print version and exit
  #   --help(-h): string                         # print help and exit
  # ]

  # export extern "npm run" [
  #   script?: string@"nu-complete pnpm run"     # the name of the script to run
  # ]
}

# Get just the extern definitions without the custom completion commands
# use completions *

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

