local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("lua", {
  s("adds", fmt(
    [[
    ls.add_snippets("{}", {{
      s("{}", {{
        {}
     }})
    }})
    ]], {
      i(1, "filetype"), i(2, "name"), i(3)
  }))
})

ls.add_snippets("lua", {
  s("addsfmt", {
    t('ls.add_snippets("'), i(1), t('", {'),
    t({"", '  s("'}), i(2), t('", fmt('),
    t({"", "    [["}),
    t({"", "    "}), i(3),
    t({"", "    ]], {"}),
    t({"", "    "}), i(0, 'i(1, "")'),
    t({"", "  }))"}),
    t({"", "})"})
  })
})
