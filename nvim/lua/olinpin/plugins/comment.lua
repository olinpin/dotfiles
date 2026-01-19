return {
    "numToStr/Comment.nvim",
    keys = {
        { "<leader>/", desc = "Toggle comment" },
    },
    config = function ()
        require('Comment').setup({
            opleader = {
                -- Line-comment toggle keymap
                line = '<leader>/'
            },
            toggler = {
                line = "<leader>/"
            }
        })
    end
}
