:- table a/0, b/0, c/0.

:- table aRaa/0, bRaa/0, cRaa/0.

:- table aOLON/0, bOLON/0, cOLON.

:- table a1/0, b1/0, c1/0.
:- table a2/0, b2/0, c2/0.
:- table a3/0, b3/0, c3/0.




a :- tnot(b), tnot(c).
b :- tnot(a), tnot(c).
c :- tnot(b), tnot(a).



a1d :- tnot(b), tnot(c).
b1d :- tnot(c).
c1d :- tnot(b).
b1d :- bRaa.
c1d :- cRaa.


a2d :- tnot(c).
b2d :- tnot(a), tnot(c).
c2d :- tnot(a).
a2d :- aRaa.
c2d :- cRaa.


a3d :- tnot(b).
b3d :- tnot(a).
c3d :- tnot(b), tnot(a).
a3d :- aRaa.
b3d :- bRaa.



aOLON :- a1d, tnot(b), tnot(c).
bOLON :- b2d, tnot(a), tnot(c).
cOLON :- c3d, tnot(b), tnot(a).




aRaa :- aOLON.
bRaa :- bOLON.
cRaa :- cOLON.

a :- aRaa.
b :- bRaa.
c :- cRaa.
