:- import concat_atom/2 from string.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     A :- B

process((H :- B)) :-
	processBody(B,Body),
	saveRule(H,Body).


	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     A

processTail((H)) :-
	saveFact(H).

	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     Body processing	

processBody((A ',' R),Body) :- 
	processBody(A,Body1),
	processBody(R,Body2),
	concat_atom([Body1,',',Body2],Body).


processBody((not R),Body):- 
	concat_atom([tnot,'(',R,')'],Body).



processBody((R),R).



saveRule(Head,Tail) :-
	write(Head), write(':-'), write(Tail), write('.'), nl.

	
saveFact(Head) :-
	write(Head), write('.'), nl.
