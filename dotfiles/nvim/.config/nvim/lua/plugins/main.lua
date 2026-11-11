return {
    { "preservim/nerdtree" },               -- Directory explorer
    { "vim-airline/vim-airline" },          -- Add an info bar to the bottom of vim
    {
        "tpope/vim-speeddating",            -- Increment/decrement dates and times correctly
        keys = { "<C-A>", "<C-X>" },
    },
    { "glts/vim-magnum", lazy=true },       -- BigInt lib, needed by...
    { "glts/vim-radical", lazy=true },      -- Utils for working with non-binary numbers
    { "tpope/vim-surround", lazy=false },   -- Commands to wrap text in quotes, brackets, etc.
    { "tpope/vim-repeat", lazy=false },     -- Add support for the repeat "." command to various plugins
    { "tpope/vim-commentary", lazy=false }, -- Add comment/uncomment support to vim
    {
        "ryanoasis/vim-devicons",           -- Devicons for use by nerd tree
        lazy=false,
    },
--     {
--         "neoclide/coc.nvim",                -- Code completion
--     },
}

