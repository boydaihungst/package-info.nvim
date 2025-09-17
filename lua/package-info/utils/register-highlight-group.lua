local constants = require("package-info.utils.constants")
local logger = require("package-info.utils.logger")

local M = {}

function M:get_colorscheme_hl()
    local colorscheme_highlights = {}
    for hl_opts_name, hl_group_name in pairs(constants.HIGHLIGHT_GROUPS) do
        local color_scheme_hl_exist, color_scheme_hl = pcall(self.get_hl, hl_group_name)
        if color_scheme_hl_exist and not vim.tbl_isempty(color_scheme_hl) then
            colorscheme_highlights[hl_opts_name] = color_scheme_hl
        end
    end
    return colorscheme_highlights
end
-- Compatibility wrapper for getting highlights
function M.get_hl(name)
    if vim.api.nvim_get_hl then
        -- Neovim 0.9+
        return vim.api.nvim_get_hl(0, { name = name })
    else
        -- Neovim 0.6–0.8
        local ok, hl = pcall(vim.api.nvim_get_hl_by_name, name, true)
        if not ok then
            return {}
        end
        return hl or {}
    end
end

function M.set_hl(group, opts)
    local success, result = pcall(vim.api.nvim_set_hl, 0, group, opts)
    if not success then
        logger.error("Error setting highlight: " .. result)
    end
    return
end

return M
