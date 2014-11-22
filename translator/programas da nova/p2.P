:- table a/0, b/0, y/0, x/0, z/0, w/0.

:- table aRaa/0, bRaa/0.

:- table aOLON/0, bOLON/0.

:- table a1/0, b1/0, y1/0, x1/0, z1/0, w1/0.
:- table a2/0, b2/0, y2/0, x2/0, z2/0, w2/0.




a :- x.
x :- tnot(a), y.
y :- tnot(b).
b :- z.
z :- tnot(b), w.
w :- tnot(a).




a1d :- x1d.
x1d :- y1d.
y1d :- tnot(b).
b1d :- z1d.
z1d :- tnot(b), w1d.
w1d.
b1d :- bRaa.

a2d :- x2d.
x2d :- tnot(a), y2d.
y2d.
b2d :- z2d.
z2d :- w2d.
w2d :- tnot(a).
a2d :- aRaa.


aOLON :- a1d, tnot(x), tnot(w).
bOLON :- b2d, tnot(y), tnot(z).




aRaa :- aOLON.
bRaa :- bOLON.

a :- aRaa.
b :- bRaa.

