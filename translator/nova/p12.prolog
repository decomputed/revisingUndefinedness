:- table a/0, b/0, c/0, y/0.
:- dynamic c/0.


y :- tnot(a).
a :- tnot(b).
b :- tnot(c).




y1d.
a1d :- tnot(b).
b1d :- tnot(c).
b1d :- bRaa.


y2d :- tnot(a).
a2d.
b2d :- tnot(c).
a2d :- aRaa.



aOLON :- a1d, tnot(y).
bOLON :- b2d, tnot(a).



aRaa :- aOLON.
bRaa :- bOLON.



a :- aRaa.
b :- bRaa.


