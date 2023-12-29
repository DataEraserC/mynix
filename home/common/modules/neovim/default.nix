{
  pkgs,
  astronvim,
  ...
}:
###############################################################################
#
#  AstroNvim's configuration and all its dependencies(lsp, formatter, etc.)
#
#e#############################################################################
{
  xdg.configFile = {
    # astronvim's config
    "nvim" = {
      source = astronvim;
      force = true;
    };

    # my custom astronvim config, astronvim will load it after base config
    # https://github.com/AstroNvim/AstroNvim/blob/v3.32.0/lua/astronvim/bootstrap.lua#L15-L16
    "astronvim/lua/user".source = ./astronvim_user;
  };

  nixpkgs.config = {
    programs.npm.npmrc = ''
      prefix = ''${HOME}/.npm-global
    '';
  };

  programs = {
    neovim = {
      enable = true;

      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      # currently we use lazy.nvim as neovim's package manager, so comment this one.
      # Install packages that will compile locally or download FHS binaries via Nix!
      # and use lazy.nvim's `dir` option to specify the package directory in nix store.
      # so that these plugins can work on NixOS.
      #
      # related project:
      #  https://github.com/b-src/lazy-nix-helper.nvim
      plugins = with pkgs.vimPlugins; [
        # search all the plugins using https://search.nixos.org/packages
        telescope-fzf-native-nvim
      ];

      # Extra packages only available to nvim(won't pollute the global home environment)
      extraPackages = with pkgs;
        [
          #-- c/c++
          cmake
          cmake-language-server
          gnumake
          ccache
          checkmake
          gcc # c/c++ compiler, required by nvim-treesitter!
          llvmPackages.clang-unwrapped # c/c++ tools with clang-tools such as clangd
          lldb

          #-- python
          nodePackages.pyright # python language server
          python3Packages.black # python formatter
          python3Packages.ruff-lsp
          (python3.withPackages (
            ps:
              with ps; [
                pynvim # Python client and plugin host for Nvim

                ipython
                pandas
                requests
                pyquery
                pyyaml
                pip # use in venv "python -m venv .venv" "source .venv/bin/activate"

                ipykernel
                jupyterlab
                matplotlib
                numpy
                seaborn
                networkx
                beautifulsoup4
                selenium
                urllib3
                pyclip
                pybluez
                pymysql
                jieba
                # wordcloud
                pandas-datareader
                pyperclip
              ]
          ))

          #-- rust
          rust-analyzer
          cargo # rust package manager
          rustfmt

          #-- zig
          zls

          #-- nix
          nil
          rnix-lsp
          # nixd
          statix # Lints and suggestions for the nix programming language
          deadnix # Find and remove unused code in .nix source files
          alejandra # Nix Code Formatter

          #-- golang
          go
          gomodifytags
          iferr # generate error handling code for go
          impl # generate function implementation for go
          gotools # contains tools like: godoc, goimports, etc.
          gopls # go language server
          delve # go debugger

          # -- java
          jdk17
          gradle
          maven
          spring-boot-cli

          #-- lua
          stylua
          lua-language-server

          #-- bash
          nodePackages.bash-language-server
          shellcheck
          shfmt

          #-- javascript/typescript --#
          nodePackages.nodejs
          nodePackages.typescript
          nodePackages.typescript-language-server
          # HTML/CSS/JSON/ESLint language servers extracted from vscode
          nodePackages.vscode-langservers-extracted
          nodePackages."@tailwindcss/language-server"

          #-- CloudNative
          nodePackages.dockerfile-language-server-nodejs
          # terraform  # install via brew on macOS
          terraform-ls
          jsonnet
          jsonnet-language-server
          hadolint # Dockerfile linter

          #-- Others
          taplo # TOML language server / formatter / validator
          nodePackages.yaml-language-server
          sqlfluff # SQL linter
          actionlint # GitHub Actions linter
          buf # protoc plugin for linting and formatting
          proselint # English prose linter

          #-- Misc
          tree-sitter # common language parser/highlighter
          nodePackages.prettier # common code formatter
          marksman # language server for markdown
          glow # markdown previewer
          fzf

          #-- Optional Requirements:
          gdu # disk usage analyzer, required by AstroNvim
          ripgrep # fast search tool, required by AstroNvim's '<leader>fw'(<leader> is space key)
        ]
        ++ (
          if pkgs.stdenv.isDarwin
          then []
          else [
            #-- verilog / systemverilog
            verible
            gdb
          ]
        );
    };
  };
}
