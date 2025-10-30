local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require "luasnip.extras"
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("tex", {
    s("beg", {
        t "\\begin{",
        i(1),
        t "}",
        t { "", "\t" },
        i(0),
        t { "", "\\end{" },
        rep(1),
        t "}",
    }),
})

ls.add_snippets("tex", {
    s(
        "start",
        fmt(
            [[
    %%%%%%% Basic Document Stuff %%%%%%%
    \documentclass{{article}}
    \usepackage[margin=25mm]{{geometry}}
    \usepackage[utf8]{{inputenc}}
    \usepackage[T1]{{fontenc}}
    %%%%%%% Lorem ipsum %%%%%%%
    \usepackage{{lipsum}}
    %%%%%%% Deutsch Übersetzungen %%%%%%%
    \usepackage[german]{{babel}}
    \usepackage{{hyperref}}
    \usepackage{{xurl}}
    %%%%%%% Arial Font %%%%%%%
    \usepackage{{helvet}}
    \renewcommand{{\familydefault}}{{\sfdefault}}
    %%%%%%% Import Pdf's %%%%%%%
    \usepackage{{pdfpages}}


    \begin {{{}}}
      {}
    \end {{{}}}
    ]],
            {
                i(1, "document"),
                i(0),
                rep(1),
            }
        )
    ),
})

ls.add_snippets("tex", {
    s(
        "literaturverzeichnis",
        fmt(
            [[
    %%%%%%% Literaturverzeichnis %%%%%%%
    \usepackage[backend=biber]{{biblatex}}
    \usepackage{{csquotes}}
    \addbibresource{{{}}}
    %%%%%%% Custom reference templates %%%%%%%
    \input{{{}}}
    ]],
            {
                i(1, "sources.bib"),
                i(2, "templates.tex"),
            }
        )
    ),
})

ls.add_snippets("tex", {
    s(
        "bf",
        fmt(
            [[
    \textbf{{{}}}
    ]],
            {
                i(1),
            }
        )
    ),
})

ls.add_snippets("tex", {
    s(
        "usepackage",
        fmt(
            [[
    \usepackage{{{}}}
    ]],
            {
                i(1, "package"),
            }
        )
    ),
})

ls.add_snippets("tex", {
    s(
        "pdf",
        fmt(
            [[
      \includepdf[pages=-]{{{}}} 
    ]],
            {
                i(1, "filename"),
            }
        )
    ),
})

ls.add_snippets("tex", {
    s(
        "quote",
        fmt(
            [[
      \enquote{{{}}} 
    ]],
            {
                i(1, "quote"),
            }
        )
    ),
})

ls.add_snippets("tex", {
    s(
        "cite",
        fmt(
            [[
      \cite[vgl. {}][S. {}]{{{}}}
    ]],
            {
                i(1, ""),
                i(2, ""),
                i(3, "citation"),
            }
        )
    ),
})

ls.add_snippets("tex", {
    s(
        "input",
        fmt(
            [[
      \input{{{}}}
    ]],
            {
                i(1, "path"),
            }
        )
    ),
})
