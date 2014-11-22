:- import concat_atom/2 from string.
:- import ith/3 from basics.
:- import member/2 from basics.


:- dynamic tempHerbrand/1.


processHerbrand((H :- B),MiniHerbrand) :-
	H \= [],
	assert(tempHerbrand(H)),
	processHerbrandBody(B),
	setof(X,tempHerbrand(X),PossibleHerbrand),
	MiniHerbrand = PossibleHerbrand,
	retractall(tempHerbrand(_)).
		
%processHerbrand((H),MiniHerbrand) :-
%	assert(tempHerbrand(H)),
%	setof(X,tempHerbrand(X),PossibleHerbrand),
%	MiniHerbrand = PossibleHerbrand,
%	retractall(tempHerbrand(_)).





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% body processing



processHerbrandBody((A ',' R)) :- 
	processHerbrandBody(A),
	processHerbrandBody(R).


processHerbrandBody((R)) :-
	assert(tempHerbrand(R)).
	




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Writes a rule to wherever we're telling/1
%

saveFact(Head) :-
	write(Head), write('.'), nl.

saveRule(Head,Tail) :-
	write(Head), write(':-'), write(Tail), write('.'), nl.

saveTable(Head) :-
	write(':-table '),write(Head), write('/0.'), nl.
