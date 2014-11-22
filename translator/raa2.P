


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     A :- B

processRAA((H :- B)) :-
	(
		B \= [],
		addPos(H),
		processRAABody(B)
	);
	true.


	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     A

processRAA((H)) :-
	processRAA((H :- [])).

	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     Body processing	

processRAABody((L,Rest)) :-
	addNeg(L),
	processRAABody(Rest).


processRAABody(L) :-
	addNeg(L).
	


	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  usamos pos(X) p indicar q X apareceu uma vez na cabeça d uma regra
%%  e neg(X) p indicar q X apareceu pelo menos umas vez negado na cauda d uma regra


addPos(X) :-
	retractall(pos(X)),
	assert(pos(X)).

addNeg((not X)) :-
	retractall(neg(X)),
	assert(neg(X)).

addNeg(_).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  em raa/1 está uma lista com todos os átomos q têm potencial
%%  p serem provados por RAA




generateRAAset :-
	bagof(X,(pos(X),neg(X)),RAA),
	assert(raa(RAA)),
	retractall(pos(_)),
	retractall(neg(_)).

	
	