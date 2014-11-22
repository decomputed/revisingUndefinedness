:- table a/0, b/0, y/0, x/0, b/0, c/0.




a :- x.
x :- y, tnot(x).
y :- tnot(a).
b :- c, tnot(b).
c :- tnot(c).


a1d :- x1d.
x1d :- y1d, tnot(x).
y1d.
b1d :- c1d, tnot(b).
c1d :- tnot(c).
x1d :- x2d.
b1d :- b3d.
c1d :- c4d.

a2d :- x2d.
x2d :- y2d.
y2d :- tnot(a).
b2d :- c2d, tnot(b).
c2d :- tnot(c).
a2d :- a1d.
b2d :- b3d.
c2d :- c4d.


a3d :- x3d.
x3d :- y3d, tnot(x).
y3d :- tnot(a).
b3d :- c3d.
c3d :- tnot(c).
x3d :- x2d.
a3d :- a1d.
c3d :- c4d.


a4d :- x4d.
x4d :- y4d, tnot(x).
y4d :- tnot(a).
b4d :- c4d, tnot(b).
c4d.
x4d :- x2d.
b4d :- b3d.
a4d :- a1d.





aOLON :- a1d, tnot(y).
xOLON :- x2d.
bOLON :- b3d.
cOLON :- c4d.




aRaa :- aOLON.
xRaa :- xOLON.
bRaa :- bOLON.
cRaa :- cOLON.

a :- aRaa.
x :- xRaa.
b :- bRaa.
c :- cRaa.


