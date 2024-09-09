local lexical = {
  filetypes = { "elixir", "eelixir", "heex", "surface" },
  cmd = { "/Users/victormartinez/Documents/lexical/_build/dev/package/lexical/bin/start_lexical.sh" },
  settings = {},
}

return {
  -- tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "codelldb",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "eslint-lsp",
        "json-lsp",
        "markdownlint",
        "prettier",
        "shfmt",
        "shellcheck",
        "taplo", -- TOML toolkit
        "typescript-language-server",
        "astro-language-server",
        "yaml-language-server",
        "lua-language-server",
        "stylua",
        "luacheck",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lexical = {
          mason = false,
          filetypes = lexical.filetypes,
          on_attach = function()
            print("Lexical has started.")
          end,
          settings = lexical.settings,
        },
        tailwindcss = {
          filetypes_include = { "heex", "elixir" },
        },
      },
      setup = {
        lexical = function(_, _)
          local lspconfig = require("lspconfig")
          local configs = require("lspconfig.configs")
          configs.lexical = {
            default_config = {
              filetypes = lexical.filetypes,
              root_dir = function(fname)
                print("finding root dir")
                return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
              end,
              cmd = lexical.cmd,
            },
          }
          return false
        end,
      },
    },
  },
}
