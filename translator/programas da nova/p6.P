:- table a/0, b/0, y/0, x/0.



a :- x.
x :- y, tnot(a).
y :- tnot(a).



a1d :- x1d.
x1d :- y1d.
y1d.


aOLON :- a1d, tnot(y), tnot(x).



aRaa :- aOLON.


a :- aRaa.




