:- import concat_atom/2 from string.
:- import ith/3 from basics.
:- import member/2 from basics.





processGL((H :- B),I) :-
	H \= [],
	processGLBody(B,NewBody,I),
	saveRule(H,NewBody),
	saveDynamic(H).

processGL((H),_) :-
	saveRule(H,true).






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% body processing



processGLBody((A ',' R),NewBody,I) :- 
	processGLBody(A,NewHead,I),
	processGLBody(R,NewTail,I),
	concat_atom([NewHead, ',', NewTail],NewBody).




processGLBody((tnot(R)),NewAtom,I):- 
	(
		member(R,I),
		concat_atom([fail],NewAtom)
	);
	concat_atom([true],NewAtom).



processGLBody((R),R,_):-
	saveDynamic(R).
	




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Writes a rule to wherever we're telling/1
%

saveFact(Head) :-
	write(Head), write('.'), nl.

saveRule(Head,Tail) :-
	write(Head), write(':-'), write(Tail), write('.'), nl.

saveDynamic(Head) :-
	write(':-dynamic '),write(Head), write('/0.'), nl.
