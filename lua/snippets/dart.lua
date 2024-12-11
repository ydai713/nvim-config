local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep  -- Import rep for repeating insert nodes

ls.add_snippets("dart", {
  s("stateless", {
    t({
      "import 'package:flutter/material.dart';",
      "",
      "class ",
    }),
    i(1, "MyWidget"),  -- Placeholder for the widget name
    t({" extends StatelessWidget {",
      "  const ",
    }),
    rep(1),  -- Repeat the widget name
    t({"({super.key});",
      "",
      "  @override",
      "  Widget build(BuildContext context) {",
      "    return ",
    }),
    i(2, "Container()"),  -- Placeholder for the widget body
    t({";",
      "  }",
      "}",
    }),
  }),
})

ls.add_snippets("dart", {
  s("stateful", {
    t({
      "import 'package:flutter/material.dart';",
      "",
      "class ",
    }),
    i(1, "MyWidget"),  -- Placeholder for the widget name
    t({" extends StatefulWidget {",
      "  const ",
    }),
    rep(1),  -- Repeat the widget name
    t({"({super.key});",
      "",
      "  @override",
      "  State<",
    }),
    rep(1),  -- Repeat the widget name for State<>
    t({"> createState() => _",
    }),
    rep(1),  -- Repeat the widget name for _MyWidgetState
    t({"State();",
      "}",
      "",
      "class _",
    }),
    rep(1),  -- Repeat the widget name for _MyWidgetState class definition
    t({"State extends State<",
    }),
    rep(1),  -- Repeat the widget name for State<>
    t({"> {",
      "  @override",
      "  Widget build(BuildContext context) {",
      "    return ",
    }),
    i(2, "Container()"),  -- Placeholder for the widget body
    t({";",
      "  }",
      "}",
    }),
  }),
})
