:- table a/0, b/0.



a :- tnot(b), tnot(a).
b :- tnot(a), tnot(b).



a1d :- tnot(b).
b1d :- tnot(b).
b1d :- bRaa.


a2d :- tnot(a).
b2d :- tnot(a).
a2d :- aRaa.


aOLON :- a1d, tnot(b).
bOLON :- b2d, tnot(a).



aRaa :- aOLON.
bRaa :- bOLON.



a :- aRaa.
b :- bRaa.


