:- table a/0, b/0.



a :- tnot(b).
b :- tnot(a).



a1d :- tnot(b).
b1d.


a2d.
b2d :- tnot(a).


aOLON :- a1d, tnot(b).
bOLON :- b2d, tnot(a).



aRaa :- aOLON.
bRaa :- bOLON.



a :- aRaa.
b :- bRaa.


