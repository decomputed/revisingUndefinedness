%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Includes e afins


:- op(1110,xfx, '<-' ).
:- import concat_atom/2 from string.
:- import term_to_atom/2 from string.
:- import term_to_codes/2 from string.
:- import atom_to_term/2 from string.
:- import append/3 from basics.
:- import length/2 from basics.
:- import member/2 from basics.


:- dynamic current/1.
:- dynamic currentVar/1.
:- dynamic possibleDynamic/2.
:- dynamic addedRule/2.







preProcess(FileName) :-
	% from this point on, we're always writing to the file
	tell('falsus.P'),

	see(FileName),
	
	loadFalsus,
	
	seen,
	told.



	
loadFalsus :-
	read(C),
	( C = end_of_file -> true;
      (
      	%write(C),nl,
      	processFalso(C),   % todas estas clausulas vao ser adicionadas no instante 1
      	loadFalsus
      )
    ).		
	
	

processFalso((newEvents)).





processFalso((not H <- B)) :- 
	writeFalso(H),
	processFalsoBody(B),
	(
		(
			H = assert(R),
			processFalso(R)
		);
		true
	).
	
processFalso((H <- B)) :- 
	writeFalso(H),
	processFalsoBody(B),
	(
		(
			H = assert(R),
			processFalso(R)
		);
		true
	).

processFalso((not H)) :-
	writeFalso(H),
	(
		(
			H = assert(R),
			processFalso(R)
		);
		true
	).
	

processFalso((H)) :-
	writeFalso(H),
	(
		(
			H = assert(R),
			processFalso(R)
		);
		true
	).		
	
	
	

	
	
	


processFalsoBody((A ',' R)) :- 
	processFalsoBody(A),
	processFalsoBody(R).

processFalsoBody((not R)):- 
	writeFalso(R).

processFalsoBody((R)):- 
	writeFalso(R).
		
    


%#####################################################################################################################
%#####################################################################################################################

%%%%%%%%%%%%%%% READING THE MAIN PROGRAM
% tudo o q for lido aqui é introduzido a partir do instante 1

consultEvol(FileName) :-
	preProcess(FileName),

	retractall(current(_)),
	retractall(currentVar(_)),
	retractall(possibleDynamic(_,_)),
	retractall(addedRule(_,_)),
	
	% form this point on, we're always writing to the file
	tell('rule.P'),

	assert(current(1)),
	assert(currentVar(1)),
	
	see('falsus.P'),
	
	loadClauses,
	
	seen,
	
	
	
	see(FileName),
	

	
	loadClauses,
	
	%%%%%%%%%%%%%%%%%
	% agora vamos escrever os dynamics...
	writeDynamics,
	
	
	%%%%%%%%%%%%%%%%%
	% agora vamos escrever o último instante
	current(Cur),
	write('current('),write(Cur),write(').'),nl,
	write(':- ensure_loaded( auxFile ).'),nl,
	
	seen,
	told.
	
	
	





loadClauses :-
	read(C),
	( C = end_of_file -> true;
      (
      	%write(C),nl,
      	current(N),
      	process(C,N,[]),   % todas estas clausulas vao ser adicionadas no instante 1
      	loadClauses
      )
    ).
    
    
% adjusting the current var
newVar(L) :-
	currentVar(V),
	concat_atom(['''','_evv',V,''''],L),
	NewV is V+1,
	retractall(currentVar(_)),
	assert(currentVar(NewV)).
	


% replacing vars
replaceVars([],[]).

replaceVars([N|NR],[CH|R]) :-
	var(N),!,
	newVar(CH),
	replaceVars(NR,R).
	
replaceVars([N|NR],[N|R]):-
	replaceVars(NR,R).







% checking and writing the dynamics
writeDynamics:-
	findall([Func,Arity],possibleDynamic(Func,Arity),Dynamics),
	findall([Func,Arity],addedRule(Func,Arity),Added),
	getNotAdded(Dynamics,Added,NotAdded),
	NotAdded \= [],!,
	writeDynamics(NotAdded).

writeDynamics.


writeDynamics([]).
writeDynamics([[F,A]|R]) :-
	concat_atom([':- dynamic ',F,'/',A],DynamicRule),
	writeRule(DynamicRule),
	writeDynamics(R).



% get all not added facts
getNotAdded([],_,[]):-!.


getNotAdded([H|T],Added,[H|NA]):-
	not(member(H,Added)),!,
	getNotAdded(T,Added,NA).
	
getNotAdded([_|T],Added,NA):-
	getNotAdded(T,Added,NA),!.







	
	
%%%%%%%%%%%%%%%%%%%%%%% Processing



process((newEvents),T,_) :-
	NewT is T + 1,
	retractall(current(_)),
	assert(current(NewT)).

	
	

	
	
myLength([],0).

myLength([H|T],N):-
	((
		var(H),
		Z=1
	);
	(
		Z=0
	)),
	myLength(T,G),
	N is G + Z,!.
	
	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     NOT A <- B	
	
process((not H <- B),T,Assert) :-

	
	
	% Verificação de se é ou não um evento...
	((
		Assert == [],
		current(N),
		N > 1,
		Event = 1
	);
	(
		Event = 0
	)),




	%%%%%%%%%%%%%%%% HEAD da Regra   --------------------------
	
	H =.. [Functor|OldArgs],
	replaceVars(OldArgs,Args),
	

	
	concat_atom(['not','_',Functor],TransformedFunctor),        % TFunctor tem not_suren
	TransformedHead =.. [TransformedFunctor|Args],              % THead tem not_suren(ARGS)
	((
		Event = 1,
		transform(TransformedHead,T,T,NewHead2)                   % NewHead = not_regra(T,X,ARGS)
	);
	(
		transform(TransformedHead,T,'X',NewHead2)                   % NewHead = not_regra(T,X,ARGS)
	)),
	
	term_to_atom(NewHead2,NewHeadQuote),
	removeQuotes(NewHeadQuote,NewHead),

		
	(
		(
			B \= [],
	
			%%%%%%%%%%%%%%%% BODY da Regra      --------------------------------
			concat_atom([TransformedFunctor,'_','body'],NewBody),              % NewBody = not_regra_body
		 	TransformedBodyHead =.. [NewBody|Args],                            % TransformedBodyHead = not_regra_body(ARGS)
		 	
		 	
		 	((
				Event = 1,
				transform(TransformedBodyHead,T,T,TransformedBody)              % TransformedBody = not_regra_body(T,X,ARGS) *(SEM ARGS)
		 	);
		 	(
		 		transform(TransformedBodyHead,T,'X',TransformedBody)              % TransformedBody = not_regra_body(T,X,ARGS) *(SEM ARGS)
		 	)),
		 	TransformedBody =.. [_|VeryArgs],
		 	term_to_atom(TransformedBody,TransformedBodyFinal2),
		 	removeQuotes(TransformedBodyFinal2,TransformedBodyFinal),
		
		 	
		 	 	
		  	%%%%%%%%%%%%%%%% Corpo do BODY     
		  	processBody(B,T,SemiFinalBody,Assert),
		  	removeQuotes(SemiFinalBody,FinalBody)
		);
		true
	),
		
 	
 	
 	

 	
 	
 	%%%%%%%%%%%%%%% Restrição do complementar    -----------------------------
 	TransformedCompl =.. [Functor|Args],                            % TransformedBodyHead = not_regra_body(ARGS)
 	((
		Event = 1,
		transform(TransformedCompl,'Level',T,ComplTransformedBody)              % TransformedBody = not_regra_body(T,X,ARGS) *(SEM ARGS)
	);
	(
		transform(TransformedCompl,'Level','X',ComplTransformedBody)              % TransformedBody = not_regra_body(T,X,ARGS) *(SEM ARGS)
	)),
	ComplRule =.. ['tnot',ComplTransformedBody],
	term_to_atom(ComplRule,ComplRuleQuote),

	%ComplTransformedBody =.. [_|ComplArgs],

 	%%%%%%%%%%%%%%%% geração do maxLevel       ----------------------------------
 	((
		Event = 1,
 		MaxLevel =.. ['maxLevel',Functor,Args,T,T,'Level']
 	);
 	(
 		MaxLevel =.. ['maxLevel',Functor,Args,T,'X','Level']
 	)),
 	term_to_atom(MaxLevel,MaxLevelQuotes),

 	
	
 	%%%%%%%%%%%%%%% Concatenação do BODY todo
	(
		(
			B \= [],
			Event = 0,
			concat_atom([TransformedBodyFinal,',',MaxLevelQuotes,',',ComplRuleQuote],AllBody2)
		);
		(
			B \= [],
			concat_atom([TransformedBodyFinal],AllBody2)
		);
		(
			Event = 0,
			concat_atom([MaxLevelQuotes,',',ComplRuleQuote],AllBody2)
		);
		(
			AllBody2 = []
		)
	),
	(
		(
			Assert \= [],
			concat_atom([Assert,',',AllBody2],AllBody)
		);concat_atom([AllBody2],AllBody)
	),
  	removeQuotes(AllBody,FullBody),
  	
  	

 	%%%%%%%%%%%%%%%%% falsum   ---------------------------------------
 	transform(TransformedHead,0,0,FalsumHead2),                    % em falsumHead está not_regra(0,0,ARGS)
 	term_to_atom(FalsumHead2,FalsumHeadQuote),
 	removeQuotes(FalsumHeadQuote,FalsumHead),
 	%FalsumHead2 =.. [_|FalsumArgs],
	

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% este ainda n tá activo...
	
	
	%%%%%%%%%%%%%%%%% falsum
	%%%%%%%% FACTO
	%transform(TransformedHead,0,0,FalsumFact),
	%FalsumFact =..[_|FalsumFactArgs], 
	%term_to_atom(FalsumFact,FalsumFactQuotes),
	%removeQuotes(FalsumFactQuotes,FalsumFactFinal),
	



	%%%%%%%% CABEÇA DA REGRA	
	%transform(TransformedHead,0,'X',FalsumRuleHead),
	%FalsumRuleHead =..[_|FalsumRuleArgs],
	%term_to_atom(FalsumRuleHead,FalsumRuleHeadFinal),
	


	%%%%%%%% MAXLEVEL
%	anonArgs(VeryArgs,AnonVeryArgs),
 	%FalsumMaxLevel =.. ['maxLevel',Functor,Args,0,'X','Level'],
	%term_to_atom(FalsumMaxLevel,FalsumMaxLevelFinal),



	%%%%%%%% COMPLEMENTAR
	%transform(H,'Level','X',FalsumCompl),          
	%term_to_atom(FalsumCompl,FalsumComplFinal),

	%FalsumComplRule =.. ['tnot',FalsumCompl],
	%term_to_atom(FalsumComplRule,FalsumComplRuleFinal),



	%%%%%%%% CONCATENACAO
	%concat_atom([FalsumRuleHeadFinal,':-',FalsumMaxLevelFinal,',',FalsumComplRuleFinal],FalsumRuleQuote),
	%removeQuotes(FalsumRuleQuote,FalsumRule),
	
	

	% fim do "este ainda n tá activo"
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 	
	%%%%%%%%%%%%%%%%% symbol table   -------------------------------------------
	
	Symbol2 =.. [symbol,TransformedFunctor,Args,Functor,Functor,T,Event],
	term_to_atom(Symbol2,SymbolQuote),
	removeQuotes(SymbolQuote,Symbol),
	
	SymbolFalsum2 =.. [symbol,TransformedFunctor,Args,Functor,Functor,0,Event],
	term_to_atom(SymbolFalsum2,SymbolFalsumQuote),
	removeQuotes(SymbolFalsumQuote,SymbolFalsum),
	
		
	
	%%%%%%%%%%%%%%%%% tablings        -----------------------------------------------------------
	length(VeryArgs,Len),
	concat_atom([':- table ',TransformedFunctor,'/',Len],TableRule),
	
	

 	%%%%%%%%%%%%%%%%% Escrita desta regra Toda
	
 	writeRule(TableRule),
 	writeRule(Symbol),
 	writeRule(SymbolFalsum),
 	writeRule(FalsumHead),
 	%writeRule(FalsumRule),
 	(
	 	(
	 		FullBody \= [],
	 		writeRule(NewHead,FullBody)
	 	);
	 	(
	 		writeRule(NewHead)
	 	)
 	),
 	(
		(
			B \= [],
 			writeRule(TransformedBodyFinal,FinalBody)
 		);
 		true
 	),
 	
 	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%  se for um assert, ainda temos coisas p fazer...
	
	((
		Functor = 'assert',
		AssertT is T + 1,
		Args = [Inside],
		transform(Suren,O,P,NewHead2),
		(
			(
				atom(P),
				transform(Suren,O,'Z',NewHead3),
				term_to_atom(NewHead3,NewHead3Quote),
				removeQuotes(NewHead3Quote,NewHead3Final),
				concat_atom(['decrement(X,Z)',',',NewHead3Final],AssertHead)
			);
				AssertHead = NewHead
		),
		process(Inside,AssertT,AssertHead)
	);
		true
	).

	
	
	





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     A <- B

process((H <- B),T,Assert) :-


	% Verificação de se é ou não um evento...
	((
		Assert == [],
		current(N),
		N > 1,
		Event = 1
	);
	(
		Event = 0
	)),


	%%%%%%%%%%%%%%%% HEAD da Regra   --------------------------
	H =.. [Functor|OldArgs],
	replaceVars(OldArgs,Args),
	TransformedHead =.. [Functor|Args],
	
	
	
	
	%%%%%%%%%%%%%%%% HEAD da Regra
	((
		Event = 1,
		transform(TransformedHead,T,T,NewHead2)                                               % em NewHead já tenho a(1,X,ARGS)
	);
	(
		transform(TransformedHead,T,'X',NewHead2)
	)),                                               % em NewHead já tenho a(1,X,ARGS)
	term_to_atom(NewHead2,NewHeadQuote),
	removeQuotes(NewHeadQuote,NewHead),
	
	%%%%%%%%%%%%%%%%% just a peek at the args...
	NewHead2 =.. [_|VeryArgs],                                      % Functor tem só "A"

	
	


	
	
	
	(
		(
			B \= [],
			%%%%%%%%%%%%%%%% BODY da Regra
			concat_atom([Functor,'_','body'],NewBody),                        % NewBody tem " a_Body "
			
			TransformedBodyHead =.. [NewBody|Args],                            % TransformedBodyHead = not_regra_body(ARGS)
			
			((
				Event = 1,
		 		transform(TransformedBodyHead,T,T,TransformedBody)              % TransformedBody = not_regra_body(T,X,ARGS) *(SEM ARGS)
		 	);
		 	(
		 		transform(TransformedBodyHead,T,'X',TransformedBody)              % TransformedBody = not_regra_body(T,X,ARGS) *(SEM ARGS)
		 	)),
		 	term_to_atom(TransformedBody,TransformedBodyQuote),
		 	removeQuotes(TransformedBodyQuote,TransformedBodyFinal),
			
			
			%%%%%%%%%%%%%%%% Corpo do BODY                         Já lá vamos
			processBody(B,T,SemiFinalBody,Assert),
			removeQuotes(SemiFinalBody,FinalBody)
		);
		true
	),
	
	
	%%%%%%%%%%%%%%% Restrição do complementar
	concat_atom(['not_',Functor],ComplFunctor),                                  % ComplFunctor passa a ter not_a
	TransformedCompl =.. [ComplFunctor|Args],
	((
		Event = 1,
		transform(TransformedCompl,'Level',T,ComplTransformedBody)              % TransformedBody = not_regra_body(T,X,ARGS) *(SEM ARGS)
	);
	(
		transform(TransformedCompl,'Level','X',ComplTransformedBody)              % TransformedBody = not_regra_body(T,X,ARGS) *(SEM ARGS)
	)),
	ComplRule =.. ['tnot',ComplTransformedBody],
	term_to_atom(ComplRule,ComplRuleQuote),
	

	%ComplTransformedBody =.. [_|ComplArgs],
	

	
	%%%%%%%%%%%%%%%% geração do maxLevel
	((
		Event = 1,
 		MaxLevel =.. ['maxLevel',ComplFunctor,Args,T,T,'Level']
 	);
 	(
 		MaxLevel =.. ['maxLevel',ComplFunctor,Args,T,'X','Level']
 	)),
 	term_to_atom(MaxLevel,MaxLevelQuotes),
 		
	
	
	%%%%%%%%%%%%%%% Concatenação do BODY todo
	(
		(
			B \= [],
			Event = 0,
			concat_atom([TransformedBodyFinal,',',MaxLevelQuotes,',',ComplRuleQuote],AllBody2)
		);
		(
			B \= [],
			concat_atom([TransformedBodyFinal],AllBody2)
		);
		(
			Event = 0,
			concat_atom([MaxLevelQuotes,',',ComplRuleQuote],AllBody2)
		);
		(
			AllBody2 = []
		)
	),
	
	(
		(
			Assert \= [],
			concat_atom([Assert,',',AllBody2],AllBody)
		);concat_atom([AllBody2],AllBody)
	),
	
	removeQuotes(AllBody,FullBody),
	
	
	
	%%%%%%%%%%%%%%%%% falsum
	%%%%%%%% FACTO
	transform(TransformedCompl,0,0,FalsumFact),
	%FalsumFact =..[_|FalsumFactArgs], 
	term_to_atom(FalsumFact,FalsumFactQuotes),
	removeQuotes(FalsumFactQuotes,FalsumFactFinal),
	



	%%%%%%%% CABEÇA DA REGRA	
	transform(TransformedCompl,0,'X',FalsumRuleHead),
	%FalsumRuleHead =..[_|FalsumRuleArgs],
	term_to_atom(FalsumRuleHead,FalsumRuleHeadFinal),
	


	%%%%%%%% MAXLEVEL
%	anonArgs(VeryArgs,AnonVeryArgs),
 	FalsumMaxLevel =.. ['maxLevel',Functor,Args,0,'X','Level'],
	term_to_atom(FalsumMaxLevel,FalsumMaxLevelFinal),



	%%%%%%%% COMPLEMENTAR
	transform(TransformedHead,'Level','X',FalsumCompl),          
	%term_to_atom(FalsumCompl,FalsumComplFinal),

	FalsumComplRule =.. ['tnot',FalsumCompl],
	term_to_atom(FalsumComplRule,FalsumComplRuleFinal),



	%%%%%%%% CONCATENACAO
	concat_atom([FalsumRuleHeadFinal,':-',FalsumMaxLevelFinal,',',FalsumComplRuleFinal],FalsumRuleQuote),
	removeQuotes(FalsumRuleQuote,FalsumRule),
	
	
	
	
	%%%%%%%%%%%%%%%%% symbol table
	
	SymbolQuote2 =.. [symbol,Functor,Args,Functor,ComplFunctor,T,Event],
	term_to_atom(SymbolQuote2,SymbolQuote),
	removeQuotes(SymbolQuote,Symbol),
	
	SymbolComplRuleQuote2 =.. [symbol,ComplFunctor,Args,Functor,Functor,0,Event],
	term_to_atom(SymbolComplRuleQuote2,SymbolComplRuleQuote),
	removeQuotes(SymbolComplRuleQuote,SymbolComplRule),
	
	SymbolComplFactQuote2 =.. [symbol,ComplFunctor,Args,Functor,Functor,0,Event],
	term_to_atom(SymbolComplFactQuote2,SymbolComplFactQuote),
	removeQuotes(SymbolComplFactQuote,SymbolComplFact),
	

	
	%%%%%%%%%%%%%%%%% tablings
	length(VeryArgs,Len),
	concat_atom([':- table ',Functor,'/',Len],TableRule),
	concat_atom([':- table ',ComplFunctor,'/',Len],TableRuleCompl),
	%concat_atom([':- dynamic ',Functor,'/',Len],DynamicRuleMain),


	%%%%%%%%%%%%%%%%% Escrita desta regra Toda
	%writeRule(DynamicRuleMain),
	writeRule(TableRule),
	writeRule(TableRuleCompl),
	writeRule(Symbol),
	writeRule(SymbolComplRule),
	writeRule(SymbolComplFact),
	writeRule(FalsumFactFinal),
	writeRule(FalsumRule),
	(
	 	(
	 		FullBody \= [],
	 		writeRule(NewHead,FullBody)
	 	);
	 	(
	 		writeRule(NewHead)
	 	)
 	),
	(
		(
			B \= [],
 			writeRule(TransformedBodyFinal,FinalBody)
 		);
 		true
 	),
	
	% dizer q esta regra já foi adicionada
	assert(addedRule(Functor,Len)),
	assert(possibleDynamic(Functor,Len)),
	
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%  se for um assert, ainda temos coisas p fazer...
	
	((
		Functor = 'assert',
		AssertT is T + 1,
		Args = [Inside],
		transform(Suren,O,P,NewHead2),
		(
			(
				atom(P),
				transform(Suren,O,'Z',NewHead3),
				term_to_atom(NewHead3,NewHead3Quote),
				removeQuotes(NewHead3Quote,NewHead3Final),
				concat_atom(['decrement(X,Z)',',',NewHead3Final],AssertHead)
			);
				AssertHead = NewHead
		),
		process(Inside,AssertT,AssertHead)
	);
		true
	).
	
	




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        NOT A



process((not H),T,Assert) :-

	process((not H <- []),T,Assert).


	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     A


process((H),T,Assert) :-
	
	process((H <- []), T,Assert).
	
	











%%%%%%%%%%%%%%%%%%%%%%%#############################################################################
%%%%%%%%%%%%%%%%%%%%%%%#############################################################################
%%%%%%%%%%%%%%%%%%%%%%%#############################################################################
% body processing



processBody((A ',' R),T,NewBody,Assert) :- 
	processBody(A,T,NewHead,Assert),
	processBody(R,T,NewTail,Assert),
	concat_atom([NewHead, ',', NewTail],NewBody).





processBody((not R),T,NewAtom,Assert):- 
	% tratar do not
	R =.. [Functor|OldArgs],
	replaceVars(OldArgs,Args),
	concat_atom(['not','_',Functor],TransformedFunctor),


	% nova var
	newVar(ThisLevel),
	

	% fazer a cabeça
	TransformedAtom =.. [TransformedFunctor|Args],
	((
		Assert == [],
		current(N),
		N > 1,
		transform(TransformedAtom,ThisLevel,T,AlmostNewAtom)
	);
	(
		transform(TransformedAtom,ThisLevel,'X',AlmostNewAtom)
	)),
	
	term_to_atom(AlmostNewAtom,NewAtomFinal),
	
	AlmostNewAtom =.. [_|VeryArgs],
	
	% adicionar o maxLevel
%	anonArgs(VeryArgs,AnonVeryArgs),
	((
		Assert == [],
		current(N),
		N > 1,
		MaxLevel =.. ['maxLevel',TransformedFunctor,Args,0,T,ThisLevel]
	);
	(
		MaxLevel =.. ['maxLevel',TransformedFunctor,Args,0,'X',ThisLevel]
	)),
	term_to_atom(MaxLevel,MaxLevelFinal),

	% full atom
	concat_atom([MaxLevelFinal,',',NewAtomFinal],NewAtom),
	
	
	
	
	%%%%%%%%%%%%%%%%% falsum   ---------------------------------------
 	% os falsum de regras com not à cabeça não precisam de mais nenhuma regra.
 	% o próprio not persiste. basta o not_blah(0,0).
 	TransformedAtom = TransformedCompl,
 	TransformedCompl =.. [ComplFunctor|_],
 	transform(TransformedCompl,0,0,FalsumFact),                    % em falsumHead está not_regra(0,0,ARGS)
 	%FalsumFact =.. [_|FalsumFactArgs],
 	term_to_atom(FalsumFact,FalsumFactQuotes),
	removeQuotes(FalsumFactQuotes,FalsumFactFinal),




	%%%%%%%% CABEÇA DA REGRA	
	transform(TransformedCompl,0,'X',FalsumRuleHead),
	%FalsumRuleHead =..[_|FalsumRuleArgs],
	term_to_atom(FalsumRuleHead,FalsumRuleHeadFinal),
	


	%%%%%%%% MAXLEVEL
%	anonArgs(VeryArgs,AnonVeryArgs),
	FalsumMaxLevel =.. ['maxLevel',Functor,Args,0,'X','Level'],
	term_to_atom(FalsumMaxLevel,FalsumMaxLevelFinal),


	%%%%%%%% COMPLEMENTAR
	transform(R,'Level','X',FalsumCompl),          
	%term_to_atom(FalsumCompl,FalsumComplFinal),

	FalsumComplRule =.. ['tnot',FalsumCompl],
	
	term_to_atom(FalsumComplRule,FalsumComplRuleFinal),
 	
 	

 	SymbolComplRuleQuote2 =.. [symbol,ComplFunctor,Args,Functor,Functor,0,0],
	term_to_atom(SymbolComplRuleQuote2,SymbolComplRuleQuote),
	removeQuotes(SymbolComplRuleQuote,SymbolComplRule),

	
	SymbolComplFactQuote2 =.. [symbol,ComplFunctor,Args,Functor,Functor,0,0],
	term_to_atom(SymbolComplFactQuote2,SymbolComplFactQuote),
	removeQuotes(SymbolComplFactQuote,SymbolComplFact),
 	
 	
 	%%%%%%%% CONCATENACAO
	concat_atom([FalsumRuleHeadFinal,':-',FalsumMaxLevelFinal,',',FalsumComplRuleFinal],FalsumRuleQuote),
	removeQuotes(FalsumRuleQuote,FalsumRule),
	
	length(VeryArgs,Len),
	concat_atom([':- table ',Functor,'/',Len],TableRuleMain),
	%concat_atom([':- dynamic ',Functor,'/',Len],DynamicRuleMain),
	assert(possibleDynamic(Functor,Len)),
	concat_atom([':- table ',ComplFunctor,'/',Len],TableRuleCompl),
	
%	writeRule(DynamicRuleMain),
	writeRule(TableRuleMain),
	writeRule(TableRuleCompl),
	writeRule(SymbolComplRule),
	writeRule(SymbolComplFact),
	writeRule(FalsumFactFinal),
	writeRule(FalsumRule).






processBody((R),T,NewAtom,Assert):- 
	R =.. [Functor|OldArgs],
	replaceVars(OldArgs,Args),
	TransformedAtom =.. [Functor|Args],

	% nova var
	newVar(ThisLevel),

	% fazer a cabeça
	((
		Assert == [],
		current(N),
		N > 1,
		transform(TransformedAtom,ThisLevel,T,AlmostNewAtom)
	);
	(
		transform(TransformedAtom,ThisLevel,'X',AlmostNewAtom)
	)),
	term_to_atom(AlmostNewAtom,NewAtomFinal),
	
	AlmostNewAtom =.. [_|VeryArgs],
	
	%adicionar o maxLevel
%	anonArgs(VeryArgs,AnonVeryArgs),
 	((
		Assert == [],
		current(N),
		N > 1,
		MaxLevel =.. ['maxLevel',Functor,Args,0,T,ThisLevel]
	);
	(
		MaxLevel =.. ['maxLevel',Functor,Args,0,'X',ThisLevel]
	)),
	term_to_atom(MaxLevel,MaxLevelFinal),
	

	% full atom
	concat_atom([MaxLevelFinal,',',NewAtomFinal],NewAtom),

	
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% faltava o falsum
	concat_atom(['not_',Functor],ComplFunctor),                                  % ComplFunctor passa a ter not_a
	TransformedCompl =.. [ComplFunctor|Args],


	%%%%%%%%%%%%%%%%% falsum
	%%%%%%%% FACTO
	transform(TransformedCompl,0,0,FalsumFact),
	%FalsumFact =..[_|FalsumFactArgs], 
	term_to_atom(FalsumFact,FalsumFactQuotes),
	removeQuotes(FalsumFactQuotes,FalsumFactFinal),




	%%%%%%%% CABEÇA DA REGRA	
	transform(TransformedCompl,0,'X',FalsumRuleHead),
	%FalsumRuleHead =..[_|FalsumRuleArgs],
	term_to_atom(FalsumRuleHead,FalsumRuleHeadFinal),
	


	%%%%%%%% MAXLEVEL
%	anonArgs(VeryArgs,AnonVeryArgs),
	FalsumMaxLevel =.. ['maxLevel',Functor,Args,0,'X','Level'],
	term_to_atom(FalsumMaxLevel,FalsumMaxLevelFinal),


	%%%%%%%% COMPLEMENTAR
	transform(TransformedAtom,'Level','X',FalsumCompl),          
	%term_to_atom(FalsumCompl,FalsumComplFinal),

	FalsumComplRule =.. ['tnot',FalsumCompl],
	
	term_to_atom(FalsumComplRule,FalsumComplRuleFinal),
	
	
	SymbolComplRuleQuote2 =.. [symbol,ComplFunctor,Args,Functor,Functor,0,0],
	term_to_atom(SymbolComplRuleQuote2,SymbolComplRuleQuote),
	removeQuotes(SymbolComplRuleQuote,SymbolComplRule),

	
	SymbolComplFactQuote2 =.. [symbol,ComplFunctor,Args,Functor,Functor,0,0],
	term_to_atom(SymbolComplFactQuote2,SymbolComplFactQuote),
	removeQuotes(SymbolComplFactQuote,SymbolComplFact),

	length(VeryArgs,Len),
	concat_atom([':- table ',ComplFunctor,'/',Len],TableRuleCompl),
	concat_atom([':- table ',Functor,'/',Len],TableRuleMain),
	%concat_atom([':- dynamic ',Functor,'/',Len],DynamicRuleMain),
	assert(possibleDynamic(Functor,Len)),
	
	%%%%%%%% CONCATENACAO
	concat_atom([FalsumRuleHeadFinal,':-',FalsumMaxLevelFinal,',',FalsumComplRuleFinal],FalsumRuleQuote),
	removeQuotes(FalsumRuleQuote,FalsumRule),

%	writeRule(DynamicRuleMain),
	writeRule(TableRuleMain),
	writeRule(TableRuleCompl),
	writeRule(SymbolComplRule),
	writeRule(SymbolComplFact),
	writeRule(FalsumFactFinal),
	writeRule(FalsumRule).
	






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



	