:- table a/0, b/0, c/0.
:- table a1d/0, b2d/0, c3d/0.

:- table a1i/0, b1i/0, c1i/0.
:- table a2i/0, b2i/0, c2i/0.
:- table a3i/0, b3i/0, c3i/0.



a :- tnot(b).
b :- tnot(c).
c :- tnot(a).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OLONs directos



a1d :- tnot(b).
b1d :- tnot(c).
c1d.
b1d :- bRaa.
c1d :- cRaa.


a2d.
b2d :- tnot(c).
c2d :- tnot(a).
a2d :- aRaa.
c2d :- cRaa.


a3d :- tnot(b).
b3d.
c3d :- tnot(a).
b3d :- bRaa.
a3d :- aRaa.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OLONs Indirectos


a1i :- tnot(b1i).
b1i :- tnot(c1i).
c1i.

a2i.
b2i :- tnot(c1i).
c2i :- tnot(a2i).

a3i :- tnot(b3i).
b3i.
c3i :- tnot(a3i).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% regras finais


aOLON :- a1d, tnot(c).
aOLON :- a1i, tnot(c), tnot(a1d).

bOLON :- b2d, tnot(a).
bOLON :- b2i, tnot(a), tnot(b2d).

cOLON :- c3d, tnot(b).
cOLON :- c3i, tnot(b),  tnot(c3d).



aRaa :- aOLON.
bRaa :- bOLON.
cRaa :- cOLON.



a :- aRaa.
b :- bRaa.
c :- cRaa.




