:- table a/0, b/0, d/0.



a :- tnot(a), tnot(b).
b :- tnot(b), d.
d :- tnot(a).

a1d :- tnot(b).
b1d :- tnot(b), d1d.
d1d.
b1d :- bRaa.


a2d :- tnot(a).
b2d :- d2d.
d2d :- tnot(a).
a2d :- aRaa.


aOLON :- a1d, tnot(d).
bOLON :- b2d, tnot(a).


aRaa :- aOLON.
bRaa :- bOLON.


a :- aRaa.
b :- bRaa.

