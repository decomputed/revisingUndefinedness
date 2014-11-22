%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Includes e afins



:- import concat_atom/2 from string.
:- import term_to_atom/2 from string.
:- import term_to_codes/2 from string.
:- import atom_to_term/2 from string.
:- import append/3 from basics.
:- import length/2 from basics.
:- import member/2 from basics.
:- import flatten/2 from basics.

:- dynamic herbrand/1.



:- consult('gl.P').
:- consult('herbrand.P').
%#####################################################################################################################
%#####################################################################################################################

% Main function


calculateRWFM(T,TU,File) :-
	getT(T,File,[]),
	gamma(T,TU,File).

getT(T,File,I) :-
	gammaSquared(I,M,File),
	I = M,!,
	T = I.

getT(T,File,I) :-
	gammaSquared(I,M,File),
	getT(T,File,M).
	

gammaSquared(I,M,File) :-
	gamma(I,M1,File),
	gamma(M1,M,File),!.

gammaSquared(I,M,File).





gamma(I,M,File) :-
	clearall,
	tell('p_modulo_i.P'),
	glTransform(I,File),
	told,
	leastModel,
	herbrand(H),
	callTp(H,M),!.

gamma(I,M,File).
	
glTransform(I,File) :-
	see(File),
	loadClauses(I,ni),
	seen.


leastModel:-
	see('p_modulo_i.P'),
	loadClauses([],herbrand),
	seen,
	load_dyn('p_modulo_i.P'),	
	setof(X,herbrand(X),AllHerbrands),
	retractall(herbrand(_)),
	flatten(AllHerbrands,AllHerbrands2),
	remove(true,AllHerbrands2,AllHerbrands3),
	remove(fail,AllHerbrands3,AllHerbrands4),
	removeDuplicates(AllHerbrands4,H),
	assert(herbrand(H)).
	%write(H),nl.
	%callTp(H,M),
	%write('sai...'),nl.

	

callTp([H|T],[H|R]) :-
	call(H),
	callTp(T,R).
		
callTp([H|T],R) :-
	not call(H),
	callTp(T,R).
	
callTp([],[]).




loadClauses(I,Mode) :-
	read(C),
	( C = end_of_file -> true;
      (
      	%write(C),nl,
		(
			Mode = herbrand,
			processHerbrand(C,MiniHerbrand),
			assert(herbrand(MiniHerbrand))
		);
		(
			processGL(C,I)
		);
		true
	  ),
	loadClauses(I,Mode)
    ).
    

	
	
	
	
	
	
	
	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	


clearall:-
	retractall(herbrand(_)).

	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Writes a rule to wherever we're telling/1
%

writeRule(Head) :-
	write(Head), write('.'), nl.

writeRule(Head,Tail) :-
	write(Head), write(':-'), write(Tail), write('.'), nl.






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Igual ao addvars mas assim percebe-se....  :p
%
	
transform(OriginalForm,InsertionTime,EvaluationTime,ExtendedForm) :-
	nonvar(OriginalForm),
	OriginalForm =.. [Functor|Args],
	ExtendedForm =.. [Functor,InsertionTime,EvaluationTime|Args].
	
transform(OriginalForm,InsertionTime,EvaluationTime,ExtendedForm) :-
	var(OriginalForm),
	ExtendedForm =.. [Functor,InsertionTime,EvaluationTime|Args],
	OriginalForm =.. [Functor|Args].
	
	

	
	



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Remover as plicas inseridas p causa dos term_to_atom
%
	

removeQuotes(Quoted,Unquoted) :-
	name(Quoted,QuoteBody),
	remove(39,QuoteBody,UnQuoteBody),
	name(Unquoted,UnQuoteBody).
	
	

	
	
genNewFunctor(Rule,Fix,Prefix,NewRule):-
	(Prefix=1,
	concat_atom([Fix,Rule],NewRule));
	(Rule =.. [Rf|Ra],
	concat_atom([Rule,Rf],NewF),
	NewRule =.. [NewF|Ra]).		
	
	

	

remove(X,[X|Xs],Ys) :-
	!,
	remove(X,Xs,Ys).
	
remove(Z,[X|Xs],[X|Ys]) :-
	!,
	remove(Z,Xs,Ys).

remove(_,[],[]).


println(Line) :-
	telling(F),
	told,
	write(Line),nl,
	tell(F).
	
	
print(Line) :-
	telling(F),
	told,
	write(Line),
	tell(F).

	
writeFalso(H) :-
	write('falso <- '), write(H), write(', not '), write(H), write('.'),nl.




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
	
	
saveTable(Head) :-
	write(':-table '),write(Head), write('/0.'), nl.

	
	
remove(X,[X|Xs],Ys) :-
	!,
	remove(X,Xs,Ys).
	
remove(Z,[X|Xs],[X|Ys]) :-
	!,
	remove(Z,Xs,Ys).

remove(_,[],[]).



memberList(X,[X|_]).
memberList(X,[_|Tail]):- 
   memberList(X,Tail).
   
removeDuplicates([],[]).

removeDuplicates([X|L],Pruned):-
	memberList(Y,L), X==Y, !,
	removeDuplicates(L,Pruned).

removeDuplicates([X|L],[X|Pruned]):-
	removeDuplicates(L,Pruned).