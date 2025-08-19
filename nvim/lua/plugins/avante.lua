if not vim.g.copilot_available then
    return {}
end

return {
    "yetone/avante.nvim",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ must add this setting! ! !
    build = function()
        -- conditionally use the correct build system for the current OS
        if vim.fn.has("win32") == 1 then
            return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        else
            return "make"
        end
    end,
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
        provider = "copilot",
        providers = {
            copilot = {
                model = vim.g.copilot_model,
                timeout = 30000, -- Timeout in milliseconds
                extra_request_body = {
                    temperature = 0.75,
                    max_tokens = 100000,
                },
            },
        },
        selection = {
            enabled = true,
            hint_display = "none",
        },
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
}
