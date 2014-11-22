:- import concat_atom/2 from string.
:- import ith/3 from basics.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%   geração de PCFs directos

% ler regra
% se regra tem not X, para o X em questão, retirar not X
% qq outro literal Y , gerar Y1d
% qq literal negado, gerar tnot(Z)
	



processDirect((H :- B),Atom) :-
	translateLiteral(H,NewH,direct,Atom),
	processDirectBody(B,Atom,NewB),
	(
		(
			raa(RAAset),
			ith(_,RAAset,H),
			H \= Atom,
			%translateLiteral(H,NewH2,direct,H),
			concat_atom([H,raa],NewH2),
			saveRule(NewH,NewH2)
		);
		true
	),
	saveRule(NewH,NewB).

processDirect((H),Atom) :-
	translateLiteral(H,NewH,direct,Atom),
	saveFact(NewH).






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% body processing



processDirectBody((A ',' R),Atom,NewBody) :- 
	processDirectBody(A,Atom,NewHead),
	processDirectBody(R,Atom,NewTail),
	concat_atom([NewHead, ',', NewTail],NewBody).




processDirectBody((not R),Atom,NewAtom):- 
	(
		R \= Atom,
		concat_atom([tnot,'(',R,')'],NewAtom),
		saveTable(R)
	);
	(
		concat_atom([true],NewAtom)
	).



processDirectBody((R),Atom,NewAtom):- 
	translateLiteral(R,NewAtom,direct,Atom).
	



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%    UTILS
%%


translateLiteral(H,NewH,Mode,Atom):-
	(
		(
			Mode = direct,
			raa(RAAset),
			ith(Iota,RAAset,Atom),
			concat_atom([H,Iota,d],NewH)		
		);
		(
			Mode = indirect,
			raa(RAAset),
			ith(Iota,RAAset,Atom),
			concat_atom([H,Iota,i],NewH)		
		)
	).





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
