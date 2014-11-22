:- table a/0, b/0, c/0, x/0.
:- table aOLON/0, bOLON/0, cOLON/0, xOLON/0.
:- table aRaa/0, bRaa/0, cRaa/0, xRaa/0.

:- table a1d/0, b2d/0, c3d/0, x4d/0.

:- table a1i/0, b1i/0, c1i/0, x1i/0.
:- table a2i/0, b2i/0, c2i/0, x2i/0.
:- table a3i/0, b3i/0, c3i/0, x3i/0.
:- table a4i/0, b4i/0, c4i/0, x4i/0.




a :- tnot(b).
b :- tnot(c), x.
c :- tnot(a).
x :- tnot(x), a.





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OLONs directos


a1d :- tnot(b).
b1d :- tnot(c), x1d.
c1d.
x1d :- tnot(x), a1d.
b1d :- bOLON.
c1d :- cOLON.
x1d :- xOLON.



a2d.
b2d :- tnot(c), x2d.
c2d :- tnot(a).
x2d :- tnot(x), a2d.
a2d :- aOLON.
c2d :- cOLON.
x2d :- xOLON.


a3d :- tnot(b).
b3d :- x3d.
c3d :- tnot(a).
x3d :- tnot(x), a3d.
b3d :- bOLON.
a3d :- aOLON.
x3d :- xOLON.



a4d :- tnot(b).
b4d :- tnot(c), x4d.
c4d :- tnot(a).
x4d :- a4d.
b4d :- bOLON.
c4d :- cOLON.
a4d :- aOLON.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OLONs Indirectos


a1i :- tnot(b1i).
b1i :- tnot(c1i), x1i.
c1i.
x1i :- tnot(x1i), a1i.
b1i :- bOLON.
c1i :- cOLON.
x1i :- xOLON.
a1i :- tnot(b), tnot(a).
b1i :- tnot(c), x1i, tnot(b).
c1i.
x1i :- tnot(x), a1i.


a2i.
b2i :- tnot(c2i), x2i.
c2i :- tnot(a2i).
x2i :- tnot(x2i), a2i.
a2i :- aOLON.
c2i :- cOLON.
x2i :- xOLON.
a2i.
b2i :- tnot(c), x2i, tnot(b).
c2i :- tnot(a), tnot(c).
x2i :- tnot(x), a2i.



a3i :- tnot(b3i).
b3i :- x3i.
c3i :- tnot(a3i).
x3i :- tnot(x3i), a3i.
b3i :- bOLON.
a3i :- aOLON.
x3i :- xOLON.
a3i :- tnot(b), tnot(a).
b3i :- x3i.
c3i :- tnot(a), tnot(c).
x3i :- tnot(x), a3i.


a4i :- tnot(b4i).
b4i :- tnot(c4i), x4i.
c4i :- tnot(a4i).
x4i :- a4i.
b4i :- bOLON.
c4i :- cOLON.
a4i :- aOLON.
a4i :- tnot(b), tnot(a).
b4i :- tnot(c), x4i, tnot(b).
c4i :- tnot(a), tnot(c).
x4i :- a4i.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% regras finais


aOLON :- a1d, tnot(c).
bOLON :- b2d, tnot(a).
cOLON :- c3d, tnot(b).
xOLON :- x4d.


aOLON :- a1i, tnot(c), tnot(a1d).
bOLON :- b2i, tnot(a), tnot(b2d).
cOLON :- c3i, tnot(b), tnot(c3d).
xOLON :- x4i, tnot(x4d).


aRaa :- aOLON.
bRaa :- bOLON.
cRaa :- cOLON.
xRaa :- xOLON.


a :- aRaa.
b :- bRaa.
c :- cRaa.
x :- xRaa.




