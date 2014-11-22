:- table a/0, b/0, y/0, x/0.
:- dynamic b/0.



a :- x.
x :- y.
y :- tnot(a).
y :- tnot(b).



a1d :- x1d.
x1d :- y1d.
y1d.
y1d :- tnot(b).



aOLON :- a1d, tnot(y).





aRaa :- aOLON.

a :- aRaa.


