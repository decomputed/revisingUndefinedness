:- table a/0, z/0, w/0.



a :- x,y.
x :- z.
z :- tnot(a).
y :- w.
w :- tnot(a).



a1d :- x1d,y1d.
x1d :- z1d.
z1d.
y1d :- w1d.
w1d.





aOLON :- a1d, tnot(w), tnot(z).


aRaa :- aOLON.


a :- aRaa.




