:- table a/0, b/0, c/0, y/0, x/0.






b :- y.
y :- tnot(a), c.
c :- a.
a :- x.
x :- tnot(b).



b1d :- y1d.
y1d :- c1d.
c1d :- a1d.
a1d :- x1d.
x1d :- tnot(b).
b1d :- aRaa.


b2d :- y2d.
y2d :- tnot(a), c2d.
c2d :- a2d.
a2d :- x2d.
x2d.
a2d :- aRaa.


aOLON :- a1d, tnot(y).
bOLON :- b2d, tnot(x).

aRaa :- aOLON.
bRaa :- bOLON.

a :- aRaa.
b :- bRaa.

