:- table a/0, b/0, c/0.



c :- a, tnot(c).
a :- tnot(b).
b :- tnot(a).



c1d :- a1d, tnot(c).
a1d :- tnot(b).
b1d.
b1d :- bRaa.
c1d :- cRaa.

c2d :- a2d, tnot(c).
a2d.
b2d :- tnot(a).
a2d :- aRaa.
c2d :- cRaa.

c3d :- a3d.
a3d :- tnot(b).
b3d :- tnot(a).
a3d :- aRaa.
b3d :- bRaa.






aOLON :- a1d, tnot(b).
bOLON :- b2d, tnot(b).
cOLON :- c3d.


aRaa :- aOLON.
bRaa :- bOLON.
cRaa :- cOLON.



a :- aRaa.
b :- bRaa.
c :- cRaa.


