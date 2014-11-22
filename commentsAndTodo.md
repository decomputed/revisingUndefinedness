to check on web
================================

- Onde é q isto foi publicado afinal d contas...
	M. Gelfond. On stratified autoepistemic theories. In M. Kaufman, editor, AAAI87, pages 207211, 1987.
	Editora do Californication
	
	
- missing on the text
	. as referências das várias abordagens à WFS
	. a referência ao prolegomena
	. corrigir a referência para o XSB-Prolog (site e isso)
	. referência para a tese o joão alcântara
	. os outros artigos dos RSMs
	. 
	
	
coments:
==========================


- O Inglês do sumário está deficiente...bem como o
dizer-se que a WFS não dá significado aos loops. Dizer que são indefinidos é
dar significado...


- Falta uma secção de método top-down, e a relação com o método top-down rSM, provando-se a correcção com respeito aos rSM. Também aí interessa as variantes de avaliação de que falámos. 

Alterações de fundo
===============================

- História do RAA não ser raciocínio clássico
A questão, como inclusivamente está na tese do alex, é que o princípio de RAA surge como uma extensão ao suporte clássico na medida em que segundo a noção de suporte clássico, uma conclusão tem de estar baseada em premissas verdadeiras. Ora no raciocínio por RAA, concluímos coisas não por as suas premissas serem verdadeiras mas porque elas, contradizendo a conclusão, não podem ser falsas. Deste ponto de vista o raciocínio por RAA poderia ser considerado como raciocínio por imposição ou por necessidade de haver coerência nas coisas (nada de haver ao mesmo tempo coisas falsas e verdadeiras), não sendo portanto clássico. 

Porém, do ponto de vista histórico, RAA é um princípio antigo como os gregos (literalmente! O aristóteles e o Euclides eram fãs...) e desse ponto de vista será considerado clássico. Aliás, podemos não ter a imposição de que uma conclusão seja baseda em premissas verdadeiras mas temos a imposição de que uma conclusão não seja baseada em premissas não verdadeiras, que a dois valores me parece que é o mesmo... e portanto, vai de encontro à ideia de suporte clássico.

posto isto, como é q eu devo chamar à coisa? é uma forma de raciocínio não clássico ou não?

- Nunca defino sporte....
- Mais exemplos
- Mal explicada a questão dos problemas de complexidade... problema ou característica?

- Tal como a questão da expressividade....

A questãoda expressividade também pode ser vista de dois pontos de vista diferentes. WFS é expressiva porque emprega 3 valores de verdade, o que lhe permite expressar todos os casos 

- um programa que foi apresentado:

	a <- b, c
	b <- d, e, f
	d <- not a
	e <- not w
	f <- not c
	
	
	c <-d, e, f
	
	
	e adicionando as extension rules
	
- há questões de fundo relacionadas c a notação... em particular:
	- página 9: notação p variável X é igual à dos literais
	- página 10: nos NLPs e nos DPs a cena do "coutable" set of rules. countable? então e os infinite?
	- página 10/11: ground atoms instead of atoms/literals?
	- página 11: as cenas do |=...

- refrasear a cena da secção 2.4, logo no início. aquilo não é resolvido ou não é? afinal em q é q ficamos?
- abuso d linguagem na secção 3.1, o parágrafo do "recalling the example in chapter one..." cenas da expressividade.
- 



Questões para o LMP
==============================

Motivation: 
	"its WFM is computable in polynomial time and several WFS implementations exist".... isto tá mal?
	Afinal posso dizer classical form of support ou não posso????? como é q m refiro ao suporte por RAA face ao suporte clássico?
SOA
	Cena da programação declarativa na computer science. não foio colmaureaur por causa do LISP????
	Afinal os SMs são NP-Completos ou não??????
	na WFS -- posso usar o omega p calcular a coisa ou não????
	
	
- fazer o summary em inglês
- fazer as intros dos minitocs
- faltam os programas de exemplo na rWFS e nos rSM
- falta rever uma cena importante - afinal como é q o operador funciona....????
- 