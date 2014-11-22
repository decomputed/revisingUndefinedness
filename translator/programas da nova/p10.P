:- table a/0, b/0, c/0, x/0, d/0.



a :- x.
x :- tnot(a).
b :- tnot(a).
c :- tnot(b).
d :- tnot(c).



a1d :- x1d.
x1d.
b1d.
c1d :- tnot(b).
d1d :- tnot(c).
b1d :- bRaa.
c1d :- cRaa.


a2d :- x2d.
x2d :- tnot(a).
b2d :- tnot(a).
c2d.
d2d :- tnot(c).
a2d :- aRaa.
c2d :- cRaa.

a3d :- x3d.
x3d :- tnot(a).
b3d :- tnot(a).
c3d :- tnot(b).
d3d.
a3d :- aRaa.
b3d :- bRaa.


aOLON :- a1d, tnot(x), tnot(b).
bOLON :- b2d, tnot(c).
cOLON :- c3d, tnot(d).


aRaa :- aOLON.
bRaa :- bOLON.
cRaa :- cOLON.


a :- aRaa.
b :- bRaa.
c :- cRaa.

