:- table a/0, x/0, y/0.



a :- x.
x :- y.
y :- tnot(a).
y :- tnot(x).



a1d :- x1d.
x1d :- y1d.
y1d.
y1d :- tnot(x).


a2d :- x2d.
x2d :- y2d.
y2d :- tnot(a).
y2d.


aOLON :- a1d, tnot(y).
xOLON :- x2d, tnot(y).



aRaa :- aOLON.
xRaa :- xOLON.



a :- aRaa.
x :- xRaa.


