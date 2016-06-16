;在Foxit中模拟Vim的操作
#IfWinActive, ahk_class classFoxitReader
j::Down
k::Up
h::Send ^+{Tab}
l::Send ^{Tab}
^f::PgDn
^b::PgUp
^k::Send k
^j::Send j
^h::Send h
^l::Send l
g::Home
o::Send ^o
d::Send ^w
q::Send !{F4}
#IfWinActive
return
