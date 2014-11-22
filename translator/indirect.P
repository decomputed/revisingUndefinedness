:- import concat_atom/2 from string.
:- import ith/3 from basics.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%   geração de PCFs directos

% ler regra
% se regra tem not X, para o X em questão, retirar not X
% qq outro literal Y , gerar Y1i
% qq literal negado, gerar tnot(Z1i)
% adicionalmente, gerar versão alterada do pcf(d) p este
	



processIndirect((H :- B),Atom) :-
	translateLiteral(H,NewH,indirect,Atom),
	(
		(
			raa(RAAset),
			ith(_,RAAset,H),
			H \= Atom,
			%translateLiteral(H,NewH2,indirect,H),
			concat_atom([H,raa],NewH2),
			saveRule(NewH,NewH2)
		);
		true
	),
	processIndirectBody(B,Atom,NewB),
	processIndirectBody2(B,Atom,NewB2),
	concat_atom([NewB2,',',tnot,'(',H,')'],NewB3),
	saveRule(NewH,NewB),
	saveRule(NewH,NewB3).

processIndirect((H),Atom) :-
	translateLiteral(H,NewH,indirect,Atom),
	saveFact(NewH).






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% body processing



processIndirectBody((A ',' R),Atom,NewBody) :- 
	processIndirectBody(A,Atom,NewHead),
	processIndirectBody(R,Atom,NewTail),
	concat_atom([NewHead, ',', NewTail],NewBody).




processIndirectBody((not R),Atom,NewAtom):- 
	(
		R \= Atom,
		translateLiteral(R,NewR,indirect,Atom),
		concat_atom([tnot,'(',NewR,')'],NewAtom),
		saveTable(NewR)
	);
	(
		concat_atom([true],NewAtom)
	).



processIndirectBody((R),Atom,NewAtom):- 
	translateLiteral(R,NewAtom,indirect,Atom).
	

processIndirectBody2((A ',' R),Atom,NewBody) :- 
	processIndirectBody2(A,Atom,NewHead),
	processIndirectBody2(R,Atom,NewTail),
	concat_atom([NewHead, ',', NewTail],NewBody).




processIndirectBody2((not R),Atom,NewAtom):- 
	(
		R \= Atom,
		concat_atom([tnot,'(',R,')'],NewAtom)
	);
	(
		concat_atom([true],NewAtom)
	).



processIndirectBody2((R),Atom,NewAtom):- 
	translateLiteral(R,NewAtom,indirect,Atom).
	


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
