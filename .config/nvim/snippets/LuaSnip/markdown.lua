local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep

return {
  s(
    {trig = 'b', dscr = 'Create code block'},
    fmta(
      [[
        ```<>
        <>
        ```
      ]],
      {i(1, 'text'), i(0)}
    )
  ),
  s(
    {trig = 'bt', dscr = 'Create code block with title'},
    fmta(
      [[
        ```<> {Title="<>"}
        <>
        ```
      ]],
      {i(1, 'text'), i(2), i(0)}
    )
  ),
  s(
    {trig = 'bl', dscr = 'Create code block with line highlighting'},
    fmta(
      [[
        ```<> {linenos=table,hl_lines="<>-<>"}
        <>
        ```
      ]],
      {i(1, 'text'), i(2, '1'), i(3, '2'), i(0)}
    )
  ),
}
