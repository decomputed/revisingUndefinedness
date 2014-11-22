:- table a/0, b/0, c/0, x/0, y/0, z/0.



a :- tnot(b).
b :- tnot(a).
c :- a, tnot(c).
x :- tnot(y).
y :- tnot(x).
z :- x, tnot(z).




a1d :- tnot(b).
b1d.
c1d :- a1d, tnot(c).
x1d :- tnot(y).
y1d :- tnot(x).
z1d :- x1d, tnot(z).
b1d :- bRaa.
c1d :- cRaa.
x1d :- xRaa.
y1d :- yRaa.
z1d :- zRaa.




a2d.
b2d :- tnot(a).
c2d :- a2d, tnot(c).
x2d :- tnot(y).
y2d :- tnot(x).
z2d :- x2d, tnot(z).
a2d :- aRaa.
c2d :- cRaa.
x2d :- xRaa.
y2d :- yRaa.
z2d :- zRaa.



a3d :- tnot(b).
b3d :- tnot(a).
c3d :- a3d.
x3d :- tnot(y).
y3d :- tnot(x).
z3d :- x3d, tnot(z).
a3d :- aRaa.
b3d :- bRaa.
x3d :- xRaa.
y3d :- yRaa.
z3d :- zRaa.


a4d :- tnot(b).
b4d :- tnot(a).
c4d :- a4d, tnot(c).
x4d :- tnot(y).
y4d.
z4d :- x4d, tnot(z).
a4d :- aRaa.
b4d :- bRaa.
c4d :- cRaa.
y4d :- yRaa.
z4d :- zRaa.



a5d :- tnot(b).
b5d :- tnot(a).
c5d :- a5d, tnot(c).
x5d.
y5d :- tnot(x).
z5d :- x5d, tnot(z).
a5d :- aRaa.
b5d :- bRaa.
c5d :- cRaa.
x5d :- xRaa.
z5d :- zRaa.



a6d :- tnot(b).
b6d :- tnot(a).
c6d :- a6d, tnot(c).
x6d :- tnot(y).
y6d :- tnot(x).
z6d :- x6d.
a6d :- aRaa.
b6d :- bRaa.
c6d :- cRaa.
x6d :- xRaa.
y6d :- yRaa.





aOLON :- a1d, tnot(b).
bOLON :- b2d, tnot(a).
cOLON :- c3d.
xOLON :- x4d, tnot(y).
yOLON :- y5d, tnot(x).
zOLON :- z6d.





aRaa :- aOLON.
bRaa :- bOLON.
cRaa :- cOLON.
xRaa :- xOLON.
yRaa :- yOLON.
zRaa :- zOLON.




a :- aRaa.
b :- bRaa.
c :- cRaa.
x :- xRaa.
y :- yRaa.
z :- zRaa.

