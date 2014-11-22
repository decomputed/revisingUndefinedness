


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      COPY FROM HERE TO END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- import pstable_model/3 from xnmr_int.
:- import append/3 from basics.
:- import member/2 from basics.
:- import str_sub/3 from string.
:- import term_to_atom/2 from string.
:- import string_substitute/4 from string.
:- import concat_atom/2 from string.
:- import select/3 from basics.
:- import flatten/2 from basics.

:- table maxLevel/5.
:- table maxLim/4.
:- table max/3.
:- table max/2.
:- table remove/3.
:- table anonArgs/2.

:- dynamic curSM/1.
:- dynamic sModels/2.
:- dynamic functors/1.
:- dynamic exclusion/1.
:- dynamic testing/1.


genFunctorList :-
	findall([Functor,ITime,Args],symbol(Functor,Args,Functor,_,ITime,_),AllFunctorsTmp2),
	testing(Time),
	cortaAsserts(AllFunctorsTmp2,AllFunctorsTmp),
	cortaMaiores2(AllFunctorsTmp,Time,AllFunctors),
	assert(functors(AllFunctors)).





cortaAsserts([],_):-!.
	
cortaAsserts([[_,_,A]|T1],L2):-
	term_to_atom(A,NewArgs),
	str_sub('<-',NewArgs,_),!,
	cortaAsserts(T1,L2).

	
cortaAsserts([[F,T,A]|T1],[[NewF,T]|T2]):-
	flatten([F,A],Suren),!,
	NewF =.. Suren,
	cortaAsserts(T1,T2).





cortaMaiores2([],_,[]).
	
cortaMaiores2([[F,T]|T1],Lim,[F|T2]):-
	T =< Lim,!,
	cortaMaiores2(T1,Lim,T2).

cortaMaiores2([[_,_]|T1],Lim,L2):-
	cortaMaiores2(T1,Lim,L2).





nextSM:-
	curSM(N),
	NewN is N + 1,
	retractall(curSM(_)),
	assert(curSM(NewN)),
	assert(sModels(NewN,[])).


clean:-
	retractall(curSM(_)),
	retractall(sModels(_,_)),
	retractall(functors(_)),
	retractall(exclusion(_)),
	retractall(testing(_)).



doTesting(Time) :-
	retractall(testing(_)),
	assert(testing(Time)).



sm :-
	clean,
	current(N),
	doTesting(N),
	restSM,
	fail.

sm(Time) :-
	clean,
	doTesting(Time),
	restSM.
	

restSM :-
	assert(curSM(0)),
	assert(exclusion([])),
	genFunctorList,
	runPstable,
	runWf,
	writeSM,
	fail.
	
	
	
writeSM :-
	findall(X,sModels(X,_),L),
	testing(N),
	nl,nl,write('-----------------------'),nl,
	write('Modelos estaveis no instante '),write(N),nl,nl,
	doWriting(L).
	
doWriting([]) :- !,
	write('-----------------------'),nl,nl.
	
doWriting([H|T]) :-
	sModels(H,SM),
	write('---> '),write(SM),nl,
	doWriting(T),!.
	
	
	

runPstable :- 
	testing(Time),
	pstable_model(not_falso(0,Time),L,1),
	nextSM,
	curSM(S),
	processSM(L,S),
	fail.
runPstable.
	

runWf :-
	generateExclusionList,
	removeSM,
	addWf.
	
	
generateExclusionList :-
	findall(X,sModels(X,_),L),
	generateExclusion(L),
	exclusion(Ex),
	delRepeated(Ex,NewEx),
	retractall(exclusion(_)),
	assert(exclusion(NewEx)),
	
	functors(Fu),
	delRepeated(Fu,NewFu),
	remove(falso,NewFu,NewNewFu),
	removeFalses(NewNewFu,MegaNewFu),
	retractall(functors(_)),
	assert(functors(MegaNewFu)).
	

removeFalses([],[]):-!.

removeFalses([H|T1],[H|T2]) :-
	testing(N),
	holds(H,N),!,
	removeFalses(T1,T2).
	
removeFalses([_|T1],L2):-
	removeFalses(T1,L2).




	

removeSM :-
	exclusion(Ex),
	removeAll(Ex).
	

removeAll([]):-!.
	
removeAll([H|T]) :-
	functors(Ex),
	remove(H,Ex,TmpEx),
	retractall(functors(_)),
	assert(functors(TmpEx)),
	removeAll(T),!.





addWf :-
	findall(X,sModels(X,_),L),
	addT(L).
	
addT([]):-!.
	
addT([H|T]) :-
	sModels(H,L),
	functors(Ex),
	append(L,Ex,NewL),
	retractall(sModels(H,_)),
	assert(sModels(H,NewL)),
	addT(T),!.




%%%%%%%%%% Generate exclusion

generateExclusion([]):-!.

generateExclusion([H|T]):-
	sModels(H,L),
	exclusion(Ex),
	retractall(exclusion(_)),
	append(L,Ex,NewEx),
	assert(exclusion(NewEx)),
	generateExclusion(T),!.







%%%%%%%%%%% Process
processSM([],_):-!.

processSM([H|T],N):-
	term_to_atom(H,K),
	str_sub('not_',K,0),!,
	processSM(T,N).
	
processSM([H|T],N):-
	term_to_atom(H,K),
	str_sub('#',K,_),!,
	processSM(T,N).	


processSM([R|Rest],N) :-
	sModels(N,SMs),
	transform(OriginalForm,_,_,R),
	append([OriginalForm],SMs,NewSMs),
	replace(NewSMs,N),
	processSM(Rest,N),!.


%%%%%% REPLACE

replace(L,N):-
	retractall(sModels(N,_)),
	assert(sModels(N,L)).
	

%%%%%%%%% DEL REPEATED

delRepeated([],[]):-!.

delRepeated([L],[L]):-!.

delRepeated([H|T],L2):-
	member(H,T),!,
	delRepeated(T,L2).

delRepeated([H|T1],[H|T2]):-
	not member(H,T1),!,
	delRepeated(T1,T2).




%%%%%%%%% FIND REPEATED

findRepeated([],_,[]):-!.

findRepeated([H|T],L2,[H|Nt]):-
	member(H,L2),!,
	findRepeated(T,L2,Nt).

findRepeated([H|T],L2,L3):-
	not member(H,L2),!,
	findRepeated(T,L2,L3).












%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	



holds(Query) :-
	current(N),
	holds(Query,N).




holds(Query,Time) :-
   %%%%%%%%%%%%%%%%%%%%%% falta ver se um query começa com not...
	Query =.. [Functor|AnArgs],
	anonArgs(AnArgs,Args),
	findall(InsertionTime,symbol(Functor,Args,_,_,InsertionTime,_),AllTimes),
	cortaMaiores(AllTimes,Time,AllTimes2),
	runCalls(Query,AllTimes2,Time).
	

runCalls(_,[],_):-
	fail.
		
runCalls(Query,[T1|Tr],Time) :-
	(
		transform(Query,T1,Time,NewQuery),
		call(NewQuery)
	);
	runCalls(Query,Tr,Time).

	
	
cortaMaiores([],_,[]):-!.
	
cortaMaiores([H1|T1],Lim,[H1|T2]):-
	H1 =< Lim,!,
	cortaMaiores(T1,Lim,T2).

cortaMaiores([_|T1],Lim,L2):-
	cortaMaiores(T1,Lim,L2).



% descobre o nível de inserção mais recente (alto) de uma determinada regra.
% falta verificar a questão dos argumentos...




% symbol syntax
% symbol(symbolName ,args           ,refersTo ,negative   ,iTime ,event)
% symbol(a          ,[]             ,a        ,not_a      ,1     ,0). event = 1, foi um evento
% symbol(not_b      ,[]             ,b        ,b          ,0     ,1).
% symbol(assert     ,[<-(not(a),b)] ,assert   ,not_assert ,2     ,1).


maxLevel(Func,AnArgs,ITime,CTime,Level) :-
	anonArgs(AnArgs,Args),
	symbol(Func,Args,_,_,_,_),   % se falhar aqui é já sinal de que a regra q s procura nao existe
	findall(NewTime,symbol(Func,_,_,_,NewTime,1),AllList),

	AllList \= [],
	maxLim(ITime,CTime,AllList,MaxList), 

	MaxList \= [],

	max(MaxList,CTime),!,
	Level = CTime.






maxLevel(Func,AnArgs,ITime,CTime,Level) :-
	anonArgs(AnArgs,Args),
	symbol(Func,Args,_,_,_,_),!,   % se falhar aqui é já sinal de que a regra q s procura nao existe
	findall(NewTime,symbol(Func,_,_,_,NewTime,0),AllList),
	(
		(
			AllList \= [],
			maxLim(ITime,CTime,AllList,MaxList), 
			(
				(
					MaxList == [],
					Level = CTime,!
				);
				(
					max(MaxList,Level)
				)
			)
		);
		(
			% se for igual a vazio logo aqui, significa que ainda só existe o not desta regra (que nem sequer tem not)
			% vamos entao dar-lhe o tempo de inserção 0
			Level = 0
		)
	),!.

maxLevel(_,_,_,_,0).

%maxLevel(Func,AnArgs,ITime,CTime,Level):-
%	Level = 0.
	




	
	
anonArgs([],[]).

anonArgs([N|NR],['_'|R]) :-
	var(N),!,
	anonArgs(NR,R).
	
anonArgs([N|NR],[N|R]):-
	anonArgs(NR,R).
	
	





maxLim(_,_,[],[]):-!.

maxLim(Inf,Sup,Init,Final) :-
	max(Init,X),
	(X =< Sup, X >= Inf), !,
	remove(X,Init,NewL),
	maxLim(Inf,Sup,NewL,NewFinal),
	Final = [X|NewFinal].
	

maxLim(Inf,Sup,Init,Final) :-
	max(Init,X),
	remove(X,Init,NewL),
	maxLim(Inf,Sup,NewL,Final),!.


	
	



	
max([],0).	
max([E],E).
max([X|Xs],M) :-
	max(Xs,X,M).
	
max([X|Xs],Y,M) :-
	maximum(X,Y,Y1),
	max(Xs,Y1,M).
	
max([],M,M).

maximum(X,Y,Y) :-
	X =< Y,!.

maximum(X,_,X).




remove(X,[X|Xs],Ys) :-
	!,
	remove(X,Xs,Ys).
	
remove(Z,[X|Xs],[X|Ys]) :-
	!,
	remove(Z,Xs,Ys).

remove([L],[L],[]).

remove(_,[],[]).




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
	
	