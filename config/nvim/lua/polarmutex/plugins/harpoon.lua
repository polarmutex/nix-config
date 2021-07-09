local M = {}

M.setup = function()
    require("harpoon").setup({
        projects = {
            ["~/repos/brianryall.xyz"] = {
                term = {cmds = {"npm run dev\n"}},
                mark = {marks = {}},
            },
            ["~/repos/beancount"] = {
                term = {cmds = {"fava journal.beancount\n"}},
                mark = {marks = {}},
            },
        },
    })
end

return M
