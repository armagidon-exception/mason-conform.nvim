# mason-conform.nvim

Automatically install formatters registered with [conform.nvim](https://github.com/stevearc/conform.nvim) via [Mason](https://github.com/williamboman/mason.nvim).

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "armagidon-exception/mason-conform.nvim",
  event = "VeryLazy",
  dependencies = {
    "williamboman/mason.nvim",
    "stevearc/conform.nvim",
  },
  opts = {},
}
```

> Note: mason.nvim and conform.nvim must be set up before mason-conform.nvim. Declaring them in `dependencies` guarantees lazy.nvim loads them in the correct order.

## Configuration

`ignore_install`

List of formatters to skip during auto-install. Useful for formatters you already manage through your system package manager, or that don't support your platform.

```lua
opts = {
  ignore_install = { "stylua", "prettier" },
}
```

`auto_enable`

Controls auto discovery: automatically sets up formatters to their matching filetypes in conform. Only affects filetypes that have no formatters explicitly configured.

```lua
opts = {
  auto_enable = {
    enabled = true,  -- default: true
    notify = false,  -- default: false
  },
}
```

- `enabled`: when `true`, scans Mason for installed formatters and registers them with conform. When `false`, only auto install runs.
- `notify`: when `true`, shows a notification for each formatter discovered.

> Auto-install runs once at startup. Auto-discover also runs once at startup; formatters installed later require a restart to be discovered.

## Important: lazy.nvim and `opts`

Do not remove `opts = {}` from your plugin spec. If you delete it and don't provide a `config` function, the plugin will not trigger start.

These are all valid:

```lua
-- Empty opts, lazy.nvim calls setup({}) automatically
opts = {},

-- With options, lazy.nvim calls setup({ignore_install = {...}})
opts = {
  ignore_install = { "stylua" },
},

-- Explicit config
config = function()
  require("mason-conform").setup()
end,

-- Explicit but with a config?
config = function(_, opts)
  require("mason-conform").setup(opts)
end,
```

## Available Formatters

Only formatters available in the Mason registry can be installed automatically. If a formatter is in the registry but not being installed, the plugin may be missing a mapping in [`lua/mason-conform/mapping.lua`](lua/mason-conform/mapping.lua).

## License

`mason-conform.nvim` is an improved fork of [zapling/mason-conform.nvim](https://github.com/zapling/mason-conform.nvim), based on [mason-nvim-lint](https://github.com/rshkarin/mason-nvim-lint), which in turn takes heavy inspiration from [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim).
