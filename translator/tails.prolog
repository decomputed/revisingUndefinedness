:- dynamic tempTails/1.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     A :- B

processTail(Tails,(H :- B),Atom) :-
	(
		assert(tempTails(ni)),
		B \= [],
		processTailBody(H,B,Atom),
		setof(X,tempTails(X),PossibleTails),
		Tails = PossibleTails,
		retractall(tempTails(_))
	);
	true.


	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     A

processTail(Tails,(H),Atom) :-
	processTail(Tails,(H :- []),Atom).

	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     Body processing	

processTailBody(H,(A ',' R),Atom) :- 
	processTailBody(H,A,Atom),
	processTailBody(H,R,Atom).


processTailBody(H,(not R),Atom):- 
	R = Atom,
	Atom \= H,
	assert(tempTails(H)).



processTailBody(_,(R),_).



