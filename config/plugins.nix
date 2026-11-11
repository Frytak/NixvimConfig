{ pkgs, lib, ... }:

let
    rangerConfig = pkgs.runCommandLocal "rnvimr-ranger-config" { } ''
        mkdir -p $out
        install -m644 ${./ranger/rc.conf} $out/rc.conf
        install -m644 ${./ranger/rifle.conf} $out/rifle.conf
        install -m755 ${./ranger/scope.sh} $out/scope.sh
        substituteInPlace $out/rc.conf --replace-fail '@SCOPE_SH@' "$out/scope.sh"
    '';

    mkServer = extra: { enable = true; packageFallback = true; } // extra;
in
{
    extraPackages = [ pkgs.ranger ] ++ lib.optionals pkgs.stdenv.isLinux [
        pkgs.ueberzugpp
        pkgs."poppler-utils"
        pkgs.ffmpeg
        pkgs.ffmpegthumbnailer
        pkgs.atool
        pkgs.bat
    ];

    extraPlugins = with pkgs.vimPlugins; [
        rnvimr
    ];

    globals = {
        loaded_netrw = 1; # Disable netrw
        loaded_netrwPlugin = 1;

        rnvimr_enable_ex = 1; # Enable Ranger to replace builtin Netrw to be a file explorer. (buggy)
        rnvimr_enable_picker = 1;
        rnvimr_urc_path = rangerConfig;
        rnvimr_ranger_cmd = [ "${pkgs.ranger}/bin/ranger" ];
    };

    plugins = {
        lsp = {
            enable = true;
            servers = {
                # Nix
                nil_ls = mkServer { };
                nixd = mkServer { };

                qmlls = mkServer { };
                protols = mkServer { };
                clangd = mkServer {
                    extraOptions.cmd = [
                        "clangd"
                        "--clang-tidy"
                        "--background-index"
                        "--fallback-style={IndentWidth: 4, UseTab: Never}"
                    ];
                };
                gopls = mkServer { };
                ocamllsp = mkServer {
                    package = pkgs.ocamlPackages.ocaml-lsp;
                };
                csharp_ls = mkServer { };
                lua_ls = mkServer { };
                ts_ls = mkServer { };
                jdtls = mkServer { };
                rust_analyzer = mkServer {
                    installCargo = false;
                    installRustc = false;
                };
                zls = mkServer { };
            };
        };

        # For Neovim development
        lazydev.enable = true;

        cmp = {
            enable = true;
            autoEnableSources = true;
            settings = {
                mapping = {
                    "<C-l>" = "cmp.mapping.confirm({select = false})";
                    "<C-h>" = "cmp.mapping.abort()";
                    "<C-k>" = "cmp.mapping.select_prev_item({behavior = 'select'})";
                    "<C-j>" = "cmp.mapping.select_next_item({behavior = 'select'})";
                    # FIXME: Cmd doesn't translate ctrl + shift
                    "<C-S-j>" = "cmp.mapping.scroll_docs(1)";
                    "<C-S-k>" = "cmp.mapping.scroll_docs(-1)";
                };
                sources = [
                    { name = "nvim_lsp"; }
                    { name = "path"; }
                    { name = "buffer"; }
                ];
            };
        };

        web-devicons.enable = true;

        lsp-status.enable = true;

        lualine = {
            enable = true;
            settings = {
                component_separators = "";
                section_separators = "";
                sections = {
                    lualine_a = [ "mode" ];
                    lualine_b = [ "branch" ];
                    lualine_c = [
                        {
                            __unkeyed-1 = "searchcount";
                            cond = {
                                __raw = ''
                                    function() return (vim.v.hlsearch == 1) end
                                '';
                            };

                            fmt = {
                                __raw = ''
                                    ---@param component string
                                    function(component)
                                        return string.format('Found: %s', component)
                                    end
                                '';
                            };
                        }
                        "diagnostics"
                    ];
                    lualine_x = [
                        {
                            __unkeyed-1 = {
                                __raw = "require(\"lsp-status\").status";
                            };
                        }
                        {
                            __unkeyed-1 = "diff";
                            colored = true;
                            #diff_color = {
                            #    added = { fg = theme.diff.added.fg },
                            #    modified = { fg = theme.diff.modified.fg },
                            #    removed = { fg = theme.diff.removed.fg },
                            #};
                            #symbols = {
                            #    added = theme.diff.added.icon,
                            #    modified = theme.diff.added.icon,
                            #    removed = theme.diff.added.icon
                            #},
                        }
                    ];
                    lualine_y = [ { __unkeyed-1 = "filetype"; colored = false; } ];
                    lualine_z = [ "progress" "location" ];
                };
            };
        };

        bufferline = {
            enable = true;
            settings.options.mode = "tabs";
        };

        telescope = {
            enable = true;
            extensions = {
                fzf-native.enable = true;
                file-browser = {
                    enable = true;
                    settings = {
                        auto_depth = true;
                        mappings.n = {
                            "c" = "require('telescope._extensions.file_browser.actions').create";
                            "r" = "require('telescope._extensions.file_browser.actions').rename";
                            "m" = "require('telescope._extensions.file_browser.actions').move";
                            "y" = "require('telescope._extensions.file_browser.actions').copy";
                            "d" = "require('telescope._extensions.file_browser.actions').remove";
                            "o" = "require('telescope._extensions.file_browser.actions').open";
                            "h" = "require('telescope._extensions.file_browser.actions').goto_parent_dir";
                            "e" = "require('telescope._extensions.file_browser.actions').goto_home_dir";
                            "w" = "require('telescope._extensions.file_browser.actions').goto_cwd";
                            "t" = "require('telescope._extensions.file_browser.actions').change_cwd";
                            "f" = "require('telescope._extensions.file_browser.actions').toggle_browser";
                            "H" = "require('telescope._extensions.file_browser.actions').toggle_hidden";
                            "s" = "require('telescope._extensions.file_browser.actions').toggle_all";
                        };
                    };
                };
            };
        };

        render-markdown.enable = true;
        markdown-preview.enable = true;
        rest.enable = true;
        treesitter = {
            enable = true;

            # Installing every grammar makes the first `nix run` build hundreds
            # of derivations. Keep this in sync with the languages configured
            # above instead.
            grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
                bash
                c
                cpp
                c_sharp
                go
                gomod
                gosum
                gowork
                java
                javascript
                json
                lua
                markdown
                markdown_inline
                nix
                ocaml
                ocaml_interface
                proto
                qmldir
                qmljs
                rust
                toml
                tsx
                typescript
                typst
                yaml
                zig
            ];
        };
        dbee.enable = true;
        typst-preview.enable = true;
    };
}
