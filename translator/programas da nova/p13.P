:- table a/0, b/0, x/0.



a :- b, x.
b :- tnot(b).
x :- tnot(a).




a1d :- b1d, x1d.
b1d :- tnot(b).
x1d.
b1d :- bRaa.


a2d :- b2d, x2d.
b2d.
x2d :- tnot(a).
a2d :- aRaa.



aOLON :- a1d, tnot(x).
bOLON :- b2d.



aRaa :- aOLON.
bRaa :- bOLON.



a :- aRaa.
b :- bRaa.


