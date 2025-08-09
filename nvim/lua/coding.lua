-- TODO: Setup lsp server to use only for navigation of code such as function defs
-- Do not want constant compiler checks while coding only want to check once done coding
-- and I want to test what I have. Also want to make the lsp server togglable and by
-- default off.
return {
    -- Code comment
    {
        "folke/ts-comments.nvim",
        opts = {},
        event = "VeryLazy",
    },
}
