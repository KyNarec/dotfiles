local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt


ls.add_snippets("java", {
  s("pub", fmt(
    [[
      public {} {}({}){{
        {}
      }}
    ]], {
    i(1, "void"), i(2, "methodName"), i(3, "parameters"), i(0)
  }))
})
