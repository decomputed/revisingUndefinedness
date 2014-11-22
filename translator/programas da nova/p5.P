:- table a/0, b/0, y/0, x/0.



a :- x.
x :- y, tnot(x).
y :- tnot(a).



a1d :- x1d.
x1d :- y1d, tnot(x).
y1d.
x1d :- xRaa.

a2d :- x2d.
x2d :- y2d.
y2d :- tnot(a).
a2d :- aRaa.


aOLON :- a1d, tnot(y).
xOLON :- x2d.


aRaa :- aOLON.
xRaa :- xOLON.

a :- aRaa.
x :- xRaa.



