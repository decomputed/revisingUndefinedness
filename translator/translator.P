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

:- dynamic pos/1, neg/1, raa/1, tails/2.



:- consult('raa2.P').
:- consult('direct.P').
:- consult('indirect.P').
:- consult('tails.P').
:- consult('preprocess.P').

%#####################################################################################################################
%#####################################################################################################################

%%%%%%%%%%%%%%% READING THE MAIN PROGRAM

consultRaa(File):-
	clearall,
	generateRAAset(File),
	raa(RAASet),
	generateTailSet(RAASet,File),
	tell('raa.P'),
	generateProgramCopy(File),
	generateDirectCFP(RAASet,File),
	generateIndirectCFP(RAASet,File),
	generateAuxRules(RAASet),
	told,
	consult('raa.P').

	
	
	
	
	
%%%%%%%%%%%%%%%%%%%%%% auxiliary rules

generateAuxRules([H|T]):-
	concat_atom([H,raa],HeadRAA),
	translateLiteral(H,DirectH,direct,H),
	translateLiteral(H,IndirectH,indirect,H),
	tails(H,TailSet),
	generateTailNegation(NegatedTail,TailSet),
	concat_atom([NegatedTail,',',IndirectH],IndirectH2),
	concat_atom([NegatedTail,',',DirectH],DirectH2),
	saveTable(DirectH),
	saveRule(HeadRAA,DirectH2),
	saveRule(HeadRAA,IndirectH2),
	saveRule(H,HeadRAA),
	generateAuxRules(T).
	
generateAuxRules([]).



%%%%%%%%%%%%%%%%%%% generate tnots for tails
generateTailNegation(NegatedTail,[H|T]):-
	concat_atom([tnot,'(',H,')'],OneTail),
	generateTailNegation(SubNegatedTail,T),
	concat_atom([OneTail,',',SubNegatedTail],PreNegatedTail),
	NegatedTail = PreNegatedTail.
		
		
generateTailNegation(NegatedTail,[]):-
	NegatedTail = true.

	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generates all direct cfps	
generateDirectCFP([H|T],File):-
	generateDirectOLONSet(H,File),
	generateDirectCFP(T,File).

generateDirectCFP(Atom,File):-
	generateDirectOLONSet(Atom,File).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generates all indirect cfps	
generateIndirectCFP([H|T],File):-
	generateIndirectOLONSet(H,File),
	generateIndirectCFP(T,File).

generateIndirectCFP(Atom,File):-
	generateIndirectOLONSet(Atom,File).



	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generates the RAA set and asserts it

generateRAAset(File):-
	see(File),
	loadClauses(raa,null),
	generateRAAset,
	seen.

generateProgramCopy(File) :-
	see(File),
	loadClauses(preprocess,null),
	seen.

	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tails set
generateTailSet([H|T],File):-
	generateTails(H,File),
	generateTailSet(T,File).
	
generateTailSet([],_).
	



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% guren for one tail

generateTails(Atom,File) :-
	see(File),
	loadClauses(tail,Atom),
	setof(X,tails(Atom,X),AllTails),
	retractall(tails(Atom,_)),
	flatten(AllTails,AllTails2),
	remove(ni,AllTails2,AllTails3),
	assert(tails(Atom,AllTails3)),
	seen.
	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generates a direct cfp for some atom
	
generateDirectOLONSet(Atom,File):-
	see(File),
	loadClauses(direct,Atom),
	seen.
	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generates a direct cfp for some atom
	
generateIndirectOLONSet(Atom,File):-
	see(File),
	loadClauses(indirect,Atom),
	seen.

	


loadClauses(X,Atom) :-
	read(C),
	( C = end_of_file -> true;
      (
      	%write(C),nl,
		(
			(
				X = raa,
				processRAA(C)
			);
			(
				X = direct,
				processDirect(C,Atom)
			);
			(
				X = indirect,
				processIndirect(C,Atom)
			);
			(
				X = tail,
				processTail(Tails,C,Atom),
				assert(tails(Atom,Tails))
			);
			(
				X = preprocess,
				process(C)
			);
			true
		),
      	loadClauses(X,Atom)
      )
    ).
    

	
	
clearall:-
	retractall(pos(_)),
	retractall(neg(_)),
	retractall(raa(_)),
	retractall(tails(_,_)).

	
	
	
	
	
	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	

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

