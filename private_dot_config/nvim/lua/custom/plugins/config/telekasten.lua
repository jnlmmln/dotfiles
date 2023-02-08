local ok, telekasten = pcall(require, 'telekasten')
if ok then
    local home = vim.fn.expand("~/telekasten")
    telekasten.setup({
        home = home,

        -- dir names for special notes (absolute path or subdir name)
        dailies   = home .. '/' .. 'daily',
        weeklies  = home .. '/' .. 'weekly',
        templates = home .. '/' .. 'templates',

        -- markdown file extension
        extension = ".md",

        -- Generate note filenames. One of:
        -- "title" (default) - Use title if supplied, uuid otherwise
        -- "uuid" - Use uuid
        -- "uuid-title" - Prefix title by uuid
        -- "title-uuid" - Suffix title with uuid
        new_note_filename = "title",
        -- file uuid type ("rand" or input for os.date()")
        uuid_type = "%Y%m%d%H%M",
        -- UUID separator
        uuid_sep = "-",

        -- following a link to a non-existing note will create it
        follow_creates_nonexisting = true,
        dailies_create_nonexisting = true,
        weeklies_create_nonexisting = true,

        -- skip telescope prompt for goto_today and goto_thisweek
        journal_auto_open = false,

        -- template for new notes (new_note, follow_link)
        -- set to `nil` or do not specify if you do not want a template
        template_new_note = home .. '/' .. 'templates/new_note.md',

        -- template for newly created daily notes (goto_today)
        -- set to `nil` or do not specify if you do not want a template
        template_new_daily = home .. '/' .. 'templates/daily.md',

        -- template for newly created weekly notes (goto_thisweek)
        -- set to `nil` or do not specify if you do not want a template
        template_new_weekly = home .. '/' .. 'templates/weekly.md',

        -- default sort option: 'filename', 'modified'
        sort = "filename",

        -- integrate with calendar-vim
        plug_into_calendar = true,
        calendar_opts = {
            -- calendar week display mode: 1 .. 'WK01', 2 .. 'WK 1', 3 .. 'KW01', 4 .. 'KW 1', 5 .. '1'
            weeknm = 4,
            -- use monday as first day of week: 1 .. true, 0 .. false
            calendar_monday = 1,
            -- calendar mark: where to put mark for marked days: 'left', 'right', 'left-fit'
            calendar_mark = 'left-fit',
        },

        -- telescope actions behavior
        close_after_yanking = false,
        insert_after_inserting = true,

        -- when linking to a note in subdir/, create a [[subdir/title]] link
        -- instead of a [[title only]] link
        subdirs_in_links = true,

        -- template_handling
        -- What to do when creating a new note via `new_note()` or `follow_link()`
        -- to a non-existing note
        -- - prefer_new_note: use `new_note` template
        -- - smart: if day or week is detected in title, use daily / weekly templates (default)
        -- - always_ask: always ask before creating a note
        template_handling = "smart",

        -- path handling:
        --   this applies to:
        --     - new_note()
        --     - new_templated_note()
        --     - follow_link() to non-existing note
        --
        --   it does NOT apply to:
        --     - goto_today()
        --     - goto_thisweek()
        --
        --   Valid options:
        --     - smart: put daily-looking notes in daily, weekly-looking ones in weekly,
        --              all other ones in home, except for notes/with/subdirs/in/title.
        --              (default)
        --
        --     - prefer_home: put all notes in home except for goto_today(), goto_thisweek()
        --                    except for notes with subdirs/in/title.
        --
        --     - same_as_current: put all new notes in the dir of the current note if
        --                        present or else in home
        --                        except for notes/with/subdirs/in/title.
        new_note_location = "smart",

        -- should all links be updated when a file is renamed
        rename_update_links = true,

        -- debug = true,
    })
    require('which-key').register {
        ['<leader>ca'] = {
            l = { 'calendar V' },
            L = { 'calendar H' },
        },
    }
    require('which-key').register {
        ['<leader>o'] = {
            name = '+telekasten',
            f = { telekasten.find_notes, 'find notes' },
            d = { telekasten.find_daily_notes, 'find daily notes' },
            g = { telekasten.search_notes, 'search notes' },
            z = { telekasten.follow_link, 'follow link' },
            p = { telekasten.panel, 'panel' },
            c = { telekasten.show_calendar, 'calendar' },
        }
    }
end
